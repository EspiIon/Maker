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
type TabBackground = array[1..taille] of Tbackground;

type Tbloc =
    record
    destRect:TSDL_Rect;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
    id:integer;
    bloc:boolean;
    end;

type TabBloc = array of array of tbloc;

type Tplayer =
    record
    destRect:TSDL_Rect;
    life:integer;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
    end;

var
    FloorLevel,top,i,k,n:integer;
    counter:real;
    sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    player:Tplayer;
    background:TabBackground;
    left,right,up,down:boolean;
    niveau:TabBloc;
    event:TSDL_Event;
    quit:boolean;

procedure Generation(var niveau:TabBloc;player:Tplayer;background:TabBackground;taille:integer);
var r:integer;
begin
    randomize();
    setlength(niveau,taille,6);
    for i:= 0 to taille-1 do
        begin
        for k:=0 to 5 do
            begin
                r:=random(2+k);
                writeln(r);
                if r=1 then
                begin
                    niveau[i][k].bloc:=True;
                    niveau[i][k].surface:= IMG_Load('./assets/terre.jpg');
                    niveau[i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,niveau[i][k].surface);
                    niveau[i][k].destRect.x:=0+40*(i);
                    niveau[i][k].destRect.y:=450 -40*k;
                    niveau[i][k].destRect.w:=40;
                    niveau[i][k].destRect.h:=40;
                end;
            end;
        end;
end;
procedure affichage(player:Tplayer;background:TabBackground;niveau:TabBloc;taille:integer;sdlrenderer:PSDL_Renderer);
begin
        SDL_RenderClear(sdlRenderer);
        for i:=1 to 3 do
            begin
            SDL_RenderCopy(sdlRenderer,background[i].texture,nil, @background[i].destRect);
            end;
        for i:=0 to taille-1 do
            for k:=0 to 5 do
                begin
                if niveau[i][k].bloc =True then
                SDL_RenderCopy(sdlRenderer,niveau[i][k].texture,nil, @niveau[i][k].destRect);
                end;
        SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);
        SDL_RenderPresent(sdlRenderer);
end;
procedure Hitbox(var player:Tplayer;var background:TabBackground;niveau:TabBloc;taille:integer);
begin
    for i:=0 to taille do
    begin
        for k:=0 to 5 do
        begin
            for n:=0 to 15 do
            begin
                if niveau[i][k].destRect.x+i = player.destRect.x+50 then
                begin
                    player.destRect.x:= player.destRect.x -40;
                end;
            end;
        end;
    end;
end;

procedure GoodPosition(var player:Tplayer;var background:TabBackground);
var i:integer;
    begin
    if player.destRect.x < 0 then
        player.destRect.x:=0;
    if player.destRect.x > 400 then
        player.destRect.x:=400;

    for i:=1 to taille do
        begin
        if background[i].destRect.x < -900 then
            begin
            background[i].destRect.x:=1800;
            end;
        if background[i].destRect.x >1800 then
            begin
            background[i].destRect.x:=-895;
            end;
        end;
    end;

procedure move(var player:Tplayer;var background:TabBackground;up,right,left:boolean;top:integer;var counter:real);
var speed,i:integer;
begin
    
    if (up = True)then
    begin
        speed:=round((player.destRect.y - top)/30)+3;
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
    if (player.destRect.y <= top) or (player.destRect.y < absoluteTop)  then
    begin
        down:=True;
        up:=False;
    end;
    if (player.destRect.y >= level) then
        begin
        down:=False;
        top:=absoluteTop;
        if player.destRect.y <> level then
            player.destRect.y := level;
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
    Generation(niveau,player,background,50);
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
        Hitbox(player,background,niveau,taille);
        Gravity(player,up,down,FloorLevel,top);
        GoodPosition(player,background);
        affichage(player,background,niveau,50,sdlrenderer);
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

            if event.type_ = SDL_KEYUP then
                begin
                if event.key.keysym.sym = SDLK_SPACE then
                    begin
                    top:= player.destRect.y -50;
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

    end;

    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;

end.