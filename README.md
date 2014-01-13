Audiohs
=======

Provides functions for easily play and record sounds in haskell. It uses `Data.Vector Float` as array type.

Install
-------

At background this package uses the cross platform [PortAudio] [portaudio-lib] library to play and record sounds, so first the portaudio bindings [portaudio] [portaudio-package] for haskell must be installed. See [here] [portaudio-package] for instructions.

1. Install [portaudio][portaudio-package] bindings

```shell
cabal install portaudio
```

2. Download [the lastest version of audiohs] [hsaudio-master] and install it:

```shell
git clone https://github.com/lemol/audiohs.git
cd hsaudio
cabal install
```

Usage
-----

Just import `Sound.Audio(play, record)` and use the functions:

```haskell
play   :: Double -> Vector Float -> IO ()
play fs x

record :: Int -> Double -> Vector Float
x <- record count fs
```

Examples
--------

1. Playing a 3 seconds 440 Hz tone.

```haskell
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
```

2. Record for 5 seconds and play the result.

```haskell
import Sound.Audio (play, record)

fs :: Double
fs = 44100

main :: IO ()
main = do
	x <- record (5*44100) fs
	play fs x
```

Or, even better:

```haskell
main = record (5*44100) fs >>= play fs
```

License
-------
(c) 2014 Leza Morais Lutonda (Lemol-C)   
[MIT License] [lemolsoft-mit-license]

Contribuitions
--------------
Critiques, suggestion, pull request, etc. all are wellcome!

Credits
-------
This package is thanks to the [portaudio][portaudio-package] bindings for haskell.

[portaudio-lib]: http://portaudio.com/
[portaudio-package]: http://hackage.haskell.org/package/portaudio
[lemolsoft-mit-license]: http://lemolsoft.mit-license.org/
[hsaudio-master]: https://github.com/lemol/audiohs/archive/master.zip
