@echo off
set path=%path%;d:\L9T\labs\haskell\hsaudio\libs

if "%1"=="configure" cabal configure -frunExamples --enable-test --extra-lib-dir=D:\L9T\labs\haskell\hsaudio\libs

cabal build
cabal test --show-details=always
