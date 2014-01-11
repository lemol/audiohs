import Sound.Audio (play, record)

fs :: Double
fs = 44100

main :: IO ()
main = do
	x <- record (5*44100) fs
	play fs x
