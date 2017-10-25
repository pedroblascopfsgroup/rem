--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171019
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3045
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado físico de ciertas tablas
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
  COD_ITEM VARCHAR2(10 CHAR) := 'HREOS-3045';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización del comité sancionador en expedientes comerciales de Cajamar.');
    DBMS_OUTPUT.PUT_LINE('');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1
      USING (SELECT DISTINCT T5.ECO_ID
          FROM '||V_ESQUEMA||'.ACT_ACTIVO T1
          JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA T2 ON T1.DD_CRA_ID = T2.DD_CRA_ID AND T2.DD_CRA_CODIGO = ''01''
          JOIN '||V_ESQUEMA||'.ACT_OFR T3 ON T3.ACT_ID = T1.ACT_ID
          JOIN '||V_ESQUEMA||'.OFR_OFERTAS T4 ON T4.OFR_ID = T3.OFR_ID AND T4.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T5 ON T5.OFR_ID = T4.OFR_ID AND T5.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_COS_COMITES_SANCION T6 ON T6.DD_COS_ID = T5.DD_COS_ID AND T6.BORRADO = 0
          WHERE T1.BORRADO = 0 AND (T6.DD_COS_ID IS NULL OR T6.DD_COS_CODIGO <> ''10'')) T2
      ON (T1.ECO_ID = T2.ECO_ID)
      WHEN MATCHED THEN UPDATE SET
          T1.DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''10'')
          , T1.USUARIOMODIFICAR = '''||COD_ITEM||''', T1.FECHAMODIFICAR = SYSDATE';
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