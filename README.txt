# stage
stage de 3ème à nuxeo

Tri des branches de nuxeo

Résumé: Le repository du code source nuxeo est trop volumineux cela a un impact sur le temps perdu à attendre pour les développeurs, les temps de téléchargements pour les tâches automatisées et la consommation de bande passante.
Ticket de suivi du problème: https://jira.nuxeo.com/browse/NXBT-736

Objectif: 
-mesurer et analyser 
-nettoyer (automatiquement)

Nombre de branches: 1 583
Nombre de branches comportant "fix": 699
	git branch -r --list "origin/fix-*"|wc -l
Nombre de branches comportant "fixup": 3
	git branch -r --list "origin/fixup*"|wc -l
Nombre de branches comportant "feature": 559
	git branch -r --list "origin/feature*"|wc -l
Nombres de branches comportant "task": 11
	git branch -r --list "origin/task*"|wc -l
Nombre de branches comportant "NXP": 100
	git branch -r --list "origin/NXP*"|wc -l
Nombre de branches de plus de 3 mois comportant "fix, feature et task": 961
	~/workspace/stage/cleanup.sh |wc -l
	git branch -r | xargs -t -n 1 git branch -r --contains


Fichier:
complete: liste complète (toutes les branches)
to keep: branches communes à conserver	
	origin/\d+\.\d+(\.\d+)?-HF\d\d-SNAPSHOT
	origin/master
	origin/stable
	origin/\d+\.\d+(\.\d+)?$
to delete: branches à supprimer
	liste manuelle
	branche mergées parmis les fix, feature et task (fixup et NXP sont des anomalies de nommage)
		git branch -r --list "origin/fix-*" --list "origin/feature-*" --list "origin/task-*" --merged


		
ignore : origin/HEAD

TODO
-génération et maintenance des branches origin/\d+\.\d+(\.\d+)?-HF\d\d-SNAPSHOT (par ex: origin/7.10-HF02-SNAPSHOT)

