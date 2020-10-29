# nix-home

Installation steps:

1. Install nix

   ```bash
   $ curl -L https://nixos.org/nix/install | sh
   ```

   MacOS Installation:

   - Create encrypted volume `nix`
   - Add `/nix` to `/etc/synthetic.conf`
   - Reboot and save password in keychain
   - Proceed with nix installation

2. Install [home-manager](https://github.com/nix-community/home-manager/)

   - Add channel
     
     ```bash
     $ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
     $ nix-channel --update
     ```
     
   - Install
     
     ```bash
     $ nix-shell '<home-manager>' -A install
     ```

3. Symbolic link to home.nix

   ```bash
   $ ln -s ./home.nix ~/.config/nixpkgs/home.nix
   ```

   

