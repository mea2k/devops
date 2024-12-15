import re

class loadavg:
  loadavg_1m: float	  # Average number of processes in queue for CPU via 1 min
  loadavg_5m: float	  # Average number of processes in queue for CPU via 5 min
  loadavg_15m: float  # Average number of processes in queue for CPU via 15 min
  current_procs: int  # Количество процессов, выполняющихся в системе сейчас
  total_procs: int    # Количество процессов в системе вообще
  last_pid: int       # Последний выданный системой PID

  def __init__(self, data: str):
    values = data.split()
    self.loadavg_1m = float(values[0])
    self.loadavg_5m = float(values[1])
    self.loadavg_15m = float(values[2])
    data = re.match('(\d+)/(\d+)', values[3])
    if data:
      self.current_procs = data.group(1)
      self.total_procs = data.group(2)
    self.last_pid = int(values[4])


  def json(self):       
    return {
      'loadavg_1m': 	 self.loadavg_1m,
      'loadavg_5m': 	 self.loadavg_5m,
      'loadavg_15m': 	 self.loadavg_15m,
      'current_procs': self.current_procs,
      'total_procs':   self.total_procs,
      'last_pid':      self.last_pid,
     }
