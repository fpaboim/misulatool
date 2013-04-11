--------------------------------------------------------------------------------
-- idp.lua  -   Table subdialog module
--------------------------------------------------------------------------------
-- Version: 0.2
-- Created: 20-Jun-2009 - Francisco Paulo de Aboim
-- Original: 25-Oct-2005 - Paula Vilela (mis.c)
-- Description:
--   This file contains the implementation of the functions
--   that compute fix-end reaction moments and stiffness
--   coefficients for a beam element with a cross secton
--   that has a sixth order polynomial variation of moment
--   of inertia.
-- Revisions:
--   *Modified on 01-Jan-2006: Luiz F. Martha
--    Changed degree of moment of inertia variation from 4th
--    to 6th degree.
--   *Modified on 26-Apr-2009: Francisco Paulo de Aboim
--    Translated code from C to Lua and added function misFixEnd_V.
--
--------------------------------------------------------------------------------
local idp  = require("idp")
module(..., package.seeall);
print("misula module loaded")


--/*==========================mis_J_x0=============================*/
--
--/** This function computes the values of coefficient of x^0 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param J0   - initial moment of inertia value                (in)
-- **
-- ** @return
-- ** Value of coefficient of x^0 in the denominator of the equations
---*\
function mis_J_x0 ( J0 )
  return(J0)
end

--
--/*==========================mis_J_x1=============================*/
--
--/** This function computes the values of coefficient of x^1 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^1 in the denominator of the equations
--
function mis_J_x1 ( len, J0, J1, J2, J3, J4, J5, J6)
  return( (-14.7*J0 + 36.0*J1 - 45.0*J2 + 40.0*J3 - 22.5*J4 +  7.2*J5 -  1.0*J6) / (len) )
end

--/*==========================mis_J_x2=============================*/
--
--/** This function computes the values of coefficient of x^2 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^2 in the denominator of the equations
-- **/
function mis_J_x2 ( len, J0, J1, J2, J3, J4, J5, J6 )
  return( ( 81.2*J0 - 313.2*J1 + 526.5*J2 - 508.0*J3 + 297.0*J4 -  97.2*J5 +  13.7*J6) / (len*len) )
end


--/*==========================mis_J_x3=============================*/
--
--/** This function computes the values of coefficient of x^3 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^3 in the denominator of the equations
-- **/
function mis_J_x3 ( len, J0, J1, J2, J3, J4, J5, J6 )
  return( ( -220.5*J0 + 1044.0*J1 - 2074.5*J2 + 2232.0*J3 - 1381.5*J4 +  468.0*J5 - 67.5*J6) / (len*len*len) )
end

--/*==========================mis_J_x4=============================*/
--
--/** This function computes the values of coefficient of x^4 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^4 in the denominator of the equations
-- **/
function mis_J_x4( len, J0, J1, J2, J3, J4, J5, J6 )
  return( ( 315.0*J0 - 1674.0*J1 + 3699.0*J2 - 4356.0*J3 + 2889.0*J4 - 1026.0*J5 +  153.0*J6) / (len*len*len*len) )
end

--/*==========================mis_J_x5=============================*/
--
--/** This function computes the values of coefficient of x^5 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^5 in the denominator of the equations
-- **/
function mis_J_x5 ( len, J0, J1, J2, J3, J4, J5, J6)
  return( ( -226.8*J0 + 1296.0*J1 - 3078.0*J2 + 3888.0*J3 - 2754.0*J4 + 1036.8*J5 -  162.0*J6) / (len*len*len*len*len) )
end

--/*==========================mis_J_x6=============================*/
--
--/** This function computes the values of coefficient of x^6 in the
-- ** equation of moment of inertia, for a beam element with a cross
-- ** section that has a sixth order polynomial variation.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **
-- ** @return
-- ** Value of coefficient of x^6 in the denominator of the equations
-- **/
function mis_J_x6 ( len, J0, J1, J2, J3, J4, J5, J6)
  return( ( 64.8*J0 - 388.8*J1 + 972.0*J2 - 1296.0*J3 + 972.0*J4 - 388.8*J5 +  64.8*J6) / (len*len*len*len*len*len) )
end


