
import Sound.Audio
import qualified Data.Vector as V
import System.Exit (exitFailure)

fs = 44100
f = 820

sinWave f fs = (sin . (2*pi*f/fs*)) . fromInteger . toEnum
tone f t fs = V.generate (fromEnum $ t*fs) $ (sinWave f fs)

simple1 = (tone 400 2 fs) V.++ (tone 220 1 fs) V.++ (tone 820 2 fs) V.++ (tone 220 2 fs)
simple2 = (tone 100 2 fs) V.++ (tone 220 2 fs) V.++ (tone 320 2 fs) V.++ (tone 420 2 fs)

main = (play (realToFrac fs) simple1) >> (play (realToFrac fs) simple2)
