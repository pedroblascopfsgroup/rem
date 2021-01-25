--/*
--##########################################
--## AUTOR=Dean Ibañez VIño
--## FECHA_CREACION=20200827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10915
--## PRODUCTO=NO
--## Finalidad: Creacion ACT_BBVA_ST1_RECHAZADOS
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
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_BBVA_ST1_RECHAZADOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe.');
		
    ELSE
            -- Creamos la tabla
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
            V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
            (
                AUX_OPERACION	            VARCHAR2(1 CHAR)
                ,AUX_FECHA_OPERACION	    VARCHAR2(10 CHAR)
                ,AUX_FECHA_PROCESO	        VARCHAR2(10 CHAR)
                ,AUX_SOCIEDAD	            VARCHAR2(4 CHAR)
                ,AUX_NUM_ACTIVO	            VARCHAR2(12 CHAR)
                ,AUX_SUBNACTIVO	            VARCHAR2(4 CHAR)
                ,AUX_NUMEROINTERNO	        VARCHAR2(6 CHAR)
                ,AUX_NUMFINCAREG	        VARCHAR2(14 CHAR)
                ,AUX_SUPRANUMERO	        VARCHAR2(12 CHAR)
                ,AUX_CEXPER	                VARCHAR2(9 CHAR)
                ,AUX_CLASE	                VARCHAR2(8 CHAR)
                ,AUX_TIPO_INMUEBLE	        VARCHAR2(2 CHAR)
                ,AUX_PAIS_INMUEBLE	        VARCHAR2(3 CHAR)
                ,AUX_LOCALIDAD_INMUEBLE	    VARCHAR2(30 CHAR)
                ,AUX_CP	                    VARCHAR2(5 CHAR)
                ,AUX_COD_PROVINCIA	        VARCHAR2(2 CHAR)
                ,AUX_DIR_INMUEBLE_1	        VARCHAR2(50 CHAR)
                ,AUX_DIR_INMUEBLE_2	        VARCHAR2(50 CHAR)
                ,AUX_IMPORTANYOARREN	    VARCHAR2(13 CHAR)
                ,AUX_FECHAINIARREN	        VARCHAR2(10 CHAR)
                ,AUX_FECHAFINARREN	        VARCHAR2(10 CHAR)
                ,AUX_VALCONTA_ACT_TER	    VARCHAR2(13 CHAR)
                ,AUX_VALCONTA_ACT_EDI	    VARCHAR2(13 CHAR)
                ,AUX_VALCONTA_ANT_TER	    VARCHAR2(13 CHAR)
                ,AUX_VALCONTA_ANT_EDI	    VARCHAR2(13 CHAR) 
                ,AUX_PORC_EDI	            VARCHAR2(10 CHAR)
                ,AUX_AMACUM	                VARCHAR2(13 CHAR)
                ,AUX_PROV_ANT	            VARCHAR2(13 CHAR)
                ,AUX_PROV_SAN	            VARCHAR2(13 CHAR)
                ,AUX_PROV_SUC	            VARCHAR2(13 CHAR)
                ,AUX_COMISION	            VARCHAR2(13 CHAR)
                ,AUX_RESULTADO_VENTA	    VARCHAR2(13 CHAR)
                ,AUX_SALDOMOAD	            VARCHAR2(13 CHAR)
                ,AUX_PROVINDISPONI	        VARCHAR2(13 CHAR)
                ,AUX_PROVMORA	            VARCHAR2(13 CHAR)
                ,AUX_RESTOFONDOINSOLV	    VARCHAR2(13 CHAR)
                ,AUX_FECHAPROXMORA	        VARCHAR2(10 CHAR)
                ,AUX_IMPORTEPROXMORA	    VARCHAR2(13 CHAR)
                ,AUX_FECHAPROXDISPO	        VARCHAR2(10 CHAR)
                ,AUX_IMPORTEPROXDISPO	    VARCHAR2(13 CHAR)
                ,AUX_FECHA_ADJUDICACION	    VARCHAR2(10 CHAR)
                ,AUX_IMPORTE_ADJ	        VARCHAR2(13 CHAR)
                ,AUX_CATASTRO	            VARCHAR2(10 CHAR)
                ,AUX_REFCSTRAL	            VARCHAR2(26 CHAR)
                ,AUX_TIPO_GAR	            VARCHAR2(1 CHAR)
                ,AUX_FECHAREF	            VARCHAR2(10 CHAR)
                ,AUX_SUCORIGEN	            VARCHAR2(10 CHAR)
                ,AUX_FECHA_BAJA_INMU	    VARCHAR2(10 CHAR)
                ,AUX_INDICADORBAJA	        VARCHAR2(1 CHAR)
                ,AUX_FECHACONTA	            VARCHAR2(10 CHAR)
                ,AUX_SUPERFICIECONS	        VARCHAR2(15 CHAR)
                ,AUX_COEF	                VARCHAR2(10 CHAR)
                ,AUX_MODIFICA	            VARCHAR2(1 CHAR)
                ,AUX_PORC_REP	            VARCHAR2(10 CHAR)
                ,AUX_NOMBREARREN	        VARCHAR2(40 CHAR)
                ,AUX_NIFARREN	            VARCHAR2(9 CHAR)
                ,AUX_DIRARREN	            VARCHAR2(40 CHAR)
                ,AUX_CPOSTALARREN	        VARCHAR2(5 CHAR)
                ,AUX_PROVARREN	            VARCHAR2(2 CHAR)
                ,AUX_LOCALARREN	            VARCHAR2(40 CHAR)
                ,AUX_NOMBREMOROSO	        VARCHAR2(30 CHAR)
                ,AUX_NIFMOROSO	            VARCHAR2(9 CHAR)
                ,AUX_VIALMOROSO	            VARCHAR2(2 CHAR)
                ,AUX_DIRMOROSO	            VARCHAR2(32 CHAR)
                ,AUX_NUMEROMOROSO	        VARCHAR2(5 CHAR)
                ,AUX_CPOSTALMOROSO	        VARCHAR2(5 CHAR)
                ,AUX_PROVMOROSO	            VARCHAR2(2 CHAR)
                ,AUX_LOCALMOROSO	        VARCHAR2(40 CHAR)
                ,AUX_NOMBREAVALISTA	        VARCHAR2(40 CHAR)
                ,AUX_NIFAVALISTA	        VARCHAR2(9 CHAR)
                ,AUX_DIRAVALISTA	        VARCHAR2(40 CHAR)
                ,AUX_CPOSTALAVALISTA	    VARCHAR2(5 CHAR)
                ,AUX_PROVAVALISTA	        VARCHAR2(2 CHAR)
                ,AUX_LOCALAVALISTA	        VARCHAR2(30 CHAR)
                ,AUX_RESTOFINCAS	        VARCHAR2(250 CHAR)
                ,AUX_RESTOFINCAS2	        VARCHAR2(199 CHAR)
                ,AUX_AFDESTINO	            VARCHAR2(12 CHAR)
                ,AUX_AGREGPROINDI	        VARCHAR2(1 CHAR)
                ,AUX_IUC	                VARCHAR2(32 CHAR)
                ,AUX_IDUFIR	                VARCHAR2(14 CHAR)
                ,AUX_REST_IDUFIR	        VARCHAR2(200 CHAR)
                ,AUX_REST_IDUFIR_2	        VARCHAR2(199 CHAR)
                ,AUX_DELIMITADOR	        VARCHAR2(1 CHAR)
                ,AUX_SALTO	                VARCHAR2(1 CHAR)
            )
            LOGGING 
            NOCOMPRESS 
            NOCACHE
            NOPARALLEL
            NOMONITORING
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');


            -- Creamos comentario
            V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Hoja ST1-Información de activos - Columna Descripción.''';
		    EXECUTE IMMEDIATE V_MSQL;	

            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados.');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

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
