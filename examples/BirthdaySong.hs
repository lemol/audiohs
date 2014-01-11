module Main where

import MusicNotes
import Sound.Audio
import qualified Data.Vector as V

part1, part2, part3, part4 :: V.Vector Float
part1 = music [g 4 (1/2), n64, g 4 (1/4), a 4 1, g 4 (1/2), c 5 (1/2), b 4 1, n16]
part2 = music [g 4 (1/2), n64, g 4 (1/4), a 4 1, g 4 (1/2), d 5 (1/2), c 5 1, n16]
part3 = music [c 5 (1/4), e 5 (1/4), g 5 1, e 5 (1/2), c 5 (1/2), b 4 1, a 4 (1/2), n16]
part4 = music [f 5 (1/4), n64, f 5 (1/4), e 5 1, c 5 (1/2), d 5 (1/2), c 5 1]

playAll :: [V.Vector Float] -> IO ()
playAll = let play' = play (realToFrac fsamp) in
	      play' . foldl (V.++) V.empty where

main :: IO ()
main = playAll [part1, part2, part3, part4]
