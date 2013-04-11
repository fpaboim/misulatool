-----------------------------------------------------------------------------
--                                                                         --
--                dialog_main.lua  -   Dialog main file                    --
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
require "iuplua"
require "iupluagl"
require "luagl"
require "iupluacontrols"
require "iupluaim"
require "imlua"

-- Include Modules
misula       = require("misula")
local table  = require("gentable")
local plot   = require("plot")

-- Global Variables
bgcolor   = "224 223 227"
white     = "255 255 255"
black     = "0   0   0  "
J = {}

xscCONST, xscLINEAR, xscPARAB  = 1, 2, 3
-- Angle Input Codes: 0 - none, 1 - degrees, 2 - tg(angle)
ANGLE_INPUT = 0
-- initializes J vector
J = {}

--********************************************************************--
---               Variable Declaration and Definitions               ---
--********************************************************************--

---------------------------**** BUTTONS ****----------------------------
--********************************************************************--
plot_btn    = iup.button {title = "   Plot  "    , SIZE = "80x14"}
table_btn   = iup.button {title = " Show Table " , SIZE = "80x14"}
exit_btn    = iup.button {title = "   Exit   "   , SIZE = "80x14"}
saveDG_btn  = iup.button {title = " Save Image " }
saveIL_btn  = iup.button {title = " Save Image " }


---------------------------**** LABELS ****-----------------------------
--********************************************************************--
misula_lbl  = iup.label {TITLE = "Misula Variation"}
len_lbl     = iup.label {TITLE = "L:"}
E_lbl       = iup.label {TITLE = "E:"}
Ma_lbl      = iup.label {SIZE  = "16" , TITLE = "Ma:"}
Mb_lbl      = iup.label {SIZE  = "16" , TITLE = "Mb:"}
Va_lbl      = iup.label {SIZE  = "16" , TITLE = "Va:"}
Vb_lbl      = iup.label {SIZE  = "16" , TITLE = "Vb:"}
Ka_lbl      = iup.label {SIZE  = "16" , TITLE = "Ka:"}
Kb_lbl      = iup.label {SIZE  = "16" , TITLE = "Kb:"}
tab_lbl     = iup.label {SIZE  = "16" , TITLE = "tab:"}
tba_lbl     = iup.label {SIZE  = "16" , TITLE = "tba:"}
qa_lbl      = iup.label {SIZE  = "16" , TITLE = "qa:"}
qb_lbl      = iup.label {SIZE  = "16" , TITLE = "qb:"}
angle_lbl   = iup.label {SIZE  = "30" , TITLE = "Angle:"}
ti_lbl      = iup.label {SIZE  = "16" , TITLE = "Ti:"}
ts_lbl      = iup.label {SIZE  = "16" , TITLE = "Ts:"}

-- separators
load_sep    = iup.label{SEPARATOR = "HORIZONTAL"}
reac_sep    = iup.label{SEPARATOR = "HORIZONTAL"}
coef_sep    = iup.label{SEPARATOR = "HORIZONTAL"}

--------------------------**** TXTBOXES ****----------------------------
--********************************************************************--
len_txt       = iup.text{VALUE = "6.0",   ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white}
E_txt         = iup.text{VALUE = "2e008", ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white}
alpha_txt     = iup.text{VALUE = "1e-005",ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white}
qa_txt        = iup.text{VALUE = "-10.0", ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white}
qb_txt        = iup.text{VALUE = "-20.0", ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white}
ti_txt        = iup.text{VALUE = "20.0",  ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white, ACTIVE   = "NO"}
ts_txt        = iup.text{VALUE = "-10.0", ALIGNMENT = "ACENTER", SIZE = 50, BGCOLOR = white, ACTIVE   = "NO"}
angle_txt     = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 45, BGCOLOR = white, ACTIVE   = "NO"}
Ma_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
Mb_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
Va_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
Vb_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
Ka_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
Kb_txt        = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
tab_txt       = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}
tba_txt       = iup.text{VALUE = "0.0",   ALIGNMENT = "ACENTER", SIZE = 57, BGCOLOR = white, READONLY = "YES"}

---------------------------**** MASKS ****------------------------------
--********************************************************************--
qa_txt.MASK = "[+/-]?(/d+/.?/d*|/./d+)"
qb_txt.MASK = "[+/-]?(/d+/.?/d*|/./d+)"
angle_txt.MASK = "[+/-]?(/d+/.?/d*|/./d+)"
alpha_txt.MASK = "(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?"
E_txt.MASK = "(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?"
len_txt.MASK   = "(/d+/.?/d*|/./d+)"

---------------------------**** TOGGLES ****-----------------------------
--********************************************************************--
-- Angle Edition Toggles
degrees_tgle = iup.toggle{title="Degrees", ACTIVE = "NO"}
tangent_tgle = iup.toggle{title="Tangent", ACTIVE = "NO"}
angle_rdo = iup.radio
{
  iup.vbox
  {
    degrees_tgle,
    tangent_tgle
  };
  value=degrees_tgle,
  tip="angle in degrees or tangent of angle"
}

