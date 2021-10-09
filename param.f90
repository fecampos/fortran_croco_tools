      module param

      implicit none

      character(len=*), parameter :: fi_grd = "croco_grd.nc"
      character(len=*), parameter :: fi_var = "in.nc"

      character(len=*), parameter :: msk_NAME = "mask_rho"
      character(len=*), parameter :: lon_NAME = "lat_rho"
      character(len=*), parameter :: lat_NAME = "lon_rho"
      character(len=*), parameter :: sig_NAME = "s_rho"
      character(len=*), parameter :: tsc_NAME = "scrum_time"
      character(len=*), parameter :: h_NAME = "h"
      character(len=*), parameter :: zeta_NAME = "zeta"
      character(len=*), parameter :: var_NAME="temp" 

      integer, parameter :: nx = 217, ny = 242, ns = 32, nt = 1, nz = 200

      integer :: i, j, k, ierr

      real, parameter :: pi=3.1415927, missing_val=-32767, dz = 10, z0 = -5

      real, parameter :: theta_s = 6, theta_b = 0, tcline = 10, hc = 10

      real :: lon(nx,ny), lat(nx,ny), S(ns), T(nt), msk(nx,ny)

      real :: h(nx,ny), zeta(nx,ny,nt), var(nx,ny,ns,nt), Z(nx,ny,ns)

      integer :: ncid, ndims, retval, timevarid, lonvarid, latvarid, svarid, mskvarid

      integer :: varvarid, hvarid, zetavarid

      real :: varinterp(nx,ny,nz), depth(nz), X(ny), Y(nx)

      end module 
