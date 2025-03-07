@echo off

set version=3.2.8
set filename=SDL3-%version%

echo Downloading SDL3 from https://github.com/libsdl-org/SDL
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/libsdl-org/SDL/releases/download/release-%version%/SDL3-devel-%version%-mingw.zip', '%filename%.zip')"

echo Extracting %filename%.zip
tar -xf %filename%.zip

del %filename%.zip

echo Copy %filename%.zip to libs folder
xcopy /s "%filename%\x86_64-w64-mingw32\" "%cd%\libs\%filename%\"

rmdir /s /q %filename%

IF exist "makefile" (
    echo makefile already exist
) ELSE (
    echo TARGET = NAME >> makefile
    echo SRCS = main.c >> makefile
    echo INCLUDES = -Ilibs\%filename%\include>> makefile
    echo CFLAGS = -Wall $(INCLUDES^) -mwindows -lmingw32 -lSDL3 -g >> makefile
    echo LIBS = -Llibs\%filename%\lib>> makefile
    echo $(TARGET^): $(SRCS^) >> makefile
    echo 	gcc $(SRCS^) -o $(TARGET^) $(CFLAGS^) $(LIBS^) >> makefile
    echo clean: >> makefile
    echo 	rm -f $(TARGET^) >> makefile
)

IF exist "main.c" (
    echo main.c already exist
) ELSE (
    echo ^#include ^<SDL3/SDL.h^> >> main.c
    echo: >> main.c
    echo ^#define WINDOW_TITLE ^"WINDOW NAME^" >> main.c
    echo ^#define WINDOW_WIDTH 640 >> main.c
    echo ^#define WINDOW_HEIGHT 480 >> main.c
    echo: >> main.c
    echo int main(int argc, char* argv[^]^) { >> main.c
    echo: >> main.c
    echo     SDL_Window* window = SDL_CreateWindow(WINDOW_TITLE, WINDOW_WIDTH, WINDOW_HEIGHT, 0^);  >> main.c
    echo: >> main.c
    echo     int running = 1; >> main.c
    echo     SDL_Event event; >> main.c
    echo: >> main.c
    echo     while (running^) { >> main.c
    echo         while (SDL_PollEvent(^&event^)^) { >> main.c
    echo             if (event.type == SDL_EVENT_QUIT^) { >> main.c
    echo                 running = 0; >> main.c
    echo             } >> main.c
    echo         } >> main.c
    echo     } >> main.c
    echo: >> main.c
    echo     SDL_DestroyWindow(window^); >> main.c
    echo     SDL_Quit(^); >> main.c
    echo: >> main.c
    echo     return 0; >> main.c
    echo } >> main.c
)


echo Initialization complete

pause