--/*=======================  misSystemMatCoef  ======================*/
--
--/** This function computes the values of matrix coefficients of
-- ** the system of equations of the conjugate beam.  These
-- ** coefficients are common to all the fundamental solutions
-- ** (rotation stiffness coefficients, fix-end moments for linearly
-- ** distributed loads, etc.) that use the conjugate beam anology.
-- **
-- **  @param len - beam element length (span)                      (in)
-- **  @param J0  - initial moment of inertia value                 (in)
-- **  @param J1  - moment of inertia at 1/6 of beam span           (in)
-- **  @param J2  - moment of inertia at 1/3 of beam span           (in)
-- **  @param J3  - moment of inertia at 1/2 of beam span           (in)
-- **  @param J4  - moment of inertia at 2/3 of beam span           (in)
-- **  @param J5  - moment of inertia at 5/6 of beam span           (in)
-- **  @param J6  - final moment of inertia value                   (in)
-- **  @param a, b, c, d - values of the system matrix coefficients (out)
-- **
-- **/
function misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6)

  local num_0 = {} --    /* numerator of integrals of x^0 in func. a */
  local num_1 = {} --    /* numerator of integrals of x^1 in func. a, b, c */
  local num_2 = {} --    /* numerator of integrals of x^2 in func. c and d */
  local den = {}   --    /* denominator polynomial coefficients of all func.*/

  num_0[1] = 0.0
  num_0[2] = 1.0

  num_1[1] = 1.0
  num_1[2] = 1.0
  num_1[3] = 0.0

  num_2[1] = 2.0
  num_2[2] = 1.0
  num_2[3] = 0.0
  num_2[4] = 0.0

  den[1] = 6
  den[2] = mis_J_x6( len, J0, J1, J2, J3, J4, J5, J6 )
  den[3] = mis_J_x5( len, J0, J1, J2, J3, J4, J5, J6 )
  den[4] = mis_J_x4( len, J0, J1, J2, J3, J4, J5, J6 )
  den[5] = mis_J_x3( len, J0, J1, J2, J3, J4, J5, J6 )
  den[6] = mis_J_x2( len, J0, J1, J2, J3, J4, J5, J6 )
  den[7] = mis_J_x1( len, J0, J1, J2, J3, J4, J5, J6 )
  den[8] = mis_J_x0( J0 )

  local i_0 = idp.idpIntegraDivPoli( num_0, den, 0.0, len )
  local i_1 = idp.idpIntegraDivPoli( num_1, den, 0.0, len )
  local i_2 = idp.idpIntegraDivPoli( num_2, den, 0.0, len )

  local a = i_1/len - i_0
  local b = i_1/len
  local c = i_2/len - i_1
  local d = i_2/len

  return a,b,c,d
end

--/*==========================misFixEnd_q_e_x1=============================*/
--
--/** This function computes the values of coefficients of x^1 and x^2 of the
-- ** numerator in the integrals:
-- ** e(x) = Mq/J
-- ** f(x) = Mq*x/J
-- ** for the computation of fix-end moments for linearly distributed load.
-- **
-- **  @param len     - beam element length                         (in)
-- **  @param qa      - initial transversal load value              (in)
-- **  @param qb      - final transversal load value                (in)
-- **
-- ** @return
-- ** Value of coefficient of x^1 in the numerator in the equation e(x) and
-- ** the value of coefficient of x^2 in the numerator in the equation f(x)
-- **/
function misFixEnd_q_e_x1( len, qa, qb )
  return -len*(2*qa+qb)/6.0
end

