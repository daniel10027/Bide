# Cahier des charges - Application Bidet


## Introduction


L'application Bidet est un jeu de dés multijoueur basé sur Flutter, avec une intégration Firebase pour la gestion des utilisateurs, des jeux et des transactions. Ce document détaille les spécifications et les fonctionnalités requises pour développer et déployer l'application Bidet.


## Objectifs


L'objectif principal de l'application Bidet est de permettre aux utilisateurs de jouer à un jeu de dés multijoueur tout en offrant des fonctionnalités sociales et de gestion de l'argent. Les principaux objectifs sont les suivants :
- Permettre aux utilisateurs de s'inscrire et de se connecter via leur numéro de téléphone.
- Créer des jeux en définissant la mise initiale, le nombre de dés, le nombre de tours et l'heure de début.
- Inviter d'autres utilisateurs à rejoindre les jeux en partageant un code.
- Débiter le solde des joueurs lorsqu'ils rejoignent un jeu.
- Gérer les jeux en temps réel, enregistrer les résultats des tours et distribuer les gains.
- Fournir un historique des jeux, des rechargements, des retraits et des pertes pour chaque utilisateur.


## Fonctionnalités Principales


### Authentification


- Inscription et connexion avec le numéro de téléphone.


### Création et Rejoignement de Jeux


- Création de jeux en spécifiant la mise initiale, le nombre de dés, le nombre de tours et l'heure de début.
- Partage de codes de jeu pour inviter d'autres utilisateurs.
- Débit du solde des joueurs lorsqu'ils rejoignent un jeu.


### Jeu


- Jeu multijoueur avec un nombre défini de tours.
- Attribution de points aux joueurs en fonction des résultats des dés.
- Gestion du temps limite pour chaque joueur pour lancer ses dés.
- Calcul et distribution des gains en fin de jeu.
- Classement des participants en fonction de leurs scores.


### Gestion de l'Argent


- Solde initial à zéro, mis à jour via rechargement mobile.
- Nécessité d'avoir un solde égal ou supérieur à la mise initiale pour participer à un jeu.
- Commission de 50 FCFA sur chaque gain final.
- Mise minimum pour un jeu : 100 FCFA.


### Fonctionnalités Sociales


- Chat en temps réel pour la communication entre les joueurs.
- Système de niveaux en fonction de la performance des utilisateurs.
- Personnalisation des avatars.
- Organisation de tournois et affichage de classements.
- Notifications en temps réel pour les invitations et les mises à jour.
- Récompenses et succès pour encourager la participation.
- Possibilité d'ajouter des amis et de les inviter à rejoindre des jeux.


### Support Client et Sécurité


- Intégration d'un système de support client.
- Mesures de sécurité pour prévenir la triche et l'utilisation de comptes multiples.


### Options de Paiement et Localisation


- Diversification des options de paiement (cartes de crédit, porte-monnaie électroniques, etc.).
- Prise en charge de plusieurs langues pour un public mondial.


### Analyse des Données


- Utilisation d'outils d'analyse pour collecter des données sur le comportement des utilisateurs et les tendances de jeu.


### Interface Utilisateur
- Conception d'une interface utilisateur conviviale et intuitive.


## Contraintes Techniques


- L'application sera développée en utilisant le framework Flutter pour une expérience multiplateforme.
- L'intégration Firebase sera utilisée pour la gestion des utilisateurs, des jeux et des transactions.
- Des mesures de sécurité strictes seront mises en place pour garantir l'intégrité du jeu et des comptes des utilisateurs.


## Calendrier de Développement


Le développement de l'application Bidet sera divisé en plusieurs phases, chaque phase ayant des jalons spécifiques. Un calendrier détaillé sera élaboré lors du lancement du projet.


## Conclusion
Ce cahier des charges définit les spécifications et les fonctionnalités clés de l'application Bidet. Il servira de base solide pour le développement de l'application, en veillant à ce que toutes les fonctionnalités requises soient prises en compte pour offrir une expérience utilisateur immersive et socialement engageante.



