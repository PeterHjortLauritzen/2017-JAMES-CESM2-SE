load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
  ;
  ; user set variables
  ;
  vname      = (/"PS","PRECL"/)
;  vname                 = "PS"      ; variable you wish to output
  horizontal_resolution = "ne30_ne30" ; -res setting
  compset="FKESSLER"                ; compset used
  iday  = 0                        ; plot day
  output_format = "pdf"             ; output format
  

;******************************************************
; create plot
;******************************************************


  fnames =  systemfunc("ls *.nc")
;  fnames = (/"fkessler.h0.nc","fkessler.h0.nc"/)
  wks = gsn_open_wks(output_format,"02_baro_wave.pdf")
  fall = addfiles(fnames,"r")       ; Open netCDF files.	
  fcnt = dimsizes(fnames)
  print(fnames)


  time= fall[0]->time(iday)
  lon = fall[0]->lon
  lat = fall[0]->lat
  nlon=dimsizes(lon)
  nlat=dimsizes(lat)

  gsn_define_colormap(wks,"BlAqGrYeOrReVi200")   ; choose colormap

  res                     = True         ; plot modifications desired
  res@gsnMaximize         = True         ; Maximize size of plot in frame
  res@gsnSpreadColors     = True         ; Use full colormap, but start
  res@gsnDraw             = False           ; don't draw
  res@gsnFrame            = False           ; don't advance frame
  res@cnFillOn            = True         ; Turn on contour fill
;  res@cnFillMode          = "AreaFill"   ; Style of fill. You can also
                                         ; use "CellFill" and "RasterFill"
  res@cnLinesOn           = False        ; Turn off contour lines
  res@cnLineLabelsOn      = False        ; Turn off contour line labels
  res@lbLabelAutoStride   = True         ; Clean up labelbar labels.
  res@mpOutlineOn     = False       ; No continents
;  res@cnFillMode="RasterFill"

  res@mpMinLatF = 20.                   ; set the minimum latitude = -70.
  res@mpMaxLatF = 70.                    ; set the maximum latitude = 70.

  res@mpMinLonF = 30.                    ; set the minimum latitude = -70.
  res@mpMaxLonF = 210.

  res@gsnStringFontHeightF = 0.02
  res@tiMainFontHeightF = 0.025
  res@lbLabelFontHeightF = 0.02
  res@tmXBLabelFontHeightF = 0.015
  res@tmYLLabelFontHeightF = 0.015
  res@pmLabelBarOrthogonalPosF = 0.2


  plot = new(2*fcnt,graphic) 
  plotk=0
  do k=0,fcnt-1
    do nvar=0,1
      print("plot "+k)

      var  = fall[k]->$vname(nvar)$(iday,:,:)    ; Read some data; convert to 1D.i
;      if (nvar.eq.0) then
        if (k.eq.0) then 
          res@tiMainString        = "CAM-FV"
        end if
        if (k.eq.1) then
          res@tiMainString        = "CAM-HOMME  (moist ~F33~h )"
        end if
        if (k.eq.2) then 
          res@tiMainString        = "CAM-SE (dry ~F33~h)"
        end if
;      else
;        res@tiMainString        = ""
; if

      if (vname(nvar).eq."PRECL") then
        var = 1000*24*3600*var ;convert from m/s to mm/day  
        res@cnLevelSelectionMode = "ManualLevels"
        res@gsnRightString = "mm/day"
        res@cnMinLevelValF  = 0.0
        res@cnMaxLevelValF  = 60.0
        res@cnLevelSpacingF = 2.0
      end if


      if (vname(nvar).eq."PS") then
        var = var/100.0 ;convert from Pa to hPa
        res@gsnRightString = "hPa"
        if (time.eq.10) then
          res@cnLevelSelectionMode = "ManualLevels"
          res@cnMinLevelValF  = 945.0
          res@cnMaxLevelValF  = 1015.0
          res@cnLevelSpacingF = 5.0
        end if
      end if

      res@mpCenterLonF = 180.0           ; Rotate the projection.
      plot(plotk) = gsn_csm_contour_map_ce(wks,var,res)
      plotk=plotk+1
      delete(var)
    end do
  end do
;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
;  resP@gsnPanelLabelBar = True                  ; add common colorbar
;  resP@gsnPanelBottom   = 0.05
  resP@txString   = "Day "+time+" moist baroclinic wave"
  resP@gsnPanelYWhiteSpacePercent = 10.0
  resP@gsnPanelXWhiteSpacePercent = 4.0
  gsn_panel(wks,plot,(/fcnt,2/),resP)            ; now draw as one plot

  txres               = True
;  txres@txFontHeightF = 0.015
;  gsn_text_ndc(wks,"Figure 1: A nifty panel plot",0.5,0.02,txres)
  frame(wks)
end
