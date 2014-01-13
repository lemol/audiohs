@echo off
set path=%path%;d:\L9T\labs\haskell\audiohs\libs

if "%1"=="configure" cabal configure -frunExamples --enable-test --extra-lib-dir=D:\L9T\labs\haskell\audiohs\libs

cabal build
cabal test --show-details=always
