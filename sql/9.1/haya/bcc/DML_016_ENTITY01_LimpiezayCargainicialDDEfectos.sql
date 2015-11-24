--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-444
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios EFECTOS Cajamar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
  
   TYPE T_TEF IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TEF IS TABLE OF T_TEF;

   TYPE T_SEF IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SEF IS TABLE OF T_SEF;

   TYPE T_TFV IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TFV IS TABLE OF T_TFV;
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
   

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';

   
--/* Configuracion ORIGEN_BIEN: DD_TEF_TIPO_EFECTO
--	(
--	  DD_TEF_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_TEF_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_TEF_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_TEF T_ARRAY_TEF := T_ARRAY_TEF(
                                    T_TEF('01','LETRA','LETRA'),
									T_TEF('02','RECIBO','RECIBO'),
									T_TEF('03','PAGARÉ','PAGARÉ'),
									T_TEF('04','PAGARÉ CUENTA CORRIENTE','PAGARÉ CUENTA CORRIENTE'),
									T_TEF('08','CERTIFICACIONES','CERTIFICACIONES'),
									T_TEF('09','PAGO CERTIFICADO','PAGO CERTIFICADO'),
									T_TEF('10','FACTURAS','FACTURAS')
                                   );

--/* Configuracion ORIGEN_BIEN: DD_SEF_SITUACION_EFECTO
--	(
--	  DD_SEF_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_SEF_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_SEF_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_SEF T_ARRAY_SEF := T_ARRAY_SEF(
                                    T_SEF('C','EN CARTERA','EN CARTERA'),
									T_SEF('A','APLICADO','APLICADO'),
									T_SEF('R','RECLAMADO','RECLAMADO'),
									T_SEF('D','DEVUELTO','DEVUELTO'),
									T_SEF('P','NOTIFICACIÓN PAGO POSTERIOR DE UNA DEVOLUCIÓN','NOTIFICACIÓN PAGO POSTERIOR DE UNA DEVOLUCIÓN')              
                                   );
--/* Configuracion ORIGEN_BIEN: DD_TFV_TIPO_FECHA_VENC
--	(
--	  DD_TFV_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
--	  DD_TFV_DESCRIPCION        VARCHAR2(50 CHAR),
--	  DD_TFV_DESCRIPCION_LARGA  VARCHAR2(250 CHAR)
--	)*/
                                   
   V_TFV T_ARRAY_TFV := T_ARRAY_TFV(
                                   T_TFV('D','DIAS VISTA','DIAS VISTA'),
                                   T_TFV('F','FECHA FIJA','FECHA FIJA'),
                                   T_TFV('N','EFECTO SIN VENCIMIENTO','EFECTO SIN VENCIMIENTO'),
                                   T_TFV('V','A LA VISTA','A LA VISTA')
                                   );


--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
   
   V_TMP_SEF T_SEF;
   V_TMP_TFV T_TFV;
   V_TMP_TEF T_TEF;

   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN

	DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TIPO EFECTO.');
	EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TEF_TIPO_EFECTO');

	DBMS_OUTPUT.PUT_LINE('Se borra la configuración de SITUACION_EFECTO.');
	EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_SEF_SITUACION_EFECTO');

	DBMS_OUTPUT.PUT_LINE('Se borra la configuración de TIPO_FECHA_VENC.');
	EXECUTE IMMEDIATE('DELETE FROM '|| V_ESQUEMA ||'.DD_TFV_TIPO_FECHA_VENC');

    DBMS_OUTPUT.PUT_LINE('Reseteamos los contadores......');
    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TEF_TIPO_EFECTO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	DBMS_OUTPUT.PUT_LINE('Contador 1');
	EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TEF_TIPO_EFECTO');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TEF_TIPO_EFECTO
	START WITH 1
	MAXVALUE 999999999999999999999999999
	MINVALUE 1
	NOCYCLE
	CACHE 20
	NOORDER');	

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_SEF_SITUACION_EFECTO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	DBMS_OUTPUT.PUT_LINE('Contador 2');
	EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_SEF_SITUACION_EFECTO');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_SEF_SITUACION_EFECTO
	START WITH 1
	MAXVALUE 999999999999999999999999999
	MINVALUE 1
	NOCYCLE
	CACHE 20
	NOORDER');	

    V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TFV_TIPO_FECHA_VENC' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
	DBMS_OUTPUT.PUT_LINE('Contador 3');
	EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TFV_TIPO_FECHA_VENC');
    end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TFV_TIPO_FECHA_VENC
	START WITH 1
	MAXVALUE 999999999999999999999999999
	MINVALUE 1
	NOCYCLE
	CACHE 20
	NOORDER');


   DBMS_OUTPUT.PUT_LINE('Creando DD_TEF_TIPO_EFECTO......');
   FOR I IN V_TEF.FIRST .. V_TEF.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TEF_TIPO_EFECTO.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TEF := V_TEF(I);
      DBMS_OUTPUT.PUT_LINE('Creando TEF: '||V_TMP_TEF(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TEF_TIPO_EFECTO (DD_TEF_ID, DD_TEF_CODIGO, DD_TEF_DESCRIPCION,' ||
		'DD_TEF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TEF(1)||''','''||V_TMP_TEF(2)||''','''
		 ||V_TMP_TEF(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_COBRO
   V_TMP_TEF := NULL;

   DBMS_OUTPUT.PUT_LINE('Creando DD_SEF_SITUACION_EFECTO......');
   FOR I IN V_SEF.FIRST .. V_SEF.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_SEF_SITUACION_EFECTO.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_SEF := V_SEF(I);
      DBMS_OUTPUT.PUT_LINE('Creando SEF: '||V_TMP_SEF(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SEF_SITUACION_EFECTO (DD_SEF_ID, DD_SEF_CODIGO, DD_SEF_DESCRIPCION,' ||
		'DD_SEF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_SEF(1)||''','''||V_TMP_SEF(2)||''','''
		 ||V_TMP_SEF(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_ORIGEN_COBRO
   V_TMP_SEF := NULL;

   DBMS_OUTPUT.PUT_LINE('Creando DD_TFV_TIPO_FECHA_VENC......');
   FOR I IN V_TFV.FIRST .. V_TFV.LAST
   LOOP
   	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TFV_TIPO_FECHA_VENC.NEXTVAL FROM DUAL';
   	EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TFV := V_TFV(I);
      DBMS_OUTPUT.PUT_LINE('Creando TFV: '||V_TMP_TFV(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TFV_TIPO_FECHA_VENC (DD_TFV_ID, DD_TFV_CODIGO, DD_TFV_DESCRIPCION,' ||
		'DD_TFV_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TFV(1)||''','''||V_TMP_TFV(2)||''','''
		 ||V_TMP_TFV(3)||''',0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_ORIGEN_COBRO
   V_TMP_TFV := NULL;

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