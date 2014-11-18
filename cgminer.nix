{config, pkgs, ...}:
{
  systemd.services.cgminer = {
    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };

  services.cgminer =
  {
    enable = true;
    pools = 
    [
      {
        url = "stratum+tcp://stratum.mining.eligius.st:3334";
        user = "1M5DoWSWRtGCNuJfwdC8294zRx1eK7FSGY";
        pass = "";
      }
    ];
    config =
    {
      disable-gpu = true;
    };
  };
}
