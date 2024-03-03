self: super: {
  jdk =
    super.openjdk11
    // {
      jre = super.openjdk11;
    };
  jre = super.openjdk11;

  scala = super.scala_2_13;

  metals = self.writeShellScriptBin "metals-emacs" ''
    exec ${self.openjdk11_headless}/bin/java \
      -XX:+UseG1GC \
      -XX:+UseStringDeduplication  \
      -Xss4m \
      -Xms400m \
      -Xmx4G \
      -Dmetals.client=emacs \
      -Dmetals.completion-item.detail=off \
      -jar ${self.coursier}/bin/.coursier-wrapped launch \
      -r bintray:scalameta/maven \
      -r bintray:scalacenter/releases \
      -r sonatype:public \
      org.scalameta:metals_2.12:0.9.4 \
      -M scala.meta.metals.Main
  '';
}
