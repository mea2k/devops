import re 

from .cpustat import cpustat
from .intr import intr

FILENAME = "/proc/stat"

def getStat():
  cpu_total = {}
  cpus = []
  intr_data = {}
  ctxt = 0
  btime = 0
  processes = 0
  procs_running = 0
  procs_blocked = 0
  softirq = 0

  try:
    with open(FILENAME) as f:
      lines = f.readlines()
      for line in lines:
        
        # starts with cpu xxxx
        if re.match('cpu\s+', line):
          cpu_total = cpustat(line).json()
        # starts with cpuN xxxx
        if re.match('cpu\d+\s+', line):
          cpus.append(cpustat(line).json())
        # starts with intr xxxx
        if re.match('intr\s+', line):
          intr_data = intr(line).json()
        # starts with ctxt xxxx
        if re.match('ctxt\s+', line):
          # The number of context switches that the system underwent.
          ctxt = int((line.split())[1])
        # starts with btime xxxx
        if re.match('btime\s+', line):
          # boot time, in seconds since the Epoch, 1970-01-01 00:00:00 +0000 (UTC).
          btime = int((line.split())[1])
        # starts with processes xxxx
        if re.match('btime\s+', line):
          # Number of forks since boot.
          processes = int((line.split())[1])
        # starts with procs_running xxxx
        if re.match('procs_running\s+', line):
          # Number of processes in runnable state.  (Linux 2.5.45 onward.)
          procs_running = int((line.split())[1])
        # starts with procs_blocked xxxx
        if re.match('procs_blocked\s+', line):
          # Number of processes blocked waiting for  I/O  to  complete.   (Linux  2.5.45 onward.)
          procs_blocked = int((line.split())[1])

        # starts with softirq xxxx
        if re.match('softirq\s+', line):
          # This line shows the number of softirq for all CPUs.  The first column is the
          # total of all softirqs and each subsequent column is the total for particular
          # softirq.  (Linux 2.6.31 onward.)
          softirq = [int(x) for x in line.split()[1:]]

  except IOError:
    print('Error')
    raise

  return {
    'cpu_total': cpu_total,
    'cpus': cpus,
    'intr': intr_data,
    'ctxt': ctxt,
    'btime': btime,
    'processes': processes,
    'procs_running': procs_running,
    'procs_blocked': procs_blocked,
    'softirq': list(softirq),
  }                              
                                