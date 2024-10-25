program menu;

uses sdl2, sdl2_image;

const 
	SURFACEWIDTH=700; {largeur en pixels de la surface de jeu}
	SURFACEHEIGHT=450; {hauteur en pixels de la surface de jeu}
	IMAGEWIDTH=100; {largeur en pixels de l'image}
	IMAGEHEIGHT=100; {hauteur en pixels de l'image}
	

{Procedure d'initialisation des elements de l'affichage: 
* la fenetre et l'image}
procedure initialise(var sdlwindow: PSDL_Window; var sdlRenderer:PSDL_Renderer;var play : PSDL_TEXTURE);
begin
	{charger la bibliotheque}
	SDL_Init(SDL_INIT_VIDEO);
 

	{création de la fenêtre et du rendu de l'affichage}
	SDL_CreateWindowAndRenderer(SURFACEWIDTH, SURFACEHEIGHT, SDL_WINDOW_SHOWN, @sdlwindow, @sdlRenderer);								
	{chargement de l'image comme texture}									
	play := IMG_LoadTexture(sdlRenderer, 'play.jpg');

end;

procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer:PSDL_Renderer; var play : PSDL_TEXTURE);
begin
	{vider la memoire correspondant a l'image et a la fenetre}
	SDL_DestroyTexture(play);	
	SDL_DestroyRenderer(sdlRenderer);
	SDL_DestroyWindow(sdlwindow);
	
	{decharger la bibliotheque}
	SDL_Quit();
end;

{Procedure d'affichage}
procedure affiche(var sdlRenderer: PSDL_Renderer; play: PSDL_TEXTURE);
	var destination_rect : TSDL_RECT;
begin
	{Choix de la position et taille de l'element a afficher}
	destination_rect.x:=(SURFACEWIDTH - IMAGEWIDTH) div 2;
	destination_rect.y:=(SURFACEHEIGHT - IMAGEHEIGHT) div 2;
	destination_rect.w:=IMAGEWIDTH;
	destination_rect.h:=IMAGEHEIGHT;
	
	{Coller l'element play dans le rendu en cours avec les 
	* caracteristiques destination_rect}
	SDL_RenderCopy(sdlRenderer, play, nil, @destination_rect);

	{Générer le rendu de la nouvelle image}
	SDL_RenderPresent(sdlRenderer);
end;

{Gestion clic souris}
procedure processMouseEvent(mouseEvent:TSDL_MouseButtonEvent; var suite : Boolean);//mouseEvent = sdlEvent^.motion
var
   x,y : LongInt ;
begin
	{recuperation des coordonnees}
   //SDL_GetMouseState( x, y );
	x:=mouseEvent.x;
	y:=mouseEvent.y;
    {test de la position: dans l'image?}
   if (x > (SURFACEWIDTH - IMAGEWIDTH) div 2) and ( x<(SURFACEWIDTH + IMAGEWIDTH) div 2) 
		and ( y > (SURFACEHEIGHT - IMAGEHEIGHT) div 2) and ( y<(SURFACEHEIGHT + IMAGEHEIGHT) div 2) then
			suite:=True
	else
		suite:=False;
end; 

var fenetre: PSDL_Window;
	jouer: PSDL_Texture;
	rendu: PSDL_Renderer;
	event: TSDL_Event; {Un événement}
    suite: boolean;
	
begin
	initialise(fenetre,rendu,jouer);
	affiche(rendu,jouer);
	
 suite:=False;
  
 
	repeat
		{On se limite a 100 fps.}
		SDL_Delay(10);
		{On affiche la scene}
		affiche(rendu,jouer);
		{On lit un evenement et on agit en consequence}
		SDL_PollEvent(@event);
	   
		if event.type_=SDL_MOUSEBUTTONDOWN then
		   processMouseEvent(event.button, suite);
		 
		if event.type_ = SDL_QUITEV then 
			suite:=True;	
	until suite;
	
	termine(fenetre,rendu,jouer);

end. 
