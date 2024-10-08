program main;

uses SDL2, SDL2_image;

const taille = 3;


type Tenemy=
    record
        surface:PSDL_Surface;
        texture:PSDL_Texture;
        destRect:TSDL_Rect;
        life,id:integer;
    end;
type Tenemies=
    record
        lEnemies:array of Tenemy;
        taille:integer;
    end;
type TabEnemy = array of Tenemy;

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

type TabBloc = array of array of Tbloc;
type Tabniveau = array[1..3] of TabBloc;

type Tniveau =
    record
    lniveau:Tabniveau;
    taillex,tailley:integer
    end;

type TabPattern = array[1..5] of TabBloc;

type Tplayer =
    record
    destRect:TSDL_Rect;
    life,speedx,speedy:integer;
    distance:real;
    surface:PSDL_Surface;
    texture:PSDL_Texture;
    left,right,up,down,touchfloor,touchbottom:boolean;
    end;

var 
    enemies:Tenemies;
    FloorLevel,top,absoluteTop,i,k,n,l:integer;
    speedy:integer;
    sdlWindow1:PSDL_Window;
    sdlRenderer:PSDL_Renderer;
    player:Tplayer;
    background:TabBackground;
    background2:Tbackground;
    niveau:Tniveau;
    pattern:TabPattern;
    quit:boolean;


procedure defBackground(var background:TabBackground;var background2:Tbackground;sdlRenderer:PSDL_Renderer;taille:integer);
var i:integer;
begin
    background2.surface:= IMG_Load('./assets/background2.png');
    background2.texture:=SDL_CreateTextureFromSurface(sdlRenderer,background2.surface);
    background2.destRect.x:=0;
    background2.destRect.y:=0;
    background2.destRect.w:=900;
    background2.destRect.h:=500;
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

procedure PositionEnemies(player:tplayer;var enemies:Tenemies;var niveau:Tniveau);
var i:integer;
begin
for i:=0 to 1 do
    begin
        enemies.lEnemies[i].destRect.x:=enemies.lEnemies[i].destRect.x-player.speedx;
    end;
end;

procedure keyinteraction(var player:Tplayer);
var event:TSDL_Event;
begin
while SDL_PollEvent(@event) <> 0 do
    begin
        if event.type_ = SDL_KEYDOWN then
            begin
                if event.key.keysym.sym = SDLK_LEFT then
                    begin
                        player.left:=True;
                        player.right:=False;   
                    end;
                if event.key.keysym.sym = SDLK_RIGHT then
                    begin
                    player.right:=True;
                    player.left:=False;
                    end;
                if (event.key.keysym.sym = SDLK_SPACE) and not player.down then
                    begin
                        if not player.up then
                            absoluteTop:= player.destRect.y -150;
                        player.up:=True;
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
                        player.left:=false;
                        player.speedx:=0;
                    end;
                if event.key.keysym.sym = SDLK_RIGHT then
                    begin
                        player.right:=false;
                        player.speedx:=0;
                    end;
                end;
    end;
end;
procedure defplayer(var player:Tplayer;var sdlRenderer:PSDL_Renderer);
begin
    player.surface := IMG_Load('./assets/player.png');
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);
    player.destRect.x:=20;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;
end;

procedure highness(var player:Tplayer);
begin
 if (not player.down) and (not player.up) and player.touchfloor then
        begin
            if ((player.destRect.y-400) mod 40) <> 0 then
                begin
                    player.destRect.y := 400+40*(round((player.destRect.y-400)/40));
                end;
        end;
end;
procedure declarationPattern(var pattern:TabPattern);
var i,k,n:integer;
begin
    for n:=1 to 5 do
        begin
            setlength(pattern[n],5,5);
            for i:=0 to 4 do
                begin
                    for k:=0 to 4  do
                        begin
                            if (i<(n+1)) and (k=0) then
                                begin
                                    pattern[n][i][k].bloc:=True;
                                    pattern[n][i][k].surface:= IMG_Load('./assets/terre.png');
                                    pattern[n][i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,pattern[n][i][k].surface);
                                    pattern[n][i][k].destRect.y:=450-40*k;
                                    pattern[n][i][k].destRect.w:=40;
                                    pattern[n][i][k].destRect.h:=40;
                                end;
                        end;
                end;
        end;
