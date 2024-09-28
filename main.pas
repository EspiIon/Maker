program main;

uses SDL2, SDL2_image;

const absoluteTop = 250;
const taille = 3;

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
type TabBackground = array[1..taille] of Tbackground;
var
    FloorLevel,top,i:integer;
    counter:real;
    sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    player:Tplayer;
    background:TabBackground;
    left,right,up,down:boolean;
    event:TSDL_Event;
    quit:boolean;


procedure GoodPosition(var player:Tplayer;var background:TabBackground);
var i:integer;
    begin
    if player.destRect.x < 0 then
        player.destRect.x:=0;
    if player.destRect.x > 400 then
        player.destRect.x:=400;

    for i:=1 to taille do
        begin
        if background[i].destRect.x < -1800 then
            begin
            background[i].destRect.x:=895*(taille-1);
            end;
        if background[i].destRect.x >1800 then
            begin
            background[i].destRect.x:=-895-taille;
            end;
        end;
    end;

procedure move(var player:Tplayer;var background:TabBackground;up,right,left:boolean;top:integer;var counter:real);
var speed,i:integer;
begin
    
    if (up = True)then
    begin
        speed:=round((player.destRect.y - top)/30)+2;
        player.destRect.y:= player.destRect.y -speed;
    end;
    if (right = True)then
        begin
        if player.destRect.x=400 then
        begin
        for i:=1 to taille do
            background[i].destRect.x:= background[i].destRect.x + round(counter);
        end
        else
            player.destRect.x:=player.destRect.x-round(counter);
        if counter > -7 then
            counter:= counter-0.2;
        end;
    if (left = True)then
    begin
        if player.destRect.x = 0 then
        begin
        for i:=1 to taille do
            background[i].destRect.x:= background[i].destRect.x + round(counter);
        end
        else
            player.destRect.x:=player.destRect.x-round(counter);
    if counter < 7 then
        counter:= counter+0.2;
    end;
end;

procedure Gravity(var player:Tplayer;var up,down:boolean;level:integer;var top:integer);
var speed:integer;
begin
    if (player.destRect.y = top) or (player.destRect.y < absoluteTop)  then
    begin
        down:=True;
        up:=False;
    end;
    if (player.destRect.y >= level) then
        begin
        down:=False;
        top:=absoluteTop;
        if player.destRect.y <> FloorLevel then
        player.destRect.y := FloorLevel;
        end;
    if down then
        begin
        speed:=round((player.destRect.y -top)/30)+2;
        player.destRect.y:= player.destRect.y + speed;
        end;
end;



begin
    FloorLevel:=400;
    top:=absoluteTop;
    if SDL_Init(SDL_INIT_VIDEO) < 0 then
        Halt;

    sdlWindow1 := SDL_CreateWindow('window1',50,50,1280,720, SDL_WINDOW_SHOWN);
    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);

    player.surface := IMG_Load('./assets/mario.png');
    for i:=1 to taille do
        begin
        background[i].surface:= IMG_Load('./assets/background.png');
        background[i].texture:= SDL_CreateTextureFromSurface(sdlRenderer,background[i].surface);
        background[i].destRect.x:=0+900*(i-1);
        background[i].destRect.y:=0;
        background[i].destRect.w:=900;
        background[i].destRect.h:=500;
        end;
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);


    //Mario
    player.destRect.x:=20;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;

    quit := false;
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
            for i:=1 to taille do
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
        for i:=1 to taille do
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