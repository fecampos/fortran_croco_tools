      program main_vinterp

      use netcdf

      use param
   
      implicit none     

      retval = nf90_open(fi_var, NF90_NOWRITE, ncid)
      retval = nf90_inq_varid(ncid, tsc_NAME, timevarid)
      retval = nf90_inq_varid(ncid, lon_NAME, lonvarid)
      retval = nf90_inq_varid(ncid, lat_NAME, latvarid)
      retval = nf90_inq_varid(ncid, sig_NAME, svarid)
      retval = nf90_inq_varid(ncid, h_NAME, hvarid)
      retval = nf90_inq_varid(ncid, zeta_NAME, zetavarid)
      retval = nf90_inq_varid(ncid, var_NAME, varvarid)
      retval = nf90_get_var(ncid, timevarid, T)
      retval = nf90_get_var(ncid, lonvarid, lon)
      retval = nf90_get_var(ncid, latvarid, lat)
      retval = nf90_get_var(ncid, svarid, S)
      retval = nf90_get_var(ncid, varvarid, var)
      retval = nf90_get_var(ncid, zetavarid,zeta)     
      retval = nf90_get_var(ncid, hvarid,h)   
      retval = nf90_close(ncid)

      retval = nf90_open(fi_grd, NF90_NOWRITE, ncid)
      retval = nf90_inq_varid(ncid, msk_NAME, mskvarid)
      retval = nf90_get_var(ncid, mskvarid, msk)
      retval = nf90_close(ncid)

      call get_depths(nx,ny,h,zeta,theta_s,theta_b,hc,ns,1,Z)

      !$OMP PARALLEL DO
      do k = 1,nz
        depth(k) = z0-(k-1)*dz
      end do
      !$OMP END PARALLEL DO

      X = lon(1,:)
      Y = lat(:,1)

      !$OMP PARALLEL DO
      do k = 1,nz
        call vinterp(nx,ny,ns,var,Z,missing_val,depth(k),varinterp(:,:,k))
      end do
      !$OMP END PARALLEL DO

      call write_vinterp_output(nx,ny,nz,nt,Y,X,depth,T,missing_val,varinterp)

      end program
