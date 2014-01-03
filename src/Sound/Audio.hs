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

forEachElm_ :: Monad m => V.Vector a -> ((Int,a) -> m b) -> m ()
forEachElm_ x f = V.foldM_ (\i e -> f (i,e) >> return (i+1)) 0 x

play :: Double -> V.Vector Float -> IO ()
play fs x = do
	xMV <- newMVar x
	let len = V.length x
	playWithBlockingIO len fs x
	return ()

playWithBlockingIO :: Int -> Double -> V.Vector Float -> IO (Either Error ())
playWithBlockingIO len fs x = do
	let numOutChan = 1

	putStrLn "AQUI"
	initialize
	strm' <- (openDefaultStream 0 numOutChan fs Nothing Nothing Nothing) :: IO (Either Error (Stream CFloat CFloat))
	let strm'' = rights [strm']
	if (length strm'')==0 then do putStrLn "BOOM"
	else do
		let strm = (head strm'')
		putStrLn "OKK"
		closeStream strm
		return ()
	terminate
	return $ Right ()
	--withDefaultStream 0 numOutChan fs Nothing Nothing Nothing $ \(strm :: Stream CFloat CFloat) -> return $ Right ()
--		allocaBytes (len*4) $ \out' -> do
--			out <- newForeignPtr_ out'
			--startStream strm
			--releaseStream len x out strm
			--stopStream strm
--			return $ Right ()

	where
		releaseStream :: Int -> V.Vector Float -> ForeignPtr CFloat -> Stream CFloat CFloat -> IO ()
		releaseStream len x out strm = do
			putStrLn "NADAA"
			--withForeignPtr out $ \p -> forEachElm_ x (\(i,e) -> pokeElemOff p i (realToFrac e))
			putStrLn "NADAO"
			--writeStream strm (fromIntegral len) out
			putStrLn "NADA"
			return ()

