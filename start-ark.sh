#!/bin/sh

# Install server / check for updates
steamcmd +login anonymous +app_update 2430930 validate +quit

# Copy configfiles
cp -r /usr/share/GameUserSettings.ini $ARK_PATH/Saved/Config/WindowsServer/GameUserSettings.ini
cp -r /usr/share/Game.ini $ARK_PATH/Saved/Config/WindowsServer/Game.ini

# Start server with proton
SERVER_CMD="$PROTON run \"${ARK_PATH}/Binaries/Win64/ArkAscendedServer.exe\" \
  \"TheIsland_WP?listen?SessionName=${SESSION_NAME}?ServerAdminPassword=${ADMIN_PASSWORD}?MapPlayerLocation=${ShowPlayerOnMAP}BabyImprintingStatScaleMultiplie=${ImprintEfficency}?bUseCorpseLocator=${CorpseLocator}?bAllowPlatformSaddleMultiFloors=${MultipleFloorsOnPlatformSaddle}?OverrideOfficialDifficulty=${Difficulty}?FuelConsumptionIntervalMultiplier=${FuelConsumption}?EggHatchSpeedMultiplier=${EggHatchSpeed}?Port=${GAME_PORT}MatingIntervalMultiplier=${MatingInterval}?LayEggIntervalMultiplier=${LayEggInterval}?PoopIntervalMultiplier=${PoopInterval}?bAllowSpeedLeveling=${SpeedLeveling}?bAllowFlyerSpeedLeveling=${FlyerSpeedLeveling}?ActiveEvent=${ActiveEvent}?PerPlatformMaxStructuresMultiplier=${StructurePerPlatform}?PreventDownloadSurvivors${PreventSurvivorDownload}?PreventDownloadItems=${PreventItemDownload}?PreventDownloadDinos=${PreventDinoDownload}?PreventUploadSurvivors=${PreventSurvivorUpload}?PreventUploadItems=${PreventItemUpload}?PreventUploadDinos=${PreventDinoUpload}?QueryPort=${QUERY_PORT}?MaxPlayers=${MAX_PLAYERS}?\""

# Install mods
if [ -n "$MODS" ]; then
  SERVER_CMD="$SERVER_CMD -automanagedmods -mods=$MODS"
fi

# Additional command line arguments
if [ -n "$CMD_ARGS" ]; then
  SERVER_CMD="$SERVER_CMD $CMD_ARGS"
fi

# Start the server
eval $SERVER_CMD > /dev/null 2>&1 &
SERVER_PID=$!

# Capture logs
tail -f --retry "${ARK_PATH}/Saved/Logs/ShooterGame.log" &

# Monitor server process
wait $SERVER_PID
exit $?
