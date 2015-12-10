--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-439
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios Relaciones Cajamar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

 
   TYPE T_TIPO_ESTADO_TLF IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_ESTADO_TLF IS TABLE OF T_TIPO_ESTADO_TLF;
   
      TYPE T_TIPO_MOTIVO_TLF IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_MOTIVO_TLF IS TABLE OF T_TIPO_MOTIVO_TLF;
     
     
   
   
	
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   -- Configuracion Entidad
   V_ENTIDAD VARCHAR2(255) := 'CAJAMAR-CDD';
   V_WORKING_CODE VARCHAR2(255) := '3058';

						   
	
	 V_TIPO_ESTADO_TLF T_ARRAY_ESTADO_TLF := T_ARRAY_ESTADO_TLF(									
												T_TIPO_ESTADO_TLF('OK','Correcto','Correcto'),
												T_TIPO_ESTADO_TLF('KO','Erroneo','Erroneo'),
												T_TIPO_ESTADO_TLF('NO-DISP','No disponible','No disponible'),
												T_TIPO_ESTADO_TLF('BLOQ','Bloqueado','Bloqueado')
												
                                   );
								   
	
	 V_TIPO_MOTIVO_TLF T_ARRAY_MOTIVO_TLF := T_ARRAY_MOTIVO_TLF(									
												T_TIPO_MOTIVO_TLF('0000','SIN VALORES','SIN VALORES')
								
												
                                   );
								   
	
								   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
  
   V_TMP_TIPO_ESTADO_TLF T_TIPO_ESTADO_TLF ;
   
      V_TMP_TIPO_MOTIVO_TLF T_TIPO_MOTIVO_TLF ;
   
   
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN





			DBMS_OUTPUT.PUT_LINE('Se borra DD_ETE_ESTADO_TELEFONO - ESTADO TLF');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_ETE_ESTADO_TELEFONO');
		
		DBMS_OUTPUT.PUT_LINE('Se borra DD_MTE_MOTIVO_TELEFONO - MOTIVO TLF');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_MTE_MOTIVO_TELEFONO');
		
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_ETE_ESTADO_TELEFONO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_ETE_ESTADO_TELEFONO');
	end if;
	
	 SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_MTE_MOTIVO_TELEFONO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_MTE_MOTIVO_TELEFONO');
	end if;
	
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_ETE_ESTADO_TELEFONO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_MTE_MOTIVO_TELEFONO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	
   DBMS_OUTPUT.PUT_LINE('Creando DD_ETE_ESTADO_TELEFONO......');
   FOR I IN V_TIPO_ESTADO_TLF.FIRST .. V_TIPO_ESTADO_TLF.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_ETE_ESTADO_TELEFONO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_ESTADO_TLF := V_TIPO_ESTADO_TLF(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo ESTADO TELEFONO: '||V_TMP_TIPO_ESTADO_TLF(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ETE_ESTADO_TELEFONO (DD_ETE_ID, DD_ETE_CODIGO, DD_ETE_DESCRIPCION,' ||
        'DD_ETE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_ESTADO_TLF(1)||''','''||RTRIM(V_TMP_TIPO_ESTADO_TLF(2))||''','''
         ||RTRIM(V_TMP_TIPO_ESTADO_TLF(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO ESTADO TLF
    COMMIT;
   V_TMP_TIPO_ESTADO_TLF:= NULL;
   V_TIPO_ESTADO_TLF:= NULL;
   
    DBMS_OUTPUT.PUT_LINE('Creando DD_MTE_MOTIVO_TELEFONO......');
   FOR I IN V_TIPO_MOTIVO_TLF.FIRST .. V_TIPO_MOTIVO_TLF.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_MTE_MOTIVO_TELEFONO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_MOTIVO_TLF := V_TIPO_MOTIVO_TLF(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo MOTIVO TELEFONO: '||V_TMP_TIPO_MOTIVO_TLF(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_MTE_MOTIVO_TELEFONO (DD_MTE_ID, DD_MTE_CODIGO, DD_MTE_DESCRIPCION,' ||
        'DD_MTE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_MOTIVO_TLF(1)||''','''||RTRIM(V_TMP_TIPO_MOTIVO_TLF(2))||''','''
         ||RTRIM(V_TMP_TIPO_MOTIVO_TLF(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO ESTADO TLF
    COMMIT;
   V_TMP_TIPO_MOTIVO_TLF:= NULL;
   V_TIPO_MOTIVO_TLF:= NULL;
  
   DBMS_OUTPUT.PUT_LINE('Script ejecutado correctamente'); 

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

