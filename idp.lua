--------------------------------------------------------------------------------
-- idp.lua  -   Table subdialog module
--------------------------------------------------------------------------------
-- Version: 0.2
-- Created: 20-Jun-2009 - Francisco Paulo de Aboim
-- Original: 25-Oct-2005 - Alexandre Lopes e Luiz F. Martha (idp.c)
--------------------------------------------------------------------------------
module(..., package.seeall);
print("idp module loaded")


-- integraDivPoliLocal: integrate a a division of polinomials using the gaussian
-- quadrature
--------------------------------------------------------------------------------
function integraDivPoliLocal( coefPoliNumerador, coefPoliDenominador, a, b )
  -- abscissas de Gauss considerando xi variando de 0 a 1
  gaussAbscissas = {
    0.069431844202974,
    0.330009478207572,
    0.669990521792428,
    0.930568155797026
  };
  -- pesos de Gauss considerando xi variando de 0 a 1
  gaussPesos = {
    0.173927422568727,
    0.326072577431273,
    0.326072577431273,
    0.173927422568727
  };

  local numPontosGauss = 4;
  local grauNumerador   = coefPoliNumerador[1];
  local grauDenominador = coefPoliDenominador[1];
  -- variavel auxiliar para armazenar o valor do numerador
  local poliNumerador = 0.0
  -- variavel auxiliar para armazenar o valor do denominador
  local poliDenominador = 0.0
  -- variavel auxiliar para armazenar o valor da integral
  local integral = 0.0

  local i,j
  for i = 1, numPontosGauss do
    poliNumerador = 0.0
    poliDenominador = 0.0
    for j = 1, grauNumerador + 1 do
      poliNumerador = (coefPoliNumerador[j+1] *
                       math.pow( a*(1-gaussAbscissas[i]) + b*gaussAbscissas[i], grauNumerador-j ))
                       + poliNumerador
    end


    for j = 1, grauDenominador+1 do
      poliDenominador = (coefPoliDenominador[j+1] *
                         math.pow( a*(1-gaussAbscissas[i]) + b*gaussAbscissas[i], grauDenominador-j ))
                         + poliDenominador
    end
    integral = (b-a) * (poliNumerador/poliDenominador) * gaussPesos[i] + integral
  end
  return integral

end

-- idpIntegraDivPoli: integrate a a division of polinomials using the gaussian
-- quadrature
--------------------------------------------------------------------------------
function idpIntegraDivPoli(coefPoliNumerador, coefPoliDenominador, a, b)
  local integral = 0
  local integralParcial1 = 0
  local integralParcial2 = 0
  local erro = 1e-8;

  integral = integraDivPoliLocal(coefPoliNumerador,
                                 coefPoliDenominador, a , b);
  integralParcial1 = integraDivPoliLocal(coefPoliNumerador,
                                         coefPoliDenominador, a, (a+b)*0.5 );
  integralParcial2 = integraDivPoliLocal(coefPoliNumerador,
                                         coefPoliDenominador,(a+b)*0.5, b );

  if (math.abs( integral - (integralParcial1 + integralParcial2) ) < erro ) then
    return( integral );
  else
    return(
      idpIntegraDivPoli(coefPoliNumerador, coefPoliDenominador, a, (a+b)*0.5 ) +
      idpIntegraDivPoli(coefPoliNumerador, coefPoliDenominador, (a+b)*0.5, b )
    );
  end
end

--***************************** End of Module********************************--
