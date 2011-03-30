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

import CpiLib
import CpiParser

import System.Console.Haskeline
import Control.Monad.State

import qualified Data.List as L


-- Some configurables:
welcome = "\nWelcome to the Continuous Pi-calculus Workbench (CPiWB).\n"
          ++"Type \"help\" for help.\n"
prompt = "CPiWB:> "

-- Our environment will be a stack of the Haskeline,
-- State transformer (of CPi Definitions), and IO monads:
type Environment = InputT (StateT [Definition] IO) ()

-- Main function:
main :: IO ()
main = do putStrLn welcome;
          evalStateT (runInputT defaultSettings loop) []
              where 
                loop :: Environment
                loop = do input <- getInputLine prompt
                          case input of
                            Nothing -> return ()
                            Just "" -> loop
                            Just "quit" -> return ()
                            Just i -> do doCommand i;
                                         loop
-- TODO: command autocomplete (see Haskeline docs).
--       can we use the command map?

doCommand :: String -> Environment
doCommand cmdln = let cmd = head $ words cmdln in
                  case (lookup cmd commands) of
                    Nothing -> say "Try again."
                    Just x  -> (cmdFn x) cmdln

---------------
-- Command map:
---------------

-- TODO: document how to add new commands

data CmdRec = CmdRec {cmdFn::String->Environment,cmdHelp::String}

commands :: [(String,CmdRec)]
commands = [("help",CmdRec {
                         cmdFn = helpCmd,
                         cmdHelp = helpTextHelp}),
            ("load",CmdRec {
                         cmdFn = loadCmd,
                         cmdHelp = helpTextLoad})]

cmdList = "\n"++L.concat(L.intersperse "\n" (map (\(x,_) -> x) commands))++"\n\n"

---------------------
-- Command Functions:
---------------------

-- load
loadCmd :: String -> Environment
loadCmd x = say $ "Loading: "++(param x)

-- help
helpCmd :: String -> Environment
helpCmd x 
    | not(null(param x)) 
        = case (lookup (param x) commands) of
            Nothing -> say $ "Sorry no help on \""++x++"\"."
            Just r -> say $ cmdHelp r
    | otherwise
        = say $ "\nThe available commands are:\n"
          ++cmdList
          ++"Type \"help <command>\" for help on a specific command.\n"

----------------------
-- Command help texts:
----------------------

helpTextHelp = "\nhelp <command>\n\tShows help on a specific command.\n"
helpTextLoad = "\nload <filename>\n\tLoads a CPi definition file.\n"

---------------------
-- Utility functions:
---------------------

-- Say something to the user:
say = outputStrLn

-- get the parameters from a command line:
params :: String -> [String]
params cmdln = tail(words cmdln)
-- just the first:
param :: String -> String
param cmdln = let ps = params cmdln in
              case ps of
                []     -> []
                (p:ps) -> p