--/*==========================misFixEnd_q_e_x2=============================*/
--/** This function computes the values of coefficients of x^2 and x^3 of the
-- ** numerator in the integrals:
-- ** e(x) = Mq/J
-- ** f(x) = Mq*x/J
-- ** for the computation of fix-end moments for linearly distributed load.
-- **
-- **  @param qa      - initial transversal load value              (in)
-- **
-- ** @return
-- ** Value of coefficient of x^2 in the numerator in the equation e(x) and
-- ** the value of coefficient of x^3 in the numerator in the equation f(x)
function misFixEnd_q_e_x2( qa )
  return( qa/2.0 )
end

--/*==========================misFixEnd_q_e_x3=============================*/
--/** This function computes the values of coefficients of x^3 and x^4 of the
-- ** numerator in the integrals:
-- ** e(x) = Mq/J
-- ** f(x) = Mq*x/J
-- ** for the computation of fix-end moments for linearly distributed load.
-- **
-- **  @param len     - beam element length                         (in)
-- **  @param qa      - initial transversal load value              (in)
-- **  @param qb      - final transversal load value                (in)
-- **
-- ** @return
-- ** Value of coefficient of x^3 in the numerator in the equation e(x) and
-- ** the value of coefficient of x^4 in the numerator in the equation f(x)
function misFixEnd_q_e_x3( len, qa, qb )
  return( -(qa-qb)/(len*6.0) )
end


--/*=======================  misRotStiffCoef  ======================*/
-- Ma;       /* initial fix-end reaction moments */
-- Mb;       /* final fix-end reaction moments */
-- a;        /* integral of a func. of conjugate beam equil. eqn.*/
-- b;        /* integral of b func. of conjugate beam equil. eqn.*/
-- c;        /* integral of c func. of conjugate beam equil. eqn.*/
-- d;        /* integral of d func. of conjugate beam equil. eqn.*/
-- e;        /* value of e load term of conjugate beam equil.eqn.*/
-- f;        /* value of f load term of conjugate beam equil.eqn.*/
function misRotStiffCoef( len, J0, J1, J2, J3, J4, J5, J6)
  local a,b,c,d = misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6);

  local e = 1.0;
  local f = 0.0;

  local Ma = (b*f - d*e)/(d*a - b*c);
  local Mb = (c*e - f*a)/(d*a - b*c);

  local Ka = Ma;
  local tab = Mb/Ma;

  e = -1.0;
  f = -len;

  Ma = (b*f - d*e)/(d*a - b*c);
  Mb = (c*e - f*a)/(d*a - b*c);

  local Kb = Mb;
  local tba = Ma/Mb;

  return Ka,Kb,tab,tba
end

--/*======================== misFixEnd_q =============================*/
-- a;        /* integral of a func. of conjugate beam equil. eqn.*/
-- b;        /* integral of b func. of conjugate beam equil. eqn.*/
-- c;        /* integral of c func. of conjugate beam equil. eqn.*/
-- d;        /* integral of d func. of conjugate beam equil. eqn.*/
-- e;        /* value of e load term of conjugate beam equil.eqn.*/
-- f;        /* value of f load term of conjugate beam equil.eqn.*/
-- den[8];   /* denominator polynomial coefficients of all func.*/
-- n_e[5];   /* numerator polynomial coefficients of func. e */
-- n_f[6];   /* numerator polynomial coefficients of func. f */

function misFixEnd_q ( len, qa, qb, J0, J1, J2, J3, J4, J5, J6)
  local a,b,c,d = misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6)
  local den = {}
  local n_e = {}
  local n_f = {}

  den[1] = 6
  den[2] = mis_J_x6( len, J0, J1, J2, J3, J4, J5, J6 )
  den[3] = mis_J_x5( len, J0, J1, J2, J3, J4, J5, J6 )
  den[4] = mis_J_x4( len, J0, J1, J2, J3, J4, J5, J6 )
  den[5] = mis_J_x3( len, J0, J1, J2, J3, J4, J5, J6 )
  den[6] = mis_J_x2( len, J0, J1, J2, J3, J4, J5, J6 )
  den[7] = mis_J_x1( len, J0, J1, J2, J3, J4, J5, J6 )
  den[8] = mis_J_x0( J0 )

  n_e[1] = 3
  n_e[2] = misFixEnd_q_e_x3( len, qa, qb )
  n_e[3] = misFixEnd_q_e_x2( qa )
  n_e[4] = misFixEnd_q_e_x1( len, qa, qb )
  n_e[5] = 0.0

  n_f[1] = 4
  n_f[2] = misFixEnd_q_e_x3( len, qa, qb )
  n_f[3] = misFixEnd_q_e_x2( qa )
  n_f[4] = misFixEnd_q_e_x1( len, qa, qb )
  n_f[5] = 0.0
  n_f[6] = 0.0

  e = idp.idpIntegraDivPoli( n_e, den, 0.0, len )
  f = idp.idpIntegraDivPoli( n_f, den, 0.0, len )

  local Ma = (b*f - d*e)/(a*d - b*c)
  local Mb = (c*e - a*f)/(a*d - b*c)
  return Ma,Mb
end


--/* ========================== misFixEnd_V =========================*/
-- qa;       /*    initial linear load              */
-- qb;       /*    final linear load                */
-- Ma;       /*    initial fix-end reaction moments */
-- Mb;       /*    final fix-end reaction moments   */
function misFixEnd_V( len, qa, qb, Ma, Mb )
  local Va, Vb
  Va = ((Ma + Mb)/len) - ((qa * len)/3) - ((qb * len)/6)
  Vb = (-(Ma + Mb)/len) - ((qa * len)/6) - ((qb * len)/3)
  return Va, Vb
end

