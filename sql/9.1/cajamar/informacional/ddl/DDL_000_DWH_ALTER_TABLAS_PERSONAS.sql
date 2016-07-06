--/*
--##########################################
--## AUTOR=MARÍA V.
--## FECHA_CREACION=20160413
--## ARTEFACTO=BATCH
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-2389
--## PRODUCTO=NO
--## 
--## FINALIDAD: SE ELIMINA CAMPO ARQUETIPO_PERSONA_ID EN D_PER
--## INSTRUCCIONES:  CONFIGURAR LAS VARIABLES NECESARIAS EN EL PRINCIPIO DEL DECLARE
--## VERSIONES:
--##        0.1 VERSIÓN INICIAL
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- SENTENCIA A EJECUTAR    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- CONFIGURACION ESQUEMA ESQUEMA_DWH
    V_SQL          VARCHAR2(4000 CHAR); -- VBLE. PARA CONSULTA QUE VALIDA LA EXISTENCIA DE UNA TABLA.
    V_NUM_TABLAS   NUMBER(16); -- VBLE. PARA VALIDAR LA EXISTENCIA DE UNA TABLA.  
    ERR_NUM        NUMBER(25);  -- VBLE. AUXILIAR PARA REGISTRAR ERRORES EN EL SCRIPT.
    ERR_MSG        VARCHAR2(1024 CHAR); -- VBLE. AUXILIAR PARA REGISTRAR ERRORES EN EL SCRIPT.

BEGIN 


   EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.D_PER DROP COLUMN  ARQUETIPO_PERSONA_ID ';



EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(ERR_MSG);
    ROLLBACK;  
    RAISE;   
END; 
/ 
EXIT;
