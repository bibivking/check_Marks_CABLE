;*******************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;*******************************************

begin

file_name = (/\
         "/home/z5218916/cable/CABLE-CASE/met_data/GSWP3_gwmodel_parameters.nc",\
         "/srv/ccrc/data45/z3509830/CABLE_runs/CABLE_site_runs/CABLE_AUX-dev/offline/GSWP3_gwmodel_parameters_site.nc"\
            /)

var2D_name= (/\
             "Sy","drainage_density",\
             "drainage_dist","dtb",\
             "elevation","elevation_std",\
             "permeability","slope","slope_std"\
           /)
var3D_name= (/\
             "clay_vec","sand_vec","silt_vec",\
             "org_vec","hyds_vec","sfc_vec",\
             "ssat_vec","sucs_vec","bch_vec",\
             "swilt_vec","watr","rhosoil_vec",\
             "css_vec","cnsd_vec"\
            /)

; __________________________ PLOT SETTING ____________________________
res                    = True
res@cnFillMode         = "RasterFill"            ; Raster Mode
res@cnFillOn           = True
res@tmBorderThicknessF = 3.0


;************** ????labelbar ***************
res@lbBoxLinesOn       = True
res@lbTitleFont        = 25
res@lbLabelFont        = 25
res@lbTitleFontHeightF = 0.013
res@lbLabelFontHeightF = 0.013
res@txString           = ""
res@tmXBLabelFont      = 25 ;Sets the font index for the bottom X-Axis labels.
res@tmYLLabelFont      = 25

;***********************************************
res@cnLinesOn          = False
res@cnLineColor        = "black"
res@cnLineThicknessF   = 1.5
res@cnLineLabelsOn     = False
res@gsnMaximize        = True

res@cnExplicitLabelBarLabelsOn = True
res@cnLevelSelectionMode       = "ExplicitLevels"

;***********************************************
res@tmXBLabelFontThicknessF = 0.015
res@tmYLLabelFontThicknessF = 0.015
res@tmXBLabelFontHeightF    = 0.015
res@tmYLLabelFontHeightF    = 0.015

;res@trYMinF            = -60
;res@trYMaxF            = 80
;res@mpMinLatF          = -60
;res@mpMaxLatF          = 80
;res@mpCenterLonF       = 160

;res@tmYLMode  = "Explicit"
;res@tmYLValues=(/60,30,0,-30,-60/)
;res@tmYLLabels=(/"60~S~o~N~N","30~S~o~N~N","0~S~o~N~","30~S~o~N~S","60~S~o~N~S"/)
;res@tmXBMode  = "Explicit"
;res@tmXBValues=(/240,300,0,60,120,180/)
;res@tmXBLabels=(/"120~S~o~N~W","60~S~o~N~W","0~S~o~N~","60~S~o~N~E","120~S~o~N~E","180~S~o~N~"/)



;***********************************************
pres                      = True   ; ???? panel resources.
pres@gsnMaximize          = True
pres@gsnPanelLabelBar     = True   ; ???? panel labelbar.
pres@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"
pres@lbBoxLinesOn         = True   ; ???lbar box ????
pres@lbTitleFont          = 25
pres@lbLabelFont          = 25
pres@lbTitleFontHeightF   = 0.013
pres@lbLabelFontHeightF   = 0.013
pres@lbAutoManage         = False
pres@lbTitleDirection     = "Across"             ; title direction
pres@lbTitlePosition      = "Bottom";Right"


var1 = new((/2,9,360,720/),float)
var2 = new((/2,14,6,360,720/),float)
;var1@_FillValue = -9999.
;var2@_FillValue = -9999.

do file_num = 0,1

f = addfile(file_name(file_num),"r")

;longitude = f1->longitude
;latitude  = f1->latitude

