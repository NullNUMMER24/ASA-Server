# Use a Debian Image as Base Image
FROM debian:latest

# Set a working dir
WORKDIR /ark

# Create steam user
RUN sudo useradd -m steam
RUN sudo passwd steam

# Add the multiverse repository and the i386 architecture
RUN sudo apt update; sudo apt install software-properties-common; sudo apt-add-repository non-free; sudo dpkg --add-architecture i386; sudo apt update

# Install steamcmd dependencies
RUN sudo apt -y install lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 libsdl2-2.0-0:i386

# Install steamcmd
RUN sudo apt-get install steamcmd

# Install ASA
RUN steamcmd +force_install_dir /ark +login anonymous +app_update 2399830 +quit

# Expose necessary ports
EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp

# Copy server configuration files
COPY Game.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini
COPY GameUserSettings.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini