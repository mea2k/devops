import os

class cpustat:
  name: str		# CPU name
  user: int 	# Time spent with normal processing in user mode.
  nice:	int   # Time spent with niced processes in user mode.
  system: int # Time spent running in kernel mode.
  idle:	int		# Time spent in vacations twiddling thumbs.
  iowait: int # Time spent waiting for I/O to completed. 
              # This is considered idle time too.	since 2.5.41
  irq: int    # Time spent serving hardware interrupts.	since 2.6.0
  softirq: int  # Time spent serving software interrupts.	since 2.6.0
  steal: int  # Time stolen by other operating systems running in a virtual environment.	since 2.6.11
  guest: int  # Time spent for running a virtual CPU or guest OS under the control of the kernel.
  guest_nice: int # Time spent running a niced guest 
                  # (virtual CPU for guest operating systems under the control of the Linux kernel). 
                  # since Linux 2.6.33

  # единица измерения USER_HZ (Jiffies)
  # обычно 1/100-я секунды
  ticks = os.sysconf(os.sysconf_names['SC_CLK_TCK'])


  def __init__(self, data: str):
    values = data.split()
    self.name 	 = values[0]
    self.user 	 = int(values[1])
    self.nice 	 = int(values[2])
    self.system  = int(values[3])
    self.idle 	 = int(values[4])
    self.iowait  = int(values[5])
    self.irq 	   = int(values[6])
    self.softirq = int(values[7])
    self.steal 	 = int(values[8])
    self.guest 	 = int(values[9])
    self.guest_nice = int(values[10])

  def json(self, unit='sec'):       
    if unit =='sec':
      tick = self.ticks
    elif unit == 'USER_HZ':
      tick = 1
    else:
      tick = 1

    return {
      'name': 	self.name,
      'user': 	self.user   * tick,
      'nice': 	self.nice   * tick,
      'system':   self.system * tick,
      'idle': 	self.idle   * tick,
      'iowait':   self.iowait * tick,
      'irq': 		self.irq    * tick,
      'softirq':  self.softirq* tick,
      'steal': 	self.steal  * tick,
      'guest': 	self.guest  * tick,
      'guest': 	self.guest  * tick,
    }
