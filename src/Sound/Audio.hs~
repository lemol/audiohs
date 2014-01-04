{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE DoAndIfThenElse #-}
--{-# LANGUAGE Safe #-}
{-# LANGUAGE Trustworthy #-}

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

withForeignPtr' :: (Ptr a -> IO b) -> ForeignPtr a -> IO b
withForeignPtr' fn ptr = withForeignPtr ptr fn

allocaForeignPtrBytes :: Int -> (Ptr a -> IO b) -> IO b
allocaForeignPtrBytes n fn =
	mallocForeignPtrBytes n >>= (withForeignPtr' fn)


bufferSize = 1024*2
sizeCFloat = sizeOf(undefined::CFloat)

forEachElm_ :: Monad m => V.Vector a -> ((Int,a) -> m b) -> m ()
forEachElm_ x f = V.foldM_ (\i e -> f (i,e) >> return (i+1)) 0 x

pokeFromVector_ :: Storable b => Ptr b -> (a -> b) -> V.Vector a -> IO ()
pokeFromVector_ ptr conv x = forEachElm_ x (\(i,e) -> pokeElemOff ptr i (conv e))

play :: Double -> V.Vector Float -> IO ()
play fs x = playWithBlockingIO fs x >> return ()

playWithBlockingIO :: Double -> V.Vector Float -> IO (Either Error ())
playWithBlockingIO fs x = withPortAudio $ alloca $ \ptrPtrStream'' -> do
	ptrPtrStream' <- (newForeignPtr_ ptrPtrStream'') :: IO (ForeignPtr (Ptr PaStream))
	withForeignPtr ptrPtrStream' $ \ptrPtrStream -> do
		res <- pa_OpenDefaultStream ptrPtrStream 0 1 paFloat32 (realToFrac fs) (toEnum bufferSize) nullFunPtr nullPtr
		ptrStream <- peek ptrPtrStream

		pa_StartStream ptrStream
		playBuffer ptrStream 1 $ V.splitAt bufferSize x 
		pa_StopStream ptrStream
	return $ Right ()

	where
		playBuffer :: Ptr PaStream -> Int -> (V.Vector Float, V.Vector Float) -> IO ()
		playBuffer ptrStream i (buffer, buffers) = do
			--putStrLn $ "buffer=" ++ (show (V.length buffer)) ++ ", buffers=" ++ (show (V.length buffers))
			allocaForeignPtrBytes (bufferSize*sizeCFloat*sizeCFloat) $ \ptr -> do
				pokeFromVector_ (ptr::Ptr CFloat) realToFrac buffer
				pa_WriteStream ptrStream (castPtr ptr) (toEnum bufferSize)

			if (V.length buffers)==0 then
				return ()
			else
				playBuffer ptrStream (i+1) $ V.splitAt bufferSize buffers

