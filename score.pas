var
  sdlSurface1 : PSDL_Surface;
  ttfFont : PTTF_Font;
  sdlColor1 : TSDL_Color;
  sdlWindow1 : PSDL_Window;
  sdlRenderer : PSDL_Renderer;
  sdlTexture1 : PSDL_Texture;
  sdlRectangle: TSDL_Rect;
  text : String;
  ptxt : pChar;
  i : Integer;
  previousH : Integer;
begin

    previousH := 0;

    //initilization of video subsystem
    if SDL_Init(SDL_INIT_VIDEO) < 0 then HALT;

    sdlWindow1 := SDL_CreateWindow('Window1', 250, 250, 500, 500, SDL_WINDOW_SHOWN);
    if sdlWindow1 = nil then HALT;

    sdlRenderer := SDL_CreateRenderer(sdlWindow1, -1, 0);
    if sdlRenderer = nil then HALT;  

    if TTF_Init = -1 then HALT;
    ttfFont := TTF_OpenFont('assets/roboto.ttf', 19);
    sdlColor1.r := 255; sdlColor1.g := 0; sdlColor1.b := 0;


    for i := 0 to High(scores) do
    begin
        text := scores[i].nom + ' : ' + IntToStr(scores[i].distance) + 'm en ' + IntToStr(scores[i].temps) + ' secondes';
        ptxt := StrAlloc(length(text)+1);
        StrPCopy(ptxt,text);
        sdlSurface1 := TTF_RenderUTF8_Blended(ttfFont, ptxt, sdlColor1);
        sdlTexture1 := SDL_CreateTextureFromSurface(sdlRenderer, sdlSurface1);
        sdlRectangle.x := 12;
        sdlRectangle.y := 25 + previousH;
        sdlRectangle.w := sdlSurface1^.w;
        sdlRectangle.h := sdlSurface1^.h;
        previousH := previousH + sdlSurface1^.h;
        SDL_RenderCopy(sdlRenderer, sdlTexture1, nil, @sdlRectangle);
        strDispose(ptxt);
    end;

    SDL_RenderPresent(sdlRenderer);
    SDL_Delay(5000);

    //cleaning procedure
    TTF_CloseFont(ttfFont);
    TTF_Quit;


    // clear memory
    SDL_FreeSurface(sdlSurface1);
    SDL_DestroyTexture(sdlTexture1);
    SDL_DestroyRenderer(sdlRenderer);
    SDL_DestroyWindow(sdlWindow1);

    //closing SDL2
    SDL_Quit;
end;

end.
