locals  {
	vms_name = {
		"vm_web" = "${var.platform_type}-${var.vm_web_prefix}-${var.vm_web_name}",
		"vm_db" = "${var.platform_type}-${var.vm_db_prefix}-${var.vm_db_name}"
		}
}
