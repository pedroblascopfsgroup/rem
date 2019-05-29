--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4405
--## PRODUCTO=NO
--## 
--## Finalidad: Calcular SP_CAMBIO_ESTADO_PUBLICACIÓN
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ECO_ID NUMBER(16); 
    
    ACT_ID NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
-- ="T_JBV("&COLUMNA&"),"
T_JBV(502),
T_JBV(2774),
T_JBV(410142),
T_JBV(409851),
T_JBV(409850)
	); 
	V_TMP_JBV T_JBV;

BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'CALL '||V_ESQUEMA||'.SP_CAMBIO_ESTADO_PUBLICACION ('||ACT_ID||',1,''REMVIP-4405'')';
	
	EXECUTE IMMEDIATE V_SQL;
	
	END LOOP;
		
	COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;

/
EXIT;