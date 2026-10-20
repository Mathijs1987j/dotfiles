# GENERATED from config.org ("User: mathijs / Development tools"). Do not edit; edit config.org.
# home/dev.nix: programming tools that Emacs and your projects use.
# The language servers come from pkgs.unstable, to match Emacs 31 and
# TypeScript 7 (chapter 13). Python projects use uv (chapter 10).
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python and web
    python3 # quick scripts; projects use uv
    uv
    nodejs

    # Tools used by the Emacs configuration; each group comes from the
    # Emacs section in config.org that uses it.
    # Python (config.org: Emacs / Python)
    unstable.basedpyright
    unstable.ruff
    # Notebooks as scripts (config.org: Emacs / Python)
    python3Packages.jupytext
    # HTML, CSS, JavaScript (config.org: Emacs / HTML, CSS and JavaScript)
    unstable.typescript # tsc --lsp (TypeScript 7)
    unstable.vscode-langservers-extracted # HTML/CSS servers
    unstable.prettier
    # Nix (config.org: Emacs / Nix)
    nil # Nix language server
    # LaTeX (config.org: Emacs / LaTeX)
    texlab
    texliveMedium
    # Spelling (config.org: Emacs / Spell checking)
    hunspellDicts.en_US
    hunspellDicts.nl_NL
  ];

  # uv: always use uv's own Python builds (they run through nix-ld, so binary
  # wheels such as numpy find their libraries), never the nixpkgs python3
  # above. Chapter 10.
  home.sessionVariables.UV_PYTHON_PREFERENCE = "only-managed";
}
