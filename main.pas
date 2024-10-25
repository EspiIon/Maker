program main;

uses SDL2, SDL2_image,structure,affichage,mouvement;

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
                            player.absoluteTop:= player.destRect.y -150;
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
                            if (n=1) and (i<4) and (k=0) then
                                begin
                                    pattern[n][i][k].bloc:=True;
                                    pattern[n][i][k].surface:= IMG_Load('./assets/terre.png');
                                    pattern[n][i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,pattern[n][i][k].surface);
                                    pattern[n][i][k].destRect.y:=450-40*k;
                                    pattern[n][i][k].destRect.w:=40;
                                    pattern[n][i][k].destRect.h:=40;
                                end;
                             if (n=2) and (((i >= 3) and (k=0)) or (k =3))then
                                begin
                                    pattern[n][i][k].bloc:=True;
                                    pattern[n][i][k].surface:= IMG_Load('./assets/terre.png');
                                    pattern[n][i][k].texture:= SDL_CreateTextureFromSurface(sdlRenderer,pattern[n][i][k].surface);
                                    pattern[n][i][k].destRect.y:=450-40*k;
                                    pattern[n][i][k].destRect.w:=40;
                                    pattern[n][i][k].destRect.h:=40;
                                end;
                            if (n=3) and (k <= i) then
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
                    r:=random(3)+1;
                    for i:=0 to 4 do
                        begin
                            for k:=0 to 4 do
                                begin
                                    if (l=1) and (s=0) then
                                        begin
                                            
                                            niveau.lniveau[l][i+s*5][k]:=pattern[1][i][k];
                                            niveau.lniveau[l][i+s*5][k].destRect.x:=(i+s*5)*(40)+(l-1)*900+1;
                                        end
                                        else
                                            begin
                                                niveau.lniveau[l][i+s*5][k]:=pattern[r][i][k];
                                                niveau.lniveau[l][i+s*5][k].destRect.x:=(i+s*5)*(40)+(l-1)*900+1;
                                            end;
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
    randomize();
    for l:=1 to 3 do
            begin
                if niveau.lniveau[l][0][0].destRect.x <= -1000 then
                    begin
                        s:=0;
                        ry:=0; 
                        while s <> 5 do
                            begin
                            r:=random(3)+1;
                                for i:=0 to 4 do
                                    begin
                                        for k:=0 to 4 do 
                                            begin
                                                niveau.lniveau[l][i+s*5][k]:=pattern[r][i][k];
                                                niveau.lniveau[l][i+s*5][k].destRect.x:=(i+s*5)*40+2000+1;
                                            end;
                                    end;
                                s:=s+1;
                            end;
        // while niveau[rx][ry].bloc = True do
        //     begin
        //         ry:=ry+1;affi
        //     end;
        // enemies.lEnemies[i].destRect.y:=niveau[rx][ry-1].destRect.y-niveau[rx][ry-1].destRect.h-7;
        // enemies.lEnemies[i].destRect.x:=40*rx+(l-1)*900;
                            end;
            end;
end;

procedure starting(var niveau:Tniveau;var pattern:TabPattern;var player:Tplayer;var enemies:Tenemies;var background:TabBackground;var background2:Tbackground);
begin
    randomize();
    player.death:=False;
    niveau.taillex:=25;
    niveau.tailley:=5;
    enemies.taille:=2;
    FloorLevel:=400;
    defBackground(background,background2,sdlRenderer,3);
    defplayer(player,sdlRenderer);
    declarationPattern(pattern);
    Generation(niveau,pattern,player,enemies,background);
    quit := false;
end;
procedure death(var player:Tplayer);
var death:boolean;
begin
    if player.destRect.y > 600 then
        begin
        player.death:=True;   
        end;
    if player.life <= 0 then
        begin
        player.death:=True;
        end;
    if player.death then
        begin
        starting(niveau,pattern,player,enemies,background,background2);
        end;
end;
begin
    sdlWindow1:=SDL_CreateWindow('window1',450,150,900,500, SDL_WINDOW_SHOWN);
    sdlRenderer:=SDL_CreateRenderer(sdlWindow1, -1, 0);
    starting(niveau,pattern,player,enemies,background,background2);
    //boucle principale
    while not quit do
    begin
        if player.destRect.x >450 then
            player.destRect.x:= 450;

        if player.destRect.y < player.absoluteTop then
            player.up:=False;
        death(player);
        highness(player);
        move(player,background,enemies,niveau,top);
        Gravity(player,FloorLevel,top,speedy);
        GoodPosition(player,background);
        display(player,enemies,background,background2,niveau,sdlrenderer);
        keyinteraction(player);
        Hitbox(player,background,niveau);
        proceduralGen(niveau,pattern,player);
        sdl_delay(10);

    end;
    SDL_DestroyRenderer(sdlrenderer);
    SDL_DestroyWindow(sdlWindow1);
    SDL_Quit;
end.
