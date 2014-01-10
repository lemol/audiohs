module Test where

import Sound.Audio
--import qualified Data.Vector as V
--import System.Exit (exitFailure)

fs :: Double
fs = 44100

testRecord1 :: IO ()
testRecord1 = do
	x <- record (5*44100) fs
	play fs 
