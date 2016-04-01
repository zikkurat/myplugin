# -*- coding:utf-8 -*-

import os

# ip=[
	# [u'日本','106.185.42.90'],
	# [u'日本','106.185.54.195'],
	# [u'日本','133.18.21.8'],
	# [u'美国','23.107.88.22'],
	# [u'美国','107.189.138.48'],
	# [u'美国','45.56.82.237'],
	# [u'香港','118.193.211.188'],
	# [u'香港','103.237.74.204']
# ]

ip=[
	[u'日本','106.186.18.59'],
	[u'日本','106.184.3.178'],
	[u'日本','133.18.21.8'],
	[u'美国','173.230.157.163'],
	[u'美国','23.236.72.98'],
	[u'美国','172.87.28.93'],
	[u'香港','118.193.197.88'],
	[u'香港','118.193.148.130'],
	[u'香港','103.237.74.204']
]

#服务器端口：22 用户名：godinhome密码：ssh789

def printInfo():
	#print '选择要进行的项目：'.decode('utf-8')
	print '-----------------------------'

	for i in range(len(ip)):
		print '%d. %s - %s' % (i,ip[i][0].encode('gbk'),ip[i][1])
		print '-----------------------------'

	return raw_input('$>')

def run():
	idx=int(printInfo())
	print 'NO. %d is ready! start now.' % idx
	commander='plink.exe -v -C -N -D 127.0.0.1:7070 -l godinhome -pw ssh789 -P 22 '+ip[idx][1]
	# commander='plink.exe -v -C -N -D 127.0.0.1:7070 -l godinhome -pw ssh789 -P 22 133.18.21.8'
	os.system(commander)

run()