-- checkbox toggles to define initial or final angle
initial_tgle    = iup.toggle{title = "Initial"; ACTIVE = "NO"}
end_tgle        = iup.toggle{title = "End"    ; ACTIVE = "NO"}
angle_tgles_box = iup.vbox
{
  initial_tgle,
  end_tgle
}

-- Load selection toggles
extload_tgle  = iup.toggle{title="External Load:", ACTIVE = "YES", VALUE = "ON"}
tempload_tgle = iup.toggle{title="Thermal  Load:", ACTIVE = "YES", VALUE = "OFF"}

---------------------------**** LISTS ****-----------------------------
--********************************************************************--
misula_list = iup.list {"None", "Linear", "Parabolic"
                       ; VALUE = xscCONST, DROPDOWN = "YES", SCROLLBAR = "NO", BGCOLOR = white}

---------------------------**** MATRIX ****-----------------------------
--********************************************************************--
data_matrix = iup.matrix
{
  numlin=5,
  numcol=3,
  numcol_visible=3,
  numlin_visible=5,
  widthdef=52,
  scrollbar="NO",
  resizematrix = "NO",
  expand = "NO",
  border = "NO",
  multiple = "NO"
}
data_matrix:setcell(0,0,"")
data_matrix:setcell(0,1,"Initial")
data_matrix:setcell(0,2,"Middle")
data_matrix:setcell(0,3,"End")
data_matrix:setcell(1,0,"d:")
data_matrix:setcell(1,1,"0.80")
data_matrix:setcell(1,2,"0.80")
data_matrix:setcell(1,3,"0.80")
data_matrix:setcell(2,0,"b:")
data_matrix:setcell(2,1,"0.30")
data_matrix:setcell(2,2,"0.30")
data_matrix:setcell(2,3,"0.30")
data_matrix:setcell(3,0,"ygc:")
data_matrix:setcell(4,0,"A:")
data_matrix:setcell(5,0,"I:")
data_matrix["bgcolor3:*"] = bgcolor
data_matrix["bgcolor4:*"] = bgcolor
data_matrix["bgcolor5:*"] = bgcolor
data_matrix["bgcolor*:2"] = bgcolor
data_matrix["bgcolor*:3"] = bgcolor
data_matrix["fgcolor*:2"] = bgcolor
data_matrix["fgcolor*:3"] = bgcolor
data_matrix["width0"] = "20"
data_matrix["alignment0"] = "ACENTER"

--------------------------**** GLCANVAS ****----------------------------
--********************************************************************--
glcnv = iup.glcanvas{
  buffer     = "DOUBLE",
  rastersize = "300x300"
}


--********************************************************************--
---                   Main Dialog GUI Construction                   ---
--********************************************************************--

---------------------------**** FRAMES ****-----------------------------
--********************************************************************--
-- Beam Canvas Frame
beamcnv_frm = iup.frame
              {
                iup.vbox
                {
                  glcnv;
                  MARGIN = "5x5"
                };
                TITLE = "Beam Conventions"
              }

-- Beam Parameters Frame
param_frm   = iup.frame
              {
                iup.hbox{ iup.fill{}, len_lbl, len_txt, iup.fill{}, E_lbl, E_txt, iup.fill{}, alpha_img, alpha_lbl, alpha_txt, iup.fill{}; ALIGNMENT = "ACENTER"}
              ;
              TITLE  = "Beam Parameters",
              MARGIN = "2x2"
              }

-- External Load Frame
load_frm    = iup.frame
              {
                iup.vbox
                {
                  iup.vbox
                  {
                    extload_tgle,
                    iup.hbox{ iup.fill{}, qa_lbl, qa_txt, iup.fill{}, qb_lbl, qb_txt, iup.fill{}};
                    MARGIN = "0x0",
                    GAP    = "2"
                  },
                  load_sep,
                  iup.vbox
                  {
                    tempload_tgle,
                    iup.hbox{ iup.fill{}, ts_lbl, ts_txt, iup.fill{}, ti_lbl, ti_txt, iup.fill{}};
                    MARGIN = "0x0",
                    GAP    = "2"
                  },
                  MARGIN = "8x3",
                  GAP    = "6"
                }
              ;
              TITLE  = "Load Parameters",
              MARGIN = "2x2"
              }

-- Angle Input Frame
tgle_frm    = iup.frame
              {
                iup.hbox{ iup.fill{}, angle_lbl, angle_txt, iup.fill{}, angle_rdo, iup.fill{}, angle_tgles_box, iup.fill{}};
                TITLE = "Input Angle",
                ALIGNMENT = "ACENTER"
              }

