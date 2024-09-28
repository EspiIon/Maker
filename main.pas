
program main;

uses SDL2, SDL2_image;


// Define records for Tbackground and Tplayer types
type Tbackground = record
  destRect:TSDL_Rect;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
end;
type Tplayer = record
    destRect:TSDL_Rect;
    life:integer;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
end;

// Define a procedure to move the player and background
procedure move(var player:Tplayer;var background:Tbackground;up,right,left:boolean);
begin
    // Move the player up if 'up' is true
    if (up = True)then
        begin
            player.destRect.y:= player.destRect.y -6;
        end;

    // Move the background left if 'right' is true (this is a mistake, it should be 'left')
    if (right = True)then
        begin
            background.destRect.x:= background.destRect.x -7;
        end;

    // Move the background right if 'left' is true (this is a mistake, it should be 'right')
    if (left = True)then
        begin
            background.destRect.x:= background.destRect.x +7;
        end;
end;


begin
    // Initialize SDL and create a window and renderer

    if SDL_Init(SDL_INIT_VIDEO) < 0 then
        Halt;

    sdlWindow1 := SDL_CreateWindow('window1',50,50,800,500, SDL_WINDOW_SHOWN);
    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);

    // Load player and background surfaces and create textures from them
    player.surface := IMG_Load('./assets/mario.png');
    background.surface:= IMG_Load('./assets/background.png');
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);
    background.texture:= SDL_CreateTextureFromSurface(sdlRenderer,background.surface);

    // Set initial positions and dimensions for the player and background
    player.destRect.x:=400;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;

    background.destRect.x:=0;
    background.destRect.y:=-45;
    background.destRect.w:=900;
    background.destRect.h:=531;

    quit := false;

    // Main game loop
    while not quit do
    begin

        if player.destRect.y < absoluteTop then
            up:=False;
        //evenement
        move(player,background,up,right,left,top,counter);
        Gravity(player,up,down,FloorLevel,top);
        GoodPosition(player,background);

        sdl_delay(10);

        while SDL_PollEvent(@event) <> 0 do
        begin

            //evenement touche appuyé
            if event.type_ = SDL_KEYDOWN then
                begin
                if event.key.keysym.sym = SDLK_LEFT then
                    begin
                    left:=True;
                    right:=False;   
                    end;
                if event.key.keysym.sym = SDLK_RIGHT then
                    begin
                    right:=True;
                    left:=False;
                    end;
                if (event.key.keysym.sym = SDLK_SPACE) and (player.destRect.y = 400) then
                    up:=True;
            end;
            //evenement touche relevé

            //fermeture
            if event.type_ = SDL_QUITEV then
            quit := true;

            //rendement
            
            SDL_RenderClear(sdlRenderer);
            for i:=1 to 2 do
                begin
                SDL_RenderCopy(sdlRenderer,background[i].texture,nil, @background[i].destRect);
                end;
            SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);

            if event.type_ = SDL_KEYUP then
                begin
                if event.key.keysym.sym = SDLK_SPACE then
                    begin
                    top:= absoluteTop;
                    end;
                if event.key.keysym.sym = SDLK_LEFT then
                    begin
                    left:=false;
                    counter :=0;
                    end;
                if event.key.keysym.sym = SDLK_RIGHT then
                    begin
                    right:=false;
                    counter :=0;
                    end;
            end;

        end;

        SDL_RenderClear(sdlRenderer);
        for i:=1 to 2 do
            begin
            SDL_RenderCopy(sdlRenderer,background[i].texture,nil, @background[i].destRect);
            end;
        SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);
        SDL_RenderPresent(sdlRenderer);

    end;

    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;

end.