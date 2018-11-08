--/*
--#########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20181008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-2463
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar estado civil de un comprador
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
  V_USUARIO VARCHAR2(10 CHAR) := 'REMVIP-2463';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización del estado civil del comprador 97949.');
    DBMS_OUTPUT.PUT_LINE('');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE SET
                DD_ECV_ID = (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES WHERE DD_ECV_CODIGO = ''02''),
                DD_REM_ID = (SELECT DD_REM_ID FROM '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES WHERE DD_REM_CODIGO = ''01''),
                USUARIOMODIFICAR = '''||V_USUARIO||''', 
                FECHAMODIFICAR = SYSDATE
                WHERE
                ECO_ID = (SELECT ECO_ID FROM REM01.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = 127217) 
                AND 
                COM_ID = (SELECT COM_ID FROM REM01.COM_COMPRADOR WHERE COM_DOCUMENTO = ''23231535V'')';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||SQL%ROWCOUNT||' compradores actualizados correctamente.');

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