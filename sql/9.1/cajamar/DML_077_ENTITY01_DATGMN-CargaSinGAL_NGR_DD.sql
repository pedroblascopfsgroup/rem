--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-435
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de Grupo alertas y Grupo Carga Alertas sin especificar en DD Cajamar , esquema CM01. P0
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
   V_TABLA1  VARCHAR(30) := 'GAL_GRUPO_ALERTA';
   V_TABLA2  VARCHAR(30) := 'GRC_GRUPO_CARGA';   
   seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
   table_count number(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
   err_num NUMBER;
   err_msg VARCHAR2(2048); 
   V_MSQL VARCHAR2(4000 CHAR);
   
   
   TYPE T_GRUPO_GAL is table of  VARCHAR2(250);
   TYPE T_ARRAY_GRUPO_GAL  IS TABLE OF T_GRUPO_GAL;
   
   TYPE T_GRUPO_GRC is table of  VARCHAR2(250);
   TYPE T_ARRAY_GRUPO_GRC  IS TABLE OF T_GRUPO_GRC;

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
--############ GRUPO ALERTA #############
   V_GRUPO_GAL T_ARRAY_GRUPO_GAL := T_ARRAY_GRUPO_GAL(
                                                   T_GRUPO_GAL('00000','GRUPO ALERTA NO ESPECIFICADO','GRUPO ALERTA NO ESPECIFICADO')
                                                  );
   
--############ GRUPO CARGA #############
   V_GRUPO_GRC T_ARRAY_GRUPO_GRC := T_ARRAY_GRUPO_GRC(
                                                   T_GRUPO_GRC('00000','GRUPO CARGA NO ESPECIFICADO','GRUPO CARGA NO ESPECIFICADO')
                                                  );
   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   v_dummy number(10);
   V_EXIST NUMBER(10); -----

   V_ENTIDAD_ID NUMBER(16);  
   V_TMP_GAL T_GRUPO_GAL;
   V_TMP_GRC T_GRUPO_GRC;
   
   
   
BEGIN

--Validamos si existe el registro antes de insertarlo
   SELECT COUNT(*) INTO V_EXIST  
   FROM GAL_GRUPO_ALERTA
   WHERE GAL_DESCRIPCION like '%NO ESPECIFICADO%';  
            

            
  IF V_EXIST = 0 THEN   
	
   DBMS_OUTPUT.PUT_LINE('Insertando en GAL_GRUPO_ALERTA .....');
   FOR I IN V_GRUPO_GAL.FIRST .. V_GRUPO_GAL.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GAL_GRUPO_ALERTA.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_GAL := V_GRUPO_GAL(I);
      DBMS_OUTPUT.PUT_LINE('Insertando en GAL_GRUPO_ALERTA: '||V_TMP_GAL(1)||' V_ENTIDAD_ID='||V_ENTIDAD_ID);   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA1||' (GAL_ID, GAL_CODIGO, GAL_DESCRIPCION,' ||
        'GAL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GAL(1)||''','''||SUBSTR(V_TMP_GAL(2),1,50)||''','''
                   ||RTRIM(V_TMP_GAL(3))||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;

   
   END LOOP;       
   V_TMP_GAL:=NULL;

  ELSE   
     DBMS_OUTPUT.PUT_LINE('YA EXISTE EL GRUPO ALERTA NO ESPECIFICADO EN LA TABLA '||V_TABLA1||'');

  END IF;     
   
   
--Validamos si existe el registro antes de insertarlo
   SELECT COUNT(*) INTO V_EXIST  
   FROM GRC_GRUPO_CARGA
   WHERE GRC_DESCRIPCION like '%NO ESPECIFICADO%';  
            

            
  IF V_EXIST = 0 THEN   
	
   DBMS_OUTPUT.PUT_LINE('Insertando en GRC_GRUPO_CARGA .....');
   FOR I IN V_GRUPO_GRC.FIRST .. V_GRUPO_GRC.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_GRC_GRUPO_CARGA.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_GRC := V_GRUPO_GRC(I);
      DBMS_OUTPUT.PUT_LINE('Insertando en GRC_GRUPO_CARGA: '||V_TMP_GRC(1)||' V_ENTIDAD_ID='||V_ENTIDAD_ID);   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA2||' (GRC_ID, GRC_CODIGO, GRC_DESCRIPCION,' ||
        'GRC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GRC(1)||''','''||SUBSTR(V_TMP_GRC(2),1,50)||''','''
                   ||RTRIM(V_TMP_GRC(3))||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   	

   
   END LOOP; 
   V_TMP_GRC:=NULL;

  ELSE   
     DBMS_OUTPUT.PUT_LINE('YA EXISTE EL GRUPO CARGA NO ESPECIFICADO EN LA TABLA '||V_TABLA2||'');

  END IF;        
   

  COMMIT;

 
 
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