end;
procedure Generation(var niveau:Tniveau;pattern:TabPattern;player:Tplayer;var enemies:Tenemies;background:TabBackground);
var s,i,k,l,ry,rx,r:integer;
begin
    for l:=1 to 3 do
        begin
            s:=0;
            ry:=0; 
            setlength(niveau.lniveau[l],niveau.taillex,niveau.tailley);
            enemies.taille:=enemies.taille*3;
            setlength(enemies.lEnemies,enemies.taille);       
            while s <> 5 do
                begin
                    r:=random(4)+1;
                    for i:=0 to 4 do
                        begin
                            for k:=0 to 4 do
                                begin
                                    niveau.lniveau[l][i+s*5][k]:=pattern[r][i][k];
                                    niveau.lniveau[l][i+s*5][k].destRect.x:=(i+s*5)*(40)+(l-1)*900;
                                end;
                        end;
                    s:=s+1;
                end;
            end;
                begin
                    for i:= 0 to enemies.taille-1 do
                        begin
                            rx:=random(niveau.taillex-7)+7;
                            enemies.lEnemies[i].surface:= IMG_Load('./assets/orc.png');
                            enemies.lEnemies[i].texture:= SDL_CreateTextureFromSurface(sdlRenderer,enemies.lEnemies[i].surface);
                            enemies.lEnemies[i].destRect.w:=60;
                            enemies.lEnemies[i].destRect.h:=50;
                            ry:=0;
                            while niveau.lniveau[l][rx][ry].bloc = True do
                                begin
                                    ry:=ry+1;
                                end;
                            enemies.lEnemies[i].destRect.y:=niveau.lniveau[l][rx][ry-1].destRect.y-niveau.lniveau[l][rx][ry-1].destRect.h-7;
                            enemies.lEnemies[i].destRect.x:=40*rx+(l-1)*900+1;
                        end;
    end;
end;

procedure proceduralGen(var niveau:Tniveau;pattern:TabPattern;player:Tplayer);
var s,i,k,l,ry,rx,r:integer;
begin
    for l:=1 to 3 do
            begin
                if niveau.lniveau[l][0][0].destRect.x <= -900 then
                    begin
                        s:=0;
                        ry:=0; 
                        while s <> 5 do
                            begin
                                r:=random(4)+1;
                                for i:=0 to 4 do
                                    begin
                                        for k:=0 to 4 do 
                                            begin
                                                niveau.lniveau[l][i+s*5][k]:=pattern[r][i][k];
                                                niveau.lniveau[l][i+s*5][k].destRect.x:=(i+s*5)*40+1800+1;
                                            end;
                                    end;
                                s:=s+1;
                            end;
        // while niveau[rx][ry].bloc = True do
        //     begin
        //         ry:=ry+1;
        //     end;
        // enemies.lEnemies[i].destRect.y:=niveau[rx][ry-1].destRect.y-niveau[rx][ry-1].destRect.h-7;
        // enemies.lEnemies[i].destRect.x:=40*rx+(l-1)*900;
                            end;
            end;
end;
procedure affichage(player:Tplayer;enemies:Tenemies;background:TabBackground;background2:Tbackground;niveau:Tniveau;sdlrenderer:PSDL_Renderer);
var i,k,l:integer;
begin
        SDL_RenderClear(sdlRenderer);
        SDL_RenderCopy(sdlrenderer,background2.texture,nil,@background2.destRect);

        for i:=1 to 3 do
            begin
                SDL_RenderCopy(sdlRenderer,background[i].texture,nil, @background[i].destRect);
            end;
        for l:=1 to 3 do
            begin
                for i:=0 to niveau.taillex-1 do
                    for k:=0 to 5 do
                        begin
                            if niveau.lniveau[l][i][k].bloc =True then
                            SDL_RenderCopy(sdlRenderer,niveau.lniveau[l][i][k].texture,nil, @niveau.lniveau[l][i][k].destRect);
                        end;
            end;
        for i:=0 to 1 do
            begin
                SDL_RenderCopy(sdlRenderer,enemies.lEnemies[i].texture,nil, @enemies.lEnemies[i].destRect);
            end;
        SDL_RenderCopy(sdlrenderer,player.texture,nil,@player.destRect);
        SDL_RenderPresent(sdlRenderer);
end;
procedure Hitbox(var player:Tplayer;background:TabBackground;var niveau:Tniveau);
var leftbloc,rightbloc,bottombloc,topbloc:TSDL_Rect;
	i,k,l:integer;
begin
    player.touchfloor:=False;
    player.touchbottom:=False;
    for l:=1 to 3 do
    begin
        for i:=0 to niveau.taillex-1 do
        begin
            for k:=0 to 5 do
            begin
                if niveau.lniveau[l][i][k].bloc = True then
                begin
                    leftbloc.y:=niveau.lniveau[l][i][k].destRect.y;
                    leftbloc.x:=niveau.lniveau[l][i][k].destRect.x;
                    leftbloc.h:=niveau.lniveau[l][i][k].destRect.h;
                    leftbloc.w:=1;

                    rightbloc.y:=niveau.lniveau[l][i][k].destRect.y;
                    rightbloc.x:=niveau.lniveau[l][i][k].destRect.x+niveau.lniveau[l][i][k].destRect.w;
                    rightbloc.h:=niveau.lniveau[l][i][k].destRect.h;
                    rightbloc.w:=1;

                    bottombloc.y:=niveau.lniveau[l][i][k].destRect.y+niveau.lniveau[l][i][k].destRect.h;
                    bottombloc.x:=niveau.lniveau[l][i][k].destRect.x;
                    bottombloc.h:=1;
                    bottombloc.w:=niveau.lniveau[l][i][k].destRect.w;

                    topbloc.y:=niveau.lniveau[l][i][k].destRect.y-1;
                    topbloc.x:=niveau.lniveau[l][i][k].destRect.x+5;
                    topbloc.h:=1;
                    topbloc.w:=niveau.lniveau[l][i][k].destRect.w-20;

                    if SDL_HasIntersection(@player.destRect,@bottombloc) then
                        begin
                            player.touchbottom:=True;
                        end;
                    if SDL_HasIntersection(@player.destRect,@topbloc) then
                        begin
                        player.touchfloor:=True;
                        player.down:=false;
                        end
                    else
                        player.touchfloor:=player.touchfloor;
                    if SDL_HasIntersection(@player.destRect,@leftbloc) then
                        begin
                            player.speedx:=-2;
                        end
                    else if SDL_HasIntersection(@player.destRect,@rightbloc) then
                        begin
                            player.speedx:=2;
                        end;
                end;
            end;
        end;
    end;
