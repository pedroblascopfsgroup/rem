--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-436
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios Personas Cajamar , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE


 TYPE T_TIPO_PERSONA IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_PERSONA IS TABLE OF T_TIPO_PERSONA; 
  
      TYPE T_TIPO_ORI_TELEFONO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TIPO_ORI_TELEFONO IS TABLE OF T_TIPO_ORI_TELEFONO; 
   
   TYPE T_TIPO_TELEFONO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TIPO_TELEFONO IS TABLE OF T_TIPO_TELEFONO;   

   TYPE T_TIPO_DOCUMENTO IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_DOCUMENTO IS TABLE OF T_TIPO_DOCUMENTO; 
   
    TYPE T_TIPO_CONCURSAL IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_CONCURSAL IS TABLE OF T_TIPO_CONCURSAL; 
   

   TYPE T_TIPO_GGE IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_GGE IS TABLE OF T_TIPO_GGE; 

--######## SUBSEGMENTO CLIENTES--########
   TYPE T_TIPO_SSC IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SSC IS TABLE OF T_TIPO_SSC;  

--######## SEGMENTO CLIENTES--########
   TYPE T_TIPO_SCE IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SCE IS TABLE OF T_TIPO_SCE;  

	
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
   V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   
   -- Configuracion Entidad
   V_ENTIDAD VARCHAR2(255) := 'CAJAMAR-CDD';
   V_WORKING_CODE VARCHAR2(255) := '3058';

   V_TIPO_PERSONA T_ARRAY_PERSONA := T_ARRAY_PERSONA(
                                    T_TIPO_PERSONA('1','FISICA','FISICA'),
				    T_TIPO_PERSONA('2','JURIDICA','JURIDICA')
                                   );
								   
	   V_TIPO_DOCUMENTO T_ARRAY_DOCUMENTO := T_ARRAY_DOCUMENTO(
                                    T_TIPO_DOCUMENTO('CAR','CARTA DE IDENTIFICACION','CARTA DE IDENTIFICACION'),
									T_TIPO_DOCUMENTO('CIF','C.I.F.','C.I.F.'),
									T_TIPO_DOCUMENTO('CXN','C.I.F. EXTRANJERO NO RESIDENTE','C.I.F. EXTRANJERO NO RESIDENTE'),
									T_TIPO_DOCUMENTO('CXT','C.I.F. EXTRANJERO RESIDENTE','C.I.F. EXTRANJERO RESIDENTE'),
									T_TIPO_DOCUMENTO('DXT','D.N.I. EXTRANJERO','D.N.I. EXTRANJERO'),
									T_TIPO_DOCUMENTO('FEC','FECHA NACIMIENTO','FECHA NACIMIENTO'),
									T_TIPO_DOCUMENTO('IFR','IDENTIFICACION FISCAL PAIS RESIDENCIA','IDENTIFICACION FISCAL PAIS RESIDENCIA'),
									T_TIPO_DOCUMENTO('NIE','NUMERO IDENTIFICACION EXTRANJERO','NUMERO IDENTIFICACION EXTRANJERO'),
									T_TIPO_DOCUMENTO('NIF','N.I.F.','N.I.F.'),
									T_TIPO_DOCUMENTO('PAS','PASAPORTE','PASAPORTE'),
									T_TIPO_DOCUMENTO('TAR','TARJETA DE RESIDENCIA','TARJETA DE RESIDENCIA')
                                   );
								   
								   
								   
								   
      V_TIPO_CONCURSAL T_ARRAY_CONCURSAL := T_ARRAY_CONCURSAL(
                                    T_TIPO_CONCURSAL('A','NORMAL ','NORMAL '),
									T_TIPO_CONCURSAL('B','CONCURSAL - CONCURSO DE ACREEDORES SIN PETICIÓN DE LIQUIDACIÓN ','CONCURSAL - CONCURSO DE ACREEDORES SIN PETICIÓN DE LIQUIDACIÓN '),
									T_TIPO_CONCURSAL('C','CONCURSAL - CONCURSO DE ACREEDORES CON PETICIÓN DE LIQUIDACIÓN ','CONCURSAL - CONCURSO DE ACREEDORES CON PETICIÓN DE LIQUIDACIÓN '),
									T_TIPO_CONCURSAL('D','CONCURSAL - CONVENIO DE ACREEDORES SIN INCUMPLIMIENTO ','CONCURSAL - CONVENIO DE ACREEDORES SIN INCUMPLIMIENTO '),
									T_TIPO_CONCURSAL('E','CONCURSAL - CONVENIO DE ACREEDORES CON INCUMPLIMIENTO ','CONCURSAL - CONVENIO DE ACREEDORES CON INCUMPLIMIENTO '),
									T_TIPO_CONCURSAL('F','CONCURSAL - LIQUIDACIÓN ','CONCURSAL - LIQUIDACIÓN '),
									T_TIPO_CONCURSAL('G','PRECONCURSAL - COMUNICACIÓN AL JUZGADO DE NEGOCIACIONES CON LOS ACREEDORES ','PRECONCURSAL - COMUNICACIÓN AL JUZGADO DE NEGOCIACIONES CON LOS ACREEDORES '),
									T_TIPO_CONCURSAL('H','PRECONCURSAL - ACUERDO DE REFINANCIACIÓN ','PRECONCURSAL - ACUERDO DE REFINANCIACIÓN '),
									T_TIPO_CONCURSAL('I','PRECONCURSAL - ACUERDO DE REFINANCIACIÓN HOMOLOGADO JUDICIALMENTE ','PRECONCURSAL - ACUERDO DE REFINANCIACIÓN HOMOLOGADO JUDICIALMENTE '),
									T_TIPO_CONCURSAL('J','PRECONCURSAL - INCUMPLIMIENTO DEL ACUERDO DE REFINANCIACIÓN HOMOLOGADO ','PRECONCURSAL - INCUMPLIMIENTO DEL ACUERDO DE REFINANCIACIÓN HOMOLOGADO '),
									T_TIPO_CONCURSAL('K','EN PROCESO DE DISOLUCIÓN SIN CONCURSO ACREEDORES ','EN PROCESO DE DISOLUCIÓN SIN CONCURSO ACREEDORES ')
                                   );								   
				
     V_TIPO_ORI_TELEFONO T_ARRAY_TIPO_ORI_TELEFONO := T_ARRAY_TIPO_ORI_TELEFONO(
                                    T_TIPO_ORI_TELEFONO('FACILI','FACILITADO POR EL CLIENTE','FACILITADO POR EL CLIENTE')
                                   );		


     V_TIPO_TELEFONO T_ARRAY_TIPO_TELEFONO := T_ARRAY_TIPO_TELEFONO(
                                    T_TIPO_TELEFONO('0','no existe','no existe'),     
                                    T_TIPO_TELEFONO('1','Télex','Télex'),
				    T_TIPO_TELEFONO('10','Teléfono','Teléfono'),
				    T_TIPO_TELEFONO('20','Fax','Fax'),
				    T_TIPO_TELEFONO('30','Teléfono Móvil','Teléfono Móvil')
                                   );								   
								   
								   
								   


   V_TIPO_GGE T_ARRAY_GGE := T_ARRAY_GGE(
                                   T_TIPO_GGE('S','HAYA','HAYA')
                                   );


   V_TIPO_SSC T_ARRAY_SSC := T_ARRAY_SSC(
                                         T_TIPO_SSC('01','AGRICULTOR BAJO PLASTICO MINORISTA','AGRICULTOR BAJO PLASTICO MINORISTA'),
                                         T_TIPO_SSC('02','COMERCIALIZADORA HORTOFRUTICOLA   ','COMERCIALIZADORA HORTOFRUTICOLA   '),
                                         T_TIPO_SSC('03','PROMOTOR GRANDE                   ','PROMOTOR GRANDE                   '),
                                         T_TIPO_SSC('04','GRAN EMPRESA                      ','GRAN EMPRESA                      '),
                                         T_TIPO_SSC('05','MEDIANA EMPRESA                   ','MEDIANA EMPRESA                   '),
                                         T_TIPO_SSC('06','PEQUEÑA EMPRESA                   ','PEQUEÑA EMPRESA                   '),
                                         T_TIPO_SSC('07','MICROEMPRESA                      ','MICROEMPRESA                      '),
                                         T_TIPO_SSC('08','PARTICULARES                      ','PARTICULARES                      '),
                                         T_TIPO_SSC('09','SECTOR PUBLICO                    ','SECTOR PUBLICO                    '),
                                         T_TIPO_SSC('10','ENTIDADES SIN ANIMO DE LUCRO      ','ENTIDADES SIN ANIMO DE LUCRO      '),
                                         T_TIPO_SSC('11','INTERMEDIARIOS FINANCIEROS        ','INTERMEDIARIOS FINANCIEROS        '),
                                         T_TIPO_SSC('12','RESTO SECTOR PRIMARIO MINORISTA   ','RESTO SECTOR PRIMARIO MINORISTA   '),
                                         T_TIPO_SSC('13','AUTONOMOS                         ','AUTONOMOS                         '),
                                         T_TIPO_SSC('14','INDUSTRIA AUX. AGROALIM. MINORISTA','INDUSTRIA AUX. AGROALIM. MINORISTA'),
                                         T_TIPO_SSC('15','PRUEBA                            ','PRUEBA                            '),
                                         T_TIPO_SSC('16','PRODUCTOR PEQUEÑA                 ','PRODUCTOR PEQUEÑA                 '),
                                         T_TIPO_SSC('17','PRODUCTOR MEDIANA                 ','PRODUCTOR MEDIANA                 '),
                                         T_TIPO_SSC('18','PRODUCTOR GRANDE                  ','PRODUCTOR GRANDE                  '),
                                         T_TIPO_SSC('19','COMERCIALIZADORA MICRO            ','COMERCIALIZADORA MICRO            '),
                                         T_TIPO_SSC('20','COMERCIALIZADORA PEQUEÑA          ','COMERCIALIZADORA PEQUEÑA          '),
                                         T_TIPO_SSC('21','COMERCIALIZADORA MEDIANA          ','COMERCIALIZADORA MEDIANA          '),
                                         T_TIPO_SSC('22','COMERCIALIZADORA GRANDE           ','COMERCIALIZADORA GRANDE           '),
                                         T_TIPO_SSC('23','ENTIDADES DE CREDITO              ','ENTIDADES DE CREDITO              '),
                                         T_TIPO_SSC('24','IND. AUX. AGROALIMENTARIA PEQUEÑA ','IND. AUX. AGROALIMENTARIA PEQUEÑA '),
                                         T_TIPO_SSC('25','IND. AUX. AGROALIMENTARIA MEDIANA ','IND. AUX. AGROALIMENTARIA MEDIANA '),
                                         T_TIPO_SSC('26','IND. AUX. AGROALIMENTARIA GRANDE  ','IND. AUX. AGROALIMENTARIA GRANDE  '),
                                         T_TIPO_SSC('27','PROMOTOR MINORISTA                ','PROMOTOR MINORISTA                '),
                                         T_TIPO_SSC('28','PROMOTOR PEQUEÑA                  ','PROMOTOR PEQUEÑA                  '),
                                         T_TIPO_SSC('29','PROMOTOR MEDIANA                  ','PROMOTOR MEDIANA                  '),
                                         T_TIPO_SSC('30','CONSTRUCTOR MINORISTA             ','CONSTRUCTOR MINORISTA             '),
                                         T_TIPO_SSC('31','CONSTRUCTOR PEQUEÑA               ','CONSTRUCTOR PEQUEÑA               '),
                                         T_TIPO_SSC('32','CONSTRUCTOR MEDIANA               ','CONSTRUCTOR MEDIANA               '),
                                         T_TIPO_SSC('33','CONSTRUCTOR GRANDE                ','CONSTRUCTOR GRANDE                ')
                                   );
		
   V_TIPO_SCE T_ARRAY_SCE := T_ARRAY_SCE(
                               T_TIPO_SCE('01','Agricultor bajo plástico minorista','Agricultor bajo plástico minorista'),
                               T_TIPO_SCE('02','Comercializadora Hortofruticola','Comercializadora Hortofruticola'),
                               T_TIPO_SCE('03','Promotor','Promotor'),
                               T_TIPO_SCE('04','Gran empresa','Gran empresa'),
                               T_TIPO_SCE('05','Mediana empresa','Mediana empresa'),
                               T_TIPO_SCE('06','Pequeña empresa','Pequeña empresa'),
                               T_TIPO_SCE('07','Microempresa','Microempresa'),
                               T_TIPO_SCE('08','Particulares','Particulares'),
                               T_TIPO_SCE('09','Sector público','Sector público'),
                               T_TIPO_SCE('10','Entidades sin ánimo de lucro','Entidades sin ánimo de lucro'),
                               T_TIPO_SCE('11','Intermediarios financieros','Intermediarios financieros'),
                               T_TIPO_SCE('12','Resto sector primario minorista','Resto sector primario minorista'),
                               T_TIPO_SCE('13','Autónomos','Autónomos'),
                               T_TIPO_SCE('14','Industria aux. agroalim. minorista','Industria aux. agroalim. minorista'),
                               T_TIPO_SCE('16','Productor pequeña','Productor pequeña'),
                               T_TIPO_SCE('17','Productor mediana','Productor mediana'),
                               T_TIPO_SCE('18','Productor grande','Productor grande'),
                               T_TIPO_SCE('19','Comercializadora micro','Comercializadora micro'),
                               T_TIPO_SCE('20','Comercializadora pequeña','Comercializadora pequeña'),
                               T_TIPO_SCE('21','Comercializadora mediana','Comercializadora mediana'),
                               T_TIPO_SCE('22','Comercializadora grande','Comercializadora grande'),
                               T_TIPO_SCE('23','Entidad de crédito','Entidad de crédito'),
                               T_TIPO_SCE('24','Ind. aux. agroalimentaria pequeña','Ind. aux. agroalimentaria pequeña'),
                               T_TIPO_SCE('25','Ind. aux. agroalimentaria mediana','Ind. aux. agroalimentaria mediana'),
                               T_TIPO_SCE('26','Ind. aux. agroalimentaria grande','Ind. aux. agroalimentaria grande'),
                               T_TIPO_SCE('27','Promotor minorista','Promotor minorista'),
                               T_TIPO_SCE('28','Promotor pequeña','Promotor pequeña'),
                               T_TIPO_SCE('29','Promotor mediana','Promotor mediana'),
                               T_TIPO_SCE('30','Constructor minorista','Constructor minorista'),
                               T_TIPO_SCE('31','Constructor pequeña','Constructor pequeña'),
                               T_TIPO_SCE('32','Constructor mediana','Constructor mediana'),
                               T_TIPO_SCE('33','Constructor grande','Constructor grande')
                           );


		
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
   
   V_TMP_TIPO_PERSONA T_TIPO_PERSONA;
   
   V_TMP_TIPO_TELEFONO T_TIPO_TELEFONO;
  
   V_TMP_TIPO_DOCUMENTO T_TIPO_DOCUMENTO; 
   V_TMP_TIPO_CONCURSAL T_TIPO_CONCURSAL;
   V_TMP_TIPO_ORI_TELEFONO  T_TIPO_ORI_TELEFONO;
   
   V_TMP_TIPO_GGE T_TIPO_GGE; 
  
   V_TMP_TIPO_SSC T_TIPO_SSC;
   V_TMP_TIPO_SCE T_TIPO_SCE;   
   
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints TIT_TITULO_IBFK_5'); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS TIT_TITULO_IBFK_5');      

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_PERS_REFERENCE_DD_SCE_S '); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS FK_PER_PERS_REFERENCE_DD_SCE_S'); 

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_FK_DD_OTE_ID '); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS FK_PER_FK_DD_OTE_ID'); 

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_FK_DD_OTE_ID '); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS DISABLE CONSTRAINTS FK_PER_FK_DD_OTE_ID'); 


