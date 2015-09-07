--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150902
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-438
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios tipos via , esquema CMMASTER.
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
   V_ESQUEMA VARCHAR(25) := 'CM01';
   V_ESQUEMA_M VARCHAR(25) := 'CMMASTER';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   -- Configuracion Entidad
   V_ENTIDAD VARCHAR2(255) := 'CAJAMAR-CDD';
   V_WORKING_CODE VARCHAR2(255) := '3058';

						   
	
	 V_TIPO_VIA T_ARRAY_VIA := T_ARRAY_VIA(
                                   T_TIPO_VIA('1','C/','C/')
                                 , T_TIPO_VIA('2','CTRA','CTRA')
                                 , T_TIPO_VIA('3','AVDA','AVDA')
                                 , T_TIPO_VIA('4','PSJE','PSJE')
                                 , T_TIPO_VIA('5','PSEO','PSEO')
                                 , T_TIPO_VIA('6','PLZA','PLZA')
                                 , T_TIPO_VIA('7','ALAM','ALAM')
                                 , T_TIPO_VIA('8','CMNO','CMNO')
                                 , T_TIPO_VIA('9','BARR','BARR')
                                 , T_TIPO_VIA('10','COLN','COLN')
                                 , T_TIPO_VIA('11','POLG','POLG')
                                 , T_TIPO_VIA('12','PROL','PROL')
                                 , T_TIPO_VIA('13','RNDA','RNDA')
                                 , T_TIPO_VIA('14','TRAV','TRAV')
                                 , T_TIPO_VIA('15','URBA','URBA')
                                 , T_TIPO_VIA('16','RAMB','RAMB')
                                 , T_TIPO_VIA('17','GLOR','GLOR')
                                 , T_TIPO_VIA('18','GALR','GALR')
                                 , T_TIPO_VIA('19','CASE','CASE')
                                 , T_TIPO_VIA('20','CUES','CUES')
                                 , T_TIPO_VIA('21','GRUP','GRUP')
                                 , T_TIPO_VIA('22','EDIF','EDIF')
                                 , T_TIPO_VIA('23','APTO','APTO')
                                 , T_TIPO_VIA('24','PARQ','PARQ')
                                 , T_TIPO_VIA('25','BLOQ','BLOQ')
                                 , T_TIPO_VIA('26','CHLT','CHLT')
                                 , T_TIPO_VIA('27','PRJE','PRJE')
                                 , T_TIPO_VIA('28','MCDO','MCDO')
                                 , T_TIPO_VIA('29','MUNI','MUNI')
                                 , T_TIPO_VIA('30','MZNA','MZNA')
                                 , T_TIPO_VIA('31','PBDO','PBDO')
                                 , T_TIPO_VIA('32','BRDA','BRDA')
                                 , T_TIPO_VIA('33','CTJO','CTJO')
                                 , T_TIPO_VIA('34','CARR','CARR')
                                 , T_TIPO_VIA('35','APDO','APDO')
                                 , T_TIPO_VIA('36','VRDA','VRDA')
                                 , T_TIPO_VIA('37','AGRU','AGRU')
                                 , T_TIPO_VIA('38','BJDA','BJDA')
                                 , T_TIPO_VIA('39','BRCO','BRCO')
                                 , T_TIPO_VIA('40','CJON','CJON')
                                 , T_TIPO_VIA('41','DSDO','DSDO')
                                 , T_TIPO_VIA('42','PTDA','PTDA')
                                 , T_TIPO_VIA('43','PZLA','PZLA')
                                 , T_TIPO_VIA('44','SBDA','SBDA')
                                 , T_TIPO_VIA('45','SNDA','SNDA')
                                 , T_TIPO_VIA('46','TNTE','TNTE')
                                 , T_TIPO_VIA('47','ALDA','ALDA')
                                 , T_TIPO_VIA('48','LGAR','LGAR')
                                 , T_TIPO_VIA('49','RESI','RESI')
                                 , T_TIPO_VIA('50','CJTO','CJTO')
                                 , T_TIPO_VIA('51','GVIA','GVIA')
                                 , T_TIPO_VIA('52','VIA','VIA')
                                 , T_TIPO_VIA('99','','')
                                 , T_TIPO_VIA('0000AL','ALAME.','ALAME.')
                                 , T_TIPO_VIA('0000AP','APART.','APART.')
                                 , T_TIPO_VIA('0000AV','AVDA.','AVDA.')
                                 , T_TIPO_VIA('0000BL','BLOQUE','BLOQUE')
                                 , T_TIPO_VIA('0000C/','CALLE','CALLE')
                                 , T_TIPO_VIA('0000CL','CALLE','CALLE')
                                 , T_TIPO_VIA('0000CM','CAMINO','CAMINO')
                                 , T_TIPO_VIA('0000CR','CTRA.','CTRA.')
                                 , T_TIPO_VIA('0000CS','CASER.','CASER.')
                                 , T_TIPO_VIA('0000EX','','')
                                 , T_TIPO_VIA('0000PZ','PLAZA','PLAZA')
                                 , T_TIPO_VIA('AGRU','AG AGRUPACION','AG AGRUPACION')
                                 , T_TIPO_VIA('ALAM','AL ALAMEDA','AL ALAMEDA')
                                 , T_TIPO_VIA('ALAME.','AL','AL')
                                 , T_TIPO_VIA('ALDA','AD ALDEA','AD ALDEA')
                                 , T_TIPO_VIA('APART.','AP','AP')
                                 , T_TIPO_VIA('APDO','AD APARTADO DE CORREOS','AD APARTADO DE CORREOS')
                                 , T_TIPO_VIA('APTO','AP APARTAMENTO','AP APARTAMENTO')
                                 , T_TIPO_VIA('AVDA','AV AVENIDA','AV AVENIDA')
                                 , T_TIPO_VIA('AVDA.','AV','AV')
                                 , T_TIPO_VIA('BARR','BO BARRIO','BO BARRIO')
                                 , T_TIPO_VIA('BJDA','BJ BAJADA','BJ BAJADA')
                                 , T_TIPO_VIA('BLOQ','BL BLOQUE','BL BLOQUE')
                                 , T_TIPO_VIA('BLOQUE','BL','BL')
                                 , T_TIPO_VIA('BRCO','BR BARRANCO','BR BARRANCO')
                                 , T_TIPO_VIA('BRDA','BO BARRIADA','BO BARRIADA')
                                 , T_TIPO_VIA('C/','CL CALLE','CL CALLE')
                                 , T_TIPO_VIA('CALLE','CL','CL')
                                 , T_TIPO_VIA('CAMINO','CM','CM')
                                 , T_TIPO_VIA('CARR','CA CARRIL','CA CARRIL')
                                 , T_TIPO_VIA('CASE','CS CASERIO','CS CASERIO')
                                 , T_TIPO_VIA('CASER.','CS','CS')
                                 , T_TIPO_VIA('CHLT','CH CHALET','CH CHALET')
                                 , T_TIPO_VIA('CJON','CJ CALLEJON','CJ CALLEJON')
                                 , T_TIPO_VIA('CJTO','CN CONJUNTO','CN CONJUNTO')
                                 , T_TIPO_VIA('CMNO','CM CAMINO','CM CAMINO')
                                 , T_TIPO_VIA('COLN','CO COLONIA','CO COLONIA')
                                 , T_TIPO_VIA('CON','CN CONJUNTO','CN CONJUNTO')
                                 , T_TIPO_VIA('CTJO','LG CORTIJO','LG CORTIJO')
                                 , T_TIPO_VIA('CTRA','CR CARRETERA','CR CARRETERA')
                                 , T_TIPO_VIA('CTRA.','CR','CR')
                                 , T_TIPO_VIA('CUES','CT CUESTA','CT CUESTA')
                                 , T_TIPO_VIA('DSDO','DS DISEMINADO','DS DISEMINADO')
                                 , T_TIPO_VIA('EDIF','ED EDIFICIO','ED EDIFICIO')
                                 , T_TIPO_VIA('ENTR','EN ENTRESUELO','EN ENTRESUELO')
                                 , T_TIPO_VIA('GALR','PJ GALERIA','PJ GALERIA')
                                 , T_TIPO_VIA('GLOR','GL GLORIETA','GL GLORIETA')
                                 , T_TIPO_VIA('GRUP','GR GRUPO','GR GRUPO')
                                 , T_TIPO_VIA('GVIA','GV GRAN VIA','GV GRAN VIA')
                                 , T_TIPO_VIA('LGAR','LG LUGAR','LG LUGAR')
                                 , T_TIPO_VIA('MCDO','MC MERCADO','MC MERCADO')
                                 , T_TIPO_VIA('MUNI','MN MUNICIPIO','MN MUNICIPIO')
                                 , T_TIPO_VIA('MZNA','MZ MANZANA','MZ MANZANA')
                                 , T_TIPO_VIA('PARQ','PQ PARQUE','PQ PARQUE')
                                 , T_TIPO_VIA('PBDO','PB POBLADO','PB POBLADO')
                                 , T_TIPO_VIA('PLAZA','PZ','PZ')
                                 , T_TIPO_VIA('PLZA','PZ PLAZA','PZ PLAZA')
                                 , T_TIPO_VIA('POLG','PG POLIGONO','PG POLIGONO')
                                 , T_TIPO_VIA('PRJE','LG PARAJE','LG PARAJE')
                                 , T_TIPO_VIA('PROL','PR PROLONGACION','PR PROLONGACION')
                                 , T_TIPO_VIA('PSEO','PS PASEO','PS PASEO')
                                 , T_TIPO_VIA('PSJE','PJ PASAJE','PJ PASAJE')
                                 , T_TIPO_VIA('PTDA','PD PARTIDA','PD PARTIDA')
                                 , T_TIPO_VIA('PZLA','PL PLAZUELA','PL PLAZUELA')
                                 , T_TIPO_VIA('RAMB','RB RAMBLA','RB RAMBLA')
                                 , T_TIPO_VIA('RESI','RS RESIDENCIAL','RS RESIDENCIAL')
                                 , T_TIPO_VIA('RNDA','RD RONDA','RD RONDA')
                                 , T_TIPO_VIA('RRRR','XX PRUEBA SIMU 2','XX PRUEBA SIMU 2')
                                 , T_TIPO_VIA('SBDA','SB SUBIDA','SB SUBIDA')
                                 , T_TIPO_VIA('SNDA','SD SENDA','SD SENDA')
                                 , T_TIPO_VIA('TNTE','TO TORRENTE','TO TORRENTE')
                                 , T_TIPO_VIA('TRAV','TR TRAVESIA','TR TRAVESIA')
                                 , T_TIPO_VIA('URBA','UR URBANIZACION','UR URBANIZACION')
                                 , T_TIPO_VIA('VIA','VI VIA','VI VIA')
                                 , T_TIPO_VIA('VRDA','VD VEREDA','VD VEREDA')
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





			DBMS_OUTPUT.PUT_LINE('Se borra DD_TVI_TIPO_VIA - TIPO VIA');
	    execute immediate('DELETE FROM ' || V_ESQUEMA_M || '.DD_TVI_TIPO_VIA');
	
		
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TVI_TIPO_VIA' and sequence_owner=V_ESQUEMA_M;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_M || '.S_DD_TVI_TIPO_VIA');
	end if;
	
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_M || '.S_DD_TVI_TIPO_VIA
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
   DBMS_OUTPUT.PUT_LINE('Creando DD_TVI_TIPO_VIA......');
   FOR I IN V_TIPO_VIA.FIRST .. V_TIPO_VIA.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_TVI_TIPO_VIA.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_VIA := V_TIPO_VIA(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo TIPO VIA: '||V_TMP_TIPO_VIA(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA (DD_TVI_ID, DD_TVI_CODIGO, DD_TVI_DESCRIPCION,' ||
        'DD_TVI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
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

