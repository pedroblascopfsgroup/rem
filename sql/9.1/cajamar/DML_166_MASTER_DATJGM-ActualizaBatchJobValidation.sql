--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-1071
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tabla BATCH_JOB_VALIDATION
--##                   
--##                               , esquema MASTER. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:0.1
--##        
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 -- BATCH_JOB_VALIDATION
 TYPE T_TPG IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TPG IS TABLE OF T_TPG;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='BATCH_JOB_VALIDATION'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 


BEGIN 

   -- BIECNT Y BIEPER (UPDATE COLUMNAS)
      DBMS_OUTPUT.put_line('ACTUALIZA QUERY DE BIECNT Y BIENPER');
   
      EXECUTE IMMEDIATE('UPDATE '||V_ESQUEMA_M||'.'||TABLA||' 
      SET JOB_VAL_VALUE = ''select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from '||V_ESQUEMA||'.APR_AUX_ABC_BIECNT_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from '||V_ESQUEMA||'.BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN'' 
      WHERE JOB_VAL_CODIGO = ''bie-16.bieCntExtraccionValidator''');

   
      DBMS_OUTPUT.put_line('BIE_CNT ACTUALIZAD0');
   
      EXECUTE IMMEDIATE ('UPDATE '||V_ESQUEMA_M||'.'||TABLA||' 
      SET JOB_VAL_VALUE = ''select TO_CHAR(a.FEMAX, ''''DDMMYYYY'''') AS ERROR_FIELD, TO_CHAR(b.FCMAX, ''''DDMMYYYY'''') AS ENTITY_CODE from (select MAX(FECHA_EXTRACCION) as FEMAX, MIN(FECHA_EXTRACCION) as FEMIN from '||V_ESQUEMA||'.APR_AUX_ABC_BIEPER_CONSOL ) a , (select MAX(FECHACREAR) as FCMAX,  MAX(FECHAMODIFICAR) as FMMAX from '||V_ESQUEMA||'.BIE_BIEN)  b   where a.FEMAX <= b.FCMAX  OR a.FEMAX <= b.FMMAX OR a.FEMAX <> a.FEMIN'' 
      WHERE JOB_VAL_CODIGO = ''bie-16.biePerExtraccionValidator''');
      
      DBMS_OUTPUT.put_line('BIE_PER ACTUALIZAD0');

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
