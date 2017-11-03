--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3095
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPV_GASTOS_PROVEEDORES -> GPV_GASTOS_PROVEEDOR
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

    TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;          
    V_TEMP_TABLAS  T_TABLAS;
    C_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS(T_TABLAS('REM01','GPV_GASTOS_PROVEEDOR'),
        T_TABLAS('REM01','MIG_AUX_GASTOS_FILTRADOS'));
    V_ESQUEMA VARCHAR2(30 CHAR) := 'REM01';
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';

BEGIN

 DBMS_OUTPUT.PUT_LINE('DESACTIVAMOS RESTRICCIONES CLAVE AJENA' );

 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
 LOOP
    BEGIN
      V_TEMP_TABLAS := C_TABLA(I);
     
      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE IN ('R','C') AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
      LOOP
          BEGIN
                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
          END;    
      END LOOP;    
     
   EXCEPTION WHEN OTHERS THEN
     NULL;
   END;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA' );

 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
 LOOP
    BEGIN
      V_TEMP_TABLAS := C_TABLA(I);
     
      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
      LOOP
          BEGIN
               
                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';        
          END;    
      END LOOP;    
     
   EXCEPTION WHEN OTHERS THEN
     NULL;
   END;
 END LOOP;
DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('INICIO');
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MIG_AUX_GASTOS_FILTRADOS';
    INSERT INTO MIG_AUX_GASTOS_FILTRADOS SELECT GPV_ID, VALIDACION FROM MIG2_GPV_GASTOS_PROVEEDORES WHERE VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MIG_AUX '||SQL%ROWCOUNT);

    REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GPV_GASTOS_PROVEEDOR',1);
    REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','MIG_AUX_GASTOS_FILTRADOS');
    
    INSERT INTO /*+ APPEND */ REM01.GPV_GASTOS_PROVEEDOR
    (GPV_ID, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA, GPV_REF_EMISOR, DD_TGA_ID
        ,DD_STG_ID, GPV_CONCEPTO, DD_TPE_ID, PVE_ID_EMISOR, GPV_FECHA_EMISION, GPV_FECHA_NOTIFICACION, DD_DEG_ID, GPV_CUBRE_SEGURO
        ,GPV_OBSERVACIONES, GPV_COD_GASTO_AGRUPADO, GPV_COD_TIPO_OPERACION, GPV_NUMERO_FACTURA_UVEM, GPV_NUMERO_PROVISION_FONDOS
        ,GPV_NUMERO_PRESUPUESTO, DD_TOG_ID, PVE_ID_GESTORIA, USUARIOCREAR, FECHACREAR, PRG_ID, VERSION, BORRADO)
    SELECT
        REM01.S_GPV_GASTOS_PROVEEDOR.NEXTVAL GPV_ID
        ,MIG2.GPV_ID
        ,MIG2.GPV_COD_GASTO_PROVEEDOR
        ,MIG2.GPV_REFERENCIA_EMISOR
        ,TGA.DD_TGA_ID
        ,STG.DD_STG_ID
        ,MIG2.GPV_CONCEPTO
        ,TPE.DD_TPE_ID
        ,PVE.PVE_ID
        ,MIG2.GPV_FECHA_EMISION
        ,MIG2.GPV_FECHA_NOTIFICACION
        ,(SELECT DEG.DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG WHERE DEG.DD_DEG_CODIGO = '01')
        ,MIG2.GPV_IND_CUBRE_SEGURO
        ,MIG2.GPV_OBSERVACIONES
        ,MIG2.GPV_COD_GASTO_AGRUPADO
        ,MIG2.GPV_COD_TIPO_OPERACION   
        ,MIG2.GPV_NUMERO_FACTURA_UVEM
        ,MIG2.GPV_NUMERO_PROVISION_FONDOS
        ,MIG2.GPV_NUMERO_PRESUPUESTO
        ,TOG.DD_TOG_ID
        ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
        ,'''||V_USUARIO||'''
        ,SYSDATE
        ,(SELECT MIN(PRG.PRG_ID) FROM REM01.PRG_PROVISION_GASTOS PRG WHERE PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS)
        ,0
        ,0
    FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES MIG2
    JOIN REM01.MIG_AUX_GASTOS_FILTRADOS AUX ON AUX.GPV_NUM_GASTO_HAYA = MIG2.GPV_ID AND AUX.VALIDACION = 0
    JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
    JOIN REM01.MIG_AUX_ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
    JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
    JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
    JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
    JOIN REM01.MIG_AUX_GASTOS_FILTRO FIL ON NVL(FIL.DD_TGA_CODIGO,TGA.DD_TGA_CODIGO) = TGA.DD_TGA_CODIGO AND FIL.DD_TPR_CODIGO = TPR.DD_TPR_CODIGO AND NVL(FIL.DD_STG_CODIGO,STG.DD_STG_CODIGO) = STG.DD_STG_CODIGO
    LEFT JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, '01')
    LEFT JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
    WHERE MIG2.VALIDACION = 0 AND FIL.PRIORIDAD = 0;
    DBMS_OUTPUT.PUT_LINE('PRIORIDAD 0 '||SQL%ROWCOUNT);
    
    MERGE INTO REM01.MIG_AUX_GASTOS_FILTRADOS T1
    USING GPV_GASTOS_PROVEEDOR T2
    ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA)
    WHEN MATCHED THEN UPDATE SET
        T1.VALIDACION = 1
    WHERE T1.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MERGE PRIORIDAD 0 '||SQL%ROWCOUNT);
    
    INSERT INTO /*+ APPEND */ REM01.GPV_GASTOS_PROVEEDOR
    (GPV_ID, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA, GPV_REF_EMISOR, DD_TGA_ID
        ,DD_STG_ID, GPV_CONCEPTO, DD_TPE_ID, PVE_ID_EMISOR, GPV_FECHA_EMISION, GPV_FECHA_NOTIFICACION, DD_DEG_ID, GPV_CUBRE_SEGURO
        ,GPV_OBSERVACIONES, GPV_COD_GASTO_AGRUPADO, GPV_COD_TIPO_OPERACION, GPV_NUMERO_FACTURA_UVEM, GPV_NUMERO_PROVISION_FONDOS
        ,GPV_NUMERO_PRESUPUESTO, DD_TOG_ID, PVE_ID_GESTORIA, USUARIOCREAR, FECHACREAR, PRG_ID, VERSION, BORRADO)
    SELECT
        REM01.S_GPV_GASTOS_PROVEEDOR.NEXTVAL GPV_ID
        ,MIG2.GPV_ID
        ,MIG2.GPV_COD_GASTO_PROVEEDOR
        ,MIG2.GPV_REFERENCIA_EMISOR
        ,TGA.DD_TGA_ID
        ,STG.DD_STG_ID
        ,MIG2.GPV_CONCEPTO
        ,TPE.DD_TPE_ID
        ,PVE.PVE_ID
        ,MIG2.GPV_FECHA_EMISION
        ,MIG2.GPV_FECHA_NOTIFICACION
        ,(SELECT DEG.DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG WHERE DEG.DD_DEG_CODIGO = '01')
        ,MIG2.GPV_IND_CUBRE_SEGURO
        ,MIG2.GPV_OBSERVACIONES
        ,MIG2.GPV_COD_GASTO_AGRUPADO
        ,MIG2.GPV_COD_TIPO_OPERACION   
        ,MIG2.GPV_NUMERO_FACTURA_UVEM
        ,MIG2.GPV_NUMERO_PROVISION_FONDOS
        ,MIG2.GPV_NUMERO_PRESUPUESTO
        ,TOG.DD_TOG_ID
        ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
        ,'''||V_USUARIO||'''
        ,SYSDATE
        ,(SELECT MIN(PRG.PRG_ID) FROM REM01.PRG_PROVISION_GASTOS PRG WHERE PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS)
        ,0
        ,0
    FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES MIG2
    JOIN REM01.MIG_AUX_GASTOS_FILTRADOS AUX ON AUX.GPV_NUM_GASTO_HAYA = MIG2.GPV_ID AND AUX.VALIDACION = 0
    JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
    JOIN REM01.MIG_AUX_ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
    JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
    JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
    JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
    JOIN REM01.MIG_AUX_GASTOS_FILTRO FIL ON NVL(FIL.DD_TGA_CODIGO,TGA.DD_TGA_CODIGO) = TGA.DD_TGA_CODIGO AND FIL.DD_TPR_CODIGO = TPR.DD_TPR_CODIGO AND NVL(FIL.DD_STG_CODIGO,STG.DD_STG_CODIGO) = STG.DD_STG_CODIGO
    LEFT JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, '01')
    LEFT JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
    WHERE MIG2.VALIDACION = 0 AND FIL.PRIORIDAD = 1;
    DBMS_OUTPUT.PUT_LINE('PRIORIDAD 1 '||SQL%ROWCOUNT);
    
    MERGE INTO REM01.MIG_AUX_GASTOS_FILTRADOS T1
    USING GPV_GASTOS_PROVEEDOR T2
    ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA)
    WHEN MATCHED THEN UPDATE SET
        T1.VALIDACION = 1
    WHERE T1.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MERGE PRIORIDAD 1 '||SQL%ROWCOUNT);
    
    INSERT INTO /*+ APPEND */ REM01.GPV_GASTOS_PROVEEDOR
    (GPV_ID, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA, GPV_REF_EMISOR, DD_TGA_ID
        ,DD_STG_ID, GPV_CONCEPTO, DD_TPE_ID, PVE_ID_EMISOR, GPV_FECHA_EMISION, GPV_FECHA_NOTIFICACION, DD_DEG_ID, GPV_CUBRE_SEGURO
        ,GPV_OBSERVACIONES, GPV_COD_GASTO_AGRUPADO, GPV_COD_TIPO_OPERACION, GPV_NUMERO_FACTURA_UVEM, GPV_NUMERO_PROVISION_FONDOS
        ,GPV_NUMERO_PRESUPUESTO, DD_TOG_ID, PVE_ID_GESTORIA, USUARIOCREAR, FECHACREAR, PRG_ID, VERSION, BORRADO)
    SELECT
        REM01.S_GPV_GASTOS_PROVEEDOR.NEXTVAL GPV_ID
        ,MIG2.GPV_ID
        ,MIG2.GPV_COD_GASTO_PROVEEDOR
        ,MIG2.GPV_REFERENCIA_EMISOR
        ,TGA.DD_TGA_ID
        ,STG.DD_STG_ID
        ,MIG2.GPV_CONCEPTO
        ,TPE.DD_TPE_ID
        ,PVE.PVE_ID
        ,MIG2.GPV_FECHA_EMISION
        ,MIG2.GPV_FECHA_NOTIFICACION
        ,(SELECT DEG.DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG WHERE DEG.DD_DEG_CODIGO = '01')
        ,MIG2.GPV_IND_CUBRE_SEGURO
        ,MIG2.GPV_OBSERVACIONES
        ,MIG2.GPV_COD_GASTO_AGRUPADO
        ,MIG2.GPV_COD_TIPO_OPERACION   
        ,MIG2.GPV_NUMERO_FACTURA_UVEM
        ,MIG2.GPV_NUMERO_PROVISION_FONDOS
        ,MIG2.GPV_NUMERO_PRESUPUESTO
        ,TOG.DD_TOG_ID
        ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
        ,'''||V_USUARIO||'''
        ,SYSDATE
        ,(SELECT MIN(PRG.PRG_ID) FROM REM01.PRG_PROVISION_GASTOS PRG WHERE PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS)
        ,0
        ,0
    FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES MIG2
    JOIN REM01.MIG_AUX_GASTOS_FILTRADOS AUX ON AUX.GPV_NUM_GASTO_HAYA = MIG2.GPV_ID AND AUX.VALIDACION = 0
    JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
    JOIN REM01.MIG_AUX_ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
    JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
    JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
    JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
    JOIN REM01.MIG_AUX_GASTOS_FILTRO FIL ON NVL(FIL.DD_TGA_CODIGO,TGA.DD_TGA_CODIGO) = TGA.DD_TGA_CODIGO AND FIL.DD_TPR_CODIGO = TPR.DD_TPR_CODIGO AND NVL(FIL.DD_STG_CODIGO,STG.DD_STG_CODIGO) = STG.DD_STG_CODIGO
    LEFT JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, '01')
    LEFT JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
    WHERE MIG2.VALIDACION = 0 AND FIL.PRIORIDAD = 2;
    DBMS_OUTPUT.PUT_LINE('PRIORIDAD 2 '||SQL%ROWCOUNT);
    
    MERGE INTO REM01.MIG_AUX_GASTOS_FILTRADOS T1
    USING GPV_GASTOS_PROVEEDOR T2
    ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA)
    WHEN MATCHED THEN UPDATE SET
        T1.VALIDACION = 1
    WHERE T1.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MERGE PRIORIDAD 2 '||SQL%ROWCOUNT);
    
    COMMIT;
    
    INSERT INTO /*+ APPEND */ REM01.GPV_GASTOS_PROVEEDOR
    (GPV_ID, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA, GPV_REF_EMISOR, DD_TGA_ID
        ,DD_STG_ID, GPV_CONCEPTO, DD_TPE_ID, PVE_ID_EMISOR, GPV_FECHA_EMISION, GPV_FECHA_NOTIFICACION, DD_DEG_ID, GPV_CUBRE_SEGURO
        ,GPV_OBSERVACIONES, GPV_COD_GASTO_AGRUPADO, GPV_COD_TIPO_OPERACION, GPV_NUMERO_FACTURA_UVEM, GPV_NUMERO_PROVISION_FONDOS
        ,GPV_NUMERO_PRESUPUESTO, DD_TOG_ID, PVE_ID_GESTORIA, USUARIOCREAR, FECHACREAR, PRG_ID, VERSION, BORRADO)
    SELECT
        REM01.S_GPV_GASTOS_PROVEEDOR.NEXTVAL GPV_ID
        ,MIG2.GPV_ID
        ,MIG2.GPV_COD_GASTO_PROVEEDOR
        ,MIG2.GPV_REFERENCIA_EMISOR
        ,TGA.DD_TGA_ID
        ,STG.DD_STG_ID
        ,MIG2.GPV_CONCEPTO
        ,TPE.DD_TPE_ID
        ,PVE.PVE_ID
        ,MIG2.GPV_FECHA_EMISION
        ,MIG2.GPV_FECHA_NOTIFICACION
        ,(SELECT DEG.DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG WHERE DEG.DD_DEG_CODIGO = '01')
        ,MIG2.GPV_IND_CUBRE_SEGURO
        ,MIG2.GPV_OBSERVACIONES
        ,MIG2.GPV_COD_GASTO_AGRUPADO
        ,MIG2.GPV_COD_TIPO_OPERACION   
        ,MIG2.GPV_NUMERO_FACTURA_UVEM
        ,MIG2.GPV_NUMERO_PROVISION_FONDOS
        ,MIG2.GPV_NUMERO_PRESUPUESTO
        ,TOG.DD_TOG_ID
        ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
        ,'''||V_USUARIO||'''
        ,SYSDATE
        ,(SELECT MIN(PRG.PRG_ID) FROM REM01.PRG_PROVISION_GASTOS PRG WHERE PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS)
        ,0
        ,0
    FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES MIG2
    JOIN REM01.MIG_AUX_GASTOS_FILTRADOS AUX ON AUX.GPV_NUM_GASTO_HAYA = MIG2.GPV_ID AND AUX.VALIDACION = 0
    JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
    JOIN REM01.MIG_AUX_ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
    JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
    JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
    JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
    JOIN REM01.MIG_AUX_GASTOS_FILTRO FIL ON NVL(FIL.DD_TGA_CODIGO,TGA.DD_TGA_CODIGO) = TGA.DD_TGA_CODIGO AND FIL.DD_TPR_CODIGO = TPR.DD_TPR_CODIGO AND NVL(FIL.DD_STG_CODIGO,STG.DD_STG_CODIGO) = STG.DD_STG_CODIGO
    LEFT JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, '01')
    LEFT JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
    WHERE MIG2.VALIDACION = 0 AND FIL.PRIORIDAD = 3;
    DBMS_OUTPUT.PUT_LINE('PRIORIDAD 3 '||SQL%ROWCOUNT);
    
    MERGE INTO REM01.MIG_AUX_GASTOS_FILTRADOS T1
    USING GPV_GASTOS_PROVEEDOR T2
    ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA)
    WHEN MATCHED THEN UPDATE SET
        T1.VALIDACION = 1
    WHERE T1.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MERGE PRIORIDAD 3 '||SQL%ROWCOUNT);
    
    INSERT INTO /*+ APPEND */ REM01.GPV_GASTOS_PROVEEDOR
    (GPV_ID, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA, GPV_REF_EMISOR, DD_TGA_ID
        ,DD_STG_ID, GPV_CONCEPTO, DD_TPE_ID, PVE_ID_EMISOR, GPV_FECHA_EMISION, GPV_FECHA_NOTIFICACION, DD_DEG_ID, GPV_CUBRE_SEGURO
        ,GPV_OBSERVACIONES, GPV_COD_GASTO_AGRUPADO, GPV_COD_TIPO_OPERACION, GPV_NUMERO_FACTURA_UVEM, GPV_NUMERO_PROVISION_FONDOS
        ,GPV_NUMERO_PRESUPUESTO, DD_TOG_ID, PVE_ID_GESTORIA, USUARIOCREAR, FECHACREAR, PRG_ID, VERSION, BORRADO)
    SELECT
        REM01.S_GPV_GASTOS_PROVEEDOR.NEXTVAL GPV_ID
        ,MIG2.GPV_ID
        ,MIG2.GPV_COD_GASTO_PROVEEDOR
        ,MIG2.GPV_REFERENCIA_EMISOR
        ,TGA.DD_TGA_ID
        ,STG.DD_STG_ID
        ,MIG2.GPV_CONCEPTO
        ,TPE.DD_TPE_ID
        ,PVE.PVE_ID
        ,MIG2.GPV_FECHA_EMISION
        ,MIG2.GPV_FECHA_NOTIFICACION
        ,(SELECT DEG.DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG WHERE DEG.DD_DEG_CODIGO = '01')
        ,MIG2.GPV_IND_CUBRE_SEGURO
        ,MIG2.GPV_OBSERVACIONES
        ,MIG2.GPV_COD_GASTO_AGRUPADO
        ,MIG2.GPV_COD_TIPO_OPERACION   
        ,MIG2.GPV_NUMERO_FACTURA_UVEM
        ,MIG2.GPV_NUMERO_PROVISION_FONDOS
        ,MIG2.GPV_NUMERO_PRESUPUESTO
        ,TOG.DD_TOG_ID
        ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
        ,'''||V_USUARIO||'''
        ,SYSDATE
        ,(SELECT MIN(PRG.PRG_ID) FROM REM01.PRG_PROVISION_GASTOS PRG WHERE PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS)
        ,0
        ,0
    FROM REM01.MIG2_GPV_GASTOS_PROVEEDORES MIG2
    JOIN REM01.MIG_AUX_GASTOS_FILTRADOS AUX ON AUX.GPV_NUM_GASTO_HAYA = MIG2.GPV_ID AND AUX.VALIDACION = 0
    JOIN REM01.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
    JOIN REM01.MIG_AUX_ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
    JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
    JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
    JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID
    JOIN REM01.MIG_AUX_GASTOS_FILTRO FIL ON NVL(FIL.DD_TGA_CODIGO,TGA.DD_TGA_CODIGO) = TGA.DD_TGA_CODIGO AND FIL.DD_TPR_CODIGO = TPR.DD_TPR_CODIGO AND NVL(FIL.DD_STG_CODIGO,STG.DD_STG_CODIGO) = STG.DD_STG_CODIGO
    LEFT JOIN REM01.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, '01')
    LEFT JOIN REM01.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
    WHERE MIG2.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('PRIORIDAD DEFAULT '||SQL%ROWCOUNT);
    
    MERGE INTO REM01.MIG_AUX_GASTOS_FILTRADOS T1
    USING GPV_GASTOS_PROVEEDOR T2
    ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA)
    WHEN MATCHED THEN UPDATE SET
        T1.VALIDACION = 1
    WHERE T1.VALIDACION = 0;
    DBMS_OUTPUT.PUT_LINE('MERGE DEFAULT '||SQL%ROWCOUNT);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FIN');
    DBMS_OUTPUT.PUT_LINE('');
    
 DBMS_OUTPUT.PUT_LINE('ACTIVAMOS RESTRICCIONES CLAVE AJENA' );
 
 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
 LOOP
      V_TEMP_TABLAS := C_TABLA(I);
     
      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE IN('R','C')
                AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
      LOOP
          BEGIN                
                     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                     
       EXCEPTION WHEN OTHERS THEN
             NULL;
       END;
      END LOOP;            
 END LOOP; 

 DBMS_OUTPUT.PUT_LINE('FALTAN ACTIVAR RESTRICCIONES' );

  FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
              FROM SYS.USER_CONSTRAINTS
             WHERE  STATUS='DISABLED')
   LOOP
  BEGIN                
EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
 
  EXCEPTION WHEN OTHERS THEN
  NULL;
  END;
  END LOOP;  

  FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
              FROM SYS.USER_CONSTRAINTS
             WHERE  STATUS='DISABLED')
   LOOP
  BEGIN                
EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;  
  EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('TABLA: '||J.TABLE_NAME||', RESTRICCION: '||J.CONSTRAINT_NAME);
  END;
  END LOOP;

  REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','GPV_GASTOS_PROVEEDOR',1);

EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT