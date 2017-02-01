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

import Control.Exception

-- parse CPi files, search for process by name, and construct ODEs
constructODEs_hs :: String -> String -> String
constructODEs_hs x y = case parseFile x of
                         Left err -> "parse error"
                         Right env -> case lookupProcName env y of
                                      Nothing -> "process not found"
                                      Just proc -> let mts = processMTS env proc
                                                       dpdt = dPdt env mts proc
                                                   in matlabODE env proc dpdt (0, (0,0))

-- handle CPi exceptions and perform CString <-> String type conversion
constructODEs :: CString -> CString -> IO CString
constructODEs x y = do file <- peekCString x
                       process <- peekCString y
                       result <- try (newCString(constructODEs_hs file process)) :: IO (Either SomeException CString)
                       case result of
                          Left ex -> newCString("CPiWB exception: '" ++ show(ex) ++ "'")
                          Right val -> do odes <- peekCString val
                                          newCString(odes)

foreign export ccall constructODEs :: CString -> CString -> IO CString
