#!/usr/bin/python

import random
import os
import shutil
import numpy as np
off = 0
nproc = 1000

memory = 20000 # In words: 1 word = 8 bytes

global NAtoms
NAtoms = 12

zeroMomentum = True

def getxyz(n,ini = "initconds") :
	n += 1
	fob = [i.replace("\n","").split() for i in open(ini,"r").readlines() ] 
	for i in range(len(fob)):
		try:
			if fob[i][0] == 'Index':
				if fob[i][1] == str(n) :
					geom = fob[i+2:i+2 + NAtoms]
					return geom
		except:
			pass

def write(dat,loc):
	fob1 = open(loc+"/geom","w+") 
	fob2 = open(loc+"/veloc","w+") 
	for i in dat:
		fob1.writelines(" ".join(i[:6]) +"\n" )
		if (zeroMomentum == False):
			fob2.writelines(" ".join(i[6:]) +"\n" ) 
		else:
			printline = np.zeros((3))
			fob2.writelines(" ".join(map(str, printline ) ) +"\n" )
	fob1.close()
	fob2.close()

dirs = []

for i in range(off,nproc):
		name = 'traj-'  + str(i)
		dirs.append(name)

#generate folders
for i in range(off,nproc):
	if not(os.path.exists(dirs[i-off])):
			os.mkdir(dirs[i-off])
	try:
		os.mkdir(dirs[i-off] +"/QM" )
		os.mkdir(dirs[i-off] +"/QM/temp" )
		os.mkdir(dirs[i-off] +"/restart" )
	except :
		pass

def makeinp(filename):
	I = open('input',"r").readlines()  
	for i in range(len(I)): # Loop over template input file
		if ( len(I[i].split()) >= 2 and I[i].split()[0] == 'rngseed' ):
			I[i] = 'rngseed '+ str( random.randint(-int(1E8),int(1E8)) ) + "\n"
		fob = open(filename,"w+")
		fob.writelines(I) 
		fob.close()

cwd = os.getcwd()

#copy executables
for i in range(off,nproc):
	print ("TRAJ:",i,"of",nproc,"("+str(i-off+1)+")")
	makeinp(dirs[i-off]+"/input") 
	#shutil.copy2('input',dirs[i-off])
	shutil.copy2('run.sh',dirs[i-off])
	shutil.copy2('submit.sbatch',dirs[i-off])
	#shutil.copy2('./QM/MOLPRO.resources',dirs[i]+"/QM/")
	resources = []
	for j in open("./QM/MOLPRO.resources","r").readlines():
		if (j.split()[0] == "scratchdir"):
			resources.append( "scratchdir " + cwd + "/%s/temp\n" %(dirs[i-off]) )
		elif (j.split()[0] == "savedir"):
			resources.append( "savedir " + cwd + "/%s/restart\n" %(dirs[i-off]) )
		elif (j.split()[0] == "memory"):
			resources.append( "memory %s\n" %memory )
		else:
			resources.append(j)
	open(dirs[i-off]+"/QM/MOLPRO.resources","w+").writelines(resources)

	shutil.copy2('./QM/MOLPRO.template',dirs[i-off]+"/QM/")
	shutil.copy2('./QM/runQM.sh',dirs[i-off]+"/QM/")
	write(getxyz(i-off),dirs[i-off]) 
	os.chdir(dirs[i-off]) 
	os.system("sbatch submit.sbatch")
	os.chdir("../")

#	shutil.copy2('./QM/QM.in',dirs[i]+"/QM/") 