--/*======================== misFixEnd_temp =============================*/
-- a;        /* integral of a func. of conjugate beam equil. eqn.*/
-- b;        /* integral of b func. of conjugate beam equil. eqn.*/
-- c;        /* integral of c func. of conjugate beam equil. eqn.*/
-- d;        /* integral of d func. of conjugate beam equil. eqn.*/
-- e;        /* value of e load term of conjugate beam equil.eqn.*/
-- f;        /* value of f load term of conjugate beam equil.eqn.*/
-- den[8];   /* denominator polynomial coefficients of all func.*/
-- n_e[5];   /* numerator polynomial coefficients of func. e */
-- n_f[6];   /* numerator polynomial coefficients of func. f */
function misFixEnd_temp ( len, ti, ts, alpha, J0, J1, J2, J3, J4, J5, J6)
  local a,b,c,d = misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6)
  local den = {}
  local n_e = {}
  local n_f = {}
  local coef = {}
  local num = alpha*(ti - ts)

  if tonumber(misula_list.value) == xscPARAB then
    coef[1], coef[2], coef[3] = CoefParab(len)
    den[1] = 2
    den[2] = coef[1]
    den[3] = coef[2]
    den[4] = coef[3]
  elseif tonumber(misula_list.value) == xscLINEAR then
    coef[1], coef[2] = CoefLin(len)
    den[1] = 1
    den[2] = coef[1]
    den[3] = coef[2]
  else
    if not tonumber(data_matrix:getcell(1,1)) then
      d_ini = 0
      data_matrix:setcell(1 , 1, d_ini)
    else
      d_ini = tonumber(data_matrix:getcell(1,1))
    end
    den[1] = 0
    den[2] = d_ini
  end

  n_e[1] = 0
  n_e[2] = num

  n_f[1] = 1
  n_f[2] = num
  n_f[3] = 0

  e = idp.idpIntegraDivPoli( n_e, den, 0.0, len )
  f = idp.idpIntegraDivPoli( n_f, den, 0.0, len )

  local Ma = (b*f - d*e)/(a*d - b*c)
  local Mb = (c*e - a*f)/(a*d - b*c)
  return Ma,Mb
end

--/*======================== misFixEnd_LIQ =============================*/
-- a;        /* integral of a func. of conjugate beam equil. eqn.*/
-- b;        /* integral of b func. of conjugate beam equil. eqn.*/
-- c;        /* integral of c func. of conjugate beam equil. eqn.*/
-- d;        /* integral of d func. of conjugate beam equil. eqn.*/
-- e;        /* value of e load term of conjugate beam equil.eqn.*/
-- f;        /* value of f load term of conjugate beam equil.eqn.*/
function misFixEnd_LIQ ( len, J0, J1, J2, J3, J4, J5, J6)
  local a,b,c,d = misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6)
  local e = 0
  local f = 1

  local Ma = (b*f - d*e)/(a*d - b*c)
  local Mb = (c*e - a*f)/(a*d - b*c)

  return Ma,Mb
end

--/*======================== misFixEnd_LIM =============================*/
-- a;        /* integral of a func. of conjugate beam equil. eqn.*/
-- b;        /* integral of b func. of conjugate beam equil. eqn.*/
-- c;        /* integral of c func. of conjugate beam equil. eqn.*/
-- d;        /* integral of d func. of conjugate beam equil. eqn.*/
-- e;        /* value of e load term of conjugate beam equil.eqn.*/
-- f;        /* value of f load term of conjugate beam equil.eqn.*/
-- x_sec     /* x distance of section for influence line calc.   */
function misFixEnd_LIM ( len, x_sec, J0, J1, J2, J3, J4, J5, J6)
  local a,b,c,d = misSystemMatCoef( len, J0, J1, J2, J3, J4, J5, J6)
  local e = 1
  local f = 1*x_sec

  local Ma = (b*f - d*e)/(a*d - b*c)
  local Mb = (c*e - a*f)/(a*d - b*c)

  return Ma,Mb
end

