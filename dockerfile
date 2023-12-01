# Use a Debian Image as Base Image
FROM debian:latest

# Set a working dir
WORKDIR /opt/steamcmd

# create ark user
RUN useradd -p ark -m -d /home/ark ark

# Install steamcmd
RUN apt -y update; apt -y install software-properties-common; apt-add-repository non-free; dpkg --add-architecture i386; apt -y update

# Install wine
RUN apt -y update && apt -y install wine wine64 mingw-w64 screen steamcmd wget xvfb  

USER ark

RUN mkdir -p /home/ark/ark_server

ENV WINEARCH=win64 
ENV WINEPREFIX=/home/ark/.wine64 
ENV TERM = linux

RUN steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir /home/ark/ark_server +login anonymous +app_update 1829350 +exit

# Downlaod steamcmd
RUN wget -o /opt/steamcmd/steamcmd https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip && unzip steamcmd.zip -d /opt/steamcmd/steamcmd.exe && rm steamcmd.zip

RUN xvfb --auto-servernum wine /opt/steamcmd/steamcmd.exe +force_install_dir /opt/ark +login anonymous +app_update 2399830 +quit

#RUN wine /opt/steamcmd/steamcmd.exe +force_install_dir /opt/ark +login anonymous +app_update 2399830 +quit 

# Expose necessary ports
EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp

# Copy server configuration files
#COPY Game.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini
#COPY GameUserSettings.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini
