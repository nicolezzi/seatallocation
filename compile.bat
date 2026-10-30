@echo off
REM Compile script for Windows
echo Compiling Exam Seat Allocation System...

if not exist out mkdir out

javac -cp "lib\sqlite-jdbc.jar" -d out src\model\*.java src\dao\*.java src\util\*.java src\service\*.java src\ui\*.java src\Main.java src\TestSuite.java src\GenerateScreenshots.java

if %ERRORLEVEL% EQU 0 (
    echo Compilation successful! Classes compiled to 'out' folder.
) else (
    echo Compilation failed with error code %ERRORLEVEL%.
)
