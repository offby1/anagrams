module Main where
import Bag
import Char
import System
import IO
import qualified Data.Map as M

-- generate anagrams of a string passed on the command line.

-- maps "Bags" (which are really just Integers) to the list of
-- dictionary words that can be made from that bag.  Example:
-- {5593:=["dog", "god"]}
type DictMap = M.Map Integer [String]

-- the same information as a DictMap, but organized as a list, for
-- easy traversal (now that I think about it this is probably silly).
type Dict = [(Integer, [String])]

member :: String -> [String] -> Bool
member string [] = False
member string (x:xs) =
      if string == x then True else member string xs

-- add the word to the list of words indexed by the Bag, but only if
-- it isn't already on that list.
adjoin :: Integer -> String -> DictMap -> DictMap
adjoin key string dict =
       M.insertWith (\new -> (\old -> ( 
                    if member (head new) old then old else (new ++ old) ))) key [string] dict

from_strings :: [String] -> DictMap
from_strings [] = M.empty
from_strings (line:lines) =
             adjoin (make_bag (line)) line (from_strings (lines))

isVowel :: Char -> Bool
isVowel c = 
        any (\v -> v == c) "aeiou" 

hasVowel :: String -> Bool
hasVowel s =
         any isVowel s

-- life is simpler if we limit our dictionary to words that are ASCII
-- only.
acceptable :: String -> Bool
acceptable word =
           all isAlpha word
            && all isAscii word
            && hasVowel word
            && ((length (word) > 1)
               || word == "a"
               || word == "i")

-- return a dictionary whose bags can all be "made from" the input
-- bag.
prune :: Integer -> Dict -> Dict
prune bag [] = []
prune bag (x:xs) = if (subtract_bags bag (fst x) ) > 0 then (x : (prune bag xs)) else prune bag xs
          
-- given a list of words, and some anagrams, make more anagrams, where
-- each new anagram gets one of the words.
combine :: [String] -> [[String]] -> [[String]]
combine words anagrams = 
        concatMap (\w -> (map (\an -> w : an) anagrams)) words

-- the heart of the matter.  Given a bag and a dictionary, return a
-- list of anagrams that can be made from that bag.  Each anagram is a
-- list of words.
anagrams :: Integer -> Dict -> [[String]]
anagrams bag [] = []
anagrams bag (x:xs) =
         let smaller = subtract_bags bag (fst x) in
         (if (smaller > 0) then
             if (Bag.empty smaller) then
                                map (\item -> [item]) (snd x)
                                else
                                    combine (snd x) (anagrams smaller (prune smaller (x:xs)))
         else
             []) ++ anagrams bag xs

main= do
      x <- readFile ("/usr/share/dict/words")

      args <- System.getArgs
      let dict = M.toList (from_strings (filter acceptable (map (map toLower) (lines x))));
          input = head args
          in (let b = make_bag input;
                  answer = anagrams (b) (prune b dict)
                  in do
                  print  answer
                  hPrint stderr (show (length answer) ++ " anagrams of " ++ input))
                 
