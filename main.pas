program main;

uses SDL2, SDL2_image;


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
    bloc,collision:boolean;
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
    FloorLevel,top,i,k,n,absoluteTop:integer;
    speedx,speedy:integer;
    sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    player:Tplayer;
    background:TabBackground;
    left,right,up,down,touchfloor,touchbottom:boolean;
    niveau:TabBloc;
    event:TSDL_Event;
    quit:boolean;


procedure defBackground(var background:TabBackground;sdlRenderer:PSDL_Renderer;taille:integer);
begin
for i:=1 to taille do
        begin
        background[i].surface:= IMG_Load('./assets/background.png');
        background[i].texture:= SDL_CreateTextureFromSurface(sdlRenderer,background[i].surface);
        background[i].destRect.x:=0+900*(i-1);
        background[i].destRect.y:=0;
        background[i].destRect.w:=900;
        background[i].destRect.h:=500;
        end;
end;
procedure keyinteraction(var up, down, right, left:boolean);
var event:TSDL_Event;
begin
while SDL_PollEvent(@event) <> 0 do
    begin
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
                if (event.key.keysym.sym = SDLK_SPACE) and not down then
                    begin
                        if not up then
                            absoluteTop:= player.destRect.y -150;
                        up:=True;
                    end;
            end;

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
                        speedx:=0;
                    end;
                if event.key.keysym.sym = SDLK_RIGHT then
                    begin
                        right:=false;
                        speedx:=0;
                    end;
                end;
    end;
end;
procedure defplayer(var player:Tplayer;var sdlRenderer:PSDL_Renderer);
begin
    player.surface := IMG_Load('./assets/mario.png');
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);
    player.destRect.x:=20;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;
end;

procedure highness(var player:Tplayer;up,down,touchfloor:boolean);
begin
 if (not down) and (not up) and touchfloor then
        begin
        writeln('aaaa');
        if ((player.destRect.y-400) mod 40) <> 0 then
        begin
            player.destRect.y := 400+40*(round((player.destRect.y-400)/40));
        end;
        end;
end;

procedure Generation(var niveau:TabBloc;player:Tplayer;background:TabBackground;taille:integer);
// var r:integer;
// begin
//     randomize();
//     setlength(niveau,taille,6);
//     for i:= 0 to taille-1 do
//         begin
//         for k:=0 to 5 do   
//             begin
//                 r:=random(2+k);
//                 if k=r then
//                 begin
//                     niveau[i][k].bloc:=True;
//                     niveau[i][k].surface:= IMG_Load('./assets/terre.jpg');
//                     niveau[i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,niveau[i][k].surface);
//                     niveau[i][k].destRect.x:=0+40*(i);
//                     niveau[i][k].destRect.y:=450-40*k;
//                     niveau[i][k].destRect.w:=40;
//                     niveau[i][k].destRect.h:=40;
//                 end;
//             end;
//         end;
begin
setlength(niveau,taille,6);
    for i:= 0 to taille-1 do
        begin
        k:=0;
            niveau[i][k].bloc:=True;
            niveau[i][k].surface:= IMG_Load('./assets/terre.jpg');
            niveau[i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,niveau[i][k].surface);
            niveau[i][k].destRect.x:=0+40*(i);
            niveau[i][k].destRect.y:=450-40*k;
            niveau[i][k].destRect.w:=40;
            niveau[i][k].destRect.h:=40;
            for k:=1 to 5 do 
                    begin
                    if ((i>7) and (k<2)) or ((i>7)and (i<22) and (k>4))  then
                    begin
                        niveau[i][k].bloc:=True;
                        niveau[i][k].surface:= IMG_Load('./assets/terre.jpg');
                        niveau[i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,niveau[i][k].surface);
                        niveau[i][k].destRect.x:=0+40*(i);
                        niveau[i][k].destRect.y:=450-40*k;
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
procedure Hitbox(player:Tplayer;background:TabBackground;var niveau:TabBloc;taille:integer;var speedx,speedy:integer;var up,down,touchfloor,touchbottom:boolean);
var leftbloc,rightbloc,bottombloc,topbloc:TSDL_Rect;
begin
    touchfloor:=False;
    touchbottom:=False;
    for i:=0 to taille-1 do
    begin
        for k:=0 to 5 do
        begin
            if niveau[i][k].bloc = True then
            begin
                leftbloc.y:=niveau[i][k].destRect.y;
                leftbloc.x:=niveau[i][k].destRect.x;
                leftbloc.h:=niveau[i][k].destRect.h;
                leftbloc.w:=2;

                rightbloc.y:=niveau[i][k].destRect.y;
                rightbloc.x:=niveau[i][k].destRect.x+niveau[i][k].destRect.w;
                rightbloc.h:=niveau[i][k].destRect.h;
                rightbloc.w:=2;

                bottombloc.y:=niveau[i][k].destRect.y+niveau[i][k].destRect.h+5;
                bottombloc.x:=niveau[i][k].destRect.x;
                bottombloc.h:=1;
                bottombloc.w:=niveau[i][k].destRect.w;

                topbloc.y:=niveau[i][k].destRect.y-1;
                topbloc.x:=niveau[i][k].destRect.x;
                topbloc.h:=1;
                topbloc.w:=niveau[i][k].destRect.w;

                if SDL_HasIntersection(@player.destRect,@bottombloc) then
                    begin
                        touchbottom:=True;
                    end;
                if SDL_HasIntersection(@player.destRect,@topbloc) then
                    begin
                    touchfloor:=True;
                    down:=false;
                    end
                else
                    touchfloor:=touchfloor;
                if SDL_HasIntersection(@player.destRect,@leftbloc) then
                    begin
                        speedx:=-2;
                    end
                else if SDL_HasIntersection(@player.destRect,@rightbloc) then
                    begin
                        speedx:=2;
                    end;
            end;
        end;
    end;
