--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Teresa Alonso
--## Finalidad: DML insertar registros DD_TPC_TIPO_CARGA
--##                                   DD_SIC_SITUACION_CARGA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


-- IMPORTANTE (acentos). Ejecutar antes: 
--    export NLS_LANG=.AL32UTF8
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE

    TYPE T_TPC_TIPO_CARGA       IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TPC_TIPO_CARGA IS TABLE OF T_TPC_TIPO_CARGA;

    TYPE T_SIC_SITUACION_CARGA       IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_SIC_SITUACION_CARGA IS TABLE OF T_SIC_SITUACION_CARGA;


--## Configuraciones a rellenar
    -- Sentencia a ejecutar 
    V_MSQL VARCHAR2(32000 CHAR);  

    -- Configuracion Esquemas
    V_ESQUEMA        VARCHAR2(25 CHAR):= 'BANK01'; 
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; 	

   -- Configuracion Usuario
    V_USUARIO VARCHAR2(10) := 'DGG';

    -- Vble. para consulta registro
    V_REG_COUNT  NUMBER(3);

    -- Vble. para consulta secuencial.
    V_ENTIDAD_ID NUMBER(16);

    -- Vble. auxiliar para registrar errores en el script.
    ERR_NUM NUMBER(25);  

    -- Vble. auxiliar para registrar mensajes de errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); 


--/* Configuracion TPC_TIPO_CARGA: DD_TPC_TIPO_CARGA
--(
--  DD_TPC_ID,
--  DD_TPC_CODIGO,
--  DD_TPC_DESCRIPCION,
--  DD_TPC_DESCRIPCION_LARGA,
--    )*/

   V_TPC_TIPO_CARGA T_ARRAY_TPC_TIPO_CARGA := T_ARRAY_TPC_TIPO_CARGA(
                                   T_TPC_TIPO_CARGA(1,'ANT','ANTERIORES HIPOTECA','ANTERIORES HIPOTECA'),
                                   T_TPC_TIPO_CARGA(2,'POS','POSTERIORES HIPOTECA','POSTERIORES HIPOTECA')
                                                                    );

--/* Configuracion SIC_SITUACION_CARGA: DD_SIC_SITUACION_CARGA
--(
--  DD_SIC_ID,
--  DD_SIC_CODIGO,
--  DD_SIC_DESCRIPCION,
--  DD_SIC_DESCRIPCION_LARGA,
--    )*/

   V_SIC_SITUACION_CARGA T_ARRAY_SIC_SITUACION_CARGA := T_ARRAY_SIC_SITUACION_CARGA(
                                   T_SIC_SITUACION_CARGA(1,'CAN','CANCELADA','CANCELADA'),
                                   T_SIC_SITUACION_CARGA(2,'REC','RECHAZADA','RECHAZADA')
                                                                    );
--## Fin Configuraciones a rellenar 
 
   V_TMP_TPC_TIPO_CARGA      T_TPC_TIPO_CARGA; 
   V_TMP_SIC_SITUACION_CARGA T_SIC_SITUACION_CARGA; 



BEGIN	

   -- Se realiza la insercion de datos en DD_TPC_TIPO_CARGA  
   DBMS_OUTPUT.PUT_LINE('Actualizando DD_TPC_TIPO_CARGA......');
   DBMS_OUTPUT.PUT_LINE('===========================================');

   FOR I IN V_TPC_TIPO_CARGA.FIRST .. V_TPC_TIPO_CARGA.LAST
   
   LOOP
       V_TMP_TPC_TIPO_CARGA := V_TPC_TIPO_CARGA(I);
     
        EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA
        WHERE DD_TPC_CODIGO = '''||V_TMP_TPC_TIPO_CARGA(2)||'''') INTO V_REG_COUNT;

	if V_REG_COUNT = 0 then	

           DBMS_OUTPUT.PUT_LINE('Nuevo registro Tipo TPC_TIPO_CARGA: '||V_TMP_TPC_TIPO_CARGA(1)||' - ' || V_TMP_TPC_TIPO_CARGA(2));   
	
