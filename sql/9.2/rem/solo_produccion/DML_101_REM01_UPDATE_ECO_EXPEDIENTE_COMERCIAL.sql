--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190306
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3538
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado a expedientes comerciales
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

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_TABLA VARCHAR2(30 CHAR) := ''; -- Variable para tabla de salida para el borrado
  COD_ITEM VARCHAR2(12 CHAR) := 'REMVIP-3538';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización del comité sancionador en expedientes comerciales de Cajamar.');
    DBMS_OUTPUT.PUT_LINE('');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
      	 	SET DD_EEC_ID = ( SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''17''),
                    USUARIOMODIFICAR = '''||COD_ITEM||''', 
		    FECHAMODIFICAR = SYSDATE
		WHERE ECO_ID IN ( 123289, 
				  121849, 
				  121958, 
				  123020, 
				  123070, 
				  123384, 
				  124598, 
				  126761 ) ';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||SQL%ROWCOUNT||' expedientes actualizados correctamente.');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