DBMS_OUTPUT.PUT_LINE('TELEFONOS - Deshabilitamos constraints FK_TEL_TEL_FK_DD_OTE_TEL'); 
EXECUTE IMMEDIATE('ALTER TABLE TEL_TELEFONOS DISABLE CONSTRAINTS FK_TEL_TEL_FK_DD_OTE_TEL');   

DBMS_OUTPUT.PUT_LINE('TELEFONOS - Deshabilitamos constraints FK_TEL_TEL_FK_DD_TTE_TEL '); 
EXECUTE IMMEDIATE('ALTER TABLE TEL_TELEFONOS DISABLE CONSTRAINTS FK_TEL_TEL_FK_DD_TTE_TEL');  

 


DBMS_OUTPUT.PUT_LINE('Se borra DD_TPE_TIPO_PERSONA');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_TPE_TIPO_PERSONA');

	    DBMS_OUTPUT.PUT_LINE('Se borra DD_TDI_TIPO_DOCUMENTO_ID');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_TDI_TIPO_DOCUMENTO_ID');
		
	    DBMS_OUTPUT.PUT_LINE('Se borra DD_SSC_SUBSEGMENTO_CLI_ENTIDAD - SUBSEGMENTO CLIENTE');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_SSC_SUBSEGMENTO_CLI_ENTIDAD');

	    DBMS_OUTPUT.PUT_LINE('Se borra DD_SCE_SEGTO_CLI_ENTIDAD - SEGMENTO CLIENTE');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_SCE_SEGTO_CLI_ENTIDAD');	    
	    
	    DBMS_OUTPUT.PUT_LINE('Se borra DD_SIC_SITUAC_CONCURSAL - SITUACION CONCURSAL');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_SIC_SITUAC_CONCURSAL');
		
		
	    DBMS_OUTPUT.PUT_LINE('Se borra 	DD_OTE_ORIGEN_TELEFONO - ORIGEN TELEFONO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_OTE_ORIGEN_TELEFONO');
	
	    DBMS_OUTPUT.PUT_LINE('Se borra 	DD_TTE_TIPO_TELEFONO - TIPO TELEFONO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_TTE_TIPO_TELEFONO');
		
	    DBMS_OUTPUT.PUT_LINE('Se borra 	DD_GGE_GRUPO_GESTOR - GRUPO GESTOR');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_GGE_GRUPO_GESTOR');
		
	    DBMS_OUTPUT.PUT_LINE('Se borra 	DD_GGE_GRUPO_GESTOR - GRUPO GESTOR');
	    execute immediate('DELETE FROM ' || V_ESQUEMA || '.DD_GGE_GRUPO_GESTOR');	
		

    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TPE_TIPO_PERSONA' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TPE_TIPO_PERSONA');
	end if;
	
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TPE_TIPO_PERSONA
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
    DBMS_OUTPUT.PUT_LINE('Tipo Persona');
		
   
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TTE_TIPO_TELEFONO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TTE_TIPO_TELEFONO');
	end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TTE_TIPO_TELEFONO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
    DBMS_OUTPUT.PUT_LINE('Contador 4');
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_TDI_TIPO_DOCUMENTO_ID' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_TDI_TIPO_DOCUMENTO_ID');
	end if;


    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_SCE_SEGTO_CLI_ENTIDAD' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_SCE_SEGTO_CLI_ENTIDAD');
    end if;
    
    
	SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_SIC_SITUAC_CONCURSAL' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_SIC_SITUAC_CONCURSAL');
	end if;
	
		SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_OTE_ORIGEN_TELEFONO' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_OTE_ORIGEN_TELEFONO');
	end if;
	
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_TDI_TIPO_DOCUMENTO_ID
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
            
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_SCE_SEGTO_CLI_ENTIDAD
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');      
	  
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_SIC_SITUAC_CONCURSAL
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_OTE_ORIGEN_TELEFONO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	
    DBMS_OUTPUT.PUT_LINE('SEQ GRUPO GESTOR');   
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_GGE_GRUPO_GESTOR' and sequence_owner=V_ESQUEMA;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_GGE_GRUPO_GESTOR');
	end if;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_GGE_GRUPO_GESTOR
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');

    DBMS_OUTPUT.PUT_LINE('Contador 25');
        V_ENTIDAD_ID:=0;
    SELECT count(*) INTO V_ENTIDAD_ID
        FROM all_sequences
        WHERE sequence_name = 'S_DD_SSC_SUBSEGMENTO_CLI_ENT' and sequence_owner=V_ESQUEMA;
        if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
       EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_DD_SSC_SUBSEGMENTO_CLI_ENT');
    END IF;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_DD_SSC_SUBSEGMENTO_CLI_ENT
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	  
	  
   DBMS_OUTPUT.PUT_LINE('Creando DD_TPE_TIPO_PERSONA......');
   FOR I IN V_TIPO_PERSONA.FIRST .. V_TIPO_PERSONA.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TDI_TIPO_DOCUMENTO_ID.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_PERSONA := V_TIPO_PERSONA(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo Documento: '||V_TMP_TIPO_PERSONA(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA (DD_TPE_ID, DD_TPE_CODIGO, DD_TPE_DESCRIPCION,' ||
        'DD_TPE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_PERSONA(1)||''','''||V_TMP_TIPO_PERSONA(2)||''','''
         ||V_TMP_TIPO_PERSONA(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_PERSONA
   V_TMP_TIPO_PERSONA:= NULL;
   V_TIPO_PERSONA:= NULL;  
	  
	 
   DBMS_OUTPUT.PUT_LINE('Creando DD_TDI_TIPO_DOCUMENTO_ID......');
   FOR I IN V_TIPO_DOCUMENTO.FIRST .. V_TIPO_DOCUMENTO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TDI_TIPO_DOCUMENTO_ID.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_DOCUMENTO := V_TIPO_DOCUMENTO(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo Documento: '||V_TMP_TIPO_DOCUMENTO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID, DD_TDI_CODIGO, DD_TDI_DESCRIPCION,' ||
        'DD_TDI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_DOCUMENTO(1)||''','''||V_TMP_TIPO_DOCUMENTO(2)||''','''
         ||V_TMP_TIPO_DOCUMENTO(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_Documento
   V_TMP_TIPO_DOCUMENTO:= NULL;
   V_TIPO_DOCUMENTO:= NULL;
   
   
   
      DBMS_OUTPUT.PUT_LINE('Creando DD_SIC_SITUAC_CONCURSAL......');
   FOR I IN V_TIPO_CONCURSAL.FIRST .. V_TIPO_CONCURSAL.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_SIC_SITUAC_CONCURSAL.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_CONCURSAL := V_TIPO_CONCURSAL(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo Documento: '||V_TMP_TIPO_CONCURSAL(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_SIC_SITUAC_CONCURSAL (DD_SIC_ID, DD_SIC_CODIGO, DD_SIC_DESCRIPCION,' ||
        'DD_SIC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_CONCURSAL(1)||''','''||SUBSTR(V_TMP_TIPO_CONCURSAL(2),1,50)||''','''
         ||V_TMP_TIPO_CONCURSAL(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_Documento
   V_TMP_TIPO_CONCURSAL:= NULL;
   V_TIPO_CONCURSAL:= NULL;
   
   
       DBMS_OUTPUT.PUT_LINE('Creando DD_OTE_ORIGEN_TELEFONO......');
   FOR I IN V_TIPO_ORI_TELEFONO.FIRST .. V_TIPO_ORI_TELEFONO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_OTE_ORIGEN_TELEFONO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_ORI_TELEFONO := V_TIPO_ORI_TELEFONO(I);
      DBMS_OUTPUT.PUT_LINE('Creando Origen Telefono: '||V_TMP_TIPO_ORI_TELEFONO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_OTE_ORIGEN_TELEFONO (DD_OTE_ID, DD_OTE_CODIGO, DD_OTE_DESCRIPCION,' ||
        'DD_OTE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_ORI_TELEFONO(1)||''','''||V_TMP_TIPO_ORI_TELEFONO(2)||''','''
         ||V_TMP_TIPO_ORI_TELEFONO(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP ORIGEN TELEFONO
   V_TMP_TIPO_ORI_TELEFONO:= NULL;
   V_TIPO_ORI_TELEFONO:= NULL;
   
   
          DBMS_OUTPUT.PUT_LINE('Creando DD_TTE_TIPO_TELEFONO......');
   FOR I IN V_TIPO_TELEFONO.FIRST .. V_TIPO_TELEFONO.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_TTE_TIPO_TELEFONO.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_TELEFONO := V_TIPO_TELEFONO(I);
      DBMS_OUTPUT.PUT_LINE('Creando Origen Telefono: '||V_TMP_TIPO_TELEFONO(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TTE_TIPO_TELEFONO (DD_TTE_ID, DD_TTE_CODIGO, DD_TTE_DESCRIPCION,' ||
        'DD_TTE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_TELEFONO(1)||''','''||V_TMP_TIPO_TELEFONO(2)||''','''
         ||V_TMP_TIPO_TELEFONO(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO TELEFONO
   V_TMP_TIPO_TELEFONO:= NULL;
   V_TIPO_TELEFONO:= NULL;
   
   

   DBMS_OUTPUT.PUT_LINE('Creando DD_GGE_GRUPO_GESTOR......');
   FOR I IN V_TIPO_GGE.FIRST .. V_TIPO_GGE.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_GGE_GRUPO_GESTOR.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_GGE := V_TIPO_GGE(I);
      DBMS_OUTPUT.PUT_LINE('Creando GRUPO_GESTOR: '||V_TMP_TIPO_GGE(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_GGE_GRUPO_GESTOR (DD_GGE_ID, DD_GGE_CODIGO, DD_GGE_DESCRIPCION,' ||
        'DD_GGE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_GGE(1)||''','''||V_TMP_TIPO_GGE(2)||''','''
         ||V_TMP_TIPO_GGE(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_GRUPO_GESTOR
   V_TMP_TIPO_GGE:= NULL;
   V_TIPO_GGE:=NULL;


   DBMS_OUTPUT.PUT_LINE('Creando DD_SSC_SUBSEGMENTO_CLI_ENTIDAD......');
   FOR I IN V_TIPO_SSC.FIRST .. V_TIPO_SSC.LAST
   LOOP
      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SSC_SUBSEGMENTO_CLI_ENT.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_SSC := V_TIPO_SSC(I);
      DBMS_OUTPUT.PUT_LINE('Creando CODIGOS_SSC: '||V_TMP_TIPO_SSC(1));   

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SSC_SUBSEGMENTO_CLI_ENTIDAD(DD_SSC_ID, DD_SSC_CODIGO, DD_SSC_DESCRIPCION,' ||
        'DD_SSC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_SSC(1)||''','''||RTRIM(SUBSTR(V_TMP_TIPO_SSC(2),1,50))||''','''
         ||RTRIM(V_TMP_TIPO_SSC(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP ARG
   V_TMP_TIPO_SSC:= NULL;
   V_TIPO_SSC:= NULL;
   
   
   DBMS_OUTPUT.PUT_LINE('Creando DD_SCE_SEGTO_CLI_ENTIDAD......');
   FOR I IN V_TIPO_SCE.FIRST .. V_TIPO_SCE.LAST
   LOOP
      V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SCE_SEGTO_CLI_ENTIDAD.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_SCE := V_TIPO_SCE(I);
      DBMS_OUTPUT.PUT_LINE('Creando CODIGOS_SCE: '||V_TMP_TIPO_SCE(1));   

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SCE_SEGTO_CLI_ENTIDAD(DD_SCE_ID, DD_SCE_CODIGO, DD_SCE_DESCRIPCION,' ||
        'DD_SCE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_SCE(1)||''','''||RTRIM(SUBSTR(V_TMP_TIPO_SCE(2),1,50))||''','''
         ||RTRIM(V_TMP_TIPO_SCE(3))||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP ARG
   V_TMP_TIPO_SCE:= NULL;
   V_TIPO_SCE:= NULL;   



DBMS_OUTPUT.PUT_LINE('PERSONAS - Habilitamos constraints TIT_TITULO_IBFK_5'); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS ENABLE CONSTRAINTS TIT_TITULO_IBFK_5'); 

DBMS_OUTPUT.PUT_LINE('PERSONAS - Habilitamos constraints FK_PER_PERS_REFERENCE_DD_SCE_S '); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS ENABLE CONSTRAINTS FK_PER_PERS_REFERENCE_DD_SCE_S');  


DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_FK_DD_OTE_ID '); 
EXECUTE IMMEDIATE('ALTER TABLE PER_PERSONAS ENABLE CONSTRAINTS FK_PER_FK_DD_OTE_ID'); 


DBMS_OUTPUT.PUT_LINE('TELEFONOS - Habilitamos constraints FK_TEL_TEL_FK_DD_OTE_TEL'); 
EXECUTE IMMEDIATE('ALTER TABLE TEL_TELEFONOS ENABLE CONSTRAINTS FK_TEL_TEL_FK_DD_OTE_TEL'); 

DBMS_OUTPUT.PUT_LINE('TELEFONOS - Habilitamos constraints FK_TEL_TEL_FK_DD_TTE_TEL '); 
EXECUTE IMMEDIATE('ALTER TABLE TEL_TELEFONOS ENABLE CONSTRAINTS FK_TEL_TEL_FK_DD_TTE_TEL'); 


   
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

