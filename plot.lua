-----------------------------------------------------------------------------
--                                                                         --
--                   plot.lua  -  Plot execution module                    --
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

require "iuplua_pplot"
module(..., package.seeall);
export = require("plot_export")
print("plot module loaded")

--********************************************************************--
---               Variable Declaration and Definitions               ---
--********************************************************************--

---------------------------**** GLOBALS ****-----------------------------
--********************************************************************--
-- plot points
PPOINTS  = 32
white    = "255 255 255"
--auxiliary variables to hold maximum/minimum graph values
graph_ymax = 0
graph_ymin = 0

---------------------------**** LABELS ****-----------------------------
--********************************************************************--
sec_lbl = iup.label { TITLE = "Section: "}

--------------------------**** TXTBOXES ****----------------------------
--********************************************************************--
sec_txt = iup.text {
  VALUE = "0.0",
  ALIGNMENT = "ACENTER",
  BGCOLOR = white,
  MASK = "(/d+/.?/d*|/./d+)"
}

---------------------------**** LISTS ****-----------------------------
--********************************************************************--
DGplot_list = iup.list {
  "Shear Force", "Bending Moment", "Rotation", "Displacement";
  VALUE = 1, DROPDOWN = "YES", VISIBLE_ITEMS = "5", BGCOLOR = "255 255 255"
}
ILplot_list = iup.list {
  "Shear Force", "Bending Moment";
  VALUE = 1, DROPDOWN = "YES", VISIBLE_ITEMS = "3", BGCOLOR = "255 255 255"
}

---------------------------**** LISTS ****-----------------------------
--********************************************************************--
sec_val     = iup.val{ "HORIZONTAL" ; MAX = "6" }

---------------------------**** PLOTS ****-----------------------------
--********************************************************************--
DG_plot = iup.pplot {
  MARGINTOP     = "30",
  MARGINBOTTOM  = "45",
  MARGINLEFT    = "65",
  MARGINRIGHT   = "25",
  AXS_XLABEL    = "X - Distance from 0 to L",
  AXS_YLABEL    = "Q",
  LEGENDSHOW    = "NO",
  AXS_YREVERSE  = "YES",  --AXS_YREVERSE is reversed in IUP 2.7
  AXS_XFONTSIZE = "10",
  AXS_YFONTSIZE = "10",
  AXS_XMIN      = "0",
  AXS_YMIN      = "-1",
  AXS_XMAX      = "6",
  AXS_YMAX      = "1",
  AXS_XAUTOMIN  = "NO",
  AXS_XAUTOMAX  = "NO",
  AXS_YAUTOMIN  = "NO",
  AXS_YAUTOMAX  = "NO",
  DS_COLOR      = "100 100 200",
  DS_SHOWVALUES = "YES",
  BGCOLOR       = "230 240 255",
  TITLE         = "Shear Diagram",
  GRID          = "YES",
  REDRAW        = "a"
}
iup.PPlotBegin(DG_plot,0)
iup.PPlotAdd  (DG_plot,0,0)
iup.PPlotAdd  (DG_plot,6,0)
iup.PPlotEnd  (DG_plot)

-- initializes plotting area with default values
IL_plot = iup.pplot {
  MARGINTOP     = "30",
  MARGINBOTTOM  = "45",
  MARGINLEFT    = "65",
  MARGINRIGHT   = "25",
  AXS_XLABEL    = "X - Distance from 0 to L",
  AXS_YLABEL    = "LIQ",
  LEGENDSHOW    = "NO",
  AXS_YREVERSE  = "NO",  --AXS_YREVERSE is reversed in IUP
  AXS_XFONTSIZE = "10",
  AXS_YFONTSIZE = "10",
  AXS_XMIN      = "0",
  AXS_YMIN      = "-1",
  AXS_XMAX      = "6",
  AXS_YMAX      = "1",
  AXS_XAUTOMIN  = "NO",
  AXS_XAUTOMAX  = "NO",
  AXS_YAUTOMIN  = "NO",
  AXS_YAUTOMAX  = "NO",
  DS_COLOR      = "100 100 200",
  DS_SHOWVALUES = "YES",
  BGCOLOR       = "230 240 255",
  TITLE         = "Shear Influence Line Diagram",
  GRID          = "YES",
  REDRAW        = "a"
}
iup.PPlotBegin(IL_plot,0)
iup.PPlotAdd  (IL_plot,0,0)
iup.PPlotAdd  (IL_plot,6,0)
iup.PPlotEnd  (IL_plot)