-- Cross Section Parameters Frame
mtrx_frm    = iup.frame
              {
                iup.vbox
                {
                  iup.hbox{iup.fill{}, iup.vbox{iup.fill{}, misula_lbl,misula_list, iup.fill{}; gap = "2x0"}, section_img, iup.fill{}},
                  iup.hbox{iup.fill{},data_matrix,iup.fill{}},
                  tgle_frm
                };
                TITLE = "Section Parameters",
                MARGIN = "0x0"
              }

-- Reaction Values Frame
reac_frm    = iup.frame
              {
                iup.vbox
                {
                  iup.hbox{iup.fill{}, Ma_lbl, Ma_txt, iup.fill{}, Mb_lbl, Mb_txt, iup.fill{}},
                  reac_sep,
                  iup.hbox{iup.fill{}, Va_lbl, Va_txt, iup.fill{}, Vb_lbl, Vb_txt, iup.fill{}};
                  MARGIN = "8x3",
                  GAP    = "3"
                };
                TITLE  = "Reaction Values",
                MARGIN = "2x2"
              }

-- Coeficient Values Frame
coef_frm    = iup.frame
              {
                iup.vbox
                {
                  iup.hbox{iup.fill{},  Ka_lbl,  Ka_txt, iup.fill{},  Kb_lbl,  Kb_txt, iup.fill{}},
                  coef_sep,
                  iup.hbox{iup.fill{}, tab_lbl, tab_txt, iup.fill{}, tba_lbl, tba_txt, iup.fill{}};
                  MARGIN = "8x3",
                  GAP    = "3"
                };
                TITLE  = "Coeficient Values",
                MARGIN = "2x2"
              }

-- Buttons Frame
button_frm = iup.frame
             {
               iup.hbox
               {
                 iup.fill{}, plot_btn, table_btn, exit_btn, iup.fill{};
                 ALIGNMENT = "ATOP",
                 MARGIN = "0x0",
                 GAP = "0x0"
               };
               MARGIN = "4x4"
             }

-------------------------**** BOXES/TABS ****---------------------------
--********************************************************************--

-- Diagrams Plot Box
DgPlot_box  = iup.vbox
              {
                plot.DG_plot,
                iup.hbox{saveDG_btn, iup.fill{},plot.DGplot_list,iup.fill{}};
                TABTITLE = " Diagrams "
              }


-- Influence Line Plot Box
ILPlot_box  = iup.vbox
              {
                plot.IL_plot,
                iup.hbox{saveIL_btn,iup.fill{},plot.ILplot_list, plot.sec_val, plot.sec_lbl, plot.sec_txt};
                TABTITLE = " Influence Line "
              }

-- Tabs
plot_tab  = iup.tabs{DgPlot_box, ILPlot_box}

-- Box Contains Beam Image and Plot Frame
plot_box  = iup.hbox{plot_tab; NMARGIN = "1x1"}

-- Box Contains Beam Image and Plot Frame
left_box  = iup.vbox
            {
              beamcnv_frm,
              plot_box;
            }

right_box = iup.vbox
            {
              param_frm,
              load_frm,
              mtrx_frm,
              reac_frm,
              coef_frm;
            }


-- main dialog box
main_box = iup.vbox
           {
             iup.hbox{left_box,right_box},
             button_frm;
           }

---------------------------**** MAINDLG ****-----------------------------
--********************************************************************--
-- main dialog construction
main_dlg   = iup.dialog
                       {
                         main_box;
                         FONT         = "Tahoma::8",
                         NMARGIN      = "3x3",
                         GAP          = "2x2",
                         BGCOLOR      = "224 223 227",
                         FGCOLOR      = "0 0 0",
                         MAXBOX       = "YES",
                         MINBOX       = "YES",
                         RESIZE       = "YES",
                         TITLE        = "MisulaTool",
                         defaultenter = plot_btn
                       }


--********************************************************************--
---                       Main Dialog Callbacks                      ---
--********************************************************************--

----------------------**** Button Callbacks ****------------------------
--********************************************************************--
--------------------- Plot Dialog Button Action ------------------------
function plot_btn:action()
  if (tonumber(plot_tab.valuepos ) == 0) then
    plot.PlotDG()
  else
    plot.PlotIL()
  end
end

-------------------- Table Dialog Button Action ------------------------
function table_btn:action()
  table.table_dlg:show()
end

---------------------- Dialog Exit Callback ----------------------------
function exit_btn:action()
  main_dlg:destroy()
end

------------------- Save DGPlot Button Action --------------------------
function saveDG_btn:action()
  -- Saves the DG image
  plot.export.ShowExportDlg( 1 )
end

------------------- Save ILPlot Button Action --------------------------
function saveIL_btn:action()
  -- Saves the IL image
  plot.export.ShowExportDlg( 2 )
end

----------------------**** TxtBox Callbacks ****------------------------
--********************************************************************--
------------------------- E Edition Callback ---------------------------
function E_txt:killfocus_cb()
  local newval = string.format("%.4g", E_txt.value)
  E_txt.value = newval
  UpdateCoef( data_matrix )
