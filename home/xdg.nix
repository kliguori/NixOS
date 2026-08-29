{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.systemOptions.desktop.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;

      download = "${osConfig.users.users.kevin.home}/downloads";

      documents = "${osConfig.users.users.kevin.home}/tank/documents";
      pictures = "${osConfig.users.users.kevin.home}/tank/pictures";
      projects = "${osConfig.users.users.kevin.home}/tank/projects";
      videos = "${osConfig.users.users.kevin.home}/tank/videos";
      music = "${osConfig.users.users.kevin.home}/tank/music";

      desktop = "$HOME";
      templates = "$HOME";
      publicShare = "$HOME";
    };
  };
}
