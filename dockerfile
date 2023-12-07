FROM ubuntu:latest

# Install curl
RUN apt -y update && apt -y upgrade && apt -y install curl unzip wget

# Install steamcmd
RUN add-apt-repository multiverse; dpkg --add-architecture i386; apt update
RUN echo 2|apt install -y steamcmd

# Variables
ENV STEAM_PATH=$HOME/.steam/steam
ENV STEAMCMD=/usr/games/steamcmd

# Create folder for ark server
RUN mkdir -p /opt/arkserver
RUN mkdir -p $STEAM_PATH

# Install ASA Files
#RUN /usr/games/steamcmd +force_install_dir /opt/arkserver +login anonymous +app_update 2430930 +quit

# Set workdir to steam path
WORKDIR $STEAM_PATH

# Make compattools folder
RUN mkdir -p compatibilitytools.d/

# Install proton
RUN wget -O - https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton8-25/GE-Proton8-25.tar.gz | tar -xz -C compatibilitytools.d/
RUN mkdir -p steamapps/compatdata/2430930
RUN cp -r compatibilitytools.d/GE-Proton8-25/files/share/default_pfx steamapps/compatdata/2430930

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_PATH
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/2430930
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/Proton-proton-8.0-4/proton

# Start Arkserver script
## Set the ark path variable
ENV Ark_PATH="${STEAM_PATH}/steamapps/common/ARK Survival Ascended Dedicated Server/ShooterGame"
## Copy the start-ark script to the container
COPY start-ark.sh /usr/local/bin/ark-server
## Set permissions on start-ark file
RUN chmod +x /usr/local/bin/ark-server

# Make image smaller
## remove tools
RUN apt -y remove unzip wget
## Clear apt chache
RUN apt -y clean && rm -rf /var/lib/apt/lists/*

#WORKDIR $HOME 
CMD bash /usr/local/bin/ark-server