end

----------------------- Alpha Edition Callback -------------------------
function alpha_txt:killfocus_cb()
  local newval = string.format("%.4g", alpha_txt.value)
  alpha_txt.value = newval
  UpdateCoef( data_matrix )
end

---------------------- Length Edition Callback -------------------------
function len_txt:killfocus_cb( )
  if len_txt.value == "" then
    len_txt.value = "0.0"
  else
    plot.sec_val.MAX = len_txt.value
  end
  if tonumber(misula_list.value) == xscPARAB then
    CheckAngle( data_matrix, 1)
  end
  UpdateCoef( data_matrix )
end

------------------------ qa Edition Callback ---------------------------
function qa_txt:killfocus_cb( c, new_value )
  if qa_txt.value == "" then
    qa_txt.value = "0.0"
  end
  UpdateCoef( data_matrix )
  table.tbl_qa_txt.value = qa_txt.value
end

------------------------ qb Edition Callback ---------------------------
function qb_txt:killfocus_cb( c, new_value )
  if qb_txt.value == "" then
    qb_txt.value = "0.0"
  end
  UpdateCoef( data_matrix )
  table.tbl_qb_txt.value = qb_txt.value
end

----------------------- Angle Edition Callback -------------------------
function angle_txt:killfocus_cb( c, new_value )
  if qb_txt.value == "" then
    qb_txt.value = "0.0"
  end
  if tonumber(misula_list.value) == xscPARAB then
    CheckAngle( data_matrix, 1)
  end
end

------------------------ ti Edition Callback ---------------------------
function ti_txt:killfocus_cb( c, new_value )
  if ti_txt.value == "" then
    ti_txt.value = "0.0"
  end
  UpdateCoef( data_matrix )
end

------------------------ ts Edition Callback ---------------------------
function ts_txt:killfocus_cb( c, new_value )
  if ts_txt.value == "" then
    ts_txt.value = "0.0"
  end
  UpdateCoef( data_matrix )
end

-----------------------**** List Callbacks ****-------------------------
--********************************************************************--
--------------------- Misula List Edition Callback ---------------------
function misula_list:action( text, pos, state )
  if ( state == 0 ) then
    return IUP_DEFAULT
  end

  if ( pos == 1 ) then
    -- shows/hides unused columns
    data_matrix["bgcolor1:2"] = bgcolor
    data_matrix["bgcolor*:2"] = bgcolor
    data_matrix["bgcolor*:3"] = bgcolor
    data_matrix["fgcolor*:2"] = bgcolor
    data_matrix["fgcolor*:3"] = bgcolor
    -- updates GUI input for selection
    initial_tgle.ACTIVE = "NO"
    end_tgle.ACTIVE = "NO"
    table.tbl_misula_list.value = "1"
    -- redraws matrix and updates coeficients
    data_matrix.REDRAW = "C2:3"
    UpdateCoef(data_matrix)
  elseif ( pos == 2 ) then
    -- shows/hides unused columns
    data_matrix["bgcolor1:2"] = bgcolor
    data_matrix["bgcolor*:2"] = bgcolor
    data_matrix["bgcolor*:3"] = white
    data_matrix["fgcolor*:2"] = bgcolor
    data_matrix["fgcolor*:3"] = black
    -- updates GUI input for selection
    initial_tgle.ACTIVE = "YES"
    end_tgle.ACTIVE = "NO"
    table.tbl_misula_list.value = "2"
    -- redraws matrix and updates coeficients
    data_matrix.REDRAW = "C2:3"
    UpdateCoef(data_matrix)
  else
    -- shows/hides unused columns
    if (initial_tgle.value == "OFF" and end_tgle.value == "OFF") then
      data_matrix["bgcolor1:2"] = white
    else
      data_matrix["bgcolor1:2"] = bgcolor
    end
    data_matrix["bgcolor*:2"] = white
    data_matrix["bgcolor*:3"] = white
    data_matrix["fgcolor*:2"] = black
    data_matrix["fgcolor*:3"] = black
    -- updates GUI input for selection
    initial_tgle.ACTIVE = "YES"
    end_tgle.ACTIVE = "YES"
    table.tbl_misula_list.value = "3"
    -- redraws matrix and updates coeficients
    data_matrix.REDRAW = "C2:3"
    UpdateCoef(data_matrix)
  end
end

----------------------**** Toggle Callbacks ****------------------------
--********************************************************************--
----------------------- Extload Toggle Callback ------------------------
function extload_tgle:action( state )
  -- checks if toggle was selected
  if (state == 1) then
    qa_txt.active = "YES"
    qb_txt.active = "YES"
  else
    qa_txt.active = "NO"
    qb_txt.active = "NO"
  end
  local len_val = tonumber(len_txt.value)
  UpdateReactions(len_val, J)
end

