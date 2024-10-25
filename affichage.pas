unit affichage;


interface
uses structure,SDL2,SDL2_image;

procedure defBackground(var background:TabBackground;var background2:Tbackground;sdlRenderer:PSDL_Renderer;taille:integer);
procedure defplayer(var player:Tplayer;var sdlRenderer:PSDL_Renderer);
procedure display(player:Tplayer;enemies:Tenemies;background:TabBackground;background2:Tbackground;niveau:Tniveau;sdlrenderer:PSDL_Renderer);


implementation
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

procedure defplayer(var player:Tplayer;var sdlRenderer:PSDL_Renderer);
begin
    player.surface := IMG_Load('./assets/player.png');
    player.texture:= SDL_CreateTextureFromSurface(sdlRenderer,player.surface);
    player.destRect.x:=20;
    player.destRect.y:=400;
    player.destRect.w:=50;
    player.destRect.h:=50;
    player.life:=20;
end;

procedure display(player:Tplayer;enemies:Tenemies;background:TabBackground;background2:Tbackground;niveau:Tniveau;sdlrenderer:PSDL_Renderer);
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
begin
end.