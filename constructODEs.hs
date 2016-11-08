-- (C) Copyright Chris Banks 2011-2012

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

{-# LANGUAGE ForeignFunctionInterface #-}

module ConstructODEs where

import Foreign.C.Types
import Foreign.C.String

foreign export ccall constructODEs :: CString -> CString -> CString

constructODEs x y = y

--constructODEs x y = do loadCmd x
--                       revMatlabCmd y

--revMatlabCmd :: String -> String
--revMatlabCmd x = do env <- evalStateT getEnv
--                    let args = words x
--                    let p = read(args!!1)
--                    let start = read(args!!2)
--                    let end = read(args!!3)
--                    let res = read(args!!4)
--                    let mts = processMTS env p
--                    let p' = dPdt env mts p
--                    let ts = (res,(start,end))
--                    matlabScript env p mts p' ts
