--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150825
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-435
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos en NIV_NIVEL , esquema #ESQUEMA#. P2
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
   seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
   table_count number(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
   err_num NUMBER;
   err_msg VARCHAR2(2048); 
   V_MSQL VARCHAR2(4000 CHAR);
   
   
   TYPE T_NIVEL is table of  VARCHAR2(250);
   TYPE T_ARRAY_NIVEL  IS TABLE OF T_NIVEL;
 
   
	
  
   v_value_count number(3);    	

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   


--############ NIVEL #############
   V_TIPO_POL T_ARRAY_NIVEL := T_ARRAY_NIVEL(  
                          T_NIVEL('0','Banco','Banco'),   
                          T_NIVEL('1','Entidad','Entidad'),
                          T_NIVEL('2','DT','DT'),
                          T_NIVEL('3','Zona','Zona'),
                          T_NIVEL('4','Oficina','Oficina')
                        );
   
   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   v_dummy number(10);
   V_EXIST NUMBER(10); -----

   V_ENTIDAD_ID NUMBER(16);
  

   
   
   V_TMP_NIV T_NIVEL;
   
   
   
BEGIN

    EXECUTE IMMEDIATE('ALTER TABLE ZON_ZONIFICACION DISABLE CONSTRAINTS ZON_ZONIFICACION_IBFK_1');   	    
    DBMS_OUTPUT.PUT_LINE('ALTER TABLE ZON_ZONIFICACION DISABLE CONSTRAINTS ZON_ZONIFICACION_IBFK_1');  

   
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de NIV_NIVEL.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.NIV_NIVEL'); 


    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_NIV_NIVEL' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_NIV_NIVEL');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_NIV_NIVEL
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );        
    
	
   DBMS_OUTPUT.PUT_LINE('Creando NIV_NIVEL......');
   FOR I IN V_TIPO_POL.FIRST .. V_TIPO_POL.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_NIV_NIVEL.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_NIV := V_TIPO_POL(I);
      DBMS_OUTPUT.PUT_LINE('Creando NIV_NIVEL: '||V_TMP_NIV(1)||'V_ENTIDAD_ID='||V_ENTIDAD_ID);   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.NIV_NIVEL (NIV_ID, NIV_CODIGO, NIV_DESCRIPCION,' ||
        'NIV_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_NIV(1)||''','''||SUBSTR(V_TMP_NIV(2),1,50)||''','''
                  ||RTRIM(V_TMP_NIV(3))||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;       
   END LOOP; --LOOP Tipo_producto      
   V_TMP_NIV:=NULL;
   
    -- Ejecutamos el update de NIV_ID en ZON_ZONIFICACION
    EXECUTE IMMEDIATE('UPDATE  '|| V_ESQUEMA ||'.ZON_ZONIFICACION SET NIV_ID = 1');

    COMMIT;
    EXECUTE IMMEDIATE('ALTER TABLE ZON_ZONIFICACION ENABLE CONSTRAINTS ZON_ZONIFICACION_IBFK_1');   	
    DBMS_OUTPUT.PUT_LINE('ALTER TABLE ZON_ZONIFICACION ENABLE CONSTRAINTS ZON_ZONIFICACION_IBFK_1');     
   

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
