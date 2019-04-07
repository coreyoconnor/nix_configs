self: super: {
  metals = self.writeShellScriptBin "metals-emacs" ''
    exec ${self.jre8}/bin/java \
      -XX:+UseG1GC \
      -XX:+UseStringDeduplication  \
      -Xss4m \
      -Xms1G \
      -Xmx12G \
      -Dmetals.client=emacs \
      -Dmetals.completion-item.detail=off \
      -jar ${self.coursier}/bin/.coursier-wrapped launch \
      -r bintray:scalameta/maven \
      -r bintray:scalacenter/releases \
      org.scalameta:metals_2.12:0.5.1-SNAPSHOT \
      -M scala.meta.metals.Main
  '';

  nix-dev = self.writeShellScriptBin "nix-dev" ''
    exec nix-shell . -A env "$@"
  '';
}
