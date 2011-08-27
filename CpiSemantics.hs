-- (C) Copyright Chris Banks 2011

-- This file is part of The Continuous Pi-calculus Workbench (CPiWB). 

--     CPiWB is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.

--     CPiWB is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.

--     You should have received a copy of the GNU General Public License
--     along with CPiWB.  If not, see <http://www.gnu.org/licenses/>.

module CpiSemantics where

import qualified Data.List as L
import qualified Control.Exception as X

import CpiLib

--------------------
-- Species semantics
--------------------

-- Semantic data structures:
data MTS = MTS [Trans]
           deriving (Show)

data Trans = TransSC Species Name Concretion  -- A ----a-----> (x;y)B
           | TransT Species TTau Species      -- A ---t@k----> B
           | TransTA Species TTauAff Species  -- A -t<a,b>@k-> B
             deriving (Show)

data Concretion = ConcBase Species OutNames InNames
                | ConcPar Concretion [Species]
                | ConcNew AffNet Concretion
                  deriving (Show)

data TTau = TTau Rate
            deriving (Show)
data TTauAff = TTauAff (Name,Name)
               deriving (Show)

-- Pretty printing:
instance Pretty MTS where
    pretty (MTS (t:ts)) = ((pretty t)++"\n")++(pretty (MTS ts))
    pretty (MTS []) = ""

