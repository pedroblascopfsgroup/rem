--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5338
--## PRODUCTO=NO
--##
--## Finalidad:  
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-5338';
    
	ACT_NUM_ACTIVO NUMBER(16);
	ACT_RECOVERY_ID NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
		T_JBV(181541, 1000000000279201),
		T_JBV(107032, 1000000000271835)
	); 
	V_TMP_JBV T_JBV;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
		V_TMP_JBV := V_JBV(I);
	
	  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
		ACT_RECOVERY_ID := TRIM(V_TMP_JBV(2));

		V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
					SET ACT_RECOVERY_ID = '||ACT_RECOVERY_ID||'
						,USUARIOMODIFICAR = '''||V_USUARIO||'''
						,FECHAMODIFICAR = SYSDATE
					WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
					';
		EXECUTE IMMEDIATE V_SQL;

	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;
END;
/
EXIT;