end;
function HitboxExtended(player:Tplayer;background:TabBackground;var niveau:TabBloc;taille:integer):boolean;
begin
    HitboxExtended:=false;
    player.destRect.h:=player.destRect.h +1;
    for i:=0 to taille-1 do
    begin
        for k:=0 to 5 do
        begin
            if niveau[i][k].bloc = True then
            begin
                if SDL_HasIntersection(@player.destRect,@niveau[i][k].destRect) then
                    begin
                        HitboxExtended:=True;
                    end
                    else
                        HitboxExtended:=HitboxExtended;
            end;
        end;
    end;
end;
procedure GoodPosition(var player:Tplayer;var background:TabBackground);
var i:integer;
    begin
    if player.destRect.x < 0 then
        player.destRect.x:=0;
    

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



procedure move(var player:Tplayer;var background:TabBackground;up,right,left:boolean;top:integer;var speedx:integer);
var speedy,i:integer;
begin 
    if (up = True)then
    begin
        speedy:=round((player.destRect.y - top)/30)+3;
        player.destRect.y:= player.destRect.y -speedy;
    end;
    if (right = True) then
        begin
         if speedx < 5 then
            speedx:= speedx+1;
        end
    else if (left = True)  then
    begin
        if speedx > -5 then
            speedx:= speedx-1;
    end
    else
        speedx:=0;
player.destRect.x := player.destRect.x+(speedx);

end;

procedure Gravity(var player:Tplayer;var up,down,touchbottom:boolean;level:integer;var top,speedy:integer);
begin
    if (player.destRect.y <= top) or (player.destRect.y < absoluteTop) or touchbottom or ((not touchfloor) and (not up))  then
    begin
        down:=True;
        up:=False;
        top:=player.destRect.y;
    end;
    if touchfloor then
        begin
            down:=False;
            top:=absoluteTop;
        end;
    if down then
        begin
        speedy:=round((player.destRect.y-top)/30)+3;
        player.destRect.y:= player.destRect.y + speedy;
        end;
end;

begin
    FloorLevel:=400;
    sdlWindow1 := SDL_CreateWindow('window1',50,50,1280,720, SDL_WINDOW_SHOWN);
    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
    defBackground(background,sdlRenderer,3);
    defplayer(player,sdlRenderer);
    Generation(niveau,player,background,50);
    quit := false;

    //boucle principale
    while not quit do
    begin
        if player.destRect.y < absoluteTop then
            up:=False;
        highness(player,up,down,touchfloor);
        move(player,background,up,right,left,top,speedx);
        Gravity(player,up,down,touchbottom,FloorLevel,top,speedy);
        GoodPosition(player,background);
        affichage(player,background,niveau,50,sdlrenderer);
        keyinteraction(up, down, right, left);
        Hitbox(player,background, niveau,50,speedx,speedy,up,down,touchfloor,touchbottom);
        sdl_delay(10);

    end;
    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;
end.