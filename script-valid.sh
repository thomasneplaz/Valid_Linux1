#!/bin/bash
choix='a'
repcrea='a'
repcontrole='a'
data='a'
path='a'
pack='a'
loc='a'
dos='a'
presdos='a'
dosbox='a'

clear
#test présence pour vagrant
echo "Installation de vagrant"
pack="vagrant"
if [ "`dpkg -l $pack 2>>log.txt | grep '^ii' `" != "" ]
  then
      echo "$pack est déjà installé sur cette machine"
  else
      echo "$pack n'est pas installé sur cette machine"
      echo "Lancement de l'installation"
      sudo apt-get install $pack
  fi
echo "Appuyez sur entré pour continuer ..."
read


#test présence virtualbox
echo "Installation de virtualbox"
pack="virtualbox-5.1"
clear
if [ "`dpkg -l $pack 2>>log.txt | grep '^ii' `" != "" ]
  then
      echo "$pack est déjà installé sur cette machine"
  else
      echo "$pack n'est pas installé sur cette machine"
      echo "Lancement de l'installation"
      sudo apt-get install $pack
fi
echo "Appuyez sur entré pour continuer ..."
read


while [ $choix != '3' ]
do

  repcrea='a'
  repcontrole='a'

  echo "que souhaitez-vous faire ? "
  echo "1) Créer une VangrantBox"
  echo "2) Agir sur une VagrantBox"
  echo "3) Quitter"
  read choix

  if [ $choix = '1' ]
  then
    #choix d'installation de la vagrant
    while [ $repcrea != 'q' ] 2>> log.txt
    do

      #ajout de la vagrantbox avec input client
      clear

      #affichage du lieux où on se trouve
      echo "vous êtes dans "; pwd


      echo "Voulez-vous créer la vagrant ici ?"
      echo "o) Créer ici"
      echo "n) Choisir un autre endroit"
      echo "q) Quitter"
      read repcrea

      if [ $repcrea = 'o' ]
      then
        #initialisation de la vagrant
        clear

        while [ $presdos != '' ] 2>> log.txt
        do
          #choix du nom du dossier de la vagrant
          echo "nom du dossier dans lequel sera la vagrant (entrer \"vagrant\" par défaut):"
          read dos
          presdos=$(ls | grep $dos)
          if [ $presdos != '' ] 2>> log.txt
          then
            echo "un dossier porte déjà ce nom"
          fi
        done
        clear
        #création du dossier et initialisation de la vagrantbox
        mkdir $dos
        cd $dos
        vagrant init 1>> log.txt
        echo "un fichier Vagrantfile à bien été créer dans $dos. Vous pouvez à présent choisir son paramétrage."


        #sudo apt-get install https://atlas.hashicorp.com/envimation/boxes/ubuntu-xenial

        #choix du lieu pour le fichier et le chemin de sync
        echo "nom du dossier de sync (entrer \"data\" par defaut): "
        read data

        echo "chemin du dossier de sync (entrer \"/var/www/html\" par defaut) : "
        read path

        #modification du fichier Vagrantfile avec les données client
        sed -i-e  's/  config.vm.box \= \"base\"/   config.vm.box \= \"..\/xenial.box\"/g' Vagrantfile
        sed -i-e  's/  \# config.vm.network \"private_network\"\, ip: \"192.168.33.10\"/config.vm.network \"private_network\"\, ip: \"192.168.33.10\"/g' Vagrantfile
        sed -i-e  's/  \# config.vm.synced_folder \"..\/data\"\, \"\/vagrant_data\"/config.vm.synced_folder \"'$data'\"\, \"'$path'\"/g' Vagrantfile

        echo "votre Vangrantbox est paramétrée"

        repcrea='a'


      #déplacmement là où l'utilisateur veux créer sa vagrantbox
      elif [ $repcrea = 'n' ]
      then

          echo "Entrez le chemin où vous souhaitez créer la vagrantbox (chemin absolu): "
          read loc
          cd $loc
          repcrea='a'

      elif [ $repcrea = 'q' ]
      then
        echo "retour menu"
      fi
    done

  clear

  elif [ $choix = '2' ]
  then

    #controle sur les vagrantbox en cours d'utilisation
    while [ $repcontrole != '4' ] 2>>log.txt
    do
      clear
      #affichage du lieux où on se trouve
      echo "vous êtes dans le dossier"; pwd

      echo "Se déplacer : (si non entrez \".\")"
      read dep

      cd $dep

      #choix des actions sur la vagrantbox
      echo "Que Voulez-vous faire ?"
      echo "1) Démarrer la box"
      echo "2) Vous connecter à la box"
      echo "3) Arrêter la box"
      echo "4) Quitter"
      read repcontrole

      #CHOIX 1
      if [ $repcontrole = '1' ]
      then
        echo "démarrage de la box"
        vagrant up 2>> log.txt

      #CHOIX 2
      elif [ $repcontrole = '2' ]
      then
        echo "connection ssh à la box, pour en sortir, entrez \"exit\""
        vagrant ssh

      #CHOIX 3
      elif [ $repcontrole = '3' ]
      then
        echo "arrêt de la box"
        vagrant halt

      fi

    done

  fi

done
