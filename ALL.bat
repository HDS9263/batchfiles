@echo off

if exist "C:\LOCAL\Resizer\bin\ffmpeg\ffmpeg.exe" set "ffmpeg=C:\LOCAL\Resizer\bin\ffmpeg\ffmpeg.exe"
if exist "N:\LOCAL\Resizer\bin\ffmpeg\ffmpeg.exe" set "ffmpeg=N:\LOCAL\Resizer\bin\ffmpeg\ffmpeg.exe"
if exist "%~dp0bin\ffmpeg\ffmpeg.exe" set "ffmpeg=%~dp0bin\ffmpeg\ffmpeg.exe"

if not exist OUTPUT mkdir OUTPUT

rem Process MP4 files
for %%f in (*.mp4) do (
    echo Processing %%~nf . . .
    "%ffmpeg%" -loglevel warning -stats -i "%%f" -map_metadata -1 -an -sn -dn -filter_complex "yadif=deint=1,select='eq(n,0)+if(gt(t-prev_selected_t,1/30.50),1,0)',scale=iw*sar:ih,setsar=1,scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:-1:-1,format=yuv420p" -vsync 0 -c:v libx264 "OUTPUT\%%~nf.mp4"
)

rem Process JPG files
for %%f in (*.jpg) do (
    echo Processing %%~nf . . .
    "%ffmpeg%" -loglevel warning -stats -i "%%f" -map_metadata -1 -an -sn -dn -filter_complex "scale=iw*sar:ih,setsar=1,scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:-1:-1,format=yuv420p" "OUTPUT\%%~nf.jpg"
)

echo Finished.
pause
