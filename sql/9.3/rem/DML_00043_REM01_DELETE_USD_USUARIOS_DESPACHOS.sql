--/*
--#########################################
--## AUTOR=Adrián Molina	
--## FECHA_CREACION=20191220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6007
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar de la tabla USD_USUARIOS_DESPACHOS 
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6007';

BEGIN

--BORRAR OFR, VIS Y CLC

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso.');

		V_SQL := 'UPDATE '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS SET 
			  BORRADO = 1,
			  USUARIOBORRAR = ''REMVIP-6007'',
			  FECHABORRAR = SYSDATE
			  WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ejust'')';

		EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado el registro en la tabla CLC_CLIENTE_COMERCIAL');

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
