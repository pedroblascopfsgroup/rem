--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-446
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios de Disposiciones de Cajamar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error    
    V_MSQL VARCHAR2(5000);
    V_EXIST NUMBER(10);
    V_ENTIDAD_ID NUMBER(16);    
    

   --Tipo Relación Entre Efecto Y Personas
   TYPE T_DTI IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_DTI IS TABLE OF T_DTI;

   TYPE T_STD IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_STD IS TABLE OF T_STD;

   TYPE T_SDI IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SDI IS TABLE OF T_SDI;

    V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';    
   
   -- Tipo Disposición                                    
   V_DTI T_ARRAY_DTI := T_ARRAY_DTI(
                                    T_DTI('COME','Comercio Exterior','Comercio Exterior')
                                   );
   -- Subtipo de disposición 
   V_STD T_ARRAY_STD := T_ARRAY_STD(
                                    T_STD('0000','Sin subtipo disposición', 'Sin subtipo disposición')
                                   );
   -- Situación disposición                                  
   V_SDI T_ARRAY_SDI := T_ARRAY_SDI(
                                    T_SDI('0','Situacion Normal','Situacion Normal'),
                                    T_SDI('1','Situacion Normal','Situacion Normal'),
                                    T_SDI('2','Vencido/Excedido','Vencido/Excedido'),
                                    T_SDI('3','Dudoso  no vencido','Dudoso  no vencido'),
                                    T_SDI('4','Dudoso vencido','Dudoso vencido'),
                                    T_SDI('5','Moroso 3-6 meses','Moroso 3-6 meses'),
                                    T_SDI('6','Moroso 6-12 meses','Moroso 6-12 meses'),
                                    T_SDI('7','Moroso 12-18 meses','Moroso 12-18 meses'),
                                    T_SDI('8','Moroso 18-21 meses','Moroso 18-21 meses'),
                                    T_SDI('9','Moroso mas 21 meses','Moroso mas 21 meses'),
                                    T_SDI('10','Suspenso','Suspenso')
                                   );


                                    
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/     
   
    V_TMP_STD T_STD;
    V_TMP_SDI T_SDI;
    V_TMP_DTI T_DTI;

 BEGIN

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TIPO DISPOSICION.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_DTI_TIPO_DISPOSICION');

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de SUBTIPO_DISPOSICION.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_DST_SUBTIPO_DISPOSICION');

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de SITUACION_DISPOSICION.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_DSI_SITUACION_DISPOSICION');

    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    V_ENTIDAD_ID:=0;
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_DTI_TIPO_DISPOSICION' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	     DBMS_OUTPUT.PUT_LINE('Contador 1');
       EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_DTI_TIPO_DISPOSICION');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_DTI_TIPO_DISPOSICION
                      START WITH 1
	                    MAXVALUE 999999999999999999999999999
                      MINVALUE 1
	                    NOCYCLE
	                    CACHE 20
	                    NOORDER'
                      );	

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_DST_SUBTIPO_DISPOSICION' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	     DBMS_OUTPUT.PUT_LINE('Contador 2');
	     EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_DST_SUBTIPO_DISPOSICION');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_DST_SUBTIPO_DISPOSICION
                       START WITH 1
	                     MAXVALUE 999999999999999999999999999
	                     MINVALUE 1
	                     NOCYCLE
	                     CACHE 20
	                     NOORDER'
                      );	

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_DSI_SITUACION_DISPOSICION' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	     DBMS_OUTPUT.PUT_LINE('Contador 3');
      EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_DSI_SITUACION_DISPOSICION');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_DSI_SITUACION_DISPOSICION
	                     START WITH 1
	                     MAXVALUE 999999999999999999999999999
                       MINVALUE 1
	                     NOCYCLE
	                     CACHE 20
	                     NOORDER'
                      );


   DBMS_OUTPUT.PUT_LINE('Creando DD_DTI_TIPO_DISPOSICION......');
   
   FOR I IN V_DTI.FIRST .. V_DTI.LAST
   LOOP
     	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_DTI_TIPO_DISPOSICION.NEXTVAL FROM DUAL';
   	  
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
   
      V_TMP_DTI := V_DTI(I);
      DBMS_OUTPUT.PUT_LINE('Creando DTI: '||V_TMP_DTI(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DTI_TIPO_DISPOSICION (DD_DTI_ID, DD_DTI_CODIGO, DD_DTI_DESCRIPCION,' ||
	            	'DD_DTI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_DTI(1)||''','''||V_TMP_DTI(2)||''','''
                ||V_TMP_DTI(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      
      EXECUTE IMMEDIATE V_MSQL;
   
   END LOOP; --LOOP TIPO_DISPOSICION
   
   V_TMP_DTI := NULL;
   DBMS_OUTPUT.PUT_LINE('Creando DD_DST_SUBTIPO_DISPOSICION......');
   
   FOR I IN V_STD.FIRST .. V_STD.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_DST_SUBTIPO_DISPOSICION.NEXTVAL FROM DUAL';
   	  
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      
      V_TMP_STD := V_STD(I);
      DBMS_OUTPUT.PUT_LINE('Creando STD: '||V_TMP_STD(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DST_SUBTIPO_DISPOSICION (DD_DST_ID, DD_DST_CODIGO, DD_DST_DESCRIPCION,' ||
                'DD_DST_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_STD(1)||''','''||V_TMP_STD(2)||''','''
		            ||V_TMP_STD(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      
      EXECUTE IMMEDIATE V_MSQL;
   
   END LOOP; --LOOP SUBTIPO_DISPOSICION
   
   V_TMP_STD := NULL;
   DBMS_OUTPUT.PUT_LINE('Creando DD_DSI_SITUACION_DISPOSICION......');

   FOR I IN V_SDI.FIRST .. V_SDI.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_DSI_SITUACION_DISPOSICION.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_SDI := V_SDI(I);
      DBMS_OUTPUT.PUT_LINE('Creando SDI: '||V_TMP_SDI(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DSI_SITUACION_DISPOSICION (DD_DSI_ID, DD_DSI_CODIGO, DD_DSI_DESCRIPCION,' ||
                'DD_DSI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_SDI(1)||''','''||V_TMP_SDI(2)||''','''
		            ||V_TMP_SDI(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      
      EXECUTE IMMEDIATE V_MSQL;
   
   END LOOP; --LOOP SITUACION_DISPOSICION
   
   V_TMP_SDI := NULL;

   COMMIT;
   



 EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;