--********************************************************************--
---                       Main Dialog Callbacks                      ---
--********************************************************************--

------------------------- Diagram List Callback ------------------------
function DGplot_list:action( text, pos, state )
  if ( state == 0 ) then
    return ""
  else
    PlotDG()
  end
end

--------------------- Influence Line List Callback ---------------------
function ILplot_list:action( text, pos, state )
  if ( state == 0 ) then
    return ""
  else
    PlotIL()
  end
end


------------------- Section Position TxtBox Callback -------------------
function sec_txt:killfocus_cb()
  -- checks if user left field blank
  if sec_txt.value == "" then
    sec_txt.value = "0.0"
  end

  -- checks if section is outside beam
  if tonumber(sec_txt.value) > tonumber(len_txt.value) then
    sec_txt.value = len_txt.value
  end

  sec_val.value = sec_txt.value
  PlotIL()
end

--------------------- Section ValueBar Callback ------------------------
function sec_val:valuechanged_cb()
  sec_txt.value = sec_val.value
  PlotIL()
end


--********************************************************************--
---                   Plot Manipulation Functions                    ---
--********************************************************************--

---------------------------- Plot Diagram ------------------------------
function PlotDG()
  local x1 = os.clock()

  if (CheckInput() == 0) then
    return
  end

  local i, x, y
  local len = tonumber(len_txt.value)
  graph_ymax = 0
  graph_ymin = 0
  DG_plot.CLEAR = ""
  GetDGPlot()
  iup.PPlotBegin(DG_plot,0)
  for i = 0, PPOINTS do
    x = (i/PPOINTS)*len
    y = DG_plot.PlotGraph(x, len)
    iup.PPlotAdd  (DG_plot, x, y)
  end
  iup.PPlotEnd  (DG_plot)

  -- 10% of graph vertical difference
  local graphdif = (graph_ymax-graph_ymin)*0.1

  DG_plot.DS_COLOR = "255 0 0"
  DG_plot.AXS_XMAX = len_txt.value
  DG_plot.AXS_XMIX = "0"
  DG_plot.AXS_YMAX = tostring(graph_ymax+graphdif)
  DG_plot.AXS_YMIN = tostring(graph_ymin-graphdif)
  DG_plot.REDRAW   = ""

  print(string.format("elapsed time: %.2f", os.clock() - x1))
end

