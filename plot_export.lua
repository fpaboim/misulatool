-----------------------------------------------------------------------------
--                                                                         --
--              plot_export.lua  -  Plot Image Export module               --
--                                                                         --
-----------------------------------------------------------------------------
--                                                                         --
--                          Version     0.2                                --
--                                                                         --
--          Created:   20-Jun-2009  - Francisco Paulo de Aboim             --
--                                                                         --
--                                                                         --
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

print("plotexport module loaded")
module(..., package.seeall);

--********************************************************************--
---               Variable Declaration and Definitions               ---
--********************************************************************--

---------------------------**** BUTTONS ****----------------------------
--********************************************************************--
local export_btn  = iup.button {title=" Export ",SIZE="50x14"}
local close_btn   = iup.button {title=" Close ",SIZE="50x14"}
local browse_btn  = iup.button {title=" Browse... ",SIZE="50x14"}

----------------------**** Canvas and Image ****------------------------
--********************************************************************--
local currentcanvas = {}
local currentcnvdlg = {}

local DGplot_iupcanvas = iup.canvas{rastersize="600x400"}
DGplot_iupcanvas.plotimg = im.ImageCreate(600, 400, im.RGB, im.BYTE)
local DGplot_cnvdlg = iup.dialog{iup.hbox{DGplot_iupcanvas}}

local ILplot_iupcanvas = iup.canvas{rastersize="600x400"}
ILplot_iupcanvas.plotimg = im.ImageCreate(600, 400, im.RGB, im.BYTE)
local ILplot_cnvdlg = iup.dialog{iup.hbox{ILplot_iupcanvas}}

--------------------------**** TXTBOXES ****----------------------------
--********************************************************************--
local export_path   = iup.text {value="",  ALIGNMENT="ALEFT", SIZE=300, BGCOLOR="255 255 255"}

---------------------------**** LAYOUT ****-----------------------------
--********************************************************************--

local export_frm = iup.frame
                    {
                      iup.hbox {export_path, iup.fill{}, browse_btn};
                      title = " Image File Name ",
                      MARGIN="3x3",
                      GAP="3x3"
                    }

local dialog_box = iup.vbox
                   {
                     iup.fill{},
                     export_frm,
                     iup.fill{},
                     iup.hbox{ iup.fill{}, export_btn, close_btn, iup.fill{} }
                   }

local dlg = iup.dialog
             {
               dialog_box;
               TITLE    = "Export Image",
               GAP    = "3x3",
               MARGIN = "3x3",
               MAXBOX  = "NO",
               RESIZE  = "NO",
               MINBOX  = "NO"
             }


--********************************************************************--
---                       Export Plot Callbacks                      ---
--********************************************************************--

----------------------**** Button Callbacks ****------------------------
--********************************************************************--
------------------------ Browse Button Action --------------------------
function browse_btn:action()
  local filedlg = iup.filedlg
                  {
                    dialogtype = "SAVE",
                    nochangedir = "YES",
                    file = export_path.value,
                    title = " Save Image File ",
                    extfilter = ".PNG image file (*.png)|*.png"
                  }

  filedlg:popup(IUP_CENTER, IUP_CENTER)

  local status = filedlg.status

  if (status == "-1") then
    return
  else
    local pathstring = filedlg.value

    if ( (string.match(pathstring, ".png" , -4)) ~= nil) then
      export_path.value = pathstring
    else
      export_path.value = pathstring..".png"
    end
  end
end

------------------------ Export Button Action --------------------------
function export_btn:action()
  SaveCanvasImage(currentcanvas.canvas, currentcanvas.plotimg, export_path.value, "PNG")
end

------------------------ Close Button Action ---------------------------
function close_btn:action()
  iup.Hide(dlg)
end

----------------------**** DGPlot Callbacks ****------------------------
--********************************************************************--
------------------------- iupcanvas Map CB  ---------------------------
function DGplot_iupcanvas:map_cb()
  print("canvas mapped")
  self.canvas = cd.CreateCanvas(cd.IUP, self)
end

------------------------- iupcanvas Action  ---------------------------
function DGplot_iupcanvas:action()
  print("canvas action")
  canvas = self.canvas
  iup.PPlotPaintTo(DG_plot, canvas)
end

----------------------**** ILPlot Callbacks ****------------------------
--********************************************************************--
------------------------- iupcanvas Map CB  ---------------------------
function ILplot_iupcanvas:map_cb()
  print("canvas mapped")
  self.canvas = cd.CreateCanvas(cd.IUP, self)
end

------------------------- iupcanvas Action  ---------------------------
function ILplot_iupcanvas:action()
  print("canvas action")
  canvas = self.canvas
  iup.PPlotPaintTo(IL_plot, canvas)
end

--********************************************************************--
---                     Export Plot Functions                        ---
--********************************************************************--

---------------------- Saves Image of cd_canvas ------------------------
function SaveCanvasImage( cd_canvas, im_image, img_name_str, img_type_str)
  iup.Show(currentcnvdlg)
  im_image:cdCanvasGetImage(cd_canvas, 0, 0)
  im_image:Save(img_name_str, img_type_str)
  iup.Hide(currentcnvdlg)
end

---------------------- Show Export Plot Dialog -------------------------
function ShowExportDlg ( plot )
  if ( plot == 1 ) then
    currentcanvas = DGplot_iupcanvas
    currentcnvdlg = DGplot_cnvdlg
    iup.Map(currentcnvdlg)
    iup.Popup(dlg,iup.CENTER,iup.CENTER)
  elseif ( plot == 2 ) then
    currentcanvas = ILplot_iupcanvas
    currentcnvdlg = ILplot_cnvdlg
    iup.Map(currentcnvdlg)
    iup.Popup(dlg,iup.CENTER,iup.CENTER)
  else
    iup.Message("ERROR", "Error saving plot image!")
  end
end

