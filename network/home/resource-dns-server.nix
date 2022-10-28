{ config, lib, pkgs, ... }: {

  services.dnsmasq = {
    servers = [
      "1.1.1.1"
      "8.8.8.8"
    ] ++ (if config.networking.enableIPv6 then [
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ] else []);

    extraConfig = ''
      no-resolv
      domain-needed
      bogus-priv
      cache-size=1000
      conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
      dnssec
      bind-interfaces
      interface=enp1s0
'' + (if config.networking.enableIPv6 then "listen-address=::1,127.0.0.1,2601:602:9700:f0fc::2,192.168.86.2"
         else "listen-address=127.0.0.1,192.168.86.2");
  };
}