------------------------- Plot Influence Line --------------------------
function PlotIL()
  if (CheckInput() == 0) then
    return
  end

  local i, x, y
  local len = tonumber(len_txt.value)
  local x_sec = tonumber(sec_txt.value)
  local Ma,Mb
  -- plot_num is: 1 - LIQ, 2 - LIM
  local plot_num = tonumber(ILplot_list.value)
  -- Gets Moments at beam endpoints considered for influence line calculation
  if (plot_num == 1) then
    -- Shear Case
    Ma, Mb = misula.misFixEnd_LIQ( len, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
  else
    -- Moment Case
    Ma, Mb = misula.misFixEnd_LIM( len, x_sec, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
  end

  graph_ymax = 0
  graph_ymin = 0
  IL_plot.CLEAR = ""
  GetILPlot()

  local midpoint = math.floor(PPOINTS*(x_sec/len))

  --Plots left of section
  if (midpoint ~= 0) then
    iup.PPlotBegin(IL_plot,0)
    for i = 0, midpoint do
      x = (i/midpoint)*(len*(midpoint/PPOINTS))
      y  = IL_plot.PlotGraph(x, len, x_sec, Ma, Mb)
      iup.PPlotAdd(IL_plot, x, y)
    end
    -- Adds actual midpoint
    y = IL_plot.PlotGraph(x_sec, len, x_sec, Ma, Mb)
    x = x_sec
    iup.PPlotAdd(IL_plot, x, y)
    iup.PPlotEnd(IL_plot)
  end

  --Plots right of section
  iup.PPlotBegin(IL_plot,0)
  for i = midpoint, PPOINTS do
    x = (i/PPOINTS)*len
    y  = IL_plot.PlotGraph(x, len, x_sec, Ma, Mb)
    -- draws graph vertical line for LIQ
    if ( i == midpoint ) then
      y = IL_plot.PlotGraph(x_sec, len, x_sec, Ma, Mb)
      x = x_sec
      if ( plot_num == 1 ) then
        iup.PPlotAdd(IL_plot, x, y)
        y = y+1
      end
    end
    iup.PPlotAdd(IL_plot, x, y)
  end
  iup.PPlotEnd(IL_plot)

  -- 10% of graph vertical difference
  local graphdif = (graph_ymax-graph_ymin)*0.1

  IL_plot.DS_COLOR = "255 0 0"
  IL_plot.DS_EDIT = "YES"
  IL_plot.AXS_XMAX = len_txt.value
  IL_plot.AXS_XMIX = "0"
  IL_plot.AXS_YMAX = tostring(graph_ymax+graphdif)
  IL_plot.AXS_YMIN = tostring(graph_ymin-graphdif)
  IL_plot.REDRAW   = ""
end

------------------ Return Shear Due to Linear Load ---------------------
function ShearLinearLoad(Va, qa, qb, x, len)
  local Qx
  Qx = Va + qa*x + (qb*x^2)/(2*len) - (qa*x^2)/(2*len)
  return Qx
end

---------------------- Shear Plotting Function -------------------------
function ShearFinal( x, len)
  local qa, qb = Get_qaqb()
  local Va = tonumber(Va_txt.value)
  local Q

  Q = ShearLinearLoad(Va, qa, qb, x, len)

  if Q > graph_ymax then
    graph_ymax = Q
  elseif Q < graph_ymin then
    graph_ymin = Q
  end

  return Q
end

----------------- Moment Caused by Linear Load Function ----------------
function MomentLinearLoad(qa, qb, x, len)
  local mq = (( -(qa-qb)/(len*6.0) ) * (x*x*x)) + (( qa/2.0 ) * (x*x)) +
  ((-len*(2*qa+qb)/6.0) * x)
  return mq
end

------------------- Moment Due to Temp Load Function -------------------
function MomentTempLoad(x, len)
  local d_ini, d_mid, d_end
  local qT
  local alpha = tonumber(alpha_txt.value)
  local ts,ti = Get_tsti()
  local num   = alpha*(ti - ts)

  if tonumber(misula_list.value) == xscPARAB then
    d_ini = tonumber(data_matrix:getcell(1,1))
    d_mid = tonumber(data_matrix:getcell(1,2))
    d_end = tonumber(data_matrix:getcell(1,3))
    if (d_ini ~= nil and d_mid ~= nil and d_end ~= nil) then
      h = ParabInterp( d_ini, d_mid, d_end, (x/len) )
    end
  elseif tonumber(misula_list.value) == xscLINEAR then
    d_ini = tonumber(data_matrix:getcell(1,1))
    d_end = tonumber(data_matrix:getcell(1,3))
    if (d_ini ~= nil and d_end ~= nil) then
      h = LinearInterp( d_ini, d_end, (x/len) )
    end
  else
    d_ini = tonumber(data_matrix:getcell(1,1))
    if d_ini ~= nil then h = d_ini end
  end

  qT = num/h
  return qT
end

---------------------- Moment Plotting Function ------------------------
function MomentFinal(x, len)
  local E  = tonumber(E_txt.value)
  local Ma = tonumber(Ma_txt.value)
  local Mb = tonumber(Mb_txt.value)
  local alpha = tonumber(alpha_txt.value)
  qa,qb = Get_qaqb()
  ts,ti = Get_tsti()
  local M

  M = Ma*((x/len)-1) + Mb*(x/len) + MomentLinearLoad(qa, qb, x, len)

  if M > graph_ymax then
    graph_ymax = M
  elseif M < graph_ymin then
    graph_ymin = M
  end

  return M
end

----------------------- Plot Rotation Function -------------------------
function RotFinal(x, len)
  local E  = tonumber(E_txt.value)
  local qa,qb = Get_qaqb()
  local Ma_q, Mb_q
  local rot

  Ma_q, Mb_q = misula.misFixEnd_q( len, qa, qb, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )

  if x == 0 then
    rot = 0
  else
    -- Fixed moments caused by thermal load do not engender rotation
    rot = misula.misRotation( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], qa, qb, Ma_q, Mb_q )/E
  end

  if rot > graph_ymax then
    graph_ymax = rot
  elseif rot < graph_ymin then
    graph_ymin = rot
  end

  return rot
end

----------------------- Plot Rotation Function -------------------------
function DisplLinearLoad(qa, qb, Ma, Mb, x, len)
  local v
  if x == 0 then
    v = 0
  else
    v = misula.misDispl( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], qa, qb, Ma, Mb )
  end

  return v
