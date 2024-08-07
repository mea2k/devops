locals {
 vms_metadata = {
       serial_port_enable = 1,
    ssh_keys = tolist(["ubuntu:${file(join("/",[abspath(path.module),".ssh/id_ed25519.pub"]))}"])
  }
}