--/* ======================= misRotation ===================================*/
-- den[8];   /* denominator polynomial coefficients of all func. */
-- num[5];   /* numerator polynomial coefficients of real moment */
function misRotation( xs, len, J0, J1, J2, J3, J4, J5, J6, qa, qb, Ma, Mb )
  local num = {}     -- numerator polynomial coefficients table
  local den = {}     -- denominator polynomial coefficients table
  local integ = nil  --integral of polynomial division of (num/den)

  num[1] = 3
  num[2] = misFixEnd_q_e_x3( len, qa, qb )
  num[3] = misFixEnd_q_e_x2( qa )
  num[4] = misFixEnd_q_e_x1( len, qa, qb ) + ((Ma + Mb)/len)
  num[5] = -Ma


  den[1] = 6
  den[2] = mis_J_x6( len, J0, J1, J2, J3, J4, J5, J6 )
  den[3] = mis_J_x5( len, J0, J1, J2, J3, J4, J5, J6 )
  den[4] = mis_J_x4( len, J0, J1, J2, J3, J4, J5, J6 )
  den[5] = mis_J_x3( len, J0, J1, J2, J3, J4, J5, J6 )
  den[6] = mis_J_x2( len, J0, J1, J2, J3, J4, J5, J6 )
  den[7] = mis_J_x1( len, J0, J1, J2, J3, J4, J5, J6 )
  den[8] = mis_J_x0( J0 )

  integ = idp.idpIntegraDivPoli( num, den, 0, xs )

  return( integ )
end

--/* ======================= misDispl ===================================*/
-- den[8];   /* denominator polynomial coefficients of all func. */
-- num[5];   /* numerator polynomial coefficients of displ. func */

function misDispl( xs, len, J0, J1, J2, J3, J4, J5, J6, qa, qb, Ma, Mb )
  local num = {}     -- numerator polynomial coefficients table
  local den = {}     -- denominator polynomial coefficients table
  local integ = nil  --integral of polynomial division of (num/den)

  num[1] = 4
  num[2] = -misFixEnd_q_e_x3( len, qa, qb )
  num[3] = -misFixEnd_q_e_x2( qa )+ (misFixEnd_q_e_x3( len, qa, qb )*xs)
  num[4] = (-misFixEnd_q_e_x1( len, qa, qb ) - ((Ma + Mb)/len)) + misFixEnd_q_e_x2( qa )*xs
  num[5] = Ma + ((misFixEnd_q_e_x1( len, qa, qb ) + ((Ma + Mb)/len))*xs)
  num[6] = -Ma*xs

  den[1] = 6
  den[2] = mis_J_x6( len, J0, J1, J2, J3, J4, J5, J6 )
  den[3] = mis_J_x5( len, J0, J1, J2, J3, J4, J5, J6 )
  den[4] = mis_J_x4( len, J0, J1, J2, J3, J4, J5, J6 )
  den[5] = mis_J_x3( len, J0, J1, J2, J3, J4, J5, J6 )
  den[6] = mis_J_x2( len, J0, J1, J2, J3, J4, J5, J6 )
  den[7] = mis_J_x1( len, J0, J1, J2, J3, J4, J5, J6 )
  den[8] = mis_J_x0( J0 )

  integ = idp.idpIntegraDivPoli( num, den, 0, xs )

  return( integ )
end

--/* ======================== misLinearInterpDepth ===========================*/
function misLinearInterpDepth( h0, h6)
  local h1 = 5.0*h0/6.0 + 1.0*h6/6.0;
  local h2 = 2.0*h0/3.0 + 1.0*h6/3.0;
  local h3 = 1.0*h0/2.0 + 1.0*h6/2.0;
  local h4 = 1.0*h0/3.0 + 2.0*h6/3.0;
  local h5 = 1.0*h0/6.0 + 5.0*h6/6.0;

  return h1,h2,h3,h4,h5
end

--/* ======================== misParabInterpDepth0 ===========================*/
function misParabInterpDepth0( h0, h6)
  local h1 = (h0-h6)/36.0 + (h6-h0)/3.0 + h0;
  local h2 = (h0-h6)/9.0 + 2.0*(h6-h0)/3.0 + h0;
  local h3 = (h0-h6)/4.0 + h6;
  local h4 = 4.0*(h0-h6)/9.0 + 4.0*(h6-h0)/3.0 + h0;
  local h5 = 25.0*(h0-h6)/36.0 + 10.0*(h6-h0)/6.0 + h0;

  return h1,h2,h3,h4,h5
end

--/* ======================== misParabInterpDepth1 ===========================*/
function misParabInterpDepth1( h0, h6)
  h1 = (h6-h0)/36.0 + h0;
  h2 = (h6-h0)/9.0 + h0;
  h3 = (h6-h0)/4.0 + h0;
  h4 = 4.0*(h6-h0)/9.0 + h0;
  h5 = 25.0*(h6-h0)/36.0 + h0;

  return h1,h2,h3,h4,h5
end

--*************************** End of Module********************************--
