      subroutine get_depths(nx,ny,h,zeta,theta_s,theta_b,hc,ns,vtransform,z)

      implicit none 
   
      integer, intent(in) :: nx, ny, ns, vtransform

      real, intent(in) :: theta_s, theta_b, hc

      real, intent(in) :: zeta(nx,ny), h(nx,ny)

      real, intent(out) :: z(nx,ny,ns)

      integer :: i, j, k

      real :: cff1, cff2, sc(ns), Cs(ns), cff(ns)

      real :: zeta1(nx,ny), hinv(nx,ny), z0(ns)
   
      real, parameter :: Dcrit = 0.01 ! min water depth in dry column cells
 
      zeta1 = zeta

      cff1 = 1/sinh(theta_s)

      cff2 = 0.5/tanh(0.5*theta_s)

      !$OMP PARALLEL DO
      do i = 1,ns
        sc(i) = (i-ns-0.5)/ns
        Cs(i) = (1-theta_b)*cff1*sinh(theta_s*sc(i))+theta_b*&
                &(cff2*tanh(theta_s*(sc(i)+0.5))-0.5)
      end do
      !$OMP END PARALLEL DO

      !$OMP PARALLEL DO
      do j = 1,ny
        do i = 1,nx
          if (zeta(i,j).lt.Dcrit-h(i,j)) then
            zeta1(i,j) = Dcrit-h(i,j)
          end if
        end do
      end do
      !$OMP END PARALLEL DO

      hinv = 1/h
    
      cff = hc*(sc-Cs)

      !$OMP PARALLEL DO
      do k = 1,ns
        do j = 1,ny
          do i = 1,nx
            z0(k) = cff(k)+Cs(k)*h(i,j)
            z(i,j,k) = z0(k)+zeta1(i,j)*(1+z0(k)*hinv(i,j))
          end do
        end do
      end do  
      !$OMP END PARALLEL DO          

      end subroutine
