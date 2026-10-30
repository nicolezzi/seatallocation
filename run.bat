@echo off
REM Execution script for Windows

if not exist out (
    echo Compiled files not found. Compiling first...
    call compile.bat
)

echo Launching Exam Seat Allocation System...
java --enable-native-access=ALL-UNNAMED -cp "out;lib\sqlite-jdbc.jar" Main %*
