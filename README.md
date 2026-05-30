# flake-start

Minimal Nix flake project template.

To start a project with this template, run:

```sh
./init-template.sh new_project_name
```

## Development

Update dependencies:

```sh
nix flake update
```

Enter the development shell:

```sh
nix develop
```

Build and run the dummy package:

```sh
nix build
nix run
```

Useful development commands:

```sh
just build
just run
just format
```
