create or replace FUNCTION DEVUELVE_TOKEN (CADENA IN VARCHAR2, SEPARADOR IN VARCHAR2, POSICION NUMBER)
RETURN VARCHAR2
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI Haya
--
-- Descripcion: Función que devuelve el tokens de una cadena de la posición indicada teniendo en
--              cuenta el separador indicado
-- ===============================================================================================
IS
  V_CADENA VARCHAR2(4000) := substr(replace(NVL(CADENA, ''), ' ', ''), 1, 4000);
  V_SEPARADOR VARCHAR2(1) := substr(replace(NVL(SEPARADOR, ''), ' ', ''), 1, 1);
  V_POSICION NUMBER := NVL(POSICION, 0);

  V_NUM_TOKENS NUMBER := Contar_Tokens(V_CADENA, V_SEPARADOR);
  
  V_TOKEN VARCHAR2(1000);
  V_POS_TOKEN_INI NUMBER;
  V_POS_TOKEN_FIN NUMBER;
BEGIN
  if V_POSICION = 1 and V_NUM_TOKENS = 1 then
    V_TOKEN := V_CADENA;
  else
    if V_POSICION > 0 and V_POSICION <= V_NUM_TOKENS  and length(V_CADENA) > 0 then
    
      if V_POSICION < V_NUM_TOKENS then
        if V_POSICION = 1 then
          V_POS_TOKEN_INI := 1;
          V_POS_TOKEN_FIN := instr(V_CADENA, V_SEPARADOR, 1, V_POSICION) - 1;
        else
          V_POS_TOKEN_INI := instr(V_CADENA, V_SEPARADOR, 1, V_POSICION - 1) + 1;
          V_POS_TOKEN_FIN := instr(V_CADENA, V_SEPARADOR, 1, V_POSICION) - 1;
        end if;    
      else
        V_POS_TOKEN_INI := instr(V_CADENA, V_SEPARADOR, 1, V_POSICION - 1) + 1;
        V_POS_TOKEN_FIN := length(V_CADENA);
      end if;
      
      V_TOKEN := substr(V_CADENA, V_POS_TOKEN_INI, (V_POS_TOKEN_FIN - V_POS_TOKEN_INI) + 1);
    else
      V_TOKEN := '';
    end if;
  end if;  
  RETURN(V_TOKEN);


END;