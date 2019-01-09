;*******************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;*******************************************

;______ From Mark Decker's code _____
setvalues NhlGetWorkspaceObjectId()
  "wsMaximumSize" : 1000000000
end setvalues
;____________________________________

begin

file_name = (/\
         "/srv/ccrc/data03/z3362708/Harmonized_Global_Soil_Data/data",\
         "/srv/ccrc/data45/z3509830/CABLE_runs/CABLE_site_runs/CABLE_AUX-dev/offline/CABLE_UNSW_GSWP3_gridinfo_0.5x0.5_site.nc"\
           /)
;       "/home/z5218916/cable/CABLE-CASE/met_data/GSWP3_gwmodel_parameters.nc",\
;       "/srv/ccrc/data45/z3509830/CABLE_runs/CABLE_site_runs/CABLE_AUX-dev/offline/GSWP3_gwmodel_parameters_site.nc"\

var_name1= (/\
             "T_SAND","S_SAND","T_SILT","S_SILT","T_CLAY","S_CLAY"\
           /)

var_name2= (/\
             "sand","sand2","silt","silt2","clay","clay2"\
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


var1 = new((/6,3600,7200/),float)
var2 = new((/6,360,720/),float)

f2 = addfile(file_name(1),"r")
do var_num = 0,5
f1 = addfile(file_name(0)+"/"+var_name1(var_num)+".nc4","r")
print(f1)
var1(var_num,:,:) = dble2flt(f1->$var_name1(var_num)$)*1.0 ;lonFlip(
var2(var_num,:,:) = f2->$var_name2(var_num)$(::-1,:)*1.0
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
plots = new(2,graphic)
;plots2 = new(6,graphic)

pic = "SCSO"
wks = gsn_open_wks("pdf",pic)
gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")

do var_num = 0,5
  res@gsnDraw       = False  ; Don't draw plots
  res@gsnFrame      = False
  res@lbLabelBarOn  = True
;  pres@lbLabelBarOn = False ; True

;  res@cnFillPalette = "WhiteBlueGreenYellowRed"

;  pres@txString = var2D_name(var_num)
;  res@tiMainString = "GSWP3_gwmodel_parameters";+" ("+f->$var2D_name(var_num)$@units+")"
  plots(0) = gsn_csm_contour(wks,var1(var_num,:,:),res)
;  res@tiMainString = "GSWP3_gwmodel_parameters_site"
  plots(1) = gsn_csm_contour(wks,var2(var_num,:,:),res)
;  delete(res@cnLevels)
  ;plots1(2) = gsn_csm_contour(wks,var1(1,var_num,:,:)-var1(0,var_num,:,:),res)
  gsn_panel(wks,(/plots/),(/1,2/),pres)
end do





end
