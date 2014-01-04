module Main where

import MusicNotes
import Sound.Audio
import qualified Data.Vector as V

part1 = music [g_ 4 1, s_ 0.5, g_ 4 1, a_ 4 2, g_ 4 1, c_ 5 1, b_ 4 1]
part2 = music [g_ 4 1, s_ 0.5, g_ 4 1, a_ 4 2, g_ 4 1, d_ 5 1, c_ 5 1]
part3 = music [c_ 5 1, e_ 5 1, g_ 5 1, s_ 0.5, e_ 5 1, c_ 5 1, b_ 4 1, s_ 0.5, a_ 4 1]
part4 = music [f_ 5 1, s_ 0.5, f_ 5 1, e_ 5 1, c_ 5 1, d_ 5 1, c_ 5 1]

play' = play (realToFrac fs)
playAll = play' . (foldl (V.++) V.empty)

main = playAll [part1, part2, part3, part4]

