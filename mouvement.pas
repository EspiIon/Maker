unit mouvement;

uses structure;

interface
procedure move(var player:Tplayer;var background:TabBackground;var enemies:Tenemies;var niveau:Tniveau;top:integer);
procedure PositionEnemies(player:tplayer;var enemies:Tenemies;var niveau:Tniveau);
procedure Gravity(var player:Tplayer;level:integer;var top,speedy:integer);
procedure Hitbox(var player:Tplayer;background:TabBackground;var niveau:Tniveau);
procedure GoodPosition(var player:Tplayer;var background:TabBackground);

implementation
procedure move(var player:Tplayer;var background:TabBackground;var enemies:Tenemies;var niveau:Tniveau;top:integer);
var i,k,l:integer;
begin 
    if (player.up = True) and not player.down then
        begin
            player.speedy:=round((player.destRect.y - top)/25)+3;
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

procedure PositionEnemies(player:tplayer;var enemies:Tenemies;var niveau:Tniveau);
var i:integer;
begin
for i:=0 to 1 do
    begin
        enemies.lEnemies[i].destRect.x:=enemies.lEnemies[i].destRect.x-player.speedx;
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
        speedy:=round((player.destRect.y-top)/25)+4;
        player.destRect.y:= player.destRect.y + speedy;
        end;
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
                    bottombloc.x:=niveau.lniveau[l][i][k].destRect.x+5;
                    bottombloc.h:=1;
                    bottombloc.w:=niveau.lniveau[l][i][k].destRect.w-20;

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