end


--------------------- Plot Displacement Function -----------------------
function DisplFinal(x, len)
  local qa,qb = Get_qaqb()
  local E  = tonumber(E_txt.value)
  local Ma_q, Mb_q
  Ma_q, Mb_q = misula.misFixEnd_q( len, qa, qb, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
  local v

  v = DisplLinearLoad(qa, qb, Ma_q, Mb_q, x, len)/E

  if v > graph_ymax then
    graph_ymax = v
  elseif v < graph_ymin then
    graph_ymin = v
  end

  return v
end

----------------- Plot Shear Influence Line Function -------------------
function plotLIQ(x, len, x_sec, Ma, Mb)
  if x == 0 then
    v = 0
  else
    if x<=x_sec then
      v = -misula.misDispl( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], 0, 0, Ma, Mb )
    else
      v = -(misula.misDispl( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], 0, 0, Ma, Mb )-1)
    end
  end

  if v > graph_ymax then
    graph_ymax = v
  elseif v < graph_ymin then
    graph_ymin = v
  end

  return v
end

----------------- Plot Moment Influence Line Function ------------------
function plotLIM(x, len, x_sec, Ma, Mb)
  if x == 0 then
    v = 0
  else
    if x<=x_sec then
      v = -misula.misDispl( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], 0, 0, Ma, Mb )
    else
      v = -(misula.misDispl( x, len, J[0], J[1], J[2], J[3], J[4], J[5], J[6], 0, 0, Ma, Mb )+1*(x-x_sec))
    end
  end

  if v > graph_ymax then
    graph_ymax = v
  elseif v < graph_ymin then
    graph_ymin = v
  end

  return v
end

----------------- Plot Shear Influence Line Function -------------------
function GetDGPlot()
  -- plot_num is: 1 - Shear, 2 - Moment, 3 - Rotation, 4 - Displacement
  local plot_num = tonumber(DGplot_list.value)

  if plot_num == 1 then
    DG_plot.AXS_YLABEL    = "Q"
    DG_plot.AXS_YREVERSE  = "YES"
    DG_plot.TITLE         = "Shear Force"
    DG_plot.REDRAW        = "a"
    DG_plot.PlotGraph = ShearFinal
  elseif plot_num == 2 then
    DG_plot.AXS_YLABEL    = "M"
    DG_plot.AXS_YREVERSE  = "NO"
    DG_plot.TITLE         = "Bending Moment"
    DG_plot.REDRAW        = "a"
    DG_plot.PlotGraph = MomentFinal
  elseif plot_num == 3 then
    DG_plot.AXS_YLABEL    = "theta"
    DG_plot.AXS_YREVERSE  = "YES"
    DG_plot.TITLE         = "Rotation"
    DG_plot.REDRAW        = "a"
    DG_plot.PlotGraph = RotFinal
  elseif plot_num == 4 then
    DG_plot.AXS_YLABEL    = "v"
    DG_plot.AXS_YREVERSE  = "YES"
    DG_plot.TITLE         = "Displacement"
    DG_plot.REDRAW        = "a"
    DG_plot.PlotGraph = DisplFinal
  end
end

----------------- Plot Shear Influence Line Function -------------------
function GetILPlot()
  -- plot_num is: 1 - LIQ, 2 - LIM
  local plot_num = tonumber(ILplot_list.value)

  if plot_num == 1 then
    IL_plot.AXS_YLABEL    = "Q"
    IL_plot.AXS_YREVERSE  = "NO"
    IL_plot.TITLE         = "Shear Influence Line Diagram"
    IL_plot.REDRAW        = "a"
    IL_plot.PlotGraph = plotLIQ
  elseif plot_num == 2 then
    IL_plot.AXS_YLABEL    = "M"
    IL_plot.AXS_YREVERSE  = "NO"
    IL_plot.TITLE         = "Moment Influence Line Diagram"
    IL_plot.REDRAW        = "a"
    IL_plot.PlotGraph = plotLIM
  end
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

----------------- Check Input Error Control Function -------------------
-- return 1 if ok, 0 if there is an error
function CheckInput()
  if (tonumber(len_txt.value) == 0) then
    iup.Message("Warning", "Beam lenght is currently null!")
    return 0
  end

  if (J[0] == nil) then
    iup.Message("Warning", "Section properties were not entered!")
    return 0
  end
  return 1
end

--*************************** End of Module********************************--
