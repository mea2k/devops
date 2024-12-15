import os

class intr:
	total: int 	# The first column of the "intr" line is the total of all interrupts served on the system since boot time. 
	counters = []	#The following counters are the count for each possible system interrupt. If you are interested in these values, take a look on /proc/interrupts which does not only show the counters but also the CPU mapping too.

	# единица измерения USER_HZ (Jiffies)
	# обычно 1/100-я секунды
	ticks = os.sysconf(os.sysconf_names['SC_CLK_TCK'])


	def __init__(self, data: str):
		values = data.split()
		self.total 	  = int(values[1])
		self.counters = map(int, values[2:])

	def json(self, unit='sec'):       
		if unit =='sec':
			tick = self.ticks
		elif unit == 'USER_HZ':
			tick = 1
		else:
			tick = 1

		return {
			'total': 	self.total * tick,
			'counters': 	[ i * tick for i in self.counters],
		}
