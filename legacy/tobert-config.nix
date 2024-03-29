# from: http://tobert.github.io/post/2014-06-24-linux-defaults.html
# comments are quotes from the post.
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  boot.kernel.sysctl = {
    # increase the number of allowed mmapped files
    "vm.max_map_count" = 1048576;

    # increase the number of file handles available globally
    "fs.file-max" = 1048576;

    # increase the number of inotify watches
    "fs.inotify.max_user_watches" = 524288;

    # allow up to 999999 processes with corresponding pids
    # this looks nice and rarely rolls over - I've never had a problem with it.
    "kernel.pid_max" = 999999; # unnecessary, but I like it

    # seconds to delay after a kernel panic and before rebooting automatically
    "kernel.panic" = 300;

    # do not enable if your machines are not physically secured
    # this can be used to force reboots, kill processses, cause kernel crashes, etc without logging in
    # but it's very handy when a machine is hung and you need to get control
    # that said, I always enable it
    "kernel.sysrq" = 1;

    "net.ipv4.ip_local_port_range" = "10000 65535";
    "net.ipv4.tcp_window_scaling" = "1";
    "net.ipv4.tcp_rmem" = "4096 87380 16777216";
    "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    "net.core.rmem_max" = "16777216";
    "net.core.wmem_max" = "16777216";
    "net.core.netdev_max_backlog" = "2500";
    "net.core.somaxconn" = "65000";

    # these will need local tuning, currently set to start flushing dirty pages at 256MB
    # writes will start blocking at 2GB of dirty data, but this should only ever happen if
    # your disks are far slower than your software is writing data
    # If you have an older kernel, you will need to s/bytes/ratio/ and adjust accordingly.
    "vm.dirty_background_bytes" = "268435456";
    "vm.dirty_bytes" = "1073741824";

    # increase the sysv ipc limits
    "kernel.shmmax" = "33554432";
    "kernel.msgmax" = "33554432";
    "kernel.msgmnb" = "33554432";
  };

  security.pam.loginLimits =
    [
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "1048576";
      }
    ]
    ++ (map
      (item: {
        item = item;
        domain = "*";
        type = "-";
        value = "unlimited";
      }) [
        "memlock"
        "fsize"
        "data"
        "rss"
        "stack"
        "cpu"
        "nproc"
        "as"
        "locks"
        "sigpending"
        "msgqueue"
      ]);
}
