# Use a Debian Image as Base Image
FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add wine xvfb curl unzip

# Set environment variables for X11 forwarding
ENV DISPLAY=:0
ENV WINEPREFIX=/root/.wine

# Create a non-root user (optional but recommended for security)
RUN adduser -D -u 1000 wineuser
USER wineuser

# Set the working directory
WORKDIR /home/wineuser

# Downlaod steamcmd
RUN curl -o /home/wineuser/steamcmd.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip && unzip steamcmd.zip -d /home/wineuser/steamcmd.exe && rm /home/wineuser/steamcmd.zip

RUN xvfb-run --auto-servernum wine /home/wineuser/steamcmd.exe +force_install_dir /opt/ark +login anonymous +app_update 2399830 +quit

#RUN wine /opt/steamcmd/steamcmd.exe +force_install_dir /opt/ark +login anonymous +app_update 2399830 +quit 

# Expose necessary ports
EXPOSE 7777/udp
EXPOSE 7778/udp
EXPOSE 27015/udp

# Copy server configuration files
#COPY Game.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/Game.ini
#COPY GameUserSettings.ini /ark/server/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini