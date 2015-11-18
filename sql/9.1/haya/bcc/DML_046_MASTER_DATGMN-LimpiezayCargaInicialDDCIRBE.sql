--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20150728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios CIRBE , esquema #ESQUEMA_MASTER#.
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
   V_ESQUEMA          VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_MASTER   VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';   
   seq_count          NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
   table_count        NUMBER(3); -- Vble. para validar la existencia de las Tablas.
   v_column_count     NUMBER(3); -- Vble. para validar la existencia de las Columnas.
   v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
   err_num            NUMBER; -- Numero de errores
   err_msg            VARCHAR2(2048); -- Mensaje de error    
   V_MSQL             VARCHAR2(5000);
   V_EXIST            NUMBER(10);
   V_ENTIDAD_ID       NUMBER(16);    
  
   TYPE T_CRC IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_CRC IS TABLE OF T_CRC;

   TYPE T_TPC IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TPC IS TABLE OF T_TPC;


   TYPE T_DIC IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_DIC IS TABLE OF T_DIC;
   
   TYPE T_GAC IS TABLE OF VARCHAR2(250);
   TYPE T_ARRAY_GAC IS TABLE OF T_GAC;
   
   TYPE T_VCI IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_VCI IS TABLE OF T_VCI;
      
   TYPE T_SIC IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SIC IS TABLE OF T_SIC;

   
   
--/* Configuracion  DD_CRC_CLASE_RIESGO_CIRBE
--    (
--      DD_CRC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--      DD_CRC_DESCRIPCION        VARCHAR2(50 CHAR),
--      DD_CRC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--    )*/
                                   
   V_CRC T_ARRAY_CRC := T_ARRAY_CRC(
                                     T_CRC('0','SIN INFORMAR CLASE RIESGO CIRBE','SIN INFORMAR CLASE RIESGO CIRBE')
                                   --T_CRC('0','CREDITOS UNIPERSONALES','CREDITOS UNIPERSONALES'),
                                   --T_CRC('2','VALORES DE RENTA FIJA','VALORES DE RENTA FIJA'),
                                   --T_CRC('4','CREDITOS SOLIDARIOS','CREDITOS SOLIDARIOS'),
                                   --T_CRC('6','SOCIEDADES COLECTIVAS O A.I.E.','SOCIEDADES COLECTIVAS O A.I.E.')
                                   );

--/* Configuracion  DD_TPC_TIPO_PRODUCTO_CIRBE
--    (
--      DD_TPC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--      DD_TPC_DESCRIPCION        VARCHAR2(50 CHAR),
--      DD_TPC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--    )*/
                                   
   V_TPC T_ARRAY_TPC := T_ARRAY_TPC(
                                     T_TPC('0','SIN INFORMAR TIPO PRODUCTO CIRBE','SIN INFORMAR TIPO PRODUCTO CIRBE'), 
                                     T_TPC('A','Crédito comercial','Crédito comercial'),
                                     T_TPC('B','Crédito financiero','Crédito financiero'),
                                     T_TPC('C','Avales,cauciones y garantías por créditos dinero','Avales, cauciones y garantias ante entidades declarantes por créditos de dinero'),
                                     T_TPC('D','Avales,cauciones y garantías por créditos firma','Avales, cauciones y garantías ante entidades declarantes por créditos de firma'),                                   
                                     T_TPC('E','Resto de avales, cauciones y garantías','Resto de avales, cauciones y garantías'),
                                     T_TPC('F','Creditos documentarios irrevocables','Creditos documentarios irrevocables'),
                                     T_TPC('G','Valores de renta fija','Valores de renta fija'),
                                     T_TPC('H','Riesgo indirecto:aceptantes de efectos','Riesgo indirecot: aceptantes de efectos'),
                                     T_TPC('I','Riesgo indirecto:resto de situaciones','Riesgo indirecto: resto de situaciones'),
                                     T_TPC('J','Productos vencidos no cobrados activos dudosos','Productos vencidos y no cobrados de activos dudosos'),
                                     T_TPC('K','Operaciones de arrendamiento financiero','Operaciones de arrendamiento financiero'),
                                     T_TPC('L','Operaciones sin recurso con inversión','Operaciones sin recurso con inversión'),
                                     T_TPC('M','Factoring sin recurso sin inversión','Factoring sin recurso sin inversión'),
                                     T_TPC('Q','Préstamos o créditos transfer a terceros','Préstamos o créditos transferidos a terceros'),
                                     T_TPC('R','Préstamos de valores','Préstamos de valores'),
                                     T_TPC('S','Adquisición temporal de activos','Adquisición temporal de activos'),
                                     T_TPC('X','Disponible pólizas de riesgo global-multiuso-','Disponible en pólizas de riesgo global -multiuso-')
                                   );
                                   
