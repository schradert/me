# My Personal Website

## Development

Add pre-commit hooks by running `nix develop` and then `exit` that broken shell once it's done.
This will generate all the proper files to trigger hooks on git events.

Run the app in development mode with `nix run .#services`

## Production

Preview full production build by running `nix run .#app`!

If there is a hash mismatch because the dependencies changed, replace that `outputHash` of the `app-node_modules` fixed-output derivation to the new one "got". It should build just fine now.

## TODOs

- [x] Migrate svelte app to new Vite standard
- [x] Change the projects emphasized
- [x] Set up media bucket
- [ ] Integrate imgResizer script if necessary
- [x] Nix build packages
- [ ] Podman container with Arion
- [ ] Host deployment on cluster
- [ ] Remove old Netlify deployment when new version deploys
- [ ] Why is the devShell breaking git history?!
