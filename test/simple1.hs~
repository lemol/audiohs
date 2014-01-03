import Sound.Audio
import qualified Data.Vector as V
import System.Exit (exitFailure)

fs = 44100 :: Float
f = 420
simple1 = V.fromList $ map (sin.(2*pi*f/fs*)) [0..fs-1]

main = play (44100 :: Double) simple1
