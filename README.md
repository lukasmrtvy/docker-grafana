# docker-grafana

## Info:
Based on Alpine:latest

## Usage:
`sudo docker rm -f grafana ; sudo docker run -d --name grafana -e TZ=Europe/Prague --net my-bridge -p 3000:3000 -v grafana:/opt/grafana/data mygrafana`


