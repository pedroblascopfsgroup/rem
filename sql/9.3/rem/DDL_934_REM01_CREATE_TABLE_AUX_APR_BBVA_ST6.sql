--/*
--##########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20200905
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10975
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar guardar los datos del fichero ST6 en AUX_APR_BBVA_ST6
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_BBVA_ST6'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Procedemos a borrarla.');
		V_MSQL := 'DROP TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla borrada.');
    END IF;
            -- Creamos la tabla
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
            V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
            (
                OPERACION                   VARCHAR2(1 CHAR)
                ,FECHA_PROCESO              VARCHAR2(10 CHAR)
                ,CONTRATO_MORA              VARCHAR2(9 CHAR)
                ,SOCIEDAD                   VARCHAR2(4 CHAR)
                ,NUMERO_ACTIVO_SAP          VARCHAR2(12 CHAR)
                ,SUBNUMERO_ACTIVO_SAP       VARCHAR2(4 CHAR)
                ,NUM_INTERNO                VARCHAR2(6 CHAR)
                ,CLASE                      VARCHAR2(8 CHAR)
                ,TIPO_INMUEBLE              VARCHAR2(2 CHAR)
                ,CALLE_INMUEBLE             VARCHAR2(50 CHAR)
                ,NUMERO_INMUEBLE            VARCHAR2(4 CHAR)
                ,CALLE_INMUEBLE_2           VARCHAR2(50 CHAR)
                ,NUMERO_INMUEBLE_2          VARCHAR2(4 CHAR)
                ,LOCALIDAD                  VARCHAR2(30 CHAR)
                ,PROVINCIA                  VARCHAR2(2 CHAR)
                ,CODIGO_POSTAL              VARCHAR2(5 CHAR)
                ,PAIS                       VARCHAR2(3 CHAR)
                ,SITUACION_REGISTRAL        VARCHAR2(1 CHAR)
                ,FECHA_DISPONIBILIDAD       VARCHAR2(10 CHAR)
                ,PROTOCOLO_ADJUD            VARCHAR2(7 CHAR)
                ,CALLE_JUZGADO              VARCHAR2(20 CHAR)
                ,NUMERO_JUZGADO             VARCHAR2(5 CHAR)
                ,NUM_FINCA_REGISTRAL        VARCHAR2(14 CHAR)
                ,CATASTRO                   VARCHAR2(10 CHAR)
                ,REFERENCIA_CATASTRAL       VARCHAR2(26 CHAR)
                ,SUPERFICIE                 VARCHAR2(15 CHAR)
                ,OFICINA_VENDEDORA          VARCHAR2(10 CHAR)
                ,COMISION_EXTERNA           VARCHAR2(13 CHAR)
                ,PRECIO_VENTA               VARCHAR2(13 CHAR)
                ,NOMBRE_CLIENTE             VARCHAR2(40 CHAR)
                ,APELLIDO_1                 VARCHAR2(40 CHAR)
                ,APELLIDO_2                 VARCHAR2(40 CHAR)
                ,TIPO_IDENTIFICADOR         VARCHAR2(1 CHAR)
                ,NIF_COMPRADOR              VARCHAR2(9 CHAR)
                ,CALLE_COMPRADOR            VARCHAR2(50 CHAR)
                ,NUMERO_COMPRADOR           VARCHAR2(4 CHAR)
                ,CP_COMPRADOR               VARCHAR2(5 CHAR)
                ,LOCALIDAD_COMPRADOR        VARCHAR2(30 CHAR)
                ,PROVINCIA_COMPRADOR        VARCHAR2(2 CHAR)
                ,PAIS_COMPRADOR             VARCHAR2(3 CHAR)
                ,FECHA_VENTA                VARCHAR2(10 CHAR)
                ,TIPO_CONTRATO              VARCHAR2(2 CHAR)
                ,RESTO_FINCAS_1             VARCHAR2(225 CHAR)
                ,RESTO_FINCAS_2             VARCHAR2(225 CHAR)
                ,PROINDIVISO                VARCHAR2(10 CHAR)
                ,POLIVALENTE                VARCHAR2(1 CHAR)
                ,COD_EMPRESA_TITULIZADORA   VARCHAR2(4 CHAR)
                ,NIF_EMPRESA_TITULIZADORA   VARCHAR2(16 CHAR)
                ,IUC                        VARCHAR2(32 CHAR)
                ,IDUFIR                     VARCHAR2(14 CHAR)
                ,REST_IDUFIR_1              VARCHAR2(225 CHAR)
                ,REST_IDUFIR_2              VARCHAR2(225 CHAR)
                ,PROCEDENCIA_LEASING        VARCHAR2(2 CHAR)
                ,SIT_COMERCIAL              VARCHAR2(15 CHAR)
                ,PRECIO_TARIFA              VARCHAR2(14 CHAR)
                ,FECHA_INICIO_TARIFA        VARCHAR2(10 CHAR)
                ,PROMOCION                  VARCHAR2(18 CHAR)
                ,COD_ERROR_SAP              VARCHAR2(3 CHAR)
                ,ERROR_SAP                  VARCHAR2(200 CHAR)
            )
            LOGGING 
            NOCOMPRESS 
            NOCACHE
            NOPARALLEL
            NOMONITORING
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');


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