instance Pretty Trans where 
    pretty (TransSC s n c) 
        = (pretty s)++" ---"++n++"--> "++(pretty c)
    pretty (TransT s t s')
        = prettyTauTrans s t s'
    pretty (TransTA s t s')
        = prettyTauTrans s t s'
    
prettyTauTrans s t s' = (pretty s)++" ---"++(pretty t)++"--> "++(pretty s')

instance Pretty Concretion where
    pretty (ConcBase s o i) 
        = "("++(prettyNames o)++";"++(prettyNames i)++")"++(pretty s)
    pretty (ConcPar c ss)
        = (pretty c)++" | "++concat(L.intersperse " | " (map pretty ss))
          -- TODO: parens?
    pretty (ConcNew net c)
        = (pretty net)++" "++(pretty c)

instance Pretty TTau where
    pretty (TTau r) = "tau@<"++r++">"
instance Pretty TTauAff where
    pretty (TTauAff (n1,n2)) = "tau@<"++n1++","++n2++">"


-- Get the Multi-Transition System for a Process:
processMTS :: [Definition] -> Process -> MTS
processMTS defs (Process ss net) = finalmts 
    where 
      initmts = transs defs (MTS []) (map fst ss)
      compxs = appls initmts
      finalmts = transs defs initmts compxs

-- Given an MTS calculate the complete transition graph:
-- NOTE: will not terminate for infinite state models
-- NOTE: this is unnecessary and WRONG! Stupid boy.
-- calcMTS :: [Definition] -> MTS -> MTS
-- calcMTS env mts = calc (openMTS mts) mts 
--     where calc (tr:trs) mts'
--               | (TransSC _ _ _) <- tr
--                   = calc trs mts'
--               | (TransT _ _ s) <- tr
--                   = calc trs (trans env mts' s)
--               | (TransTA _ _ s) <- tr
--                   = calc trs (trans env mts' s)
--           calc [] mts'
--               | (mtsCard mts) == (mtsCard mts')
--                   = mts' --bottom out at fixpoint
--               | otherwise
--                   = calcMTS env mts' --otherwise recurse over new transitions

-- Cardinality of an MTS:
mtsCard :: MTS -> Int
mtsCard x = length $ openMTS x

-- Add the immediate transitions for a species to the MTS:
-- TODO: Species want to be in normal form. (Don't they?)
-- TODO: First need to define normal form!
trans :: [Definition] -> MTS -> Species -> MTS
trans env mts s = trans' env mts s
    where
      trans' env mts s' 
          = ifnotnil (lookupTrans mts s') (\x -> mts) (trans'' env mts s')
          where
            trans'' :: [Definition] -> MTS -> Species -> MTS
            -- Nil
            trans'' env mts Nil = mts
            -- Def
            trans'' env mts (Def _ _)
                = maybe ex (trans' env mts) (lookupDef env s')
                where ex = X.throw (CpiException
                                    ("Species "++(pretty s)++" not in the Environment."))
            -- Sum
            trans'' _ mts (Sum []) = mts
            -- Sum(Tau + ...)
            trans'' env mts (Sum (((Tau r),dst):pss))
                = MTS ((TransT s (TTau r) dst):
                       (openMTS(trans' env mts (Sum pss))))
            -- Sum(Comm + ...)
            trans'' env mts (Sum (((Comm n o i),dst):pss))
                = MTS ((TransSC s n (ConcBase dst o i)):
                       (openMTS(trans' env mts (Sum pss))))
            -- Par
            trans'' _ mts (Par []) = mts
            trans'' env mts (Par (c:cs)) = transPar (c:cs) [] []
                where transPar (c:cs) res taus
                          = transPar cs (tr++res) (taus'++taus)
                            where taus' = getTaus s tr res
                                  tr = openMTS(trans' env mts c)
                      transPar [] res taus
                          = MTS (res++taus)
            -- New
            trans'' env mts (New net c)
                = MTS ((restrict(openMTS(trans' env (MTS []) c)))
                       ++(openMTS mts))
                where 
                  restrict [] = []
                  restrict ((TransSC _ n dst):trs) 
                      | n `elem` (sites net) 
                          = restrict trs
                      | otherwise
                          = (TransSC s n (ConcNew net dst)):(restrict trs)
                  restrict ((TransT _ t dst):trs)
                          = (TransT s t (New net dst)):(restrict trs)
                  restrict ((TransTA _ t@(TTauAff (n,n')) dst):trs)
                      | (r /= Nothing)
                          = (TransT s (TTau ((\(Just x)->x)r)) (New net dst))
                            :(restrict trs)
                      | otherwise
                          = (TransTA s t (New net dst)):(restrict trs)
                      where r = (aff net (n,n'))

-- Concatenate MTSs
(->++) :: MTS -> MTS -> MTS
x ->++ y = MTS ((openMTS x)++(openMTS y))

-- Add multiple species to the MTS:
transs :: [Definition] -> MTS -> [Species] -> MTS
transs _ mts [] = mts
transs defs mts (spec:specs)
    = (transs defs mts' specs)
      where mts' = (trans defs mts spec)

-- Get the transition list of an MTS:
openMTS = \(MTS x) -> x

-- Lookup the transitions for a species in an MTS.
lookupTrans :: MTS -> Species -> [Trans]
lookupTrans (MTS []) _ =  []
lookupTrans (MTS (tran:trans)) s
    | s == (transSrc tran)   = tran:(lookupTrans (MTS trans) s) 
    | otherwise              = lookupTrans (MTS trans) s

-- The source Species of a transition:
transSrc :: Trans -> Species
transSrc (TransSC s _ _) = s
transSrc (TransT s _ _) = s
transSrc (TransTA s _ _) = s

-- Pseudo-application of concretions:
pseudoapp :: Concretion -> Concretion -> Maybe Species
pseudoapp (ConcBase s1 a x) (ConcBase s2 b y)
    | (length a == length y)&&(length x == length b)
        = Just $ Par [(sub (zip x b) s1),(sub (zip y a) s2)]
    | otherwise
        = Nothing
pseudoapp c1 (ConcPar c2 s2)
    = maybe Nothing (Just.(\x->Par (x:s2))) (pseudoapp c1 c2)
pseudoapp c1 (ConcNew net c2)
    = maybe Nothing (Just.(\x->New net x)) (pseudoapp c1 c2)
pseudoapp (ConcPar c1 ss) c2
    = maybe Nothing (Just.(\x->Par (x:ss))) (pseudoapp c1 c2)
pseudoapp (ConcNew net c1) c2
    = maybe Nothing (Just.(\x->New net x)) (pseudoapp c1 c2)

-- get the resultants (complexes!) of pseudoapplications in an MTS
-- TODO: this seems a bit dirty... can I do better?
appls :: MTS -> [Species]
appls (MTS []) = []
appls (MTS (tr:trs)) = appls' $ concs (tr:trs)
    where concs :: [Trans] -> [Concretion]
          concs [] = []
          concs ((TransSC s n c):trs)
              = c:(concs trs)
          concs (_:trs)
              = concs trs
          appls' :: [Concretion] -> [Species]
          appls' [] = []
          appls' (c:cs) = (appls'' c cs)++(appls' cs)
          appls'' :: Concretion -> [Concretion] -> [Species]
          appls'' x [] = []
          appls'' x (c:cs) 
              = maybe (appls'' x cs) (\y->(y:(appls'' x cs))) (pseudoapp x c)

-- Compare two lists of transitions for pseudoapplication compatibility
-- and return any resultant tau transitions:
-- NOTE: WTF was I thinking when I wrote this??
getTaus :: Species -> [Trans] -> [Trans] -> [Trans]
getTaus src (tr:trs) trs'
    | (TransSC s n c) <- tr
        = (getTaus' tr trs')++(getTaus src trs trs')
    | otherwise
        = getTaus src trs trs'
    where getTaus' (TransSC _ n c) ((TransSC _ n' c'):trs')
              | Just dst <- pseudoapp c c'
                  = (TransTA src (TTauAff (n,n')) dst):
                    (getTaus' tr trs')
              | otherwise
                  = getTaus' tr trs'
          getTaus' tr (_:trs') = getTaus' tr trs'
          getTaus' _ [] = []
getTaus _ [] _ = []

--------------------
-- Process semantics
 --------------------

-- Prime components of a species:
primes :: [Definition] -> Species -> [Species]
primes env Nil = []
primes env s@(Def _ _) = maybe ex (primes env) (lookupDef env s)
    where ex = X.throw (CpiException
                        ("Species "++(pretty s)++" not in the Environment."))
primes env s@(Sum _) = [s]
primes env s@(New _ _) = [s]
primes env (Par []) = []
primes env (Par (s:ss)) = (primes env s)++(concatMap (primes env) ss)


-- Support of a process - prime species in a process:
-- NOTE: do we want to check conc.>0 ??
supp :: [Definition] -> Process -> [Species]
supp env (Process [] _) = []
supp env (Process [(s,c)] _) = primes env s    
supp env (Process ((s,c):ps) aff) = (primes env s)++(supp env (Process ps aff))
