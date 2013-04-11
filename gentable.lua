-----------------------------------------------------------------------------
--                                                                         --
--                  table.lua  -   Table subdialog module                  --
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

module(..., package.seeall);
print("gentable module loaded")

-- Global Variables
white = "255 255 255"

--********************************************************************--
---               Variable Declaration and Definitions               ---
--********************************************************************--
--
---------------------------**** BUTTONS ****----------------------------
--********************************************************************--
tbl_gen_btn   = iup.button{TITLE = " Generate Table! " , SIZE = "80x14"}
col_add_btn   = iup.button{TITLE = "+"     , SIZE = "15x14"}
col_del_btn   = iup.button{TITLE = "-"      , SIZE = "15x14"}
col_edit_btn  = iup.button{TITLE = "Modify" , SIZE = "40x14"}

---------------------------**** LABELS ****----------------------------
--********************************************************************--
tbl_misula_lbl= iup.label{TITLE = "Misula Variation"}
tbl_qa_lbl    = iup.label{SIZE  = "20" , TITLE = " qa: "}
tbl_qb_lbl    = iup.label{SIZE  = "20" , TITLE = " qb: "}
tbl_col_lbl   = iup.label{SIZE  = "50" , TITLE = " Column #: ", ALIGNMENT = "ARIGHT"}
tbl_Iab_lbl   = iup.label{SIZE  = "35" , TITLE = " Ia/Ib: ", ALIGNMENT = "ARIGHT"}

---------------------------**** TXTBOXES ****----------------------------
--********************************************************************--
tbl_qa_txt    = iup.text{VALUE = "0.0"  , ALIGNMENT = "ACENTER", SIZE = 45, BGCOLOR = white}
tbl_qb_txt    = iup.text{VALUE = "0.0"  , ALIGNMENT = "ACENTER", SIZE = 45, BGCOLOR = white}
tbl_col_txt   = iup.text{VALUE = "1"    , ALIGNMENT = "ACENTER", SIZE = 45, BGCOLOR = white}
tbl_Iab_txt   = iup.text{VALUE = "1.000", ALIGNMENT = "ACENTER", SIZE = 45, BGCOLOR = white}
tbl_col_txt.MASK = "/d+"
tbl_Iab_txt.MASK = "(/d+/.?/d*|/./d+)"

---------------------------**** LISTS ****----------------------------
--********************************************************************--
-- table misula list
tbl_misula_list = iup.list { "None", "Linear", "Parabolic";
                             value = 1,
                             dropdown = "YES",
                             BGCOLOR = white}

---------------------------**** MATRIX ****----------------------------
--********************************************************************--
-- table output matrix
output_matrix = iup.matrix
{
    numlin=6,
    numcol=20,
    numlin_visible=6,
    numcol_visible=20,
    scrollbar="YES",
    resizematrix = "YES",
    readonly = "YES",
    widthdef = "32",
    expand = "NO",
    border = "NO",
    multiple = "NO"
}
output_matrix:setcell(0,0,"Ib/Ia")
output_matrix:setcell(0,1,"1.000")
output_matrix:setcell(0,2,"0.900")
output_matrix:setcell(0,3,"0.800")
output_matrix:setcell(0,4,"0.700")
output_matrix:setcell(0,5,"0.600")
output_matrix:setcell(0,6,"0.500")
output_matrix:setcell(0,7,"0.400")
output_matrix:setcell(0,8,"0.300")
output_matrix:setcell(0,9,"0.200")
output_matrix:setcell(0,10,"0.150")
output_matrix:setcell(0,11,"0.120")
output_matrix:setcell(0,12,"0.100")
output_matrix:setcell(0,13,"0.080")
output_matrix:setcell(0,14,"0.060")
output_matrix:setcell(0,15,"0.050")
output_matrix:setcell(0,16,"0.040")
output_matrix:setcell(0,17,"0.030")
output_matrix:setcell(0,18,"0.020")
output_matrix:setcell(0,19,"0.010")
output_matrix:setcell(0,20,"0.005")
output_matrix:setcell(1,0,"Ka*l/(E*Ib)")
output_matrix:setcell(2,0,"Kb*l/(E*Ib)")
output_matrix:setcell(3,0,"tab*Ka*l/(E*Ib)")
output_matrix:setcell(4,0,"")
output_matrix:setcell(5,0,"12*Ma/ql^2")
output_matrix:setcell(6,0,"-12*Mb/ql^2")

