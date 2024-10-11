program test_scores;

uses scores, sysutils;

var nom : string;
    distance : integer;
    temps : integer;
    score : TScore;
    listescores : TabScores;
    i : integer;
    choix : integer;

procedure menu(var choix : integer);
begin
    writeln('Que voulez vous faire ? ');
    writeln('1. Ajouter un score');
    writeln('2. Lire les scores');
    writeln('3. Enregistrer les scores');
    writeln('4. Quitter');
    readln(choix);
end;

begin

    SetLength(listescores, 0);
    choix := 0;

    if FileExists(FILE_NAME) then
    begin
        // Lire les scores du fichier
        lireScores(listescores);
    end
    else
    begin
        // Créer un fichier de scores vide
        ecrireScores(listescores);
    end;
    
    while choix <> 4 do
    begin
        menu(choix);
        if choix = 1 then
        begin
            writeln('----- Ajouter un joueur -----');
            writeln('Entrez le nom du joueur : ');
            readln(nom);
            writeln('Entrez la distance parcourue : ');
            readln(distance);
            writeln('Entrez le temps mis : ');
            readln(temps);
            score := creerScore(nom, distance, temps);
            ajouterScore(listescores, score);
            writeln('---------------------------------');
        end
        else if choix = 2 then
        begin
            writeln('----- Lecture des scores -----');
            for i := 0 to High(listescores) do
            begin
                writeln('Nom : ', listescores[i].nom);
                writeln('Distance : ', listescores[i].distance);
                writeln('Temps : ', listescores[i].temps);
            end;
            writeln('---------------------------------');
        end
        else if choix = 3 then
        begin
            writeln('--- Enregistrement des scores ---');
            ecrireScores(listescores);
            writeln('---------------------------------');
        end;
    end;
end.