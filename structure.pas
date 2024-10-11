unit structure;
interface
uses SDL2;
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
    left,right,up,down,touchfloor,touchbottom,death:boolean;
    end;

implementation
begin
end.