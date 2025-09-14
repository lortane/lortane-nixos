{ outputs, ... }:

{
  imports = [ outputs.nixosModules.wg-server ];

  networking.wg-server = {
    enable = true;
    openFirewall = true;
    externalInterface = "eno1";
    peers = {
      "lortane@wes" = {
        publicKey = "peoJzK9MQN3rNSAcRfnVtMoB6A2sByartvYShKUCGHM=";
        allowedIP = "10.100.0.2";
      };
    };
  };
}
