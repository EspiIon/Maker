program main;

uses SDL2, SDL2_image;



type Tbackground = 
    record
    destRect:TSDL_Rect;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
    end;
type Tplayer = 
    record
    destRect:TSDL_Rect;
    life:integer;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
    end;

var 
    sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    player:Tplayer;
    background:Tbackground;
    keyState:PUInt8;
    one:integer;
    left,right,up:boolean;
    event:TSDL_Event;
    n:integer;
    quit:boolean;



procedure move(var player:Tplayer;var background:Tbackground;up,right,left:boolean);
begin
    if (up = True) and (player.destRect.y=400) then
    begin
        player.destRect.y:= player.destRect.y -100;
        
    end

    else if (right = True) and (up = False) then
    begin
        if player.destRect.y=400 then
            begin
                background.destRect.x:= background.destRect.x -10;
            end
        else
            background.destRect.x:= background.destRect.x -2;
    end

    else if (left = True) and (up = False) then
        begin
            if player.destRect.y =400 then
                begin
                background.destRect.x:= background.destRect.x +10;
                end
            else
            background.destRect.x:= background.destRect.x +2;
            
        end;
    
end;



begin
    if SDL_Init(SDL_INIT_VIDEO) < 0 then 
        Halt;

    sdlWindow1 := SDL_CreateWindow('window1',50,50,800,500, SDL_WINDOW_SHOWN);
    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
    
    player.surface := IMG_Load('./assets/mario.png');
    background.surface:= IMG_Load('./assets/background.png');
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);
    background.texture:= SDL_CreateTextureFromSurface(sdlRenderer,background.surface);
    //Mario
    player.destRect.x:=400;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;
    
    //Background
    background.destRect.x:=0;
    background.destRect.y:=-45;
    background.destRect.w:=900;
    background.destRect.h:=531;

    quit := false;
    n:=0;
    while not quit do
    begin
    //gravitée
        if (background.destRect.x = -100) and (player.destRect.y > 375)  then
            background.destRect.x := background.destRect.x +5;
            if player.destRect.y < 400 then
            begin
            player.destRect.y:=player.destRect.y +1;
            move(player,background,up,right,left);
            sdl_delay(4);
            end;

        
        //evenement
        while SDL_PollEvent(@event) <> 0 do
        begin
            
            //evenement touche appuyé
            if event.type_ = SDL_KEYDOWN then
                begin
                case event.key.keysym.sym of
                    SDLK_LEFT: left:=True;
                    SDLK_RIGHT: right:=True;
                    SDLK_SPACE: up:=True;
                end;
            end;
            //evenement touche relevé
            
            //fermeture
            if event.type_ = SDL_QUITEV then
            quit := true;

            move(player,background,up,right,left);  

            //rendement
            SDL_RenderClear(sdlRenderer);
            SDL_RenderCopy(sdlRenderer,background.texture,nil, @background.destRect);
            SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);
            if event.type_ = SDL_KEYUP then
                begin
                case event.key.keysym.sym of
                    SDLK_LEFT: left:=false;
                    SDLK_RIGHT: right:=false;
                    SDLK_SPACE: up:=false;
                end;
            end;
    
        end;

        SDL_RenderClear(sdlRenderer);
        SDL_RenderCopy(sdlRenderer,background.texture,nil, @background.destRect);
        SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);
        SDL_RenderPresent(sdlRenderer);

        
    end;

    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;

end.