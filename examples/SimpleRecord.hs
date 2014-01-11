import Sound.Audio (play, record)

fs :: Double
fs = 44100

main :: IO ()
main = record (5*44100) fs >>= play fs
