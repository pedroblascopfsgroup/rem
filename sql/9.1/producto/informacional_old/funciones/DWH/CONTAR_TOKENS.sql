create or replace FUNCTION CONTAR_TOKENS (CADENA IN VARCHAR2, SEPARADOR IN VARCHAR2)
RETURN NUMBER
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Enero 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion:
-- Motivos del cambio:
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Función que devuelve los tokens de una cadena delimitados por un separador
-- ===============================================================================================
IS
  V_CADENA VARCHAR2(4000) := substr(trim(NVL(CADENA, '')), 1, 4000);
  V_SEPARADOR VARCHAR2(1) := substr(trim(NVL(SEPARADOR, '')), 1, 1);
  V_NUM_TOKENS NUMBER := 0;
BEGIN
  V_NUM_TOKENS := NVL(length(V_CADENA), 0) - NVL(length(replace(V_CADENA, V_SEPARADOR, '')), 0) + 1;
  
  if NVL(length(V_CADENA), 0) = 0 then V_NUM_TOKENS := 0; end if;
  
  RETURN(V_NUM_TOKENS);

END;