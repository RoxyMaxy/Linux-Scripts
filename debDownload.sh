#!/bin/bash
#D'abord, on copie les fichiers .deb du répertoire apt vers le répertoire web pour plus de facilité
mkdir -p /var/www/html/deb/; cp /var/cache/apt/archives/*.deb /var/www/html/deb/ 2>/dev/null

#Ensuite créer la page HTML: le "content-type" au début
echo -e "Content-type: text/html\n\n"

#On ajoute l'option -e à echo pour reconnaîter les échappements
echo -e "<!DOCTYPE html>\n<html>\n<head>\n<meta charset=\"UTF-8\">\n<title>Fichiers deb</title>\n</head>"
echo -e "<body style=\"background-color:cornsilk;\">"
echo -e "<h1 style=\"color:slategrey; text-align:center\">Liste des fichiers .deb</h1>"

#Maintenant, on liste les fichiers .deb avec leurs liens de téléchargement
    for i in $(ls /var/www/html/deb/); do
        echo "<p style=\"color:green;\"><a href=\"deb/$i\" download>$i</a></p>"
    done
echo -e "</body>\n</html>"

#Modifier des permissions pour que tout utilisateur puisse accéder aux fichiers .deb
chmod -R 755 /var/www/html/deb/