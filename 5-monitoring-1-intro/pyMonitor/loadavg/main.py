from .loadavg import loadavg

FILENAME = "/proc/loadavg"

def getStat():
  loadavg_1m = 0
  loadavg_5m = 0
  loadavg_15m = 0
  current_procs = 0
  total_procs = 0
  last_pid = 0     
  try:
    with open(FILENAME) as f:
      lines = f.readlines()     
      for line in lines:
        data = loadavg(line).json()
        loadavg_1m = data['loadavg_1m']
        loadavg_5m = data['loadavg_5m']
        loadavg_15m = data['loadavg_15m']
        current_procs = data['current_procs']
        total_procs = data['total_procs']
        last_pid = data['last_pid']
  except IOError:
    print('Error')
    raise

  return {
    'loadavg_1m'   : loadavg_1m,
    'loadavg_5m'   : loadavg_5m,
    'loadavg_15m'  : loadavg_15m,
    'current_procs': current_procs,
    'total_procs'  : total_procs,
    'last_pid'     : last_pid,
   }                              
                                