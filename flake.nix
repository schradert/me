{
  description = "Personal Website";
  inputs.canivete.url = github:schradert/canivete;
  outputs = inputs:
    inputs.canivete.lib.mkFlake {
      inherit inputs;
      everything = [./nix];
    } {};
}
