unit scores;

interface

const FILE_NAME = 'scores.dat';

type TScore = record
    nom : string;
    distance: integer;
    temps : integer;
end;

type TabScores = array of TScore;

type FichierScores = file of TScore;

// procedure affichageScoreboard(scores : TabScores);

procedure lireScores(var scores : TabScores);

procedure ajouterScore(var scores : TabScores; score : TScore);

procedure ecrireScores(scores : TabScores);

function creerScore(nom : string; distance : integer; temps : integer) : TScore;

implementation

uses SDL2, SDL2_image, SDL2_ttf, SysUtils;

function creerScore(nom : string; distance : integer; temps : integer) : TScore;
var
    score : TScore;
begin
    score.nom := nom;
    score.distance := distance;
    score.temps := temps;
    creerScore := score;
end;

procedure ajouterScore(var scores: TabScores; score: TScore);
begin
    SetLength(scores, Length(scores) + 1);
    scores[High(scores)] := score;   
end;

procedure ecrireScores(scores: TabScores);
var f : FichierScores;
    i : integer;
begin
    assign(f, FILE_NAME);
    rewrite(f);
    for i := 0 to High(scores) do
    begin
        write(f, scores[i]);
    end;
    close(f);
end;

procedure lireScores(var scores: TabScores);
var
    f: FichierScores;
    score: TScore;
begin
    assign(f, FILE_NAME);
    reset(f);

    SetLength(scores, 0);

    while not EOF(f) do
    begin
        read(f, score); 
        SetLength(scores, Length(scores) + 1); 
        scores[High(scores)] := score; 
    end;
    
    close(f);
end;


begin
end.