let
  configLocation = ../..;
in
{
  resolveConfigLocation = (configFile:
    "/${configLocation}" + ("/" + configFile)
  );
}
