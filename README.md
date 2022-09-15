# OCaml 5 tutorial

This repository contains the source code for the OCaml 5 tutorial session at ICFP 2022.

### Installation

```
λ git clone https://github.com/Sudha247/ocaml5-tutorial-icfp-22.git
λ cd ocaml5-tutorial-icfp-22/code
λ opam update
λ opam switch create ./ ocaml-base-compiler.5.0.0~alpha1 --no-install
λ opam repo add alpha git+https://github.com/kit-ty-kate/opam-alpha-repository.git
λ opam install . --deps-only
λ eval $(opam env)
```

### Slides

The slides can be found [here](https://docs.google.com/presentation/d/17P1FbV6msoeTMWxbwGFisBgGJyW-q8GcDt2EgpcDR0w/edit?usp=sharing).

### Interactive usage

To use the libraries declared, you can use the interactive toplevel UTop. You
need to install it separately and can then instruct the build system to start
it with all the libraries like Domainslib loaded:

```
λ opam install utop
λ dune utop
```
