from .uptime import uptime

FILENAME = "/proc/uptime"

def getStat():
  total = 0.0
  idle = 0.0

  try:
    with open(FILENAME) as f:
      lines = f.readlines()     
      for line in lines:
        data = uptime(line).json()
        total = data['total']
        idle = data['idle']

  except IOError:
    print('Error')
    raise

  return {
    'total': total,
    'idle': idle,
   }                              
                                