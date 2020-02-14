--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6354
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir las nuevas partidas presupuestarias para los gastos de Sareb para este 2019
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
		   WHERE GPV_NUM_GASTO_HAYA = ''11258435'' ';

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
