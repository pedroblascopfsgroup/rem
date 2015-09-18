--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150804
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-452
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de VENCIDOS 
--##                                  DD_MAD_MOTIVO_ALTA_DUDOSO
--##                                  DD_MBD_MOTIVO_BAJA_DUDOSO
--##                                  DD_TVE_TIPO_VENCIDO, esquema CM01.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_MAD IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_MAD IS TABLE OF T_MAD;

   TYPE T_MBD IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_MBD IS TABLE OF T_MBD;
   
   TYPE T_TVE IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_TVE IS TABLE OF T_TVE;
   
   
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
--Configuracion  DD_MAD_MOTIVO_ALTA_DUDOSO
                                   
   V_MAD T_ARRAY_MAD := T_ARRAY_MAD(
                                    T_MAD('001','AVALES EJECUTADOS','AVALES EJECUTADOS'),
                                    T_MAD('002','ARRASTRE /  LITIGIO','ARRASTRE /  LITIGIO'),
                                    T_MAD('003','CONCURSOS','CONCURSOS'),
                                    T_MAD('004','ORDEN MANUAL CLIENTE','ORDEN MANUAL CLIENTE'),
                                    T_MAD('005','ORDEN MANUAL OPERACION','ORDEN MANUAL OPERACION'),
                                    T_MAD('006','POR MOROSIDAD','POR MOROSIDAD'),
                                    T_MAD('007','REFINANCIACIONES','REFINANCIACIONES'),
                                    T_MAD('008','ORDEN AUTAMTICA OPERACIÓN','ORDEN AUTAMTICA OPERACIÓN'),
                                    T_MAD('009','RETROCESION FALLIDO','RETROCESION FALLIDO'),
                                    T_MAD('010','VARIACION DUDOSO','VARIACION DUDOSO')
                                   );

                                   
   V_MBD T_ARRAY_MBD := T_ARRAY_MBD(
                                    T_MBD('000','PAGO CLIENTE','PAGO CLIENTE'),
                                    T_MBD('001','ADJUDICADOS','ADJUDICADOS'),                
                                    T_MBD('002','COMPRAVENTAS/DACIONES','COMPRAVENTAS/DACIONES'),
                                    T_MBD('003','FALLIDOS','FALLIDOS'),   
                                    T_MBD('004','CONCURSOS','CONCURSOS'), 
                                    T_MBD('005','REINSTRUMENTACION','REINSTRUMENTACION'),                             
                                    T_MBD('006','ORDENES OPERACION MANUAL','ORDENES OPERACION MANUAL'),         
                                    T_MBD('007','QUITAS','QUITAS'),                             
                                    T_MBD('008','ORDENES OPERACION AUTOMATICA','ORDENES OPERACION AUTOMATICA')
                                   );    
                                   
                                   
   V_TVE T_ARRAY_TVE := T_ARRAY_TVE( 
                                    T_TVE('0001', 'Vencidos: Operaciones que van entrando en impago en el mes en curso.', 'Vencidos: Operaciones que van entrando en impago en el mes en curso.'),                                   
                                    T_TVE('0002', 'Previo pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 2.', 'Previo pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 2.'),
                                    T_TVE('0003', 'Pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 1.', 'Pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 1.'),
                                    T_TVE('0004', 'Proyectado: Operaciones que entrarán en dudoso en el mes en curso.', 'Proyectado: Operaciones que entrarán en dudoso en el mes en curso.'),
                                    T_TVE('0005', 'Dudosos: Operaciones que ya están en dudoso. Aquí puede darse el caso que una operación esté en dudoso y además, al no ser morosa, pueda estar también en otro de los tramos anteriores.', 'Dudosos: Operaciones que ya están en dudoso. Aquí puede darse el caso que una operación esté en dudoso y además, al no ser morosa, pueda estar también en otro de los tramos anteriores.')                                    
                                   );   
   
   V_TMP_MAD T_MAD;
   V_TMP_MBD T_MBD;
   V_TMP_TVE T_TVE;      

   
BEGIN

    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_MAD_MOTIVO_ALTA_DUDOSO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_MAD_MOTIVO_ALTA_DUDOSO');
       
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_MBD_MOTIVO_BAJA_DUDOSO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_MBD_MOTIVO_BAJA_DUDOSO');        
       
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_TVE_TIPO_VENCIDO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TVE_TIPO_VENCIDO');      
    
    
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_MAD_MOTIVO_ALTA_DUDOSO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_MAD_MOTIVO_ALTA_DUDOSO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_MAD_MOTIVO_ALTA_DUDOSO
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
    WHERE sequence_name = 'S_DD_MBD_MOTIVO_ALTA_DUDOSO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_MBD_MOTIVO_ALTA_DUDOSO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_MBD_MOTIVO_ALTA_DUDOSO
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
    WHERE sequence_name = 'S_DD_TVE_TIPO_VENCIDO' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TVE_TIPO_VENCIDO');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TVE_TIPO_VENCIDO
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    
 
 
   DBMS_OUTPUT.PUT_LINE('Creando DD_MAD_MOTIVO_ALTA_DUDOSO......');
   FOR I IN V_MAD.FIRST .. V_MAD.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_MAD_MOTIVO_ALTA_DUDOSO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_MAD := V_MAD(I);
      DBMS_OUTPUT.PUT_LINE('Creando MAD: '||V_TMP_MAD(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_MAD_MOTIVO_ALTA_DUDOSO (DD_MAD_ID, DD_MAD_CODIGO, DD_MAD_DESCRIPCION,' ||
        'DD_MAD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_MAD(1)||''','''||SUBSTR(V_TMP_MAD(2),1, 50)||''','''
         ||V_TMP_MAD(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_MAD := NULL;



   DBMS_OUTPUT.PUT_LINE('Creando DD_MBD_MOTIVO_ALTA_DUDOSO......');
   FOR I IN V_MBD.FIRST .. V_MBD.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_MBD_MOTIVO_ALTA_DUDOSO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_MBD := V_MBD(I);
      DBMS_OUTPUT.PUT_LINE('Creando MBD: '||V_TMP_MBD(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_MBD_MOTIVO_BAJA_DUDOSO (DD_MBD_ID, DD_MBD_CODIGO, DD_MBD_DESCRIPCION,' ||
        'DD_MBD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_MBD(1)||''','''||SUBSTR(V_TMP_MBD(2),1, 50)||''','''
         ||V_TMP_MBD(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_MBD := NULL;
   
   

   DBMS_OUTPUT.PUT_LINE('Creando DD_TVE_TIPO_VENCIDO......');
   FOR I IN V_TVE.FIRST .. V_TVE.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TVE_TIPO_VENCIDO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TVE := V_TVE(I);
      DBMS_OUTPUT.PUT_LINE('Creando TVE: '||V_TMP_TVE(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TVE_TIPO_VENCIDO (DD_TVE_ID, DD_TVE_CODIGO, DD_TVE_DESCRIPCION,' ||
        'DD_TVE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TVE(1)||''','''||SUBSTR(V_TMP_TVE(2),1, 50)||''','''
         ||V_TMP_TVE(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_TVE := NULL;


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

