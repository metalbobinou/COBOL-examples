:: Batch for setting OC-Environment in Windows with MSC compiler
:: Note: Env vars are set for Sergey's WIN binaries from kiska.net/opencobol

@echo off

:: Check if this batch was called allready and exit if it was called before.
if "%COB_ENV_SET%"    NEQ "" goto :eof

:: Set the internal env var
set COB_ENV_SET=1

:: Check for valid MSC Environment and let it do it's work.
if "%VS110COMNTOOLS%" NEQ "" (
   call "%VS110COMNTOOLS%vsvars32.bat"
) else if "%VS100COMNTOOLS%" NEQ "" (
   call "%VS100COMNTOOLS%vsvars32.bat"
) else if "%VS90COMNTOOLS%" NEQ "" (
   call "%VS90COMNTOOLS%vsvars32.bat"
) else if "%VS80COMNTOOLS%" NEQ "" (
   call "%VS80COMNTOOLS%vsvars32.bat"
) else if "%VS71COMNTOOLS%" NEQ "" (
   call "%VS71COMNTOOLS%vsvars32.bat"
) else if "%VS70COMNTOOLS%" NEQ "" (
   call "%VS70COMNTOOLS%vsvars32.bat"
) else (
   echo Warning: Not possible to set environment for Microsoft Visual Studio!
)

:: Now the stuff for OC
echo Setting environment for OpenCOBOL.

:: Get the main dir from the batch's position (only works in NT environments)
if "%COB_MAIN_DIR%"   EQU "" set COB_MAIN_DIR=%~dp0.
:: Ajoute par MOI
set COB_MAIN_DIR=C:\OpenCobol

:: Set the necessary folders for cobc
if "%COB_CONFIG_DIR%" EQU "" set COB_CONFIG_DIR=%COB_MAIN_DIR%\config
if "%COB_COPY_DIR%"   EQU "" set COB_COPY_DIR=%COB_MAIN_DIR%\copy

:: Set the necessary options for MSC compiler
if "%COB_CFLAGS%"     EQU "" set COB_CFLAGS=/I "%COB_MAIN_DIR%"
if "%COB_LIB_PATHS%"  EQU "" set COB_LIB_PATHS=/LIBPATH:"%COB_MAIN_DIR%"
if "%COB_LIBS%"       EQU "" (
   if exist "%COB_MAIN_DIR%\mpir.lib" set COB_LIBS=libcob.lib mpir.lib
   if exist "%COB_MAIN_DIR%\gmp.lib"  set COB_LIBS=libcob.lib gmp.lib
)

:: Add the bin path of OC to PATH for further references
set PATH=%COB_MAIN_DIR%;%PATH%
