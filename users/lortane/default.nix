{ outputs, ... }:

{
  imports = [
    outputs.nixosModules.normal-users
  ];

  normalUsers = {
    lortane = {
      extraGroups = [ "wheel" ];
      sshKeyFiles = [
        ./pubkeys/id_lortane-wes.pub
        ./pubkeys/id_lortane-zack.pub
      ];
    };
  };
}
