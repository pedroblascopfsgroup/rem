--/*
--#########################################
--## AUTOR=PIER GOTTA	
--## FECHA_CREACION=20200618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-7567
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir CLC_COD_CLIENTE_PRINEX de la tabla CLC_CLIENTE_COMERCIAL 
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2565';

BEGIN

--BUSCA Y ACTUALIZA DD_TPN_TIPO_INMUEBLE

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso.');
		

		V_SQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL SET
			  CLC_COD_CLIENTE_PRINEX = 1588843,
			  USUARIOMODIFICAR = ''REMVIP-7567'',
			  FECHAMODIFICAR = SYSDATE
			  WHERE CLC_REM_ID = 2006208';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha modificado registros en la registro en la tabla CLC_CLIENTE_COMERCIAL');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL SET
			  CLC_COD_CLIENTE_PRINEX = 1687885,
			  USUARIOMODIFICAR = ''REMVIP-7567'',
			  FECHAMODIFICAR = SYSDATE
			  WHERE CLC_REM_ID = 121668';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha modificado registros en la registro en la tabla CLC_CLIENTE_COMERCIAL');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
