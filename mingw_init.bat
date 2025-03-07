@echo off

set version=2.32.2
set filename=SDL2-%version%

echo Downloading SDL2 from https://github.com/libsdl-org/SDL
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/libsdl-org/SDL/releases/download/release-%version%/SDL2-devel-%version%-mingw.zip', '%filename%.zip')"

echo Extracting %filename%.zip
tar -xf %filename%.zip

del %filename%.zip

echo Copy %filename%.zip to libs folder
xcopy /s "%filename%\x86_64-w64-mingw32\" "%cd%\libs\%filename%\"

rmdir /s /q %filename%

IF exist "makefile" (
    echo makefile already exist
) ELSE (
    echo TARGET = my_program >> makefile
    echo SRCS = main.c >> makefile
    echo INCLUDES = -IX:\C\autotemplate\SDL2\libs\SDL2-2.32.2\include>> makefile
    echo CFLAGS = -Wall $(INCLUDES^) -mwindows -lmingw32 -lSDL2main -lSDL2 -g >> makefile
    echo LIBS = -LX:\C\autotemplate\SDL2\libs\SDL2-2.32.2\lib>> makefile
    echo $(TARGET^): $(SRCS^) >> makefile
    echo 	gcc $(SRCS^) -o $(TARGET^) $(CFLAGS^) $(LIBS^) >> makefile
    echo clean: >> makefile
    echo 	rm -f $(TARGET^) >> makefile
)

IF exist "main.c" (
    echo main.c already exist
) ELSE (
    echo ^#include ^<SDL2/SDL.h^> >> main.c
    echo: >> main.c
    echo ^#define WINDOW_TITLE ^"Hello World!^" >> main.c
    echo ^#define WINDOW_WIDTH 640 >> main.c
    echo ^#define WINDOW_HEIGHT 480 >> main.c
    echo: >> main.c
    echo int main(int argc, char* argv[^]^) { >> main.c
    echo: >> main.c
    echo     SDL_Init(SDL_INIT_EVERYTHING^); >> main.c
    echo: >> main.c
    echo     SDL_Window* window = SDL_CreateWindow(WINDOW_TITLE, >> main.c
    echo         SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, >> main.c
    echo         WINDOW_WIDTH, WINDOW_HEIGHT, 0^); >> main.c
    echo: >> main.c
    echo     int running = 1; >> main.c
    echo     SDL_Event event; >> main.c
    echo: >> main.c
    echo     while (running^) { >> main.c
    echo         while (SDL_PollEvent(^&event^)^) { >> main.c
    echo             if (event.type == SDL_QUIT^) { >> main.c
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