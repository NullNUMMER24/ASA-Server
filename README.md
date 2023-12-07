# ASA-Server
# Steam DB
https://steamdb.info/
# How to use this Image
### Build and start the docker image
**Example Docker build command**
```
 docker build -t my-ark-server .
```
**Example Docker run command**
```
docker run -p 7777:7777/udp -p 7778:7778/udp -p 27015:27015/udp -d my-ark-server
```
# Start server with docker-compose
```
sudo docker-compose up --build
```
