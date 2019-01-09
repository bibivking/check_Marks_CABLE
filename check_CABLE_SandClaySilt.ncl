;*****************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;*******************************************

begin


var_name= (/\
           "clay","silt","sand"\
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


;var1 = new((/11,360,720/),float) ; Mark's
;var2 = new((/11,360,720/),float) ; Mark's
var1 = new((/11,300,720/),float)
var2 = new((/11,150,360/),float)

filename1 = "/srv/ccrc/data44/z3362708/CABLE/Data_set_codes/gswp3_srf_creation/Soiltype_SandClaySilt_GSWP3_0.5deg.nc"
;filename2 = "/home/z5218916/cable/CABLE-CASE/met_data/CABLE_UNSW_GSWP3_gridinfo_0.5x0.5.nc" ; Mark's
filename2 = "/home/z5218916/cable/CABLE-CASE/src/Marks_latest_branch_with_fixes/CABLE-AUX/offline/gridinfo_CSIRO_1x1.nc"

f1 = addfile (filename1,"r")
f2 = addfile (filename2,"r")
;longitude = f1->longitude
;latitude  = f1->latitude

do var_num = 0,2
   var1(var_num,:,:) = lonFlip(f1->$var_name(var_num)$({-60.:},:))
   var2(var_num,:,:) = f2->$var_name(var_num)$(::-1,:)
end do

var1!0 = "var"
var1!1 = "lat"
var1!2 = "lon"
var1&lat = f1->lat({-60:})
var1&lon = fspan(-179.75,179.75,720)

var2!0 = "var"
var2!1 = "lat"
var2!2 = "lon"
var2&lat = f2->latitude(0::-1)
print(var2&lat)
var2&lon = fspan(-179.5,179.5,360)

var3 = linint2_Wrap(var2&lon,var2&lat,var2,True,var1&lon,var1&lat,0)

var1 = where(.not. ismissing(var3),var1, var2@missing_value)

var1@missing_value = var2@missing_value

; **************** Mark's ****************
;do var_num = 0,2
;  var1(var_num,:,:) = lonFlip(f1->$var_name(var_num)$)
;  var2(var_num,:,:) = lonFlip(f2->$var_name(var_num)$);(::-1,:)
;end do
;*****************************************

plots = new(3,graphic)

;pic = "GRIDFILE_for_checking_Marks_Org" ;Mark's
pic = "GRIDFILE_for_checking_Marks_Org2"
wks = gsn_open_wks("pdf",pic)
gsn_define_colormap(wks,"rainbow");"WhiteBlueGreenYellowRed")

do var_num = 0,2

  pres@txString = var_name(var_num)
  res@cnFillPalette = "WhiteBlueGreenYellowRed"


  if (var_num .le. 2) then
     res@cnLevels = (/0.001,.1,.2,.3,.4,.5,.6,.7,.8,.9,1./)
  else if (var_num .eq. 3) then
     res@cnLevels = (/0.001,.05,.1,.15,.2,.25,.3,.35,.4/)
  else if (var_num .eq. 4) then
     res@cnLevels = (/0.001,.05,.1,.15,.2,.25,.3,.35,.4,.45,.5/)
  else if (var_num .eq. 5) then
     res@cnLevels = (/.2,.25,.3,.35,.4,.45,.5,.55,.6/)
  else if (var_num .eq. 6) then
     res@cnLevels = (/4.,5.,6.,7.,8.,9.,10.,11.,12./)
  else if (var_num .eq. 7) then
     res@cnLevels = (/0.,0.0002,0.0004,0.0006,0.0008,0.0010/)
  else if (var_num .eq. 8) then
     res@cnLevels = (/0.001,.1,.2,.3,.4,.5,.6,.7,.8,.9,1./)
  else if (var_num .eq. 9) then
     res@cnLevels = (/0.001,.05,.1,.15,.2,.25,.3,.35/)
  else
     res@cnLevels = (/0.,500,1000,1500,2000/)
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if


  res@tiMainString = "(a) Mark's Org"
  plots(0) = gsn_csm_contour(wks,var1(var_num,:,:)*1.0,res)

  ;res@tiMainString = "(b) Mark's Gridfile" ;Mark's
  res@tiMainString = "(b) Standard"
  plots(1) = gsn_csm_contour(wks,var2(var_num,:,:)*1.0,res)

  res@cnFillPalette = "ViBlGrWhYeOrRe"
  res@tiMainString = "(c) Standard - Mark's Org"
  ;res@tiMainString = "(c) Mark's Gridfile - Mark's Org" ;Mark's

  delete(res@cnLevels)

  if (var_num .le. 2) then
     res@cnLevels = (/-.6,-.5,-.4,-.3,-.2,-.1,.1,.2,.3,.4,.5,.6/)
  else if (var_num .eq. 3) then
     res@cnLevels = (/-.25,-.2,-.15,-0.1,-.05,.05,.1,.15,.2,.25/)
  else if (var_num .eq. 4) then
     res@cnLevels = (/-.2,-.15,-0.1,-.05,.05,.1,.15,.2/)
  else if (var_num .eq. 5) then
     res@cnLevels = (/-.08,-.06,-.04,-.02,.02,.04,.06,.08/)
  else if (var_num .eq. 6) then
     res@cnLevels = (/-7.,-6.,-5.,-4.,-3.,-2.,-1.,1.,2.,3.,4.,5.,6.,7./)
  else if (var_num .eq. 7) then
     res@cnLevels = (/-0.0004,-0.0003,-0.0002,-0.0001,0.0001,0.0002,0.0003,0.0004/)
  else if (var_num .eq. 8) then
     res@cnLevels = (/-.5,-.4,-.3,-.2,-0.1,.1,.2,.3,.4,.5/)
  else if (var_num .eq. 9) then
     res@cnLevels = (/-.14,-.12,-.1,-.08,-.06,-.04,-.02,.02,.04,.06,.08,.1,.12,.14/)
  else
     res@cnLevels = (/-1000,-800,-600,-400,-200,200,400,600,800,1000/)
  end if
  end if
  end if
  end if
  end if
  end if
  end if
  end if

;  plots(2) = gsn_csm_contour(wks,(var2(var_num,:,:)-var1(var_num,:,:))*1.0,res) ;Mark's
  plots(2) = gsn_csm_contour(wks,(var3(var_num,:,:)-var1(var_num,:,:))*1.0,res)
  delete(res@cnLevels)
  gsn_panel(wks,(/plots/),(/2,2/),pres)
end do




end
