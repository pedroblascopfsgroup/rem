--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-475
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de ATIPICOS 
--##                                  DD_TAT_TIPO_ATIPICO
--##                                  DD_MAT_MOTIVO_ATIPICO
--##                               , esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_TAT IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_TAT IS TABLE OF T_TAT;

   
   TYPE T_MAT IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_MAT IS TABLE OF T_MAT;
   
   
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

--Configuracion  DD_TAT_TIPO_ATIPICO
                                   
   V_TAT T_ARRAY_TAT := T_ARRAY_TAT(
                                    T_TAT('1093','Gastos derivados de la preparación de un expediente.','Gastos derivados de la preparación de un expediente.'),
                                    T_TAT('1094','Saldo deudor impagado de una tarjeta.','Saldo deudor impagado de una tarjeta.'),
                                    T_TAT('1099','Importe ejecutado impagado por el cliente.','Importe ejecutado impagado por el cliente.')
                                   );

--Configuracion  DD_MAT_MOTIVO_ATIPICO                                   
                                   
   V_MAT T_ARRAY_MAT := T_ARRAY_MAT( 
                                    T_MAT('0000', 'SIN INFORMAR PERFIL GESTOR', 'SIN INFORMAR PERFIL GESTOR')
                                   );   
   
   V_TMP_TAT T_TAT;
   V_TMP_MAT T_MAT;      

   
BEGIN


    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_TAT_TIPO_ATIPICO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TAT_TIPO_ATIPICO');       
       
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_MAT_MOTIVO_ATIPICO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_MAT_MOTIVO_ATIPICO');      
    
    
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TAT_TIPO_ATIPICO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TAT_TIPO_ATIPICO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TAT_TIPO_ATIPICO
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
    WHERE sequence_name = 'S_DD_MAT_MOTIVO_ATIPICO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_MAT_MOTIVO_ATIPICO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_MAT_MOTIVO_ATIPICO
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 

 
   DBMS_OUTPUT.PUT_LINE('Creando DD_TAT_TIPO_ATIPICO......');
   FOR I IN V_TAT.FIRST .. V_TAT.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TAT_TIPO_ATIPICO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TAT := V_TAT(I);
      DBMS_OUTPUT.PUT_LINE('Creando TAT: '||V_TMP_TAT(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TAT_TIPO_ATIPICO (DD_TAT_ID, DD_TAT_CODIGO, DD_TAT_DESCRIPCION,' ||
        'DD_TAT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TAT(1)||''','''||SUBSTR(V_TMP_TAT(2),1, 50)||''','''
         ||V_TMP_TAT(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_TAT := NULL;


   DBMS_OUTPUT.PUT_LINE('Creando DD_MAT_MOTIVO_ATIPICO......');
   FOR I IN V_MAT.FIRST .. V_MAT.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_MAT_MOTIVO_ATIPICO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_MAT := V_MAT(I);
      DBMS_OUTPUT.PUT_LINE('Creando MAT: '||V_TMP_MAT(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_MAT_MOTIVO_ATIPICO (DD_MAT_ID, DD_MAT_CODIGO, DD_MAT_DESCRIPCION,' ||
        'DD_MAT_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_MAT(1)||''','''||SUBSTR(V_TMP_MAT(2),1, 50)||''','''
         ||V_TMP_MAT(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_MAT := NULL;


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

