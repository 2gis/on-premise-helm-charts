#!/bin/bash
set -e

URL=$1
KEY=$2
NAVI_FRONT=$3

SCRIPTPATH=$(dirname `readlink -f "$0"`)
cd $SCRIPTPATH/points

#UPSTREAM=`kubectl describe cm $NAVI_FRONT-configmap | grep upstream | awk '{print $2}'| rev | cut -c -2 | rev`
UPSTREAM=`helm ls | grep navi-back | awk '{print $1}' | awk -F 'back-' '{print $2}'` # для партнера из-за openshift

# Pairs Directions API - to do нет токена в api key
# Truck Directions API - to do нет токена в api key

for i in $UPSTREAM; do          
  if [[ "$i" == "directions-bicycle" ]];then
    echo "Create routing for Directions API bicycle:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_bc.json`
    echo 
  elif [[ "$i" == "directions-car" ]];then
    echo "Create routing for Directions API car:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_cr.json`
    echo 
  elif [[ "$i" == "distance-matrix" ]];then
    echo "Create routing for Distance Matrix API:"
    echo 
    echo `curl -s $URL/get_dist_matrix/2.0?key=$KEY --header 'Content-Type: application/json' -d @moscow_dm.json`
    echo 
  elif [[ "$i" == "directions-pedestrian" ]];then
    echo "Create routing for Directions API pedestrian:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_pd.json`
    echo 
  elif [[ "$i" == "public-transport" ]];then
    echo "Create routing for Public Transport API:"
    echo 
    echo `curl -s $URL/public_transport/2.0?key=$KEY --header 'Content-Type: application/json' -d @moscow_pt.json`
    echo 
  elif [[ "$i" == "directions-taxi" ]];then
    echo "Create routing for Directions API taxi:"
    echo 
    echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_tx.json`
    echo 
  elif [[ "$i" == "directions-truck" ]];then
    echo "Create routing for Directions API taxi:"
    echo 
    echo `curl -s $URL/truck/6.0.0/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_tr.json`
    echo 
  elif [[ "$i" == "isochrone-car" ]];then
    echo "Create routing for Isochrone API:"
    echo 
    echo `curl -s $URL/get_hull?key=$KEY --header 'Content-Type: application/json' -d @moscow_is_cr.json`
    echo 
  elif [[ "$i" == "directions-pairs" ]];then
    echo "Create routing for Directions-pairs car:"
    echo 
    echo `curl -s $URL/get_pairs/1.0/car?key=$KEY --header 'Content-Type: application/json' -d @moscow_pr.json`
    echo 
    echo "Create routing for Directions-pairs pedestrian:"
    echo 
    echo `curl -s $URL/get_pairs/1.0/pedestrian?key=$KEY --header 'Content-Type: application/json' -d @moscow_pr.json`
    echo 
  fi
done
