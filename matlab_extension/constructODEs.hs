-- This file is part of The Continuous Pi-calculus Workbench (CPiWB).
-- Author: Ross Rhodes

{-# LANGUAGE ForeignFunctionInterface #-}

module ConstructODEs where

import CPi.Lib
import CPi.Matlab
import CPi.ODE
import CPi.Parser
import CPi.Semantics

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Foreign.Ptr

import System.IO.Unsafe

constructODEs_hs :: String -> String -> String
constructODEs_hs x y = do case parseFile x of
                            Left err -> y
                            Right env -> case lookupProcName env y of
                                         Nothing -> y
                                         Just proc -> do let mts = processMTS env proc
                                                         let dpdt = dPdt env mts proc
                                                         matlabODE env proc dpdt (10,(0,100))

-- each use of unsafePerformIO should be removed
constructODEs :: CString -> CString -> CString
constructODEs x y = do let u = unsafePerformIO $ peekCString x
                       let v = unsafePerformIO $ peekCString y
                       let result = constructODEs_hs u v
                       unsafePerformIO $ newCString result

foreign export ccall constructODEs :: CString -> CString -> CString
