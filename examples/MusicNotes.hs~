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

data Sound = Sound (Maybe Note) Octave Duration

c_ o d = Sound (Just C) o d; cs_ o d = Sound (Just Cs) o d
d_ o d = Sound (Just D) o d; ds_ o d = Sound (Just Ds) o d
e_ o d = Sound (Just E) o d
f_ o d = Sound (Just F) o d; fs_ o d = Sound (Just Fs) o d
g_ o d = Sound (Just G) o d; gs_ o d = Sound (Just Gs) o d
a_ o d = Sound (Just A) o d; as_ o d = Sound (Just As) o d
b_ o d = Sound (Just B) o d
s_   d = Sound Nothing  0 d

type Octave = Float --Int
type Duration = Float
type Frequency = Float

type MusicSound = (Int -> Float)

fundamental :: Note -> Frequency
fundamental note = fundamentals !! (fromEnum note)
	where
		fundamentals = [261.6, 277.2, 293.7, 311.1, 329.6, 349.2, 370.0, 392.0, 415.3, 440.0, 466.2, 493.9]

fs = 44100 :: Frequency

sinWave f = (sin . (2*pi*f/fs*)) . fromInteger . toEnum

pitch :: Note -> Octave -> MusicSound
pitch note oct = sinWave freq
	where
		freq = (2**(oct-4)) * (fundamental note)

space :: MusicSound
space = \x->0

toInt = fromEnum . toRational

sound :: Sound -> V.Vector Float
sound (Sound maybeNote oct dur) = theSound maybeNote
	where
		theSound (Just note) = V.generate (toInt $ dur*fs) $ pitch note oct
		theSound Nothing     = V.generate (toInt $ dur*fs) $ space

music x = V.concat $ map sound x

