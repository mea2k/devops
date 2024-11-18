locals  {
	vms_name = {
		"vm_web" = "${var.platform_type}-${var.vm_web_prefix}-${var.vm_web_name}",
		"vm_db" = "${var.platform_type}-${var.vm_db_prefix}-${var.vm_db_name}"
		}

 vms_metadata = {
  # type=object({
  #   serial_port_enable: number,
  #   ssh_keys: list(string),
  # })
  # description = "{serial_port_enable=<NUMBER>, ssh_keys: LIST(STRING)}"
  #default = {    
    serial_port_enable = 1,
    ssh_keys = tolist(["ubuntu:${var.vms_ssh_root_key}"])
  }
}
