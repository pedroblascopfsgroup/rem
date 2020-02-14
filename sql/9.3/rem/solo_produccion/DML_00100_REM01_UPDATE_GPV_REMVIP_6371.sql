--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200206
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6371
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado de la lista de gastos
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


	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

BEGIN

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza GPV_GASTOS_PROVEEDOR ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
        	   SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''08'' ),
		       USUARIOMODIFICAR = ''REMVIP-6354'',
	    	       FECHAMODIFICAR   = SYSDATE
		   WHERE GPV_NUM_GASTO_HAYA IN
		  (
''10984763'',
''10984757'',
''10984704'',
''10984745'',
''10984831'',
''10984709'',
''10984905'',
''10984913'',
''10984649'',
''10984824'',
''10984742'',
''10984845'',
''10984807'',
''10984899'',
''10984911'',
''10984904'',
''10984759'',
''10984816'',
''10984753'',
''10984907'',
''10984820'',
''10984912'',
''10984787'',
''10984796'',
''10984793'',
''10984747'',
''10984897'',
''10984903'',
''10984839'',
''10984909'',
''10984785'',
''10984707'',
''10984801'',
''10984780'',
''10984799'',
''10984826'',
''10984829'',
''10984834'',
''10984835'',
''10984791'',
''10984841'',
''10984657'',
''10984900'',
''10984802'',
''10984751'',
''10984908'',
''10984809''

)			
		';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' gasto ');  

	COMMIT;


EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
