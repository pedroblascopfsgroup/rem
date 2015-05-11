--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Teresa Alonso
--## Finalidad: DML insertar registros DD_RMO_RESOL_MORATORIA
--##                                   DD_SIT_SITUACION_TITULO
--##                                   DD_EAD_ENTIDAD_ADJUDICA
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

    TYPE T_RMO_RESOL_MORATORIA       IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_RMO_RESOL_MORATORIA IS TABLE OF T_RMO_RESOL_MORATORIA;

    TYPE T_SIT_SITUACION_TITULO       IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_SIT_SITUACION_TITULO IS TABLE OF T_SIT_SITUACION_TITULO;

    TYPE T_EAD_ENTIDAD_ADJUDICA       IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_EAD_ENTIDAD_ADJUDICA IS TABLE OF T_EAD_ENTIDAD_ADJUDICA;

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


--/* Configuracion RMO_RESOL_MORATORIA: DD_RMO_RESOL_MORATORIA
--(
--  DD_RMO_ID,
--  DD_RMO_CODIGO,
--  DD_RMO_DESCRIPCION,
--  DD_RMO_DESCRIPCION_LARGA,
--    )*/

   V_RMO_RESOL_MORATORIA T_ARRAY_RMO_RESOL_MORATORIA := T_ARRAY_RMO_RESOL_MORATORIA(
                                   T_RMO_RESOL_MORATORIA(1,'FAV','FAVORABLE','FAVORABLE'),
                                   T_RMO_RESOL_MORATORIA(2,'DES','DESFAVORABLE','DESFAVORABLE')
                                                                    );

--/* Configuracion SIT_SITUACION_TITULO: DD_SIT_SITUACION_TITULO
--(
--  DD_SIT_ID,
--  DD_SIT_CODIGO,
--  DD_SIT_DESCRIPCION,
--  DD_SIT_DESCRIPCION_LARGA,
--    )*/

   V_SIT_SITUACION_TITULO T_ARRAY_SIT_SITUACION_TITULO := T_ARRAY_SIT_SITUACION_TITULO(
                                   T_SIT_SITUACION_TITULO(1,'INS','INSCRITO','INSCRITO'),
                                   T_SIT_SITUACION_TITULO(2,'PEN','PENDIENTE SUBSANACION','PENDIENTE SUBSANACION')
                                                                    );

--/* Configuracion EAD_ENTIDAD_ADJUDICA: DD_EAD_ENTIDAD_ADJUDICA
--(
--  DD_EAD_ID,
--  DD_EAD_CODIGO,
--  DD_EAD_DESCRIPCION,
--  DD_EAD_DESCRIPCION_LARGA,
--    )*/

   V_EAD_ENTIDAD_ADJUDICA T_ARRAY_EAD_ENTIDAD_ADJUDICA := T_ARRAY_EAD_ENTIDAD_ADJUDICA(
                                   T_EAD_ENTIDAD_ADJUDICA(1,'FON','FONDO','FONDO'),
                                   T_EAD_ENTIDAD_ADJUDICA(2,'BAN','BANKIA','BANKIA'),
                                   T_EAD_ENTIDAD_ADJUDICA(3,'SAR','SAREB','SAREB')
                                                                    );


--## Fin Configuraciones a rellenar 
 
   V_TMP_RMO_RESOL_MORATORIA      T_RMO_RESOL_MORATORIA; 
   V_TMP_SIT_SITUACION_TITULO     T_SIT_SITUACION_TITULO; 
   V_TMP_EAD_ENTIDAD_ADJUDICA     T_EAD_ENTIDAD_ADJUDICA; 



