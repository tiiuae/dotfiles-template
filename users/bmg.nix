# SPDX-License-Identifier: Apache-2.0
_: {
  users.users = {
    <CHANGE_ME> = {
      isNormalUser = true;
      home = "/home/<CHANGE_ME>";
      description = "<CHANGE_ME>";
      openssh.authorizedKeys.keys = [
        "<CHANGE_ME>"
      ];
      extraGroups = ["networkmanager" "wheel" "dialout" "plugdev"];
      #Set an initial dummy "Password" for the first boot
      # sudo -i ; passwd <username>
      #hashedPassword = "";
    };
  };
}
