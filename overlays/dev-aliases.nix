self: super: {
  metals = self.writeShellScriptBin "metals-emacs" ''
    exec ${self.jre8}/bin/java \
      -XX:+UseG1GC \
      -XX:+UseStringDeduplication  \
      -Xss4m \
      -Xms1G \
      -Xmx8G \
      -Dmetals.client=emacs \
      -jar ${self.coursier}/bin/.coursier-wrapped launch \
      -r bintray:scalameta/maven \
      -r bintray:scalacenter/releases \
      ch.epfl.scala:bsp4j:2.0.0-M2 \
      org.scalameta:metals_2.12:0.4.0-SNAPSHOT \
      -M scala.meta.metals.Main
  '';

  nix-dev = self.writeShellScriptBin "nix-dev" ''
    exec nix-shell . -A env "$@"
  '';
}
