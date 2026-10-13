# NixOS configurations for my machines 

Personal NixOS config built with [flake-parts](https://github.com/hercules-ci/flake-parts) and following the **dendritic pattern** (or trying to). The flake is assembled with `flake-parts.lib.mkFlake` and `import-tree`, which together auto-import every `.nix` file under `modules/`. Outputs are declared next to the code they describe, no central monolithic `flake.nix` output block.

## `modules/` Layout

| Directory | Purpose |
|---|---|
| `flake-parts/` | `dendritic.nix` enables the module schema, `lib.nix` provides `mkNixos`/`mkDarwin`/`mkHomeManager` helpers. |
| `hosts/` | One directory per machine with `configuration.nix`, `flake-parts.nix`, hardware/boot/filesystem pieces, and host-scoped `users/`. |
| `disks/` | Reusable disk layouts consumed by `disko`. |
| `programs/` | Application configs split by interface — `cli/` for terminal tools (shell, network, dev) and `gui/` for graphical apps + `desktop-env/` (compositor, greeter, bar, launcher). |
| `users/` | Cross-host user baseline (e.g. `khaen/configuration.nix`); host-specific overlays live under `hosts/<host>/users/`. |

## Current machines

| Hostname | Description |
| --- | --- |
| nostromo | Desktop PC with an i7 12700k and a RX 6800xt. |
| romulus | Thinkpad E14 gen 6 with a Ryzen 5 7535U. |
| sevastopol | Lenovo laptop with an i5 1035G4 that is being used as a server. |
