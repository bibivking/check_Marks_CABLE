;*****************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;*******************************************

begin

var_name= (/\
           "sfc","swilt"\
           /)

; __________________________ PLOT SETTING ____________________________
res                    = True
res@cnFillMode         = "RasterFill"            ; Raster Mode
res@cnFillOn           = True
res@tmBorderThicknessF = 3.0

res@gsnDraw            = False  ; Don't draw plots
res@gsnFrame           = False
res@lbLabelBarOn       = True

;************** ����labelbar ***************
res@lbBoxLinesOn       = True
res@lbTitleFont        = 25
res@lbLabelFont        = 25
res@lbTitleFontHeightF = 0.013
res@lbLabelFontHeightF = 0.013
res@txString           = ""
res@tmXBLabelFont      = 25 ;Sets the font index for the bottom X-Axis labels.
res@tmYLLabelFont      = 25

;*************** ���õ�ֵ�� *****************
res@cnLinesOn          = False
res@cnLineColor        = "black"
res@cnLineThicknessF   = 1.5
res@cnLineLabelsOn     = False
res@gsnMaximize        = True

res@cnExplicitLabelBarLabelsOn = True
res@cnLevelSelectionMode = "ExplicitLevels"

;************ ����������ֵ��Χ **************
res@tmXBLabelFontThicknessF = 0.015
res@tmYLLabelFontThicknessF = 0.015
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015

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

;**************** ͼ�������� *****************
pres                    = True                                      ; ���� panel resources.
pres@gsnMaximize        = True
pres@gsnPanelLabelBar   = True                     ; ���� panel labelbar.
pres@cnLevelSelectionMode = "ExplicitLevels" ;"ManualLevels"
pres@lbBoxLinesOn       = True                       ;�ر�lbar box ����
pres@lbTitleFont        = 25
pres@lbLabelFont        = 25
pres@lbLabelBarOn       = False ; True                    ; �رո���plot��labelbar
pres@lbTitleFontHeightF = 0.013
pres@lbLabelFontHeightF = 0.013
pres@lbAutoManage       = False
pres@lbTitleDirection   = "Across"             ; title direction
pres@lbTitlePosition    = "Bottom";Right"


var1 = new((/300,720/),float)
var2 = new((/150,360/),float)

filename1 = "/home/z5218916/cable/CABLE-CASE/met_data/CABLE_UNSW_GSWP3_gridinfo_0.5x0.5.nc"
filename2 = "/home/z5218916/cable/CABLE-CASE/src/Marks_latest_branch_with_fixes/CABLE-AUX/offline/gridinfo_CSIRO_1x1.nc"

f1 = addfile (filename1,"r")
f2 = addfile (filename2,"r")
;longitude = f1->longitude
;latitude  = f1->latitude

var1 = lonFlip(f1->sfc({-60.:},:) - f1->swilt({-60.:},:))
var2 = (f2->sfc(::-1,:) - f2->swilt(::-1,:))

var1!0 = "lat"
var1!1 = "lon"
var1&lat = f1->latitude({-60:})
var1&lon = fspan(-179.75,179.75,720)


var2!0 = "lat"
var2!1 = "lon"
var2&lat = f2->latitude(0::-1)
print(var2&lat)
var2&lon = fspan(-179.5,179.5,360)

var3 = linint2_Wrap(var2&lon,var2&lat,var2,True,var1&lon,var1&lat,0)

var1 = where(.not. ismissing(var3),var1, var2@missing_value)

var1@missing_value = var2@missing_value

plots = new(3,graphic)
pic = "fc-wp"
wks = gsn_open_wks("pdf",pic)
gsn_define_colormap(wks,"rainbow");"WhiteBlueGreenYellowRed")


res@cnFillPalette = "WhiteBlueGreenYellowRed"
res@cnLevels = (/-0.02,0,0.02,0.04,0.06,0.08,0.1,0.12,0.14,0.16,0.18,0.20/)

res@tiMainString = "(a) Mark's fc - wp"
plots(0) = gsn_csm_contour(wks,var1*1.0,res)

res@tiMainString = "(b) Standard's fc -wp"
plots(1) = gsn_csm_contour(wks,var2*1.0,res)

delete(res@cnLevels)

res@cnFillPalette = "ViBlGrWhYeOrRe"
res@tiMainString = "(c) abs(Mark's) - abs(Standard's)"
res@cnLevels = (/-0.1,-0.08,-0.06,-0.04,-0.02,0,0.02,0.04,0.06,0.08,0.1/);,0.12,0.14,0.16,0.18,0.20/)

plots(2) = gsn_csm_contour(wks,(abs(var1)-abs(var3))*1.0,res)

gsn_panel(wks,(/plots/),(/2,2/),pres)


end
