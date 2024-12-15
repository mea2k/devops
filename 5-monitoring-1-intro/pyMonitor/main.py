import os
import errno
import json
from datetime import datetime
import time

# import metric modules
import cpustat
import uptime
import loadavg
import meminfo

LOG_PATH	 = "/var/log/pymonitor"
LOG_PREFIX = "awesome_monitoring_"
LOG_SUFFIX = ""


# create or append file 'LOG_PREFIX yyyy-mm-dd LOF_SUFFIX'
# and write log record as
# timestamp(UNIX) - DATA(JSON)
def save_log(data):
	date = datetime.now().strftime("%Y-%m-%d")
	filename = LOG_PATH + "/" + LOG_PREFIX + date + LOG_SUFFIX + ".log"
	if not os.path.exists(LOG_PATH):
		try:
			os.makedirs(LOG_PATH)
		except OSError as exc: # Guard against race condition
			if exc.errno != errno.EEXIST:
				print('Error')
				raise

	try:
		with open(filename, "a") as fp:
			fp.write(f"{data['timestamp']} - ")
			json.dump(data, fp)
			fp.write("\n")
	except IOError:
		print('Error')
		raise

# get all stat from metric modules
def get_stat():
	# CPU data ('/proc/cpustat')
	cpu_data = cpustat.getStat()
	# Uptime data ('/proc/uptime')
	uptime_data = uptime.getStat()
	# Average CPU usage ('/proc/loadavg')
	loadavg_data = loadavg.getStat()
	#Memory usage data ('/proc/meminfo')
	memory_data = meminfo.getStat()
	return {
		'time': datetime.now().isoformat(),
  	'timestamp': int(time.time()),
    'cpu_data': cpu_data,
		'uptime': uptime_data,
		'loadavg': loadavg_data,
		'meminfo': memory_data,
	}


data = get_stat()
#print(data)
save_log(data)
