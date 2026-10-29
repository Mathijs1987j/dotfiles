# GENERATED from config.org ("Programming / Tools for the Emacs configuration"). Do not edit; edit config.org.
# nix/desktop/dev-tools.nix: the programs the Emacs configuration relies on;
# each group comes from the Emacs section in config.org that uses it.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = with pkgs; [
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
    # Spelling (config.org: Emacs / Spell checking)
    hunspellDicts.en_US
    hunspellDicts.nl_NL
  ];
}
