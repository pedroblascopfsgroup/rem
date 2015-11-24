--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-474
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de GESTORES 
--##                                  DD_TPG_TIPO_GESTOR
--##                                  PEF_PERFILES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 GMN:> No deshabilitamos la FK FUN_PER_IBFK_2 de FUN_PEF
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_TPG IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_TPG IS TABLE OF T_TPG;

   
   TYPE T_PEF IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_PEF IS TABLE OF T_PEF;
   
   
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
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

--Configuracion  DD_TPG_TIPO_GESTOR
                                   
   V_TPG T_ARRAY_TPG := T_ARRAY_TPG(
                                    T_TPG('0000','SIN INFORMAR TIPO GESTOR','SIN INFORMAR TIPO GESTOR')
                                   );

--Configuracion  PEF_PERFILES                                   
                                   
   V_PEF T_ARRAY_PEF := T_ARRAY_PEF( 
                                      T_PEF('0', 'SIN INFORMAR PERFIL GESTOR', 'SIN INFORMAR PERFIL GESTOR')
--                                    , T_PEF('FPFSRSUPASU', 'Usuario de soporte Sistemas', 'Usuario de soporte Sistemas')
--                                    , T_PEF('FPSOFICINA', 'Usuario con funcion de supervisor', 'Usuario con funcion de supervisor')
--                                    , T_PEF('FPFSADMIN', 'Usuario administrador', 'Usuario administrador')
--                                    , T_PEF('FPFDT', 'Gestor itineario exp. recobro', 'Gestor itineario exp. recobro')
--                                    , T_PEF('FPFSRUSUREC', 'Usuario con acceso a Recovery', 'Usuario con acceso a Recovery')                                                                        
                                   );   
   
   V_TMP_TPG T_TPG;
   V_TMP_PEF T_PEF;      

   
BEGIN


-- Deshabilitamos FKs
   EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS  FK_PER_FK_DD_TPG_ID');
--   EXECUTE IMMEDIATE('ALTER TABLE FUN_PEF      DISABLE CONSTRAINTS  FUN_PER_IBFK_2');
   EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS  FK_PER_PEF_ID');
   EXECUTE IMMEDIATE('ALTER TABLE ZON_PEF_USU  DISABLE CONSTRAINTS  ZON_PER_USU_IBFK3');

    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DD_TPG_TIPO_GESTOR.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TPG_TIPO_GESTOR');       
       
--    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de PEF_PERFILES.');
--    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.PEF_PERFILES');      
    
    
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TPG_TIPO_GESTOR' and sequence_owner=V_ESQUEMA;
   
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TPG_TIPO_GESTOR');
    end if;
   
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TPG_TIPO_GESTOR
                       START WITH 1
                       MAXVALUE 999999999999999999999999999
                       MINVALUE 1
                       NOCYCLE
                       CACHE 20
                       NOORDER'
                      );    

--    V_ENTIDAD_ID:=0;
--    SELECT count(*) INTO V_ENTIDAD_ID
--    FROM all_sequences
--    WHERE sequence_name = 'S_PEF_PERFILES' and sequence_owner=V_ESQUEMA;
--   
--    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
--        DBMS_OUTPUT.PUT_LINE('Contador 1');
--        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_PEF_PERFILES');
--    end if;
--   
--    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_PEF_PERFILES
--                       START WITH 1
--                       MAXVALUE 999999999999999999999999999
--                       MINVALUE 1
--                       NOCYCLE
--                       CACHE 20
--                       NOORDER'
--                      );    
 

 
   DBMS_OUTPUT.PUT_LINE('Creando DD_TPG_TIPO_GESTOR......');
   FOR I IN V_TPG.FIRST .. V_TPG.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TPG_TIPO_GESTOR.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TPG := V_TPG(I);
      DBMS_OUTPUT.PUT_LINE('Creando TPG: '||V_TMP_TPG(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPG_TIPO_GESTOR (DD_TPG_ID, DD_TPG_CODIGO, DD_TPG_DESCRIPCION,' ||
        'DD_TPG_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TPG(1)||''','''||SUBSTR(V_TMP_TPG(2),1, 50)||''','''
         ||V_TMP_TPG(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_TPG := NULL;


--   DBMS_OUTPUT.PUT_LINE('Creando PEF_PERFILES......');
--   FOR I IN V_PEF.FIRST .. V_PEF.LAST
--   LOOP
--       V_MSQL := 'SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL FROM DUAL';
--       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
--      V_TMP_PEF := V_PEF(I);
--      DBMS_OUTPUT.PUT_LINE('Creando PEF: '||V_TMP_PEF(1));   
--
--      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_CODIGO, PEF_DESCRIPCION,' ||
--        'PEF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
--                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_PEF(1)||''','''||SUBSTR(V_TMP_PEF(2),1, 50)||''','''
--         ||V_TMP_PEF(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
--      EXECUTE IMMEDIATE V_MSQL;
--   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
--   V_TMP_PEF := NULL;


   COMMIT;

-- Habilitamos FKs
   EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS ENABLE CONSTRAINTS FK_PER_FK_DD_TPG_ID');
--   EXECUTE IMMEDIATE('ALTER TABLE FUN_PEF      ENABLE CONSTRAINTS FUN_PER_IBFK_2');
   EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS ENABLE CONSTRAINTS FK_PER_PEF_ID');
   EXECUTE IMMEDIATE('ALTER TABLE ZON_PEF_USU  ENABLE CONSTRAINTS ZON_PER_USU_IBFK3');   
   

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
