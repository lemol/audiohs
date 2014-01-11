import Sound.Audio (play)
import qualified Data.Vector as V

fs :: Double
fs = 44100

sineWave :: V.Vector Float
sineWave = V.fromList $ map sinList [0..3*fs'-1]
	where
		sinList = sin . (2 * 440 * pi/fs' *)
		fs'     = realToFrac fs

main :: IO ()
main = play fs sineWave

