module MusicNotes where

import qualified Data.Vector as V

data Note = C | Cs |
            D | Ds |
            E |
            F | Fs |
            G | Gs |
            A | As | 
            B
	deriving (Enum, Eq, Show)

data Sound = Sound Note Octave Duration
           | Silence Duration

c, cs, d, ds, e, f, fs, g, gs, a, as, b
	:: Octave -> Duration -> Sound

c = Sound C; cs = Sound Cs
d = Sound D; ds = Sound Ds
e = Sound E
f = Sound F; fs = Sound Fs
g = Sound G; gs = Sound Gs
a = Sound A; as = Sound As
b = Sound B

n1, n2, n4, n8, n16, n32
	:: Sound

n1   = Silence 1
n2   = Silence (1/2)
n4   = Silence (1/4)
n8   = Silence (1/8)
n16  = Silence (1/16)
n32  = Silence (1/32)
n64  = Silence (1/64)

type Octave = Int
type Duration = Float
type Frequency = Float

type MusicSound = (Int -> Float)

fundamental :: Note -> Frequency
fundamental note = fundamentals !! fromEnum note
	where
		fundamentals = [261.6, 277.2, 293.7, 311.1, 329.6, 349.2, 370.0, 392.0, 415.3, 440.0, 466.2, 493.9]

fsamp :: Frequency
fsamp = 44100

sinWave :: Frequency -> Int -> Frequency
sinWave freq = (sin . (2*pi*freq/fsamp*)) . fromInteger . toEnum

pitch :: Note -> Octave -> MusicSound
pitch note oct = let freq = (2**(realToFrac oct - 4)) * fundamental note
                 in sinWave freq

space :: MusicSound
space _ = 0

toInt :: RealFrac a => a -> Int
toInt = fromIntegral . floor

sound :: Sound -> V.Vector Float
sound (Sound note oct dur) = V.generate (toInt $ dur*fsamp) $ pitch note oct
sound (Silence dur)        = V.generate (toInt $ dur*fsamp)   space

music :: [Sound] -> V.Vector Float
music x = V.concat $ map sound x