--           V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPC_TIPO_CARGA.NEXTVAL FROM DUAL';
--           EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA (
						DD_TPC_ID,
						DD_TPC_CODIGO,
						DD_TPC_DESCRIPCION,
						DD_TPC_DESCRIPCION_LARGA,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO) '  ||

                   ' VALUES ('||V_TMP_TPC_TIPO_CARGA(1)|| ','''||V_TMP_TPC_TIPO_CARGA(2)||''','''||V_TMP_TPC_TIPO_CARGA(3)||''','''
                              ||V_TMP_TPC_TIPO_CARGA(4)||''','''||V_USUARIO||''',SYSDATE,0)';
           EXECUTE IMMEDIATE V_MSQL;

	else 
 
          DBMS_OUTPUT.PUT_LINE('Dato existente en TPC_TIPO_CARGA: '||V_TMP_TPC_TIPO_CARGA(1)||' - ' ||V_TMP_TPC_TIPO_CARGA(2));    

   	end if;	

   END LOOP; --LOOP TPC_TIPO_CARGA
   V_TMP_TPC_TIPO_CARGA:= NULL;
   V_TPC_TIPO_CARGA:= NULL;
      
   COMMIT;  

   -- Se realiza la insercion de datos en DD_SIC_SITUACION_CARGA  
   DBMS_OUTPUT.PUT_LINE('Actualizando DD_SIC_SITUACION_CARGA......');
   DBMS_OUTPUT.PUT_LINE('===========================================');

   FOR I IN V_SIC_SITUACION_CARGA.FIRST .. V_SIC_SITUACION_CARGA.LAST
   
   LOOP
       V_TMP_SIC_SITUACION_CARGA := V_SIC_SITUACION_CARGA(I);
     
        EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA
        WHERE DD_SIC_CODIGO = '''||V_TMP_SIC_SITUACION_CARGA(2)||'''') INTO V_REG_COUNT;

	if V_REG_COUNT = 0 then	

           DBMS_OUTPUT.PUT_LINE('Nuevo registro Tipo SIC_SITUACION_CARGA: '||V_TMP_SIC_SITUACION_CARGA(1)||' - ' || V_TMP_SIC_SITUACION_CARGA(2));   
	
--           V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_SIC_SITUACION_CARGA.NEXTVAL FROM DUAL';
--           EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA (
						DD_SIC_ID,
						DD_SIC_CODIGO,
						DD_SIC_DESCRIPCION,
						DD_SIC_DESCRIPCION_LARGA,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO) ' || 

                   ' VALUES ('||V_TMP_SIC_SITUACION_CARGA(1)|| ','''||V_TMP_SIC_SITUACION_CARGA(2)||''',
		           '''||V_TMP_SIC_SITUACION_CARGA(3)||''','''||V_TMP_SIC_SITUACION_CARGA(4)||''',
                           '''||V_USUARIO||''',SYSDATE,0)';
           EXECUTE IMMEDIATE V_MSQL;

	else 
 
          DBMS_OUTPUT.PUT_LINE('Dato existente en DD_SIC_SITUACION_CARGA: '||V_TMP_SIC_SITUACION_CARGA(1)||' - ' ||V_TMP_SIC_SITUACION_CARGA(2));    

   	end if;	

   END LOOP; --LOOP SIC_SITUACION_CARGA
   V_TMP_SIC_SITUACION_CARGA:= NULL;
   V_SIC_SITUACION_CARGA:= NULL;
   
      
   COMMIT;  

   DBMS_OUTPUT.PUT_LINE('FIN insertar filas las Tablas en el Esquema: ' || V_ESQUEMA);
   DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

 -- Control de errores
  EXCEPTION  
	WHEN OTHERS THEN
	  
	  err_num := SQLCODE;
	  err_msg := SQLERRM;
	
	  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	  DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	  DBMS_OUTPUT.put_line(err_msg);
	  
	  ROLLBACK;
	  RAISE;
END;
/
EXIT;