---------------------- Tempload Toggle Callback ------------------------
function tempload_tgle:action( state )
  -- checks if toggle was selected
  if (state == 1) then
    ti_txt.active = "YES"
    ts_txt.active = "YES"
  else
    ti_txt.active = "NO"
    ts_txt.active = "NO"
  end
  local len_val = tonumber(len_txt.value)
  UpdateReactions(len_val, J)
end

----------------------- Initial Toggle Callback ------------------------
function initial_tgle:action( state )
  -- checks if toggle was selected
  if state == 1 then
    end_tgle.value = "OFF"
    degrees_tgle.active = "YES"
    tangent_tgle.active = "YES"
    angle_txt.active    = "YES"

    -- checks parabolic case
    if (tonumber(misula_list.value) == xscPARAB) then
      data_matrix["bgcolor1:2"] = bgcolor
      data_matrix.REDRAW = "C2"
    end

    -- updates global angle edition indicator
    if degrees_tgle.value == "ON" then
      ANGLE_INPUT = 1
    else
      ANGLE_INPUT = 2
    end
  else
    degrees_tgle.active = "NO"
    tangent_tgle.active = "NO"
    angle_txt.active    = "NO"
    ANGLE_INPUT = 0
    -- checks parabolic case
    if (tonumber(misula_list.value) == xscPARAB) then
      data_matrix["bgcolor1:2"] = white
      data_matrix.REDRAW = "C2"
    end
  end
end

------------------------- End Toggle Callback --------------------------
function end_tgle:action( state )
  if state == 1 then
    initial_tgle.value = "OFF"
    degrees_tgle.active = "YES"
    tangent_tgle.active = "YES"
    angle_txt.active    = "YES"
    data_matrix["bgcolor1:2"] = bgcolor
    data_matrix.REDRAW = "C2"
    -- updates global angle edition indicator
    if degrees_tgle.value == "ON" then
      ANGLE_INPUT = 1
    else
      ANGLE_INPUT = 2
    end
  else
    data_matrix["bgcolor1:2"] = white
    data_matrix.REDRAW = "C2"
    degrees_tgle.active = "NO"
    tangent_tgle.active = "NO"
    angle_txt.active    = "NO"
    ANGLE_INPUT = 0
  end
end

----------------------- Degrees Toggle Callback ------------------------
function degrees_tgle:action( state )
  if state == 1 then
    ANGLE_INPUT = 1
  else
    ANGLE_INPUT = 2
  end
end

----------------------**** Matrix Callbacks ****------------------------
--********************************************************************--
----------------------- Matrix Edition Callback ------------------------
function data_matrix:edition_cb( lin, col, mode, update )
  if (mode == 0) then
    if (lin == 3 or lin == 4 or lin == 5 ) then
      return iup.IGNORE
    end

    if (self.VALUE == "0") then
      return iup.IGNORE
    end

    if (lin == 2 ) then
      self:setcell(2,1, self.VALUE)
      self:setcell(2,2, self.VALUE)
      self:setcell(2,3, self.VALUE)
      UpdateColumn(self, 1)
      UpdateColumn(self, 2)
      UpdateColumn(self, 3)
      return iup.DEFAULT
    end
  end

  if (mode == 1) then
    -- Linear case
    if ((tonumber(misula_list.value) == xscLINEAR) and (col == 2)) then
      return iup.IGNORE
    -- Parabolic case
    elseif ((tonumber(misula_list.value) == xscCONST) and ((col == 3)or(col == 2))) then
      return iup.IGNORE
    -- case where angle input is entered
    elseif ( lin == 1 and col == 2 and (ANGLE_INPUT ~= 0) and (tonumber(misula_list.value) == xscPARAB)) then
      return iup.IGNORE
    end

  end
end


--------------------- Matrix Value Edition Callback --------------------
function data_matrix:value_edit_cb(lin, col, newval)
  UpdateColumn(data_matrix, col)
  CheckAngle(matrix, col)
end

-----------------------**** Tabs Callbacks ****-------------------------
--********************************************************************--
----------------------- Plot tabchange callback ------------------------
function plot_tab:tabchange_cb(new_tab, old_tab)
  if ( tonumber(self.valuepos) == 1 ) then
    -- Deactivates load toggles
    extload_tgle.active  = "NO"
    tempload_tgle.active = "NO"
    -- Deactivates load values
    qa_txt.active    = "NO"
    qb_txt.active    = "NO"
    ti_txt.active    = "NO"
    ts_txt.active    = "NO"
    -- Deactivates E/alpha parameters
    E_txt.active     = "NO"
    alpha_txt.active = "NO"
  else
    -- Reactivates load toggles
    extload_tgle.active  = "YES"
    tempload_tgle.active = "YES"
    -- Reactivates E/alpha parameters
    E_txt.active         = "YES"
    alpha_txt.active     = "YES"
    -- Activates according to toggle state
    if (extload_tgle.value == "ON") then
      qa_txt.active = "YES"
      qb_txt.active = "YES"
    end
    if (tempload_tgle.value == "ON") then
      ti_txt.active = "YES"
      ts_txt.active = "YES"
    end
  end
