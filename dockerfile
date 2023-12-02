FROM ubuntu:latest

# Install some tools
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		unzip \
		ca-certificates \
		xvfb

# Install wine and related packages
RUN dpkg --add-architecture i386 \
		&& apt-get update -qq \
		&& apt-get install -y -qq \
				wine-stable \
				winetricks \
				wine32 \
				libgl1-mesa-glx:i386 \
		&& rm -rf /var/lib/apt/lists/*

# Create Ark user
RUN useradd -m -p "ark" ark

# Set up sudo without password prompt for the Ark user
RUN echo 'ark ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ark-nopasswd

# Create wine dir
RUN mkdir -p /home/ark/.cache/wine

# Install mono
RUN mkdir -p /opt/wine-stable/share/wine/mono && \
    curl https://dl.winehq.org/wine/wine-mono/7.0.0/wine-mono-7.0.0-x86.tar.xz | sudo tar -xJv -C /opt/wine-stable/share/wine/mono

# Download gecko
RUN mkdir -p /opt/wine-stable/share/wine/gecko && \
    curl -o /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi
RUN mkdir -p /opt/wine-stable/share/wine/gecko && \
    curl -o /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi

ENV WINEPREFIX=/home/ark/prefix32
ENV WINEARCH=win32

# Download steamcmd
RUN curl -o /home/ark/steamcmd.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip && unzip /home/ark/steamcmd.zip -d /home/ark/steamcmd.exe && rm /home/ark/steamcmd.zip

RUN rm -rf /root/.cache/winetricks/corefonts

USER ark
#RUN sudo xvfb-run --auto-servernum winetricks --unattended corefonts vcrun2015 gecko

RUN xvfb-run --auto-servernum wine /home/ark/steamcmd.exe +force_install_dir /home/ark +login anonymous +app_update 2399830 +quit