import re 

FILENAME = "/proc/meminfo"

def getStat():
  try:
    with open(FILENAME) as f:
      lines = f.readlines()     
      data = {}
      for line in lines:
        m = re.match('([\w_\(\)]+):\s+(\d+)\s*(\w*)', line)
        if m:
          data[m[1]] = {
            'value': m[2],
            'unit' : m[3] if m[3] else ''
          }
  except IOError:
    print('Error')
    raise

  return data                         
                                