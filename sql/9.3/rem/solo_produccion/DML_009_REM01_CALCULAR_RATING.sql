--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3842
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
		T_JBV(293626),
		T_JBV(290538),
		T_JBV(273985),
		T_JBV(283792),
		T_JBV(285440),
		T_JBV(325918),
		T_JBV(281691),
		T_JBV(286160),
		T_JBV(290235),
		T_JBV(286856),
		T_JBV(281353),
		T_JBV(274530),
		T_JBV(278676),
		T_JBV(281321),
		T_JBV(285600),
		T_JBV(344222),
		T_JBV(328565),
		T_JBV(278579),
		T_JBV(286851),
		T_JBV(280210),
		T_JBV(286438),
		T_JBV(280121),
		T_JBV(281641),
		T_JBV(283107),
		T_JBV(274674)
	); 
	V_TMP_JBV T_JBV;

BEGIN	

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'CALL '||V_ESQUEMA||'.CALCULO_RATING_ACTIVO_AUTO ('||ACT_ID||',''REMVIP-3764'')';
	
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