FROM steamcmd/steamcmd:latest

# Install curl
RUN apt -y update && apt -y upgrade && apt -y install wget python3 libfreetype6

# Variables
ENV STEAM_PATH=$HOME/.steam/steam
ENV STEAMCMD=/usr/games/steamcmd
WORKDIR $STEAM_PATH

# Install Proton build from Glorious Eggroll
ENV PROTON_VERSION=GE-Proton8-21
RUN mkdir -p compatibilitytools.d/
RUN wget -O - \
  https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${PROTON_VERSION}/${PROTON_VERSION}.tar.gz \
  | tar -xz -C compatibilitytools.d/
RUN mkdir -p steamapps/compatdata/2430930
RUN cp -r compatibilitytools.d/${PROTON_VERSION}/files/share/default_pfx steamapps/compatdata/2430930

# Export Proton paths
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_PATH
ENV STEAM_COMPAT_DATA_PATH=${STEAM_PATH}/steamapps/compatdata/2430930
ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

# Start Arkserver script
## Set the ark path variable
ENV ARK_PATH="${STEAM_PATH}/steamapps/common/ARK Survival Ascended Dedicated Server/ShooterGame"
## Copy the start-ark script to the container
COPY start-ark.sh /usr/local/bin/start-ark.sh
## Set permissions on start-ark file
RUN chmod +x /usr/local/bin/start-ark.sh

# Copy GameUserSettings.ini and Game.ini
COPY GameUserSettings.ini $ARK_PATH/Saved/Config/WindowsServer/GameUserSettings.ini
COPY GameUserSettings.ini $ARK_PATH/Saved/Config/WindowsServer/Game.ini


# Make image smaller
## remove tools
RUN apt -y remove unzip wget
## Clear apt chache
RUN apt -y clean && rm -rf /var/lib/apt/lists/*

WORKDIR $HOME
ENTRYPOINT ["ark-server"]