;LAI = f1->LAI(time, latitude, longitude)
if file_num .eq. 0 then
do var_num = 0,8
   var1(file_num,var_num,:,:)   = f->$var2D_name(var_num)$*1.0 ;lonFlip(
end do

do var_num = 0,13
   var2(file_num,var_num,:,:,:) = f->$var3D_name(var_num)$*1.0 ;lonFlip(
end do

else
  do var_num = 0,8
     var1(file_num,var_num,:,:)   = f->$var2D_name(var_num)$*1.0 ;(::-1,:)
  end do

  do var_num = 0,13
     var2(file_num,var_num,:,:,:) = f->$var3D_name(var_num)$*1.0 ;(::-1,:)
  end do
end if
end do

;var1!0 = "var"
;var1!1 = "lat"
;var1!2 = "lon"
;var1&lat = f1->latitude({-60:})
;var1&lon = fspan(-179.75,179.75,720)


;var2!0 = "var"
;var2!1 = "lat"
;var2!2 = "lon"
;var2&lat = f2->latitude(0::-1)
;print(var2&lat)
;var2&lon = fspan(-179.5,179.5,360)

;var3 = linint2_Wrap(var2&lon,var2&lat,var2,True,var1&lon,var1&lat,0)
plots1 = new(3,graphic)
plots2 = new(6,graphic)

pic = "ELEVFILE3"
wks = gsn_open_wks("pdf",pic)
gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")

do var_num = 0,8
  res@gsnDraw       = False  ; Don't draw plots
  res@gsnFrame      = False
  res@lbLabelBarOn  = True
  pres@lbLabelBarOn = False ; True

  res@cnFillPalette = "WhiteBlueGreenYellowRed"

  if (var_num .eq. 0) then
     res@cnLevels = fspan(.2,0.4,11)
  else if (var_num .eq. 1) then
     res@cnLevels = fspan(0,0.002,11)
  else if (var_num .eq. 2) then
     res@cnLevels = fspan(0,20,21)
  else if (var_num .eq. 3) then
     res@cnLevels = fspan(0,200,21)
  else if (var_num .eq. 4) then
     res@cnLevels = fspan(0,5600,15)
  else if (var_num .eq. 5) then
     res@cnLevels = fspan(0,1000,11)
  else if (var_num .eq. 6) then
     res@cnLevels = fspan(5e-07,7.5e-06,13)
  else
     res@cnLevels = fspan(0,0.1,21)
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  pres@txString = var2D_name(var_num)
  res@tiMainString = "GSWP3_gwmodel_parameters";+" ("+f->$var2D_name(var_num)$@units+")"
  plots1(0) = gsn_csm_contour(wks,var1(0,var_num,:,:),res)
  res@tiMainString = "GSWP3_gwmodel_parameters_site"
  plots1(1) = gsn_csm_contour(wks,var1(1,var_num,:,:),res)
  delete(res@cnLevels)
  ;plots1(2) = gsn_csm_contour(wks,var1(1,var_num,:,:)-var1(0,var_num,:,:),res)
  gsn_panel(wks,(/plots1(0:1)/),(/1,2/),pres)
end do

delete(res@tiMainString)

do var_num = 0,13

   res@gsnDraw       = False  ; Don't draw plots
   res@gsnFrame      = False
   res@lbLabelBarOn  = False
   pres@lbLabelBarOn = True
   pres@gsnMaximize  = True
   pres@txString = var3D_name(var_num)+" in GSWP3_gwmodel_parameters_site";"difference of "+var3D_name(var_num);+" ("+f->$var3D_name(var_num)$@units+")"
;  res@cnFillPalette = "ViBlGrWhYeOrRe"

  if (var_num .lt. 4) then
     res@cnLevels = fspan(0,0.9,19)
  else if (var_num .eq. 4) then
     res@cnLevels = fspan(0,0.032,17)
  else if (var_num .eq. 5) then
     res@cnLevels = fspan(0.14,0.38,13)
  else if (var_num .eq. 6) then
     res@cnLevels = fspan(0.38,0.56,10)
  else if (var_num .eq. 7) then
     res@cnLevels = fspan(-0.7,-0.0,15)
  else if (var_num .eq. 8) then
     res@cnLevels = fspan(3,12,10)
  else if (var_num .eq. 9) then
     res@cnLevels = fspan(0,0.24,13)
  else if (var_num .eq. 10) then
     res@cnLevels = fspan(0,0.12,13)
  else if (var_num .eq. 11) then
     res@cnLevels = fspan(0,1800,10)
  else if (var_num .eq. 12) then
     res@cnLevels = fspan(760,920,14)
  else if (var_num .eq. 13) then
     res@cnLevels = fspan(0,0.3,16)
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  delete(res@cnLevels)

  do layers = 0,5
     plots2(layers) = gsn_csm_contour(wks,var2(1,var_num,layers,:,:),res);-var2(0,var_num,layers,:,:)
  end do
  gsn_panel(wks,(/plots2/),(/3,2/),pres)

end do




end
