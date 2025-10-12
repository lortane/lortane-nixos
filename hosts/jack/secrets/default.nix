{inputs, ...}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    wg-client.file = ./wg-client.age;
  };
}
