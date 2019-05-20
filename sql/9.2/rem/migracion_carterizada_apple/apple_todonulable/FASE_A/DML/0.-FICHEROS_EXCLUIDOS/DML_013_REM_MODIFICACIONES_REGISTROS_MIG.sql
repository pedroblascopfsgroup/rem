--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-2821
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  Rellenar el array
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  
  TYPE T_VIC IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_VIC IS TABLE OF T_VIC;
   
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'REM01';   -- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M   VARCHAR2(25 CHAR):= 'REMMASTER';  -- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  TABLE_COUNT number(3);                      -- Vble. para validar la existencia de las Tablas.
  err_num NUMBER;                           -- Numero de errores
  err_msg VARCHAR2(2048);                       -- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_EXIST NUMBER(10);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso. Corregimos ACT_AGR_PRINCIPAL.');

    V_MSQL := '
      UPDATE REM01.MIG_AAG_AGRUPACIONES SET AGR_ACT_PRINCIPAL = NULL WHERE AGR_ACT_PRINCIPAL = 0';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[FIN] Corregimos '||SQL%ROWCOUNT||' filas en MIG_AAG_AGRUPACIONES.');    

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso. Corregimos GESTORES.');

    V_MSQL := '
      UPDATE REM01.MIG2_GEA_GESTORES_ACTIVOS SET GEA_TIPO_GESTOR = ''HAYASBOINM'' WHERE GEA_TIPO_GESTOR = ''SBOINM''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[SBOINM  --> HAYASBOINM] Corregimos '||SQL%ROWCOUNT||' filas en MIG2_GEA_GESTORES_ACTIVOS.');    

    V_MSQL := '
      UPDATE REM01.MIG2_GEA_GESTORES_ACTIVOS SET GEA_TIPO_GESTOR = ''HAYASBOFIN'' WHERE GEA_TIPO_GESTOR = ''SBOFIN''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[SBOFIN  --> HAYASBOFIN] Corregimos '||SQL%ROWCOUNT||' filas en MIG2_GEA_GESTORES_ACTIVOS.');

    V_MSQL := '
      UPDATE REM01.MIG2_GEA_GESTORES_ACTIVOS SET GEA_TIPO_GESTOR = ''HAYAGBOINM'' WHERE GEA_TIPO_GESTOR = ''GCBOINM''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[GCBOINM --> HAYAGBOINM] Corregimos '||SQL%ROWCOUNT||' filas en MIG2_GEA_GESTORES_ACTIVOS.');

    V_MSQL := '
      UPDATE REM01.MIG2_GEA_GESTORES_ACTIVOS SET GEA_TIPO_GESTOR = ''HAYAGBOFIN'' WHERE GEA_TIPO_GESTOR = ''GCBOFIN''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[GCBOFIN --> HAYAGBOFIN] Corregimos '||SQL%ROWCOUNT||' filas en MIG2_GEA_GESTORES_ACTIVOS.'); 
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso.');  

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/
EXIT
