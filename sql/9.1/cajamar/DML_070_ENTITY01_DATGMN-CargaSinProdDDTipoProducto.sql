--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151002
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-435
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de producto sin especificar en DD TPR Cajamar , esquema CM01. P0
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
 
 --/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#';
   V_TABLA  VARCHAR(30) := 'DD_TPR_TIPO_PROD';
   seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
   table_count number(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
   err_num NUMBER;
   err_msg VARCHAR2(2048); 
   V_MSQL VARCHAR2(4000 CHAR);
   
   
   TYPE T_TIPO_TPR is table of  VARCHAR2(250);
   TYPE T_ARRAY_TIPO_TPR  IS TABLE OF T_TIPO_TPR;

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
--############ TIPO PRODUCTO #############
   V_TIPO_TPR T_ARRAY_TIPO_TPR := T_ARRAY_TIPO_TPR(
                                      							T_TIPO_TPR('00000','PRODUCTO NO ESPECIFICADO','PRODUCTO NO ESPECIFICADO')
                                                  );
   
   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   v_dummy number(10);
   V_EXIST NUMBER(10); -----

   V_ENTIDAD_ID NUMBER(16);  
   V_TMP_TPR T_TIPO_TPR;
   
   
   
BEGIN

   EXECUTE IMMEDIATE('ALTER TABLE dd_tpe_tipo_prod_entidad DISABLE CONSTRAINTS FK_DD_TPE_T_FK_TPE_TP_DD_TPR_T');   	
   DBMS_OUTPUT.PUT_LINE('ALTER TABLE dd_tpe_tipo_prod_entidad DISABLE CONSTRAINTS FK_DD_TPE_T_FK_TPE_TP_DD_TPR_T');  


--Validamos si existe el regidtro antes de insertarlo
   SELECT COUNT(*) INTO V_EXIST  
   FROM DD_TPR_TIPO_PROD
   WHERE  DD_TPR_DESCRIPCION like '%PRODUCTO NO ESPECIFICADO%';  
            

            
  IF V_EXIST = 0 THEN   
	
   DBMS_OUTPUT.PUT_LINE('Insertando en dd_tpr_tipo_prod......');
   FOR I IN V_TIPO_TPR.FIRST .. V_TIPO_TPR.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPR_TIPO_PROD.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TPR := V_TIPO_TPR(I);
      DBMS_OUTPUT.PUT_LINE('Insertando en dd_tpr_tipo_prod: '||V_TMP_TPR(1)||' V_ENTIDAD_ID='||V_ENTIDAD_ID);   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_TPR_ID, DD_TPR_CODIGO, DD_TPR_DESCRIPCION,' ||
        'DD_TPR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TPR(1)||''','''||SUBSTR(V_TMP_TPR(2),1,50)||''','''
                   ||RTRIM(V_TMP_TPR(3))||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
      --COMMIT;
   	

   
   END LOOP; --LOOP Tipo_producto      
   V_TMP_TPR:=NULL;

  ELSE   
     DBMS_OUTPUT.PUT_LINE('YA ESISTE EL TIPO PRODUCTO NO ESPECIFICADO EN LA TABLA '||V_TABLA||'');

  END IF;     
   
   

  COMMIT;

  EXECUTE IMMEDIATE('ALTER TABLE dd_tpe_tipo_prod_entidad ENABLE CONSTRAINTS FK_DD_TPE_T_FK_TPE_TP_DD_TPR_T');   	
  DBMS_OUTPUT.PUT_LINE('HABILITAMOS ALTER TABLE dd_tpe_tipo_prod_entidad ENABLE CONSTRAINTS FK_DD_TPE_T_FK_TPE_TP_DD_TPR_T');  
  
 
  DBMS_OUTPUT.PUT_LINE('INSERT commiteado');
  DBMS_OUTPUT.PUT_LINE('--------------------------------------');  
  
  

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