end;
function HitboxExtended(var player:Tplayer;background:TabBackground;var niveau:Tniveau):boolean;
var i,k,l:integer;
begin
    HitboxExtended:=false;
    player.destRect.h:=player.destRect.h +1;
    for l:=1 to 3 do
    begin
        for i:=0 to (niveau.taillex-1) do
        begin
            for k:=0 to 5 do
            begin
                if niveau.lniveau[l][i][k].bloc = True then
                begin
                    if SDL_HasIntersection(@player.destRect,@niveau.lniveau[l][i][k].destRect) then
                        begin
                            HitboxExtended:=True;
                        end
                        else
                            HitboxExtended:=HitboxExtended;
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



procedure move(var player:Tplayer;var background:TabBackground;var enemies:Tenemies;var niveau:Tniveau;top:integer);
var i,k,l:integer;
begin 
    if (player.up = True) and not player.down then
        begin
            player.speedy:=round((player.destRect.y - top)/30)+2;
            player.destRect.y:= player.destRect.y -player.speedy;
        end;
    if (player.right = True) then
        begin
            if player.speedx < 5 then
                player.speedx:=player.speedx+1;
        end
    else if (player.left = True)  then
        begin
            if player.speedx > -5 then
                player.speedx:=player.speedx-1;
        end
    else
        player.speedx:=0;

if ((player.destRect.x = 450) and player.right) or ((player.destRect.x = 0) and player.left) then
    begin
        positionEnemies(player,enemies,niveau);
        player.distance:=(player.distance+player.speedx/10);
        for l:=1 to 3 do
            begin
                for i:=0 to (niveau.taillex-1) do
                    begin
                        for k:=0 to niveau.tailley do
                            begin
                                if niveau.lniveau[l][i][k].bloc then
                                    niveau.lniveau[l][i][k].destRect.x := niveau.lniveau[l][i][k].destRect.x-player.speedx;
                            end;
                    end;
            end;
    end
    else
        begin
        player.distance:=(player.distance+player.speedx/10);
        player.destRect.x := player.destRect.x+(player.speedx);
        end;
end;

procedure Gravity(var player:Tplayer;level:integer;var top,speedy:integer);
begin
    if (player.destRect.y <= top) or (player.destRect.y < absoluteTop) or player.touchbottom or ((not player.touchfloor) and (not player.up))  then
    begin
        player.down:=True;
        player.up:=False;
        top:=player.destRect.y;
    end;
    if player.touchfloor then
        begin
            player.down:=False;
            top:=absoluteTop;
        end;
    if player.down then
        begin
        speedy:=round((player.destRect.y-top)/30)+3;
        player.destRect.y:= player.destRect.y + speedy;
        end;
end;

begin
    randomize();
    niveau.taillex:=25;
    niveau.tailley:=5;
    enemies.taille:=2;
    FloorLevel:=400;
    sdlWindow1:=SDL_CreateWindow('window1',450,150,900,500, SDL_WINDOW_SHOWN);
    sdlRenderer:=SDL_CreateRenderer(sdlWindow1, -1, 0);
    defBackground(background,background2,sdlRenderer,3);
    defplayer(player,sdlRenderer);
    declarationPattern(pattern);
    Generation(niveau,pattern,player,enemies,background);
    quit := false;
    //boucle principale
    while not quit do
    begin
        if player.destRect.x >450 then
            player.destRect.x:= 450;

        if player.destRect.y < absoluteTop then
            player.up:=False;
        highness(player);
        move(player,background,enemies,niveau,top);
        Gravity(player,FloorLevel,top,speedy);
        GoodPosition(player,background);
        affichage(player,enemies,background,background2,niveau,sdlrenderer);
        keyinteraction(player);
        Hitbox(player,background,niveau);
        proceduralGen(niveau,pattern,player);
        sdl_delay(10);

    end;
    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;
end.
