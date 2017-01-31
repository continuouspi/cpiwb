-- This file is part of The Continuous Pi-calculus Workbench (CPiWB).
-- Author: Ross Rhodes

{-# LANGUAGE ForeignFunctionInterface #-}

module ConstructODEs where

import CPi.Lib
import CPi.Matlab
import CPi.ODE
import CPi.Parser
import CPi.Semantics

import Foreign.C.Types
import Foreign.C.String

-- each case requires only one clause: Matlab covers validation
constructODEs_hs :: String -> String -> String
constructODEs_hs x y = case parseFile x of
                         Left err -> "parse error"
                         Right env -> case lookupProcName env y of
                                      Nothing -> "process not found"
                                      Just proc -> let mts = processMTS env proc
                                                       dpdt = dPdt env mts proc
                                                   in matlabODE env proc dpdt (0, (0,0))

constructODEs :: CString -> CString -> IO CString
constructODEs x y = do defs <- peekCString x
                       process <- peekCString y
                       newCString (constructODEs_hs defs process)

foreign export ccall constructODEs :: CString -> CString -> IO CString
