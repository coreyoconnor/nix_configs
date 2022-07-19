{ config, lib, pkgs, ... }: {

  services.dnsmasq = {
    servers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
      "8.8.8.8"
      "2001:4860:4860::8888"
    ];

    extraConfig = ''
      no-resolv
      domain-needed
      bogus-priv
      cache-size=1000
      conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
      dnssec
      bind-interfaces
      interface=enp1s0
      listen-address=::1,127.0.0.1,192.168.86.2
    '';
  };
}