--/* Configuracion  DD_DIC_DIVISA_CIRBE
--	(
--	  DD_DIC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_DIC_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_DIC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_DIC T_ARRAY_DIC := T_ARRAY_DIC(
                                     T_DIC('0','SIN INFORMAR DIVISA CIRBE','SIN INFORMAR DIVISA CIRBE'),   
                                     T_DIC('A','Peseta(desaparecida)','Peseta(desaparecida)'),
                                     T_DIC('B','Dólar USA','Dólar USA'),
                                     T_DIC('C','Dólar canadiense','Dólar canadiense'),
                                     T_DIC('D','Franco francés(desaparecido)','Franco francés(desaparecido)'),
                                     T_DIC('E','Libra esterlina','Libra esterlina'),
                                     T_DIC('F','Libra irlandesa(desaparecida)','Libra irlandesa(desaparecida)'),
                                     T_DIC('G','Franco suizo','Franco suizo'),
                                     T_DIC('H','Franco belga(desaparecido)','Franco belga(desaparecido)'),
                                     T_DIC('I','Marco alemán(desaparecido)','Marco alemán(desaparecido)'),
                                     T_DIC('J','Lira italiana(desaparecida)','Lira italiana(desaparecida)'),
                                     T_DIC('K','Florín(desaparecido)','Florín(desaparecido)'),
                                     T_DIC('L','Corona sueca','Corona sueca'),
                                     T_DIC('M','Corona danesa','Corona danesa'),
                                     T_DIC('N','Corona noruega','Corona noruega'),
                                     T_DIC('O','Marco finlandés(desaparecido)','Marco finlandés(desaparecido)'),
                                     T_DIC('P','Chelín austriaco(desaparecido)','Chelín austriaco(desaparecido)'),
                                     T_DIC('Q','Escudo portugués(desaparecido)','Escudo portugués(desaparecido)'),
                                     T_DIC('R','Yen japonés','Yen japonés'),
                                     T_DIC('S','Euro','Euro'),
                                     T_DIC('T','Otras','Otras')
                                   );  
                                                                    
--/* Configuracion  DD_VCI_VENCIMIENTO_CIRBE
--	(
--	  DD_VCI_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_VCI_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_VCI_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_VCI T_ARRAY_VCI := T_ARRAY_VCI(
                                     T_VCI('0','SIN INFORMAR VENCIMIENTO CIRBE','SIN INFORMAR VENCIMIENTO CIRBE'), 
                                     T_VCI('A','Vencimiento medio a la vista y hasta 3 meses','Vencimiento medio a la vista y hasta 3 meses'),
                                     T_VCI('B','Vencimiento medio más de 3 meses y hasta 1 año','Vencimiento medio más de 3 meses y hasta 1 año'),
                                     T_VCI('C','Vencimiento medio más de 1 año y hasta 3 años','Vencimiento medio más de 1 año y hasta 3 años'),
                                     T_VCI('D','Vencimiento medio más de 3 años y hasta 5 años','Vencimiento medio más de 3 años y hasta 5 años'),
                                     T_VCI('E','Vencimiento medio más de 5 años','Vencimiento medio más de 5 años'),
                                     T_VCI('M','Vencimiento indeterminado','Vencimiento indeterminado')
                                   );
                                   
--/* Configuracion  DD_GAC_GARANTIA_CIRBE
--	(
--	  DD_GAC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_GAC_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_GAC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_GAC T_ARRAY_GAC := T_ARRAY_GAC(
                                     T_GAC('0',' SIN INFORMAR GARANTIA CIRBE','SIN INFORMAR GARANTIA CIRBE'),
                                     T_GAC('A','Garantía real 100% efectos públicos,depósitos','Garantía real al 100 % representada por efectos públicos, depósitos dinerarios, hipotecas inmobiliarias o navales, valores mobiliarios de cotización calificada y mercancías, o resguardos de depósito de las mismas'),
                                     T_GAC('B','Garantías reales al 100% distintas anteriores','Garantías reales al 100% distintas de las anteriores'),
                                     T_GAC('C','Garantias reales parciales > 50% por A y B','Garantías reales parciales mayores del 50 % por cualquiera de los conceptos incluidos en A y B anteriores'),
                                     T_GAC('D','Garantías del sector público','Garantías del sector público(tal como se define en las Circulares contables'),
                                     T_GAC('E','Garantías CESCE','Garantías CESCE'),
                                     T_GAC('F','Garantía de entidad declarante a la CIR','Garantía de entidad declarante a la CIR'),
                                     T_GAC('H','Garantía de entidad de crédito no residente','Garantía de entidad de crédito no residente'),
                                     T_GAC('V','Resto de situaciones no contempladas','Resto de situaciones no contempladas')
                                  );                                              
                                   
                                   
-- /* Configuracion  DD_SIC_SITUACION_CIRBE
--	(
--	  DD_SIC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_SIC_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_SIC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_SIC T_ARRAY_SIC := T_ARRAY_SIC(
                                   T_SIC('0','SIN INFORMAR SITUACION CIRBE','SIN INFORMAR SITUACION CIRBE'),
                                   T_SIC('1','Normal/Dudoso (clave 5ª = A,B,C,D,K)','Normal/Dudoso (clave 5ª = ,B,C,D,K)'),
                                   T_SIC('2','Moroso (clave 5ª = E,F,G,H,I)','Moroso (clave 5ª = E,F,G,H,I)'),
                                   T_SIC('3','Suspenso (clave 5ª = J)','Suspenso (clave 5ª = J)')
                                 --  T_SIC('4','Convenio de Acreedores (clave 5ª = L)','Convenio de Acreedores (clave 5ª = L)')
                                   );     
                                   
                                              

--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   

   V_TMP_TPC T_TPC;
   V_TMP_DIC T_DIC;
   V_TMP_CRC T_CRC;
   V_TMP_SIC T_SIC;
   V_TMP_GAC T_GAC;
   V_TMP_VCI T_VCI;
   
BEGIN
    if V_ESQUEMA_MASTER not like '%TER' then
        DBMS_OUTPUT.PUT_LINE('ATENCION, debe ejecutarse en #ESQUEMA_MASTER#');
    end if;

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de CLASE_RIESGO_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_CRC_CLASE_RIESGO_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_CRC_CLASE_RIESGO_CIRBE');

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TIPO_PRODUCTO_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_TPC_TIPO_PRODUCTO_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_COC_COD_OPERAC_CIRBE');
    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de DIVISA_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_DIC_DIVISA_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_DIC_DIVISA_CIRBE');

    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de VENCIMIENTO_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_VCI_VENCIMIENTO_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_VCI_VENCIMIENTO_CIRBE');
    
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de GARANTIA_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_GAC_GARANTIA_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_GAC_GARANTIA_CIRBE');
     
    DBMS_OUTPUT.PUT_LINE('Se borra la configuración de SITUACION_CIRBE.');
    --EXECUTE IMMEDIATE('TRUNCATE TABLE '|| V_ESQUEMA_MASTER ||'.DD_SIC_SITUACION_CIRBE');
    EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA_MASTER ||'.DD_SIC_SITUACION_CIRBE');
 
    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_CRC_CLASE_RIESGO_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 1');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_CRC_CLASE_RIESGO_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_CRC_CLASE_RIESGO_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TPC_TIPO_PRODUCTO_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 2');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_TPC_TIPO_PRODUCTO_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_TPC_TIPO_PRODUCTO_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_DIC_DIVISA_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 3');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_DIC_DIVISA_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_DIC_DIVISA_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    
    
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_VCI_VENCIMIENTO_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 4');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_VCI_VENCIMIENTO_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_VCI_VENCIMIENTO_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_GAC_GARANTIA_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 5');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_GAC_GARANTIA_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_GAC_GARANTIA_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_SIC_SITUACION_CIRBE' and sequence_owner=V_ESQUEMA_MASTER;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
        DBMS_OUTPUT.PUT_LINE('Contador 6');
        EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_SIC_SITUACION_CIRBE');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_MASTER || '.S_DD_SIC_SITUACION_CIRBE
    START WITH 1
    MAXVALUE 999999999999999999999999999
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER');    

   DBMS_OUTPUT.PUT_LINE('Creando DD_CRC_CLASE_RIESGO_CIRBE......');
   FOR I IN V_CRC.FIRST .. V_CRC.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_CRC_CLASE_RIESGO_CIRBE.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_CRC := V_CRC(I);
      DBMS_OUTPUT.PUT_LINE('Creando CRC: '||V_TMP_CRC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_CRC_CLASE_RIESGO_CIRBE (DD_CRC_ID, DD_CRC_CODIGO, DD_CRC_DESCRIPCION,' ||
        'DD_CRC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_CRC(1)||''','''||V_TMP_CRC(2)||''','''
         ||V_TMP_CRC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_CLIENTE
   V_TMP_CRC := NULL;

   DBMS_OUTPUT.PUT_LINE('Creando DD_COC_COD_OPERAC_CIRBE......');
   FOR I IN V_TPC.FIRST .. V_TPC.LAST
   LOOP
       V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_TPC_TIPO_PRODUCTO_CIRBE.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TPC := V_TPC(I);
      DBMS_OUTPUT.PUT_LINE('Creando TPC: '||V_TMP_TPC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_COC_COD_OPERAC_CIRBE (DD_COC_ID, DD_COC_CODIGO, DD_COC_DESCRIPCION,' ||
        'DD_COC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TPC(1)||''','''||V_TMP_TPC(2)||''','''
         ||V_TMP_TPC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; 
   V_TMP_TPC := NULL;
   
  DBMS_OUTPUT.PUT_LINE('Creando DD_DIC_DIVISA_CIRBE......');
   FOR I IN V_DIC.FIRST .. V_DIC.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_DIC_DIVISA_CIRBE.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_DIC := V_DIC(I);
      DBMS_OUTPUT.PUT_LINE('Creando DIC: '||V_TMP_DIC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_DIC_DIVISA_CIRBE (DD_DIC_ID, DD_DIC_CODIGO, DD_DIC_DESCRIPCION,' ||
		'DD_DIC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_DIC(1)||''','''||V_TMP_DIC(2)||''','''
		 ||V_TMP_DIC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_DIC := NULL;   
   
   DBMS_OUTPUT.PUT_LINE('Creando DD_VCI_VENCIMIENTO_CIRBE......');
   FOR I IN V_VCI.FIRST .. V_VCI.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_VCI_VENCIMIENTO_CIRBE.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_VCI := V_VCI(I);
      DBMS_OUTPUT.PUT_LINE('Creando DIC: '||V_TMP_VCI(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_VCI_VENCIMIENTO_CIRBE (DD_VCI_ID, DD_VCI_CODIGO, DD_VCI_DESCRIPCION,' ||
		'DD_VCI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_VCI(1)||''','''||V_TMP_VCI(2)||''','''
		 ||V_TMP_VCI(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_VCI := NULL;  
   
   DBMS_OUTPUT.PUT_LINE('Creando DD_GAC_GARANTIA_CIRBE......');
   FOR I IN V_GAC.FIRST .. V_GAC.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_GAC_GARANTIA_CIRBE.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_GAC := V_GAC(I);
      DBMS_OUTPUT.PUT_LINE('Creando GAC: '||V_TMP_GAC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_GAC_GARANTIA_CIRBE (DD_GAC_ID, DD_GAC_CODIGO, DD_GAC_DESCRIPCION,' ||
		'DD_GAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_GAC(1)||''','''||V_TMP_GAC(2)||''','''
		 ||V_TMP_GAC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_GAC := NULL;   
   
   DBMS_OUTPUT.PUT_LINE('Creando DD_SIC_SITUACION_CIRBE......');
   FOR I IN V_SIC.FIRST .. V_SIC.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA_MASTER||'.S_DD_SIC_SITUACION_CIRBE.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_SIC := V_SIC(I);
      DBMS_OUTPUT.PUT_LINE('Creando GAC: '||V_TMP_SIC(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_MASTER||'.DD_SIC_SITUACION_CIRBE (DD_SIC_ID, DD_SIC_CODIGO, DD_SIC_DESCRIPCION,' ||
		'DD_SIC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_SIC(1)||''','''||V_TMP_SIC(2)||''','''
		 ||V_TMP_SIC(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_RELACION_GRUPO
   V_TMP_SIC := NULL;
   COMMIT;    
   

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
