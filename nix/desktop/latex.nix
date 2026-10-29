# GENERATED from config.org ("Writing and teaching / LaTeX"). Do not edit; edit config.org.
# nix/desktop/latex.nix: TeX Live with the packages my preamble needs, and the
# link that lets TeX find the preamble in the repository.
{ pkgs, username, ... }:

{
  users.users.${username}.packages = [
    (pkgs.texliveMedium.withPackages (
      ps: with ps; [
        # Language, fonts and micro-typography
        babel-english
        babel-dutch
        hyphen-dutch
        cm-super # scalable versions of the T1 text fonts
        setspace
        microtype
        # Mathematics
        mathtools
        amscls # amsthm
        doublestroke # dsfont
        stmaryrd
        accents
        # Colour, tables and pictures
        xcolor
        colortbl
        tabularray
        ninecolors # used by tabularray
        booktabs
        diagbox
        pict2e # used by diagbox
        pgf # TikZ
        pgfplots
        # Quotes and lists
        csquotes
        etoolbox # used by csquotes
        enumitem
        # Links and cross-references
        hyperref
        cleveref
        # Page layout
        geometry
      ]
    ))
  ];

  # ~/texmf -> ~/dotfiles/live/texmf: TeX finds MJPreamble.sty in the
  # repository, so editing the preamble needs no rebuild.
  dotfiles.links."texmf" = "live/texmf";
}
