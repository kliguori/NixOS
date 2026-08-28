{ ... }:
{
  programs.nixvim.plugins.orgmode = {
    enable = true;
    settings = {
      org_agenda_files = [ "~/tank/org/**/*" ];
      org_default_notes_file = "~/tank/org/refile.org";
      org_hide_leading_stars = true;
      org_startup_indented = true;
    };
  };
}
