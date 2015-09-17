--/*
--##########################################
--## AUTOR=Alberto Campos 
--## FECHA_CREACION=20150917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5
--## INCIDENCIA_LINK=CMREC-715
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TASADORA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TASADORA IS TABLE OF T_TASADORA;
    V_TASADORA T_ARRAY_TASADORA := T_ARRAY_TASADORA(
      T_TASADORA('01','01','VALORACIONES DEL MEDITERRÁNEO S.A.', '010005977631VALMESA-VALORACIONES DEL MEDITERRÁNEO S.A.', 'DML'),
      T_TASADORA('02','02','SOCIEDAD DE TASACIÓN S.A.', '020012724057SOCIEDAD DE TASACIÓN S.A.', 'DML'),
      T_TASADORA('07','07','TINSA', '070090247314TASACIONES INMOBILIARIAS S.A.', 'DML'),
      T_TASADORA('11','11','ARCO VALORACIONES S.A.', '11210134019ARCO VALORACIONES S.A.', 'DML'),
      T_TASADORA('12','12','ALIA TASACIONES', '120101471567ALIA TASACIONES', 'DML'),
      T_TASADORA('13','13','AFES TASACIONES', '130200060482AFES TASACIONES', 'DML'),
      T_TASADORA('14','14','IBERTASA', '140300102514IBERTASA', 'DML'),
      T_TASADORA('15','15','GESVALT', '150093068602GESVALT', 'DML'),
      T_TASADORA('16','16','EUROVALORACIONES S.A.', '160101167325EUROVALORACIONES S.A.', 'DML'),
      T_TASADORA('17','17','TERRA VT SOCIEDAD DE TASACIONES INMOBILIARIAS S.A.', '172112030610TERRA VT SOCIEDAD DE TASACIONES INMOBILIARIAS S.A.', 'DML'),
      T_TASADORA('18','18','TECNITASA', '180020483425TÉCNICOS EN TASACIÓN S.A.', 'DML'),
      T_TASADORA('19','19','KRATA', '192110141644KRATA, S.A. SOCIEDAD DE TASACIÓN', 'DML'),
      T_TASADORA('20','20','OFICINA DE TASACIONES S.A.', '20210000390OFICINA DE TASACIONES S.A.', 'DML')
    ); 
    V_TMP_TASADORA T_TASADORA;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DD_TRA_TASADORA ********'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.BIE_VALORACIONES BVA, '||V_ESQUEMA||'.DD_TRA_TASADORA TRA WHERE BVA.DD_TRA_ID = TRA.DD_TRA_ID';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.DD_TRA_TASADORA ...no se modificará nada.');
	ELSE
		V_SQL := 'DELETE FROM '||V_ESQUEMA||'.DD_TRA_TASADORA TRA';
		EXECUTE IMMEDIATE V_SQL;

		-- LOOP Insertando valores en DD_TRA_TASADORA
	    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_TRA_TASADORA... Empezando a insertar datos en el diccionario');
	    
	        FOR I IN V_TASADORA.FIRST .. V_TASADORA.LAST
		      LOOP
		      V_TMP_TASADORA := V_TASADORA(I);
		                  
		                  V_SQL := 'SELECT COUNT(1) FROM DD_TRA_TASADORA WHERE DD_TRA_CODIGO = '''||TRIM(V_TMP_TASADORA(1))||'''';
		                  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		                  -- Si existe la TASADORA
		                  IF V_NUM_TABLAS > 0 THEN                                
		                          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TRA_TASADORA... Ya existe la TASADORA '''|| TRIM(V_TMP_TASADORA(1))||'''');
		                  ELSE            
		                          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TRA_TASADORA (' ||
		                                    'DD_TRA_ID, DD_TRA_CODIGO, DD_TRA_DESCRIPCION, DD_TRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)' ||
		                                    'VALUES('||V_TMP_TASADORA(1)||', '''||V_TMP_TASADORA(2)||''', '''||TRIM(V_TMP_TASADORA(3))||''', '''||  
		                                    ''||V_TMP_TASADORA(4)||''','''||TRIM(V_TMP_TASADORA(5))||''','|| 
		                                    'SYSDATE,0 )';
		                          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TASADORA(2)||''','''||TRIM(V_TMP_TASADORA(3))||'''');
		                          EXECUTE IMMEDIATE V_MSQL;
		                  END IF;
		      END LOOP;
	    COMMIT;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_TRA_TASADORA... Datos del diccionario insertado');
	
	END IF;	   

    COMMIT;
	
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
