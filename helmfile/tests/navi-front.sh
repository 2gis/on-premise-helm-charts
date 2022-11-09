#!/bin/bash
set -e

URL=$1
KEY=$2
NAVI_FRONT=$3

SCRIPTPATH=$(dirname `readlink -f "$0"`)
cd $SCRIPTPATH/points

#UPSTREAM=`kubectl describe cm $NAVI_FRONT-configmap | grep upstream | awk '{print $2}'| rev | cut -c -2 | rev`
UPSTREAM=`helm ls | grep navi-back | awk '{print $1}'| rev | cut -c -2 | rev` # для партнера

# bc - Directions API велосипеды
# cr - Directions API автомобили
# dm - Distance Matrix API (до 25х25)
# is - Isochrone API
# pd - Directions API пешеходы
# tx - Directions API такси
# pt - Public Transport
# pr - Pairs Directions API - to do нет токена в api key
# tr - Truck Directions API - to do нет токена в api key

for i in $UPSTREAM; do          
  if [[ "$i" == "bc" ]];then
    echo "Create routing for Directions API bicycle:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @kazan_bc.json`
    echo 
  elif [[ "$i" == "cr" ]];then
    echo "Create routing for Directions API car:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @kazan_cr.json`
    echo 
  elif [[ "$i" == "dm" ]];then
    echo "Create routing for Distance Matrix API:"
    echo 
    echo `curl -s $URL/get_dist_matrix/2.0?key=$KEY --header 'Content-Type: application/json' -d @kazan_dm.json`
    echo 
  elif [[ "$i" == "is" ]];then
    echo "Create routing for Isochrone API:"
    echo 
    echo `curl -s $URL/get_hull?key=$KEY --header 'Content-Type: application/json' -d @kazan_is.json`
    echo 
  elif [[ "$i" == "pd" ]];then
    echo "Create routing for Directions API pedestrian:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @kazan_pd.json`
    echo 
  elif [[ "$i" == "pt" ]];then
    echo "Create routing for Public Transport API:"
    echo 
    echo `curl -s $URL/public_transport/2.0?key=$KEY --header 'Content-Type: application/json' -d @kazan_pt.json`
    echo 
  elif [[ "$i" == "tx" ]];then
    echo "Create routing for Directions API taxi:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @kazan_tx.json`
    echo 
  fi
done
