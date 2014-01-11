import Sound.Audio
import qualified Data.Vector as V

fs = 44100

sineWave fs' = V.generate (fromEnum $ 3*fs) $ (sin . (2*4410*pi/fs*)) . fromInteger . toEnum
	where fs = realToFrac fs'

main = play fs x where
	x = sineWave fs
