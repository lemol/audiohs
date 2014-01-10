{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DoAndIfThenElse #-}
--{-# LANGUAGE Safe #-}
{-# LANGUAGE Trustworthy #-}

module Sound.Audio(play, record) where

import Sound.PortAudio.Base
import Sound.PortAudio

import Control.Monad (void, unless, liftM, liftM2)
import Control.Concurrent.MVar ()

import Foreign.C.Types
import Foreign.Storable
import Foreign.ForeignPtr.Safe
import Foreign.Marshal.Alloc
import Foreign.Ptr

import qualified Data.Vector as V
import Data.Either ()

withForeignPtr' :: (Ptr a -> IO b) -> ForeignPtr a -> IO b
withForeignPtr' fn ptr = withForeignPtr ptr fn

allocaForeignPtrBytes :: Int -> (Ptr a -> IO b) -> IO b
allocaForeignPtrBytes n fn =
	mallocForeignPtrBytes n >>= withForeignPtr' fn

defaultBufferSize :: Int
defaultBufferSize = 1024

sizeCFloat :: Int
sizeCFloat = sizeOf(undefined::CFloat)

forEachElm_ :: Monad m => V.Vector a -> ((Int,a) -> m b) -> m ()
forEachElm_ x f = V.foldM_ (\i e -> f (i,e) >> return (i+1)) 0 x

pokeFromVector_ :: Storable b => Ptr b -> (a -> b) -> V.Vector a -> IO ()
pokeFromVector_ ptr conv x = forEachElm_ x (\(i,e) -> pokeElemOff ptr i (conv e))

peekFromVector :: Storable b => Ptr b -> (b -> a) -> Int -> IO (V.Vector a)
peekFromVector ptr conv count = V.generateM count $ \i -> liftM conv (peekElemOff ptr i)

withDefaultStream' :: Real a => Ptr (Ptr PaStream) -> Int -> Int -> a -> Int -> (Ptr PaStream -> IO b) -> IO (Either a1 b)
withDefaultStream' ptrPtrStream inChans outChans fs bufferSize fn =
	pa_OpenDefaultStream ptrPtrStream (toEnum inChans) (toEnum outChans) paFloat32 (realToFrac fs) (toEnum bufferSize) nullFunPtr nullPtr >>
	peek ptrPtrStream		>>= \ptrStream ->
	pa_StartStream ptrStream 	>>
	fn ptrStream 			>>= \res ->
	pa_CloseStream ptrStream 	>>
	return (Right res)

play :: Double -> V.Vector Float -> IO ()
play fs x = void (playWithBlockingIO fs x)

playWithBlockingIO :: Double -> V.Vector Float -> IO (Either Error ())
playWithBlockingIO = playWithBlockingIOCustom defaultBufferSize

playWithBlockingIOCustom :: Int -> Double -> V.Vector Float -> IO (Either Error ())
playWithBlockingIOCustom bufferSize fs x = withPortAudio $ alloca $ \ptrPtrStream'' -> do
	ptrPtrStream' <- newForeignPtr_ ptrPtrStream'' :: IO (ForeignPtr (Ptr PaStream))
	withForeignPtr ptrPtrStream' $ \ptrPtrStream ->
		withDefaultStream' ptrPtrStream 0 1 fs bufferSize $ \ptrStream -> 
			playBuffer ptrStream 1 $ V.splitAt bufferSize x 

	return $ Right ()

	where
		playBuffer :: Ptr PaStream -> Int -> (V.Vector Float, V.Vector Float) -> IO ()
		playBuffer ptrStream i (buffer, buffers) = do
			allocaForeignPtrBytes (bufferSize*sizeCFloat*sizeCFloat) $ \ptr -> do
				pokeFromVector_ (ptr::Ptr CFloat) realToFrac buffer
				pa_WriteStream ptrStream (castPtr ptr) (toEnum bufferSize)

			unless (V.length buffers == 0) $ playBuffer ptrStream (i+1) $ V.splitAt bufferSize buffers

record :: Int -> Double -> IO (V.Vector Float)
record samplesCount fs = recordWithBlockingIO samplesCount fs >>= \res ->
			 case res of
				Left _ 	       -> return V.empty
				Right waveData -> return waveData

recordWithBlockingIO :: Int -> Double -> IO (Either Error (V.Vector Float))
recordWithBlockingIO = recordWithBlockingIOCustom defaultBufferSize

recordWithBlockingIOCustom :: Int -> Int -> Double -> IO (Either Error (V.Vector Float))
recordWithBlockingIOCustom bufferSize samplesCount fs = withPortAudio $ alloca $ \ptrPtrStream'' -> do
	ptrPtrStream' <- newForeignPtr_ ptrPtrStream'' :: IO (ForeignPtr (Ptr PaStream))
	withForeignPtr ptrPtrStream' $ \ptrPtrStream -> 
		withDefaultStream' ptrPtrStream 1 0 fs bufferSize $ \ptrStream ->
			recordBuffer ptrStream samplesCount

	where
		recordBuffer :: Ptr PaStream -> Int -> IO (V.Vector Float)
		recordBuffer ptrStream left | left <= bufferSize = getNextSamples ptrStream left
					    | otherwise          = liftM2 (V.++)
									(getNextSamples ptrStream bufferSize)
                                                                   	(recordBuffer ptrStream $ left - bufferSize)

		getNextSamples :: Ptr PaStream -> Int -> IO (V.Vector Float)
		getNextSamples ptrStream size = 
			allocaForeignPtrBytes (size*sizeCFloat) $ \ptr -> do
				pa_ReadStream ptrStream (castPtr ptr) (toEnum size)
				peekFromVector (ptr :: Ptr CFloat) realToFrac size
