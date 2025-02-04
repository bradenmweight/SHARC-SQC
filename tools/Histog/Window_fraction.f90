!
!...calculate the electronic population through histogram
!...obtained by SQCQD
!...WHZhou,11/22/2018
program main
implicit none
integer::N  !# of density files
character(len=30),allocatable::nameall(:)
character(len=80)::filename
integer::nrow,ncol,nstate,nstep
real*8,allocatable::hist(:,:,:),arr(:,:,:),pop(:,:)
logical::alive
integer::i,j,k,Ns
real*8::sumf

write(*,*)"Try to find how many density*.dat files we need to average"
!call get_num_file("density*.dat",N)
call count_file_head('density',N)
write(*,*)"N=",N

allocate(nameall(N))
!call get_name_file("density*.dat",N,nameall)
call get_name_file_head('density',N,nameall)

filename="density00001.dat"
inquire(file=filename, exist=alive)
if(.not.alive)then
  write(*,*) 'Could not find file "',trim(filename),'"!'
  stop
endif

call get_row_block('density00001.dat',nrow)
write(*,*)"nrow=",nrow

call get_col_block('density00001.dat',ncol)
write(*,*)"ncol=",ncol

allocate(arr(nrow,ncol,N))

nstep=nrow
nstate=ncol-1

allocate(hist(nstep,nstate,N))

arr=0.d0 ; k=0 
do i=1,N

  call read_block(nrow,ncol,nameall(i),arr(:,:,i))
  k=k+1

  hist(:,:,i)=arr(:,2:3,i)

enddo
write(*,*)"k=",k
write(*,*)"How many density*.dat files do you want to average"
write(*,*)"Please input an integer between 1 and",N
read(*,*)Ns

open(unit=2,file="window_fac.dat")
allocate(pop(nstep,nstate)) ; pop=0.d0
do j=1,nstep
   sumf=0.d0
   do i=1,Ns !N sample
      do k=1,nstate
         pop(j,k)=pop(j,k)+hist(j,k,i)
         !sumf=sumf+hist(j,k,i)
      enddo
   enddo
   !write(*,*)"sumf=",sumf,pop(j,:)
   pop(j,:)=pop(j,:)/Ns
   !write(*,*)"pop=",pop(j,:)
   write(2,*)j,pop(j,:)
enddo
close(2)


end program main
!
