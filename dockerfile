FROM ubuntu:latest

# Install curl
RUN apt -y update && apt -y upgrade && apt -y install curl 

# Install steamcmd
RUN add-apt-repository multiverse; dpkg --add-architecture i386; apt update
RUN echo 2|apt install -y steamcmd

# Create Ark user
RUN useradd -m -p "ark" ark

# Install some tools
RUN apt -y install unzip ca-certificates xvfb

# Create folder for ark server
RUN mkdir -p /opt/arkserver

# Install wine and related packages
RUN dpkg --add-architecture i386 && apt -y install -y wine-stable winetricks wine32 wine64 libgl1-mesa-glx:i386 && rm -rf /var/lib/apt/lists/*

# Install ASA Files
RUN /usr/games/steamcmd +force_install_dir /opt/arkserver +login anonymous +app_update 2430930 +quit

# Install git and make
RUN apt -y update && apt -y install git make

# Make compattools folder
RUN mkdir -p /home/ark/.steam/steam/compatibilitytools.d

# Install proton
RUN curl -LJO "https://github.com/ValveSoftware/Proton/archive/refs/tags/proton-8.0-4.zip" && unzip Proton-proton-8.0-4.zip
RUN cp -r Proton-proton-8.0-4/files/share/default_pfx
USER ark
RUN make install



ENV PROTON=${STEAM_PATH}/compatibilitytools.d/${PROTON_VERSION}/proton

# Create wine dir
RUN mkdir -p /home/ark/.cache/wine

#RUN xvfb-run --auto-servernum wine /home/ark/steamcmd.exe +force_install_dir /home/ark +login anonymous +app_update 2399830 +quit
# CMD wine64 /opt/arkserver/ShooterGame/Binaries/Win64/ArkAscendedServer.exe