--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150820
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación campos PERSONAS para cajamar
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='PER_PERSONAS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
                 PER_COD_ESTADO_CICLO_VIDA VARCHAR2(50 CHAR)
               , PER_SCORING VARCHAR2(10 CHAR)
               , PER_SERV_NOMINA_PENSION VARCHAR2(1 CHAR)
               , PER_ULTIMA_ACTUACION VARCHAR2(1024 CHAR)
               , PER_SITUACION_CONCURSAL VARCHAR2(1 CHAR)
            )';

  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  MODIFY
            (
                 DD_SCL_ID NUMBER(16, 0) 
              ,  DD_SCE_ID NUMBER(16, 0) 
              ,  PER_REX_FECHA DATE 
              ,  PER_NOM50                VARCHAR2(1200)
              ,  PER_SEXO                 VARCHAR2(4) 
              ,  PER_RIESGO_AUTORIZADO    NUMBER(15,2)
              ,  PER_RIESGO_DISPUESTO     NUMBER(15,2)
              ,  PER_RIESGO_IND           NUMBER(15,2)
              ,  PER_PASIVO_VISTA         NUMBER(15,2)
              ,  PER_PASIVO_PLAZO         NUMBER(15,2)
              ,  PER_INGRESOS_DOMICILIADOS   VARCHAR2(4) 
              ,  PER_VR_OTRAS_ENT            NUMBER(15,2)
              ,  PER_VR_DANIADO_OTRAS_ENT    NUMBER(15,2)
              ,  PER_VOL_FACTURACION         NUMBER(15,2)             
            )';

     
  EXECUTE IMMEDIATE V_MSQL;
  EXECUTE IMMEDIATE V_MSQL2;

DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');

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