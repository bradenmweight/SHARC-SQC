toolpath=/home/wzhou21/Fortran_code/Toolbox

h2p:
	ifort hist2pop.f90 -I $(toolpath)  -L$(toolpath) -ltoolkit -lblas -llapack -o h2p
winf:
	ifort Window_fraction.f90 -I $(toolpath)  -L$(toolpath) -ltoolkit -lblas -llapack -o winf
clean:	
	rm -f h2p
.PHONY: h2p
