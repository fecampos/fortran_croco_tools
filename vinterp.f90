      subroutine vinterp(nx,ny,ns,var,Z,missing_val,z0,varout)

      implicit none

      integer, intent(in) :: nx,ny,ns

      real,intent(in) :: var(nx,ny,ns), Z(nx,ny,ns), missing_val, z0
 
      real, intent(out) :: varout(nx,ny)

      integer :: i, j, k

      integer :: aa(nx,ny,ns), levs(nx,ny), msk(nx,ny)
    
      real :: z1, z2, v1, v2
 
      aa = Z

      where(aa.lt.z0)
        aa = 1
      elsewhere
        aa = 0
      end where

      levs = sum(aa,3)

      where(levs.eq.ns)
        levs = ns-1
      end where

      !$OMP PARALLEL DO
      do j = 1,ny
        do i = 1,nx
          if (levs(i,j).ne.0) then
            z1 = Z(i,j,levs(i,j)+1)
            z2 = Z(i,j,levs(i,j))       
            v1 = var(i,j,levs(i,j)+1)
            v2 = var(i,j,levs(i,j))
            varout(i,j) = ((v1-v2)*z0+v2*z1-v1*z2)/(z1-z2)
          end if
        end do
      end do
      !$OMP END PARALLEL DO    

       where(varout.eq.0)
         varout = missing_val
       end where

      end subroutine