output_matrix["bgcolor4:*"] = bgcolor
output_matrix["height4"] = "1"
output_matrix["width0"] = "70"
output_matrix["width1"] = "26"
output_matrix["alignment0"] = "ACENTER"

--********************************************************************--
---                      Table GUI Construction                      ---
--********************************************************************--
-- box for column edition
table_column_box = iup.hbox {
  tbl_col_lbl, tbl_col_txt, tbl_Iab_lbl, tbl_Iab_txt, col_add_btn, col_del_btn, col_edit_btn
}
-- box for table loads
table_load_box = iup.hbox {
  iup.fill{}, tbl_qa_lbl, tbl_qa_txt, iup.fill{}, tbl_qb_lbl, tbl_qb_txt, iup.fill{}
}
-- box for misula list
table_misula_box = iup.hbox {
  iup.fill{}, tbl_misula_lbl, tbl_misula_list, iup.fill{}
}
-- main table box
table_box = iup.vbox {
  iup.frame {
    iup.hbox {
      table_misula_box, table_load_box, table_column_box
    };
    TITLE = ""
  },
  iup.fill{},
  output_matrix,
  iup.fill{},
  iup.hbox {
    iup.fill{}, tbl_gen_btn, iup.fill{}
  };
  GAP = "3x0"
}
-- table dialog construction
table_dlg = iup.dialog {
  table_box;
  FONT   = "Tahoma::8",
  GAP    = "0x0",
  MARGIN = "3x3",
  BGCOLOR = "224 223 227",
  FGCOLOR = "0 0 0",
  MAXBOX  = "NO",
  MINBOX  = "NO",
  RESIZE  = "YES",
  TITLE   = "Fundamental Parameters Table";
}

--********************************************************************--
---                          Table Callbacks                         ---
--********************************************************************--

------------------- Table Generation Button Action ---------------------
function tbl_gen_btn:action()
  GenerateTable()
end

--------------------- Table Misula List Action -------------------------
function tbl_misula_list:action( text, pos, state )
  if ( state == 0 ) then
    return IUP_DEFAULT
  elseif ( pos == 1 ) then
    misula_list.value = "1"
    misula_list:action( text, pos, state )
  elseif ( pos == 2 ) then
    misula_list.value = "2"
    misula_list:action( text, pos, state )
  else
    misula_list.value = "3"
    misula_list:action( text, pos, state )
  end
end

--------------------- tbl_qa Edition Callback --------------------------
function tbl_qa_txt:killfocus_cb( c, new_value )
  qa_txt.value = tbl_qa_txt.value
end

--------------------- tbl_qb Edition Callback --------------------------
function tbl_qb_txt:killfocus_cb( c, new_value )
  qb_txt.value = tbl_qb_txt.value
end

------------------- Table Column Edition Callback ----------------------
function col_edit_btn:action()
  if tonumber(tbl_Iab_txt.VALUE) > 1 then
    tbl_Iab_txt.VALUE = "1.000"
  end
  output_matrix:setcell(0, tonumber(tbl_col_txt.VALUE), tbl_Iab_txt.VALUE)
  output_matrix.REDRAW = "ALL"
end