BEGIN	

   -- Se realiza la insercion de datos en DD_RMO_RESOL_MORATORIA  
   DBMS_OUTPUT.PUT_LINE('Actualizando DD_RMO_RESOL_MORATORIA......');
   DBMS_OUTPUT.PUT_LINE('===========================================');

   FOR I IN V_RMO_RESOL_MORATORIA.FIRST .. V_RMO_RESOL_MORATORIA.LAST
   
   LOOP
       V_TMP_RMO_RESOL_MORATORIA := V_RMO_RESOL_MORATORIA(I);
     
         V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA
        WHERE DD_RMO_CODIGO = '''||V_TMP_RMO_RESOL_MORATORIA(2)||'''';
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_REG_COUNT;

	if V_REG_COUNT = 0 then	

           DBMS_OUTPUT.PUT_LINE('Nuevo registro Tipo RMO_RESOL_MORATORIA: '||V_TMP_RMO_RESOL_MORATORIA(1)||' - ' || V_TMP_RMO_RESOL_MORATORIA(2));   

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA (
						DD_RMO_ID,
						DD_RMO_CODIGO,
						DD_RMO_DESCRIPCION,
						DD_RMO_DESCRIPCION_LARGA,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO) '  ||

                   ' VALUES ('||V_TMP_RMO_RESOL_MORATORIA(1)|| ','''||V_TMP_RMO_RESOL_MORATORIA(2)||''',
                           '''||V_TMP_RMO_RESOL_MORATORIA(3)||''','''
                              ||V_TMP_RMO_RESOL_MORATORIA(4)||''','''||V_USUARIO||''',SYSDATE,0)';
           EXECUTE IMMEDIATE V_MSQL;

	else 
 
          DBMS_OUTPUT.PUT_LINE('Dato existente en RMO_RESOL_MORATORIA: '||V_TMP_RMO_RESOL_MORATORIA(1)||' - ' ||V_TMP_RMO_RESOL_MORATORIA(2));    

   	end if;	

   END LOOP; --LOOP RMO_RESOL_MORATORIA
   V_TMP_RMO_RESOL_MORATORIA:= NULL;
   V_RMO_RESOL_MORATORIA:= NULL;
      
   COMMIT;  

   -- Se realiza la insercion de datos en DD_SIT_SITUACION_TITULO  
   DBMS_OUTPUT.PUT_LINE('Actualizando DD_SIT_SITUACION_TITULO......');
   DBMS_OUTPUT.PUT_LINE('===========================================');

   FOR I IN V_SIT_SITUACION_TITULO.FIRST .. V_SIT_SITUACION_TITULO.LAST
   
   LOOP
       V_TMP_SIT_SITUACION_TITULO := V_SIT_SITUACION_TITULO(I);
     
        EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO
        WHERE DD_SIT_CODIGO = '''||V_TMP_SIT_SITUACION_TITULO(2)||'''') INTO V_REG_COUNT;

	if V_REG_COUNT = 0 then	

           DBMS_OUTPUT.PUT_LINE('Nuevo registro Tipo SIT_SITUACION_TITULO: '||V_TMP_SIT_SITUACION_TITULO(1)||' - ' || V_TMP_SIT_SITUACION_TITULO(2));   
	
--           V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_SIT_SITUACION_TITULO.NEXTVAL FROM DUAL';
--           EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO (
						DD_SIT_ID,
						DD_SIT_CODIGO,
						DD_SIT_DESCRIPCION,
						DD_SIT_DESCRIPCION_LARGA,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO) ' || 

                   ' VALUES ('||V_TMP_SIT_SITUACION_TITULO(1)|| ','''||V_TMP_SIT_SITUACION_TITULO(2)||''',
		           '''||V_TMP_SIT_SITUACION_TITULO(3)||''','''||V_TMP_SIT_SITUACION_TITULO(4)||''',
                           '''||V_USUARIO||''',SYSDATE,0)';
           EXECUTE IMMEDIATE V_MSQL;

	else 
 
          DBMS_OUTPUT.PUT_LINE('Dato existente en DD_SIT_SITUACION_TITULO: '||V_TMP_SIT_SITUACION_TITULO(1)||' - ' ||V_TMP_SIT_SITUACION_TITULO(2));    

   	end if;	

   END LOOP; --LOOP SIT_SITUACION_TITULO
   V_TMP_SIT_SITUACION_TITULO:= NULL;
   V_SIT_SITUACION_TITULO:= NULL;
   
      
   COMMIT;  


   -- Se realiza la insercion de datos en DD_EAD_ENTIDAD_ADJUDICA  
   DBMS_OUTPUT.PUT_LINE('Actualizando DD_EAD_ENTIDAD_ADJUDICA......');
   DBMS_OUTPUT.PUT_LINE('===========================================');

   FOR I IN V_EAD_ENTIDAD_ADJUDICA.FIRST .. V_EAD_ENTIDAD_ADJUDICA.LAST
   
   LOOP
       V_TMP_EAD_ENTIDAD_ADJUDICA := V_EAD_ENTIDAD_ADJUDICA(I);
     
        EXECUTE IMMEDIATE('SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA
        WHERE DD_EAD_CODIGO = '''||V_TMP_EAD_ENTIDAD_ADJUDICA(2)||'''') INTO V_REG_COUNT;

	if V_REG_COUNT = 0 then	

           DBMS_OUTPUT.PUT_LINE('Nuevo registro Tipo DD_EAD_ENTIDAD_ADJUDICA: '||V_TMP_EAD_ENTIDAD_ADJUDICA(1)||' - ' || V_TMP_EAD_ENTIDAD_ADJUDICA(2));   

           V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA (
						  DD_EAD_ID,
						  DD_EAD_CODIGO,
						  DD_EAD_DESCRIPCION,
						  DD_EAD_DESCRIPCION_LARGA,
						  USUARIOCREAR,
						  FECHACREAR,
						  BORRADO) '  ||

                   ' VALUES ('||V_TMP_EAD_ENTIDAD_ADJUDICA(1)|| ','''||V_TMP_EAD_ENTIDAD_ADJUDICA(2)||''',
                           '''||V_TMP_EAD_ENTIDAD_ADJUDICA(3)||''','''
                              ||V_TMP_EAD_ENTIDAD_ADJUDICA(4)||''','''||V_USUARIO||''',SYSDATE,0)';
           EXECUTE IMMEDIATE V_MSQL;

	else 
 
          DBMS_OUTPUT.PUT_LINE('Dato existente en DD_EAD_ENTIDAD_ADJUDICA: '||V_TMP_EAD_ENTIDAD_ADJUDICA(1)||' - ' ||V_TMP_EAD_ENTIDAD_ADJUDICA(2));    

   	end if;	

   END LOOP; --LOOP DD_EAD_ENTIDAD_ADJUDICA
   V_TMP_EAD_ENTIDAD_ADJUDICA:= NULL;
   V_EAD_ENTIDAD_ADJUDICA:= NULL;
      
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