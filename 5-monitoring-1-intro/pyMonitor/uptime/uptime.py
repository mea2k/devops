class uptime:
  total: float	# Total upname (in sec)
  idle: float 	# Total uptime in idle (in sec)

 

  def __init__(self, data: str):
    values = list(map(float, data.split()))
    self.total 	 = values[0]
    self.idle 	 = values[1]


  def json(self, unit='sec'):       
    if unit =='sec':
      tick = 1
    else:
      tick = 1

    return {
      'total': 	self.total * tick,
      'idle': 	self.idle  * tick,
     }
