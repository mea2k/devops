resource "local_file" "hosts_templatefile" {
  content = templatefile("${path.module}/hosts.tftpl",
    { webservers = yandex_compute_instance.vm_web,
      databases  = (yandex_compute_instance.vm_db),
      storage    = [yandex_compute_instance.vm_storage]
  })
  filename = "${abspath(path.module)}/hosts.ini"
}

