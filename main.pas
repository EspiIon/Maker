program main;

uses SDL2, SDL2_image;

var sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    surfaceMario,surfaceBackground:PSDL_Surface;
    mario,background:PSDL_Texture;
    destRectMario,destRectBackground:TSDL_Rect;
    event:TSDL_Event;
    quit:boolean;
begin
    if SDL_Init(SDL_INIT_VIDEO) < 0 then 
        Halt;

    sdlWindow1 := SDL_CreateWindow('window1',50,50,800,500, SDL_WINDOW_SHOWN);

    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
    surfaceMario := IMG_Load('./assets/mario.png');
    surfaceBackground:= IMG_Load('./assets/background.png');
    mario:= SDL_CreateTextureFromSurface(sdlRenderer,surfaceMario);
    background:= SDL_CreateTextureFromSurface(sdlRenderer,surfaceBackground);
    //Mario
    destRectMario.x:=10;
    destRectMario.y:=400;
    destRectMario.w:=50;
    destRectMario.h:=50;

    //Background
    destRectBackground.x:=0;
    destRectBackground.y:=-45;
    destRectBackground.w:=900;
    destRectBackground.h:=531;

    quit := false;
    while not quit do
    begin
        while SDL_PollEvent(@event) <> 0 do
        begin

            if event.type_ = SDL_QUITEV then
            quit := true;

            if event.type_ = SDL_KEYDOWN then
            begin
                case event.key.keysym.sym of 
                    SDLK_ESCAPE:quit:=True;
                    SDLk_right:destRectMario.x:= destRectMario.x +5;
                    SDLk_left:destRectMario.x:= destRectMario.x -5;
                end;
            end;


            SDL_RenderClear(sdlRenderer);
            SDL_RenderCopy(sdlRenderer,background,nil, @destRectBackground);
            SDL_RenderCopy(sdlrenderer,mario,nil,@destRectMario);

            SDL_RenderPresent(sdlRenderer);
        end;
    end;

    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;

end.