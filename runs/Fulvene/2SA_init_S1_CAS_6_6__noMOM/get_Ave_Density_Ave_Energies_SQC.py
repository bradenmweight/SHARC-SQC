# The purpose of this script is to get the population
#   density from multiple trajectories and average them
# To be used with QD-SQC Sharc Code.
###             ~ Braden Weight ~
###             November 27, 2020

import numpy as np

NTraj = 1000 # Number of trajectories
NSteps = 400 # Number of steps per trajectory
NStates = 2 # Dimension of reduced density matrix
TimeStep = 0.1 # fs


### BEGIN MAIN PROGRAM ###
NColumns = NStates

# Get all density and energy data from trajectory folders
density = np.zeros((NTraj,NSteps,NStates))
energy = np.zeros((NTraj,NSteps,NStates))
bad_count = 0
for t in range(NTraj+1):
    print (t, "of", NTraj)
    try:
        lines = open("traj-" + str(t) + "/density.dat","r").readlines()
        if (len(lines) < NSteps):
            print ("Not enough steps in",t," of",NTraj, " Skipping.")
            bad_count += 1
            continue
    except FileNotFoundError:
        print ("File notfound. Skipping.")
        bad_count += 1
        continue
    file01 = open("traj-" + str(t) + "/density.dat","r")
    for count, line in enumerate(file01):
        s = line.split()
        if (count < NSteps and len(s) == NStates+1):
            density[t,count,0] += float(s[1])
            density[t,count,1] += float(s[2])
        #print (density[t,count,:])
    file01.close()

print ("bad_count = ", bad_count)

# Get the average over all trajectories at each step
average_density = np.zeros((NSteps,2))
for n in range(NSteps):
    sum1 = np.sum(density[:,n,0]) 
    sum2 = np.sum(density[:,n,1])
    average_density[n,0] = sum1 / NTraj
    average_density[n,1] = sum2 / NTraj
    sum1 = np.sum( average_density[n,:] )
    average_density[n,0] /= sum1
    average_density[n,1] /= sum1

file01 = open(f"density-{NTraj-bad_count}.dat","w")
for n in range(NSteps):
    line = [round(n*TimeStep,4),average_density[n,0],average_density[n,1]]
    file01.write( "\t".join(map(str,line)) + "\n" )
file01.close()

