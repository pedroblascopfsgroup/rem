--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4668
--## PRODUCTO=NO
--## 
--## Finalidad: Calcular rating
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    ACT_ID NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(5924914),
		T_JBV(5924929),
		T_JBV(5924933),
		T_JBV(5925021),
		T_JBV(5954934),
		T_JBV(5955845),
		T_JBV(5962787),
		T_JBV(5925039),
		T_JBV(5925046),
		T_JBV(5925063),
		T_JBV(5925064),
		T_JBV(5925071),
		T_JBV(6938934),
		T_JBV(6949797),
		T_JBV(6966391),
		T_JBV(5925097),
		T_JBV(5935532),
		T_JBV(6044700),
		T_JBV(6050178),
		T_JBV(6051243),
		T_JBV(6054562),
		T_JBV(6057592),
		T_JBV(6058343),
		T_JBV(5931843),
		T_JBV(6355382),
		T_JBV(7001601),
		T_JBV(7001600),
		T_JBV(7002702),
		T_JBV(7001562),
		T_JBV(7002672),
		T_JBV(7001546),
		T_JBV(7001538),
		T_JBV(7002258),
		T_JBV(7001460),
		T_JBV(7001362),
		T_JBV(7001271),
		T_JBV(7001194),
		T_JBV(7001979),
		T_JBV(7001956),
		T_JBV(7001193),
		T_JBV(7001934),
		T_JBV(7001186),
		T_JBV(7000953),
		T_JBV(7001799),
		T_JBV(7000817),
		T_JBV(7000760),
		T_JBV(7000759),
		T_JBV(7001678),
		T_JBV(7001605),
		T_JBV(7001604)
	); 
	V_TMP_JBV T_JBV;

BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'CALL '||V_ESQUEMA||'.CALCULO_RATING_ACTIVO_AUTO ('||ACT_ID||',''REMVIP-4668'')';
	
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
