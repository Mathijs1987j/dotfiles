# GENERATED from config.org ("Emacs / To-do list"). Do not edit; edit config.org.
# nix/desktop/todo.nix: the weekly reminder to review the to-do list.
{ config, pkgs, ... }:

{
  systemd.user.services.todo-review = {
    description = "Reminder to review the to-do list";
    path = [
      pkgs.libnotify # notify-send
      config.services.emacs.package # emacsclient, for the click
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      file="$HOME/Documents/ToDo/ToDo.org"
      [ -f "$file" ] || exit 0
      # Stays until clicked or dismissed; prints "default" when clicked.
      action=$(notify-send --app-name=To-do --expire-time=0 --wait \
        --action=default=Open "Weekly review" \
        "Sort the Inbox into topics, mark what is done, then M-x MJ-org-archive-done.") || true
      if [ "$action" = default ]; then
        emacsclient -n -c "$file"
      fi
    '';
  };

  systemd.user.timers.todo-review = {
    description = "Sunday evening: review the to-do list";
    wantedBy = [ "graphical-session.target" ]; # only while logged in
    partOf = [ "graphical-session.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 19:00:00";
      Persistent = true; # missed (off or asleep): at the next login or wake-up
    };
  };
}
