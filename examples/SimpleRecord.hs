import Sound.Audio (play, record)

fs :: Double
fs = 44100

main :: IO ()
<<<<<<< HEAD
main = record (5*44100) fs >>= play fs
=======
main = do
	x <- record (5*44100) fs
	play fs x
>>>>>>> 7f43190d7a938c72e5d134ff5e9b43e9849654d8
