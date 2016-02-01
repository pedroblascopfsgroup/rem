--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-448
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Grupos económicos y Grupos Personas, esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_TGL IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TGL IS TABLE OF T_TGL;

   TYPE T_TGE IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TGE IS TABLE OF T_TGE;

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
   

   --/* Configuracion  DD_TGL_TIPO_GRUPO_CLIENTE
--	(
--	  DD_TGL_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_TGL_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_TGL_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_TGL T_ARRAY_TGL := T_ARRAY_TGL(
                            T_TGL('001','GRUPOS DE RIESGOS','GRUPOS DE RIESGOS'),
                            T_TGL('002','GRUPOS DE MIEMBROS DEL CONSEJO RECTOR','GRUPOS DE MIEMBROS DEL CONSEJO RECTOR'),
                            T_TGL('004','CLIENTES DE SEGUIMIENTO ESPECIAL','CLIENTES DE SEGUIMIENTO ESPECIAL'),
                            T_TGL('005','SOCIEDADES PARTICIPADAS','SOCIEDADES PARTICIPADAS'),
                            T_TGL('006','INTERRELACION ECONOMICA','INTERRELACION ECONOMICA'),
                            T_TGL('007','CONSOLIDACION GRUPO DE ENTIDADES FINANCIERAS','CONSOLIDACION GRUPO DE ENTIDADES FINANCIERAS'),
                            T_TGL('008','CONSOLIDACION GRUPO DE RESTO DE PARTICIPACIONES','CONSOLIDACION GRUPO DE RESTO DE PARTICIPACIONES'),
                            T_TGL('009','CONSOLIDACION ASOCIADAS','CONSOLIDACION ASOCIADAS','CONSOLIDACION ASOCIADAS','CONSOLIDACION ASOCIADAS'),
                            T_TGL('010','AREA DE NEGOCIO INMOBILIARIO','AREA DE NEGOCIO INMOBILIARIO','AREA DE NEGOCIO INMOBILIARIO','AREA DE NEGOCIO INMOBILIARIO'),
                            T_TGL('011','POLITICAS RESTRICTIVAS','POLITICAS RESTRICTIVAS')                              
                                   );   
   

--/* Configuracion  DD_TGE_TIPO_RELACION_GRUPO
-- GRUPOS PERSONAS
-- Tipo de relación entre el grupo económico y la persona
--	(
--	  DD_TGE_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_TGE_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_TGE_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_TGE T_ARRAY_TGE := T_ARRAY_TGE(
                                    T_TGE('0000','SIN TIPO GRUPO CLIENTE','SIN TIPO GRUPO CLIENTE')
                                   );

   V_TMP_TGL T_TGL;
   V_TMP_TGE T_TGE;

   BEGIN

    -- Borrado de datos Tipo de grupo
    DBMS_OUTPUT.PUT_LINE('Se borran los datos de DD_TGL_TIPO_GRUPO_CLIENTE.');   
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TGL_TIPO_GRUPO_CLIENTE');

           
    -- Borrado de datos Tipo relación grupo    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TIPO_RELACION_GRUPO.');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TGE_TIPO_RELACION_GRUPO');
   
    
    -- Inicio secuencia
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TGL_TIPO_GRUPO_CLIENTE' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	DBMS_OUTPUT.PUT_LINE('Contador 1');
	EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TGL_TIPO_GRUPO_CLIENTE');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TGL_TIPO_GRUPO_CLIENTE
	START WITH 1
	MAXVALUE 999999999999999999999999999
	MINVALUE 1
	NOCYCLE
	CACHE 20
	NOORDER');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TGE_TIPO_RELACION_GRUPO' and sequence_owner=V_ESQUEMA;
    
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 2');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TGE_TIPO_RELACION_GRUPO');
    end if;
    
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TGE_TIPO_RELACION_GRUPO
                        START WITH 1
                        MAXVALUE 999999999999999999999999999
                        MINVALUE 1
                        NOCYCLE
                        CACHE 20
                        NOORDER'
                      );

   -- Inserción de datos tipo relacion grupo
  DBMS_OUTPUT.PUT_LINE('Creando DD_TGL_TIPO_GRUPO_CLIENTE......');
   FOR I IN V_TGL.FIRST .. V_TGL.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TGL_TIPO_GRUPO_CLIENTE.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TGL := V_TGL(I);
      DBMS_OUTPUT.PUT_LINE('Creando TGL: '||V_TMP_TGL(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TGL_TIPO_GRUPO_CLIENTE (DD_TGL_ID, DD_TGL_CODIGO, DD_TGL_DESCRIPCION,' ||
		'DD_TGL_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TGL(1)||''','''||V_TMP_TGL(2)||''','''
		 ||V_TMP_TGL(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_TGL := NULL;
   
   
   -- Inserción de datos tipo relacion grupo
   DBMS_OUTPUT.PUT_LINE('Creando DD_TGE_TIPO_RELACION_GRUPO......');
   FOR I IN V_TGE.FIRST .. V_TGE.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TGE_TIPO_RELACION_GRUPO.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TGE := V_TGE(I);
      DBMS_OUTPUT.PUT_LINE('Creando TGE: '||V_TMP_TGE(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TGE_TIPO_RELACION_GRUPO (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION,' ||
		'DD_TGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TGE(1)||''','''||V_TMP_TGE(2)||''','''
		 ||V_TMP_TGE(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_TGE := NULL;

   

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
