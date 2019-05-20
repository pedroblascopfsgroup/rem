--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=HREOS-2902
--## PRODUCTO=NO
--## 
--## Finalidad: ACT_PTO_PRESUPUESTO
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ACA_CABECERA';

  USUARIO_MIGRACION VARCHAR2(50 CHAR):= '#USUARIO_MIGRACION#';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la insercion de presupuestos para los activos migrados.');

      -------------------------------------------------
      --INSERCION EN ACT_PTO_PRESUPUESTO--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_PTO_PRESUPUESTO');

      
      V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL
              , ACT.ACT_ID
              , EJE.EJE_ID
              , 1000000
              , '''||USUARIO_MIGRACION||'''
              , SYSDATE
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 			MIG  
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO 				ACT ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
        JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 			EJE ON EJE.EJE_ANYO = 2019
        LEFT JOIN '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO 	PTO ON PTO.ACT_ID = ACT.ACT_ID AND PTO.EJE_ID = EJE.EJE_ID AND PTO.BORRADO = 0
        WHERE PTO.PTO_ID IS NULL AND ACT.BORRADO = 0
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;

      EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.GUNSHOTS_MIGAPPLE_PFS (GUNSHOT_COD,GUNSHOT_DML,GUNSHOT_DESC,GUNSHOT_REGISTROS_ACTUALIZADOS,GUNSHOT_TIMESTAMP) VALUES (''GNS018'',''DML_017_REM01_CARGA_ACT_PTO_PRESUPUESTO.sql'',''Para insertar el presupuesto 1000000 de euros en los activos migrados que no tengan presupuesto correpsondiente al ejercicio del 2019.''
      ,'||V_NUM_TABLAS||',SYSDATE)' ;

      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] [GNS018] Se inserta el presupuesto 1000000€ de '||V_NUM_TABLAS||' activos.');  
    
      COMMIT;
    
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
      
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
