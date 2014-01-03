{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DoAndIfThenElse #-}

module Sound.Audio(play) where


import Sound.PortAudio.Base
import Sound.PortAudio

import Control.Monad (foldM, foldM_, forM_)
import Control.Concurrent.MVar
import Control.Concurrent (threadDelay)
import Text.Printf

import Foreign.C.Types
import Foreign.Storable
import Foreign.ForeignPtr.Safe
import Foreign.Marshal.Alloc
import Foreign.Ptr

import qualified Data.Vector as V
import Data.Either

time = 5
fs = 44100
fpb = time*fs

--bufferCount = ((time * fs) / fpb)

tsize = 200


forEachElm_ :: Monad m => V.Vector a -> ((Int,a) -> m b) -> m ()
forEachElm_ x f = V.foldM_ (\i e -> f (i,e) >> return (i+1)) 0 x

play :: V.Vector Float -> IO ()
play x = do
	outDev <- (return 2)
	putStrLn (show outDev)
	let outputParameters = PaStreamParameters (PaDeviceIndex outDev) 1 paFloat32 (PaTime 0) nullPtr

	pa_Initialize

	alloca $ \ptrOutParam' -> do
		ptrOutParam'' <- newForeignPtr_ ptrOutParam'
		withForeignPtr ptrOutParam'' $ \ptrOutParam -> do
			poke ptrOutParam outputParameters
			alloca $ \ptrPtrStrm'' -> do
				ptrPtrStrm' <- newForeignPtr_ ptrPtrStrm''
				withForeignPtr ptrPtrStrm' $ \ptrPtrStrm -> do
					result <- pa_OpenStream ptrPtrStrm nullPtr ptrOutParam 44100 fpb paNoFlag nullFunPtr nullPtr

					if result==(unPaErrorCode paNoError) then do
						ptrStrm <- peek ptrPtrStrm
						startRes <- pa_StartStream ptrStrm
						if startRes==(unPaErrorCode paNoError) then do
							putStrLn (show ((fromIntegral fpb)*sizeOf(undefined::CFloat)))
							allocaBytes ((fromIntegral fpb)*sizeOf(undefined::CFloat)) $ \out' -> do
								outData <- newForeignPtr_ out'
								withForeignPtr outData $ \p -> do
									forEachElm_ x (\(i,e) -> pokeElemOff (p::(Ptr CFloat)) i (realToFrac e))
									res <- pa_WriteStream (castPtr ptrStrm) (castPtr p) fpb
									if res==(unPaErrorCode paNoError) then do
										putStrLn "Golo"
										res <- pa_StopStream (castPtr ptrStrm)
										if res==(unPaErrorCode paNoError) then do
											putStrLn "Golo2"
										else do
											putStrLn "BOOM4"
										return ()
									else do
										putStrLn "BOOM3"
										return ()
						else do
							putStrLn "BOOM2"
							putStrLn (show startRes)
							return ()
					else do
						putStrLn "BOOM1"
						putStrLn (show result)
						return ()
	pa_Terminate
	putStrLn "FIM"

