--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150818
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-435
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios Contratos Cajamar , esquema CM01. P2
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
   V_ESQUEMA VARCHAR(25) := 'CM01';
   V_ESQUEMA_M VARCHAR(25) := 'CMMASTER';
   seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
   table_count number(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
   err_num NUMBER;
   err_msg VARCHAR2(2048); 
   V_MSQL VARCHAR2(4000 CHAR);
   
   
   TYPE T_POLITICAS is table of  VARCHAR2(250);
   TYPE T_ARRAY_POLITICAS  IS TABLE OF T_POLITICAS;
 
   
	
  
   v_value_count number(3);    	

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   


--############ POLITICAS #############
   V_TIPO_POL T_ARRAY_POLITICAS := T_ARRAY_POLITICAS(  
							T_POLITICAS('1','politica favorable','politica favorable'),
                                                        T_POLITICAS('2','politica neutral','politica neutral'),
                                                        T_POLITICAS('3','neutral por no vinculación','neutral por no vinculación'),
                                                        T_POLITICAS('4','Politica restrictiva','Politica restrictiva')
                        );
   
   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   v_dummy number(10);
   V_EXIST NUMBER(10); -----

   V_ENTIDAD_ID NUMBER(16);
  

   
   
   V_TMP_POL T_POLITICAS;
   
   
   
BEGIN


   
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_POL_POLITICAS.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_POL_POLITICAS'); 


    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_POL_POLITICAS' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_POL_POLITICAS');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_POL_POLITICAS
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );        
    
	
   DBMS_OUTPUT.PUT_LINE('Creando DD_POL_POLITICAS......');
   FOR I IN V_TIPO_POL.FIRST .. V_TIPO_POL.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_POL := V_TIPO_POL(I);
      DBMS_OUTPUT.PUT_LINE('Creando DD_POL_POLITICAS: '||V_TMP_POL(1)||'V_ENTIDAD_ID='||V_ENTIDAD_ID);   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION,' ||
        'DD_POL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_POL(1)||''','''||SUBSTR(V_TMP_POL(2),1,50)||''','''
                  ||RTRIM(V_TMP_POL(3))||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
      --COMMIT;
   	

   
   END LOOP; --LOOP Tipo_producto      
   V_TMP_POL:=NULL;
   

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