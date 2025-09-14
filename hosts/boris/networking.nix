{
  networking.hostName = "boris";

  # Static IP configuration
  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = "192.168.1.135";
      prefixLength = 24;
    }
  ];
 
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
  networking.resolvconf.enable = true; 
}
