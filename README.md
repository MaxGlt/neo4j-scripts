# Scripts de Gestion IIS

## Aperçu

Ce projet contient des scripts PowerShell organisés en deux catégories principales : IIS_Module et IIS_Rules. Ces scripts sont conçus pour faciliter la gestion des modules et des règles IIS (Internet Information Services), aidant ainsi les administrateurs à automatiser des tâches courantes et à maintenir un environnement serveur bien configuré.

## Structure du Projet
```sh
├───IIS_Module
│   ├───1.Add-EnableModule.ps1
│   ├───2.DisableIISModule.ps1
│   └───3.EnableIISModule.ps1
└───IIS_Rules
    ├───1.RewriteRules.ps1
    ├───2.ListRewriteRules.ps1
    └───3.DeleteAllRules.ps1
```

### IIS_Module
Ce répertoire contient des scripts liés à la gestion des modules IIS :

- Add-EnableModule.ps1 : Ajoute un nouveau module IIS sur le serveur s'il n'est pas déjà présent.
- DisableIISModule.ps1 : Active un module IIS existant, le rendant disponible pour utilisation.
- EnableIISModule.ps1 : Désactive un module IIS, l'empêchant d'être utilisé sans le supprimer du serveur.

### IIS_Rules
Ce répertoire contient des scripts pour gérer les règles IIS :

- RewriteRules.ps1 : Créer des nouvelles les règles de réécriture globales IIS.
- ListRewriteRules.ps1 : Lister les règles de réécriture globales IIS existantes.
- DeleteAllRules.ps1 : Vider complètement les règles de réécriture globales.

## Prérequis
Avant d'utiliser ces scripts, assurez-vous que les éléments suivants sont en place :

PowerShell : Installé et accessible.
Module WebAdministration : Nécessaire pour la gestion IIS.
IIS : La machine cible doit avoir IIS installé et en cours d'exécution.