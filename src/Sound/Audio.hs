module Sound.Audio(play) where


import Sound.PortAudio.Base
import Sound.PortAudio

import Control.Monad (foldM, foldM_, forM_)
import Control.Concurrent.MVar
import Control.Concurrent (threadDelay)
import Text.Printf

import Foreign.C.Types
import Foreign.Storable
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Ptr

import qualified Data.Vector as V

play :: Double -> V.Vector Float -> IO ()
play fs x = putStrLn "calling play" >> return ()

