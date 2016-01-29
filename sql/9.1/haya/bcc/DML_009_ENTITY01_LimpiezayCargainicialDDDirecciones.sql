--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150725
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-438
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

 
   TYPE T_TIPO_VIA IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_VIA IS TABLE OF T_TIPO_VIA;
   
     
   
   
	
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   -- Configuracion Entidad
   V_ENTIDAD VARCHAR2(255) := 'CAJAMAR-CDD';
   V_WORKING_CODE VARCHAR2(255) := '3058';

						   
	
	 V_TIPO_VIA T_ARRAY_VIA := T_ARRAY_VIA(									
												T_TIPO_VIA('AGRU','AGRUPACION','AGRUPACION'),
												T_TIPO_VIA('ALAM','ALAMEDA   ','ALAMEDA   '),
												T_TIPO_VIA('ALAME.','ALAME.','ALAME.'),
												T_TIPO_VIA('ALDA','ALDEA     ','ALDEA     '),
												T_TIPO_VIA('APART.','APART.','APART.'),
												T_TIPO_VIA('APDO','APARTADO DE CORREOS ','APARTADO DE CORREOS '),
												T_TIPO_VIA('APTO','APARTAMENTO         ','APARTAMENTO         '),
												T_TIPO_VIA('AVDA','AVENIDA   ','AVENIDA   '),
												T_TIPO_VIA('AVDA.','AVDA.','AVDA.'),
												T_TIPO_VIA('BARR','BARRIO    ','BARRIO    '),
												T_TIPO_VIA('BJDA','BAJADA    ','BAJADA    '),
												T_TIPO_VIA('BLOQ','BLOQUE    ','BLOQUE    '),
												T_TIPO_VIA('BLOQUE','',''),
												T_TIPO_VIA('BRCO','BARRANCO  ','BARRANCO  '),
												T_TIPO_VIA('BRDA','BARRIADA  ','BARRIADA  '),
												T_TIPO_VIA('C/','CALLE     ','CALLE     '),
												T_TIPO_VIA('CALLE','CALLE','CALLE'),
												T_TIPO_VIA('CAMINO','CAMINO','CAMINO'),
												T_TIPO_VIA('CARR','CARRIL    ','CARRIL    '),
												T_TIPO_VIA('CASE','CASERIO   ','CASERIO   '),
												T_TIPO_VIA('CASER.','CASER.','CASER.'),
												T_TIPO_VIA('CHLT','CHALET    ','CHALET    '),
												T_TIPO_VIA('CJON','CALLEJON  ','CALLEJON  '),
												T_TIPO_VIA('CJTO','CONJUNTO  ','CONJUNTO  '),
												T_TIPO_VIA('CMNO','CAMINO    ','CAMINO    '),
												T_TIPO_VIA('COLN','COLONIA   ','COLONIA   '),
												T_TIPO_VIA('CON','CONJUNTO  ','CONJUNTO  '),
												T_TIPO_VIA('CTJO','CORTIJO   ','CORTIJO   '),
												T_TIPO_VIA('CTRA','CARRETERA ','CARRETERA '),
												T_TIPO_VIA('CTRA.','CTRA.','CTRA.'),
												T_TIPO_VIA('CUES','CUESTA    ','CUESTA              '),
												T_TIPO_VIA('DSDO','DISEMINADO','DISEMINADO'),
												T_TIPO_VIA('EDIF','EDIFICIO  ','EDIFICIO  '),
												T_TIPO_VIA('ENTR','ENTRESUELO','ENTRESUELO'),
												T_TIPO_VIA('GALR','GALERIA   ','GALERIA   '),
												T_TIPO_VIA('GLOR','GLORIETA  ','GLORIETA  '),
												T_TIPO_VIA('GRUP','GRUPO     ','GRUPO     '),
												T_TIPO_VIA('GVIA','GRAN VIA  ','GRAN VIA  '),
												T_TIPO_VIA('LGAR','LUGAR     ','LUGAR     '),
												T_TIPO_VIA('MCDO','MERCADO   ','MERCADO   '),
												T_TIPO_VIA('MUNI','MUNICIPIO ','MUNICIPIO '),
												T_TIPO_VIA('MZNA','MANZANA   ','MANZANA   '),
												T_TIPO_VIA('PARQ','PARQUE    ','PARQUE    '),
												T_TIPO_VIA('PBDO','POBLADO   ','POBLADO   '),
												T_TIPO_VIA('PLAZA','PLAZA','PLAZA'),
												T_TIPO_VIA('PLZA','PLAZA     ','PLAZA     '),
												T_TIPO_VIA('POLG','POLIGONO  ','POLIGONO  '),
												T_TIPO_VIA('PRJE','PARAJE    ','PARAJE    '),
												T_TIPO_VIA('PROL','PROLONGACION        ','PROLONGACION        '),
												T_TIPO_VIA('PSEO','PASEO     ','PASEO     '),
												T_TIPO_VIA('PSJE','PASAJE    ','PASAJE    '),
												T_TIPO_VIA('PTDA','PARTIDA   ','PARTIDA             '),
												T_TIPO_VIA('PZLA','PLAZUELA','PLAZUELA'),
												T_TIPO_VIA('RAMB','RAMBLA  ','RAMBLA  '),
												T_TIPO_VIA('RESI','RESIDENCIAL         ','RESIDENCIAL         '),
												T_TIPO_VIA('RNDA','RONDA   ','RONDA   '),
												T_TIPO_VIA('SBDA','SUBIDA  ','SUBIDA  '),
												T_TIPO_VIA('SNDA','SENDA   ','SENDA   '),
												T_TIPO_VIA('TNTE','TORRENTE','TORRENTE'),
												T_TIPO_VIA('TRAV','TRAVESIA','TRAVESIA'),
												T_TIPO_VIA('URBA','URBANIZACION        ','URBANIZACION        '),
												T_TIPO_VIA('VIA','VIA     ','VIA     '),
												T_TIPO_VIA('VRDA','VEREDA  ','VEREDA  ')
												
                                   );
								   
				
								   

--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
   
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
  
   V_TMP_TIPO_VIA T_TIPO_VIA ;

   
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN





			DBMS_OUTPUT.PUT_LINE('Se borra DD_TVD_TIPO_VIA_DIRECCION - TIPO VIA');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_TVD_TIPO_VIA_DIRECCION');
	
		
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TVD_TIPO_VIA_DIRECCION' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TVD_TIPO_VIA_DIRECCION');
	end if;
	
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TVD_TIPO_VIA_DIRECCION
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
   DBMS_OUTPUT.PUT_LINE('Creando DD_TVD_TIPO_VIA_DIRECCION......');
   FOR I IN V_TIPO_VIA.FIRST .. V_TIPO_VIA.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TVD_TIPO_VIA_DIRECCION.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_VIA := V_TIPO_VIA(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo TIPO VIA: '||V_TMP_TIPO_VIA(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TVD_TIPO_VIA_DIRECCION (DD_TVD_ID, DD_TVD_CODIGO, DD_TVD_DESCRIPCION,' ||
        'DD_TVD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_VIA(1)||''','''||RTRIM(V_TMP_TIPO_VIA(2))||''','''
         ||RTRIM(V_TMP_TIPO_VIA(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO VIA
    COMMIT;
   V_TMP_TIPO_VIA:= NULL;
   V_TIPO_VIA:= NULL;
   
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

