--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190508
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3764
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
		T_JBV(263197),
		T_JBV(271320),
		T_JBV(275285),
		T_JBV(275725),
		T_JBV(290984),
		T_JBV(290989),
		T_JBV(290991),
		T_JBV(290975),
		T_JBV(290974),
		T_JBV(292170),
		T_JBV(292177),
		T_JBV(292479),
		T_JBV(292468),
		T_JBV(293715),
		T_JBV(293717),
		T_JBV(293716),
		T_JBV(293773),
		T_JBV(294141),
		T_JBV(294246),
		T_JBV(294245),
		T_JBV(333268),
		T_JBV(333275),
		T_JBV(333655),
		T_JBV(333922),
		T_JBV(344596)
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