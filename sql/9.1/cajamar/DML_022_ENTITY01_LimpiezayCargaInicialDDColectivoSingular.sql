--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150729
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-436
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de PERSONAS Colectivo Singular, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_COS IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_COS IS TABLE OF T_COS;

   
      
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquema Master
   seq_count          NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

--Código del grupo de carga   
--Configuracion  DD_COS_COLECTIVO_SINGULAR
                                   
   V_COS T_ARRAY_COS := T_ARRAY_COS(
                                    T_COS('0000', 'SIN INFORMAR COLECTIVO SINGULAR', 'SIN INFORMAR COLECTIVO SINGULAR')
                                   );
                                   
--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_TMP_COS T_COS;

   
BEGIN

    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_COS_COLECTIVO_SINGULAR.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_COS_COLECTIVO_SINGULAR');
       
        
 
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_COS_COLECTIVO_SINGULAR' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_COS_COLECTIVO_SINGULAR');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_COS_COLECTIVO_SINGULAR
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 


   DBMS_OUTPUT.PUT_LINE('Creando DD_COS_COLECTIVO_SINGULAR......');
   FOR I IN V_COS.FIRST .. V_COS.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_COS_COLECTIVO_SINGULAR.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_COS := V_COS(I);
      DBMS_OUTPUT.PUT_LINE('Creando GRC: '||V_TMP_COS(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_COS_COLECTIVO_SINGULAR (DD_COS_ID, DD_COS_CODIGO, DD_COS_DESCRIPCION,' ||
        'DD_COS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_COS(1)||''','''||SUBSTR(V_TMP_COS(2),1, 50)||''','''
         ||V_TMP_COS(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_COS := NULL;


  

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

