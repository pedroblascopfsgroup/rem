--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200324
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6440
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla para CONFIGRACION ALERTAS PUBLICACION
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_EXISTE NUMBER (1); -- Vlbe. para consultar si la sequencia existe.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
    V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
    V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
    V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
    V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';

    V_TABLA VARCHAR2(32 CHAR) := 'CONF_ALERTAS_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('BANKIA','','Notarial (dación)',	 '0','0','1','1','0','0'),
		T_TIPO_DATA('BANKIA','','',			 '1','1','1','1','0','0'),
		T_TIPO_DATA('SAREB','','',			 '0','0','1','1','0','0'),
		T_TIPO_DATA('CAJAMAR','','',			 '0','0','1','1','0','0'),
		T_TIPO_DATA('LIBERBANK','','',			 '0','1','1','1','1','0'),
		T_TIPO_DATA('CERBERUS','DIVARIAN','',		 '1','0','1','1','0','1'),
		T_TIPO_DATA('CERBERUS','APPLE - INMOBILIARIO','','0','1','1','1','0','0'),
		T_TIPO_DATA('OTRA CARTERA','','',		 '1','0','1','1','0','0')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla borramos
    IF V_NUM_TABLAS = 1 THEN 

	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
        EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' ';
		
    END IF;
	
    --Creamos la tabla
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(

		CARTERA        			VARCHAR2(100 CHAR),          	
		SUBCARTERA			VARCHAR2(100 CHAR),
		SUBTIPO_TITULO			VARCHAR2(100 CHAR),
		INSCRIPCION			NUMBER(1,0),
		CARGAS				NUMBER(1,0),
		POSESION			NUMBER(1,0),
		TIPO_ALQUILER			NUMBER(1,0),
		ALQUILADO			NUMBER(1,0),
		OCUPADO				NUMBER(1,0)
	
    )'; 

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');

	IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

	END IF;

	IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

	END IF;

	IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

	END IF;

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.CARTERA IS ''Descripcion Cartera''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.SUBCARTERA IS ''Descripcion Subcartera''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.SUBTIPO_TITULO IS ''Subtipo titulo''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.INSCRIPCION IS ''Esta inscrito''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.CARGAS IS ''Tiene cargas''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.POSESION IS ''Tiene posesion''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.TIPO_ALQUILER IS ''Tiene tipo de alquiler''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.ALQUILADO IS ''Esta alquilado''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.CONF_ALERTAS_PUBLICACION.OCUPADO IS ''Esta ocupado (sin titulo)''';

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');  
	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (CARTERA, SUBCARTERA, SUBTIPO_TITULO, INSCRIPCION, CARGAS, POSESION,TIPO_ALQUILER, ALQUILADO, OCUPADO) VALUES (' ||
                      ''''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''',' ||
                      ''''||V_TMP_TIPO_DATA(4)||''','''||TRIM(V_TMP_TIPO_DATA(5))||''','''||TRIM(V_TMP_TIPO_DATA(6))||''',' || 
		      ''''||V_TMP_TIPO_DATA(7)||''','''||TRIM(V_TMP_TIPO_DATA(8))||''','''||TRIM(V_TMP_TIPO_DATA(9))||''')';
         
	
	  EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' CREADA CORRECTAMENTE ');


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
