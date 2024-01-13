{ config, lib, pkgs, ... }: {

  services.dnsmasq = {
    settings = {
      server = [
        "1.1.1.1"
        "8.8.8.8"
      ] ++ (if config.networking.enableIPv6 then [
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
      ] else []);

      # no-resolve = true;
      domain-needed = true;
      bogus-priv = true;
      cache-size = 1000;
      conf-file = "${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf";
      dnssec = true;
      bind-interfaces = true;
      interface = "enp1s0";
      listen-address = if config.networking.enableIPv6
                        then "::1,127.0.0.1,2601:602:9700:f0fc::2,192.168.86.2"
                        else "127.0.0.1,192.168.86.2";
    };
  };
}