--------------------- Table Column Add Callback ------------------------
function col_add_btn:action()
  if tonumber(tbl_Iab_txt.VALUE) > 1 then
    tbl_Iab_txt.VALUE = "1.000"
  end
  output_matrix.ADDCOL = tostring(tbl_col_txt.VALUE - 1)
  output_matrix:setcell(0, tonumber(tbl_col_txt.VALUE), tbl_Iab_txt.VALUE)
  output_matrix.REDRAW = "C"..tbl_col_txt.VALUE
end

------------------- Table Column Delete Callback -----------------------
function col_del_btn:action()
  output_matrix.DELCOL = tbl_col_txt.VALUE
end


--********************************************************************--
---                        Table Functions                           ---
--********************************************************************--

---------------------- Generate Table Function -------------------------
function GenerateTable()
  -- hard coded values used for table generation
  -- Jini = 1 and Jend is variable
  local d_ini = 1
  local b_ini = 12
  local b_mid = 12
  local b_end = 12
  local len_val = 1
  -- variables used for table generation
  local J = {}
  local col, i, Ka_val, Kb_val, tab_val, tba_val, Ma, Mb
  local aux1, aux2, aux3, aux4, aux5
  -- gets number of columns in matrix
  local col_num = tonumber(output_matrix.numcol)
  -- tests if qa and qb are not NULL
  if tbl_qa_txt.value == "" then tbl_qa_txt.value = "0" end
  if tbl_qb_txt.value == "" then tbl_qb_txt.value = "0" end
  local qa = tonumber(tbl_qa_txt.value)
  local qb = tonumber(tbl_qb_txt.value)
  -- calculates J for every column
  for col = 1,col_num do
    -- gets d_end value according with Ib/Ia ratio of table
    local d_end = tonumber( (output_matrix:getcell(0,col))^(1/3) )
    -- linear case
    if (tbl_misula_list.value == "2") then
      for i = 0,6 do
        r = i * (1/6)
        d = LinearInterp( d_ini, d_end, r)
        b = LinearInterp( b_ini, b_end, r)
        J[i] = RectInertia ( b, d )
      end
    -- parabolic case
    elseif (tbl_misula_list.value == "3") then
      d_mid = ((d_end-d_ini)*3/4 )+d_ini
      for i = 0,6 do
        r = i * (1/6)
        d = ParabInterp( d_ini, d_mid, d_end, r)
        b = ParabInterp( b_ini, b_mid, b_end, r)
        J[i] = RectInertia ( b, d )
      end
    else
      for i = 0,6 do
        r = i * (1/6)
        d = d_ini
        b = b_ini
        J[i] = RectInertia ( b, d )
      end
    end
    -- gets coeficient values for current cross section
    Ka_val, Kb_val, tab_val, tba_val =
      misula.misRotStiffCoef( len_val, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
    -- gets moment reaction values for current cross section
    Ma, Mb =
      misula.misFixEnd_q( len_val, qa, qb, J[0], J[1], J[2], J[3], J[4], J[5], J[6] )
    -- calculates table value
    aux1 = (Ka_val * len_val)/ J[6]
    aux2 = (Kb_val * len_val)/ J[6]
    aux3 = (tab_val* Ka_val * len_val)/ J[6]
    aux4 = (-12*Ma)/(qa * len_val * len_val)
    aux5 = (12*Mb)/(qa * len_val * len_val)
    -- formats and writes to table
    aux1  = tostring(string.format("%.5g", aux1))
    aux2  = tostring(string.format("%.5g", aux2))
    aux3  = tostring(string.format("%.5g", aux3))
    aux4  = tostring(string.format("%.5g", aux4))
    aux5  = tostring(string.format("%.5g", aux5))
    output_matrix:setcell(1, col, aux1)
    output_matrix:setcell(2, col, aux2)
    output_matrix:setcell(3, col, aux3)
    output_matrix:setcell(5, col, aux4)
    output_matrix:setcell(6, col, aux5)
  end
  output_matrix.REDRAW = "ALL"
end
--*************************** End of Module********************************--
