{
  description = "Personal Website";
  inputs.canivete.url = github:schradert/canivete;
  inputs.nix2container.url = github:nlewo/nix2container;
  inputs.nix2container.inputs.nixpkgs.follows = "canivete/nixpkgs";
  outputs = inputs:
    inputs.canivete.lib.mkFlake {
      inherit inputs;
      everything = [./nix];
    } {};
}