end

--********************************************************************--
---                       Main Dialog Functions                      ---
--********************************************************************--

---------------------- Set Generic Matrix to Float ---------------------
function MatrixSetFloat( matrix )
  local m = tonumber(matrix.numlin)
  local n = tonumber(matrix.numcol)

  for  i = 1,m do
    for j = 1,n do
      iup.maskMatSet( matrix, "(/d+/.?/d*|/./d+)" , 0, 0, i, j)
    end
  end
end

----------- Checks Angle Input and Calculates Accordingly --------------
function CheckAngle( matrix, col )
  local len = tonumber(len_txt.value)

  -- calculates other columns according to angle input

  ---- LINEAR CASE
  if (tonumber(misula_list.value) == xscLINEAR) then
    --declares auxiliary variable used to calculate modified d
    local d_mod = tonumber(data_matrix:getcell(1,col))
    if not d_mod then return end

    -- angle input in degrees
    if ANGLE_INPUT == 1 then
      local angle = math.rad(tonumber(angle_txt.value))
      -- calculates based on edited column
      if col == 1 then
        d_mod = d_mod + (len * math.tan(angle))
        d_mod = tostring(string.format("%.5g", d_mod))
        data_matrix:setcell(1 , 3, d_mod)
      else
        d_mod = d_mod - (len * math.tan(angle))
        d_mod = tostring(string.format("%.5g", d_mod))
        data_matrix:setcell(1 , 1, d_mod)
      end
    --angle input with tangent value
    elseif ANGLE_INPUT == 2 then
      local tg = tonumber(angle_txt.value)
      -- calculates based on edited column
      if col == 1 then
        d_mod = d_mod + (len * tg)
        d_mod = tostring(string.format("%.5g", d_mod))
        data_matrix:setcell(1 , 3, d_mod)
      else
        d_mod = d_mod - (len * tg)
        d_mod = tostring(string.format("%.5g", d_mod))
        data_matrix:setcell(1 , 1, d_mod)
      end
    end
    -- updates modified column info
    if col == 1 then
      UpdateColumn(data_matrix, 3)
    else
      UpdateColumn(data_matrix, 1)
    end

  ---- PARABOLIC CASE
  elseif (tonumber(misula_list.value) == xscPARAB) then
    if degrees_tgle.active == "NO" then return nil end
    local d_ini
    local d_end
    -- error control for unentered heights (considered 0)
    if not tonumber(data_matrix:getcell(1,1)) then
      return
    else
      d_ini = tonumber(data_matrix:getcell(1,1))
    end
    if not tonumber(data_matrix:getcell(1,3)) then
      return
    else
     d_end = tonumber(data_matrix:getcell(1,3))
    end

    -- angle input in degrees
    if ANGLE_INPUT == 1 then
      local tg = math.tan(math.rad(tonumber(angle_txt.value)))
      if initial_tgle.value == "ON" then
        local a = ((d_end - d_ini - (len*tg))/(len*len))
        local b = tg
        local c = d_ini
        local d_mid = (a*(len/2)^2) + (b*(len/2) + c)
        d_mid = tostring(string.format("%.5g", d_mid))
        data_matrix:setcell(1 , 2, d_mid)
      else
        local a = (d_ini - d_end)/(len^2) + (tg/len)
        local b = tg - (2*a*len)
        local c = d_ini
        local d_mid = (a*(len/2)^2) + (b*(len/2) + c)
        d_mid = tostring(string.format("%.5g", d_mid))
        data_matrix:setcell(1 , 2, d_mid)
      end
    --angle input with tangent value
    elseif ANGLE_INPUT == 2 then
      local tg = tonumber(angle_txt.value)
      if initial_tgle.value == "ON" then
        -- calculates coeficients of parabolic equation
        local a = ((d_end - d_ini - (len*tg))/(len*len))
        local b = tg
        local c = d_ini
        local d_mid = (a*(len/2)^2) + (b*(len/2) + c)
        d_mid = tostring(string.format("%.5g", d_mid))
        data_matrix:setcell(1 , 2, d_mid)
      else
        local a = (d_ini - d_end)/(len^2) + (tg/len)
        local b = tg - (2*a*len)
        local c = d_ini
        local d_mid = (a*(len/2)^2) + (b*(len/2) + c)
        d_mid = tostring(string.format("%.5g", d_mid))
        data_matrix:setcell(1 , 2, d_mid)
      end
    end
  end
  data_matrix.REDRAW = "ALL"
end

