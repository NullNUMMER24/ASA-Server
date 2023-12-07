FROM ubuntu:latest

# Install curl
RUN apt -y update && apt -y upgrade && apt -y install curl 

# Install steamcmd
RUN add-apt-repository multiverse; dpkg --add-architecture i386; apt update
RUN echo 2|apt install -y steamcmd

# Variables
ENV STEAM_PATH=$HOME/.steam/steam

# Install some tools
RUN apt -y install unzip ca-certificates xvfb git make curl

# Create folder for ark server
RUN mkdir -p /opt/arkserver

# Install wine and related packages
RUN dpkg --add-architecture i386 && apt -y install -y wine-stable winetricks wine32 wine64 libgl1-mesa-glx:i386 && rm -rf /var/lib/apt/lists/*

# Install ASA Files
RUN /usr/games/steamcmd +force_install_dir /opt/arkserver +login anonymous +app_update 2430930 +quit

# Set workdir to steam path
WORKDIR $STEAM_PATH

# Make compattools folder
RUN mkdir -p compatibilitytools.d

# Install proton
RUN curl -LJO "https://github.com/ValveSoftware/Proton/archive/refs/tags/proton-8.0-4.zip" && unzip Proton-proton-8.0-4.zip -C compatibilitytools.d/
RUN mkdir steamapps/compatdata/2430930
RUN cp -r compatibilitytools.d/Proton-proton-8.0-4/files/share/default_pfx steamapps/compatdata/2430930

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

# remove tools

WORKDIR $HOME 
ENTRYPOINT ["start-ark"]