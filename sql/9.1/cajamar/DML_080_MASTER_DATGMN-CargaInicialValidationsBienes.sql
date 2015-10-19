--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151019
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-532
--## PRODUCTO=NO
--## 
--## Finalidad: Limpieza y carga inicial de tablas validaciones DD_JVI_JOB_VAL_INTERFAZ, y BATCH_JOB_VALIDATION para BIENES, esquema CMMASTER
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  
  -- Configuracion Esquemas
 V_ESQUEMA         VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 V_ESQUEMA_MASTER  VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
 V_TABLA           VARCHAR2(25 CHAR):= 'BATCH_JOB_VALIDATION';
 V_MSQL1           VARCHAR2(4000 CHAR);
 V_MSQL2           VARCHAR2(4000 CHAR); 
 V_EXISTE          NUMBER(10);
 err_num  NUMBER; -- Numero de errores
 err_msg  VARCHAR2(2048); -- Mensaje de error  


BEGIN

  V_MSQL1 := 'SELECT COUNT(*) FROM '||V_ESQUEMA_MASTER||'.'||V_TABLA||'
                             WHERE JOB_VAL_CODIGO = ''bie-16.bieCntExtraccionValidator''';
 
 
  V_MSQL2 := 'UPDATE '||V_ESQUEMA_MASTER||'.'||V_TABLA||'
                  SET JOB_VAL_VALUE =''select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from APR_AUX_ABC_BIECNT_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN''
                  WHERE JOB_VAL_CODIGO = ''bie-16.bieCntExtraccionValidator''';
 
  EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;

  IF V_EXISTE > 0 THEN
     DBMS_OUTPUT.PUT_LINE('Se actualiza la validación "bie-16.bieCntExtraccionValidator" de '||V_TABLA||''); 
     EXECUTE IMMEDIATE V_MSQL2;
    
  ELSE 
     DBMS_OUTPUT.PUT_LINE('No existe la validación "bie-16.bieCntExtraccionValidator" de '||V_TABLA||'');  
  END IF;

 
 
   V_MSQL1 := 'SELECT COUNT(*) FROM '||V_ESQUEMA_MASTER||'.'||V_TABLA||'
                             WHERE JOB_VAL_CODIGO = ''bie-16.biePerExtraccionValidator''';
 
 
   V_MSQL2 := 'UPDATE '||V_ESQUEMA_MASTER||'.'||V_TABLA||'
                  SET JOB_VAL_VALUE =''select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from APR_AUX_ABC_BIEPER_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN''
                  WHERE JOB_VAL_CODIGO = ''bie-16.biePerExtraccionValidator''';
 
  EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;

  IF V_EXISTE > 0 THEN
     DBMS_OUTPUT.PUT_LINE('Se actualiza la validación "bie-16.biePerExtraccionValidator" de '||V_TABLA||''); 
     EXECUTE IMMEDIATE V_MSQL2;
    
  ELSE 
     DBMS_OUTPUT.PUT_LINE('No existe la validación "bie-16.biePerExtraccionValidator" de '||V_TABLA||'');  
  END IF;
 
 

 COMMIT;

EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;
