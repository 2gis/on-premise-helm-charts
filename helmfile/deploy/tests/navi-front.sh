#!/bin/bash
set -e
set -u
set -o pipefail

URL=$1
KEY=$2
NAVI_FRONT=$3

SCRIPTPATH=$(dirname `readlink -f "$0"`)
cd $SCRIPTPATH/points

UPSTREAM=`kubectl describe cm $NAVI_FRONT-configmap | grep upstream | awk '{print $2}'|awk -F 'back-' '{print $2}'`
#UPSTREAM=`helm ls | grep navi-back | awk '{print $1}' | awk -F 'back-' '{print $2}'` # для партнера из-за openshift

sleep 5
echo $UPSTREAM
# Pairs Directions API - to do нет токена в api key
# Truck Directions API - to do нет токена в api key
for service in $UPSTREAM; do
  case $service in
    "freeroam")
        echo "Create routing for Directions API bicycle:"
        echo
        echo `curl -sSfG  $URL/free_roam/2.0?key=$KEY -d @moscow_fr.txt`
        echo
        ;;
    "directions-bicycle")
        echo "Create routing for Directions API bicycle:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_bc.json`
        echo
        ;;
    "directions-car")
        echo "Create routing for Directions API car:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_сr.json`
        echo
        ;;
    "distance-matrix")
        echo "Create routing for Distance Matrix API:"
        echo
        echo `curl -s $URL/get_dist_matrix/2.0?key=$KEY --header 'Content-Type: application/json' -d @moscow_dm.json`
        echo
        ;;
    "directions-pedestrian")
        echo "Create routing for Directions API pedestrian:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_pd.json`
        echo
        ;;
    "public-transport")
        echo "Create routing for Public Transport API:"
        echo
        echo `curl -s $URL/public_transport/2.0?key=$KEY --header 'Content-Type: application/json' -d @moscow_pt.json`
        echo
        ;;
    "directions-taxi")
        echo "Create routing for Directions API taxi:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_tx.json`
        echo
        ;;
    "directions-emergency")
        echo "Create routing for Directions API emergency:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_em.json`
        echo
        ;;
    "directions-truck")
        echo "Create routing for Directions API truck:"
        echo
        echo `curl -s $URL/carrouting/6.0.1/global?key=$KEY --header 'Content-Type: application/json' -d @moscow_tr.json`
        echo
        ;;
    "isochrone-car")
        echo "Create routing for Isochrone API car:"
        echo
        echo `curl -s $URL/get_hull?key=$KEY --header 'Content-Type: application/json' -d @moscow_is_cr.json`
        echo
        ;;
  esac
done