---------------------- Updates Data Matrix Column ----------------------
function UpdateColumn( matrix, col )
  local d,b,y,a,i
  local d = tonumber(matrix:getcell(1,col))
  local b = tonumber(matrix:getcell(2,col))

  -- calculates and updates matrix column data
  if (d ~= nil and b ~= nil) then
    y = d/2
    a = RectArea( b, d )
    i = RectInertia ( b, d )

    y = tostring(string.format("%.5g", y))
    a = tostring(string.format("%.5g", a))
    i = tostring(string.format("%.5g", i))

    matrix:setcell(3,col, y)
    matrix:setcell(4,col, a)
    matrix:setcell(5,col, i)

    UpdateCoef( matrix )

    matrix.REDRAW = "ALL"
  end
end

---------------------- Updates Data Matrix Column ----------------------
function UpdateCoef( matrix )
  local d_ini, d_mid, d_end, Ka_val, Kb_val, tab_val, tba_val
  local i, b, d
  local len_val = tonumber(len_txt.value)

  if len_val == 0 then
    return ""
  end

  -- constant case
  if ( tonumber(misula_list.value) == xscCONST) then
    d_ini = tonumber(matrix:getcell(1,1))
    b_ini = tonumber(matrix:getcell(2,1))
    if (d_ini ~= nil and b_ini ~= nil) then
      for i = 0,6 do
        J[i] = RectInertia ( b_ini, d_ini )
      end
      Ka_val, Kb_val, tab_val, tba_val = misula.misRotStiffCoef( len_val, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
      Ka_val  = tostring(string.format("%g", Ka_val))
      Kb_val  = tostring(string.format("%g", Kb_val))
      tab_val = tostring(string.format("%g", tab_val))
      tba_val = tostring(string.format("%g", tba_val))
      Ka_txt.value = Ka_val
      Kb_txt.value = Kb_val
      tab_txt.value = tab_val
      tba_txt.value = tba_val
      UpdateReactions( len_val, J )
    end

  -- linear case
  elseif ( tonumber(misula_list.value) == xscLINEAR) then
    d_ini = tonumber(matrix:getcell(1,1))
    b_ini = tonumber(matrix:getcell(2,1))
    d_end = tonumber(matrix:getcell(1,3))
    b_end = tonumber(matrix:getcell(2,3))
    if (d_ini ~= nil and b_ini ~= nil and d_end ~= nil and b_end ~= nil) then
      for i = 0,6 do
        r = i * (1/6)
        d = LinearInterp( d_ini, d_end, r)
        b = LinearInterp( b_ini, b_end, r)
        J[i] = RectInertia ( b, d )
      end
      Ka_val, Kb_val, tab_val, tba_val = misula.misRotStiffCoef( len_val, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
      Ka_val  = tostring(string.format("%g", Ka_val))
      Kb_val  = tostring(string.format("%g", Kb_val))
      tab_val = tostring(string.format("%g", tab_val))
      tba_val = tostring(string.format("%g", tba_val))
      Ka_txt.value = Ka_val
      Kb_txt.value = Kb_val
      tab_txt.value = tab_val
      tba_txt.value = tba_val
      UpdateReactions( len_val, J )
    end

  -- parabolic case
  elseif ( tonumber(misula_list.value) == xscPARAB) then
    d_ini = tonumber(matrix:getcell(1,1))
    b_ini = tonumber(matrix:getcell(2,1))
    d_mid = tonumber(matrix:getcell(1,2))
    b_mid = tonumber(matrix:getcell(2,2))
    d_end = tonumber(matrix:getcell(1,3))
    b_end = tonumber(matrix:getcell(2,3))
    if (d_ini ~= nil and b_ini ~= nil and d_mid ~= nil and b_mid ~= nil
    and d_end ~= nil and b_end ~= nil) then
      for i = 0,6 do
        r = i * (1/6)
        d = ParabInterp( d_ini, d_mid, d_end, r)
        b = ParabInterp( b_ini, b_mid, b_end, r)
        J[i] = RectInertia ( b, d )
      end
      Ka_val, Kb_val, tab_val, tba_val = misula.misRotStiffCoef( len_val, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
      Ka_val  = tostring(string.format("%.4g", Ka_val))
      Kb_val  = tostring(string.format("%.4g", Kb_val))
      tab_val = tostring(string.format("%.4g", tab_val))
      tba_val = tostring(string.format("%.4g", tba_val))
      Ka_txt.value = Ka_val
      Kb_txt.value = Kb_val
      tab_txt.value = tab_val
      tba_txt.value = tba_val
      UpdateReactions( len_val, J )
    end
  end
end

---------------------- Updates Reaction Values -------------------------
function UpdateReactions( len, J )
  local E  = tonumber(E_txt.value)
  local alpha = tonumber(alpha_txt.value)
  local qa,qb  = Get_qaqb()
  local ts,ti  = Get_tsti()
  local Ma, Mb, Ma_q, Mb_q, Ma_T, Mb_T

  Ma_q, Mb_q = misula.misFixEnd_q( len, qa, qb, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
  Ma_T, Mb_T = misula.misFixEnd_temp( len, ti, ts, alpha, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
  Ma_T = Ma_T * E
  Mb_T = Mb_T * E

  Ma = Ma_q + Ma_T
  Mb = Mb_q + Mb_T

  Ma_txt.value = tostring(string.format("%.4g", Ma))
  Mb_txt.value = tostring(string.format("%.4g", Mb))

  Va, Vb = misula.misFixEnd_V( len, qa, qb, Ma_q, Mb_q )
  Va_txt.value = tostring(string.format("%.4g", Va))
  Vb_txt.value = tostring(string.format("%.4g", Vb))
end

-------------------- Returns Rectangular Inertia -----------------------
function RectInertia( b, d )
  local I
  I = (b * d * d * d) / 12

  return I
end

---------------------- Returns Rectangular Area ------------------------
function RectArea( b, d )
  local A
  A = ( b * d )

  return A
end

-------------------- Returns Linear Interpolation ----------------------
--
function LinearInterp( d_ini, d_end, r )
  local d = ( d_ini * (1-r)) + (d_end * r)

  return d
end

------------------- Returns Parabolic Interpolation --------------------
function ParabInterp( d_ini, d_mid, d_end, r )
  local N1 = (r-0.5)*(r-1)*2
  local N2 = (-4)*r*(r-1)
  local N3 = 2*r*(r-0.5)
  local d_interp = N1*d_ini + N2*d_mid + N3*d_end

  return( d_interp )
end

------------------- Returns Coeficients of Parabola --------------------
-- returns a,b and c of y = ax^2 + bx + c
function CoefParab( len )
  local d_ini, d_mid, d_end
  local a,b,c
  -- error control for unentered heights (considered 0)
  if not tonumber(data_matrix:getcell(1,1)) then
    d_ini = 0
    data_matrix:setcell(1 , 1, d_ini)
  else
    d_ini = tonumber(data_matrix:getcell(1,1))
  end
  if not tonumber(data_matrix:getcell(1,2)) then
    d_mid = 0
    data_matrix:setcell(1 , 3, d_mid)
  else
    d_mid = tonumber(data_matrix:getcell(1,2))
  end
  if not tonumber(data_matrix:getcell(1,3)) then
    d_end = 0
    data_matrix:setcell(1 , 3, d_end)
  else
    d_end = tonumber(data_matrix:getcell(1,3))
  end

  c = d_ini
  a = (2*d_end - 4*d_mid + 2*d_ini) / len^2
  b = (d_end - a*len^2 - c)/ len

  return a,b,c
end

--------------------- Returns Coeficients of Line ----------------------
-- returns a and b of y = ax + b
function CoefLin( len )
  if not tonumber(data_matrix:getcell(1,1)) then
    d_ini = 0
    data_matrix:setcell(1 , 1, d_ini)
  else
    d_ini = tonumber(data_matrix:getcell(1,1))
  end
  if not tonumber(data_matrix:getcell(1,3)) then
    d_end = 0
    data_matrix:setcell(1 , 3, d_end)
  else
    d_end = tonumber(data_matrix:getcell(1,3))
  end

  a = (d_end - d_ini)/len
  b = d_ini

  return a,b
end

---------------------- Gets Values of qa and qb ------------------------
function Get_qaqb()
  local qa, qb
  if (extload_tgle.value == "ON") then
    qa = tonumber(qa_txt.value)
    qb = tonumber(qb_txt.value)
  else
    qa = 0
    qb = 0
  end
  return qa,qb
end

---------------------- Gets Values of ti and ts ------------------------
function Get_tsti()
  local ts, ti
  if (tempload_tgle.value == "ON") then
    ts = tonumber(ts_txt.value)
    ti = tonumber(ti_txt.value)
  else
    ts = 0
    ti = 0
  end
  return ts,ti
end

---------------------- Gets Values of ti and ts ------------------------
function glcnv:action(x, y)
  iup.GLMakeCurrent(self)
  gl.ClearColor(1.0, 1.0, 1.0, 1.0)
  gl.Clear(gl.COLOR_BUFFER_BIT)
  gl.Clear(gl.DEPTH_BUFFER_BIT)
  gl.MatrixMode(gl.PROJECTION)
  gl.Viewport(0, 0, 300, 300)
  gl.LoadIdentity()
  gl.Begin(gl.LINES)
  gl.Color(1.0, 0.0, 0.0)
  gl.Vertex(0.0, 0.0)
  gl.Vertex(10.0, 10.0)
  gl.End()
  iup.GLSwapBuffers(self)
end


--*************************** End of Module********************************--

---- MAIN
-- Makes plots acessible in export module
plot.export.DG_plot  = plot.DG_plot
plot.export.IL_plot = plot.IL_plot
-- Sets main dialog matrix to float
MatrixSetFloat(data_matrix)
-- Calculates area, inertia... for default values
UpdateColumn(data_matrix, 1)
UpdateColumn(data_matrix, 2)
UpdateColumn(data_matrix, 3)
-- Shows dialog
main_dlg:show()

if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end
