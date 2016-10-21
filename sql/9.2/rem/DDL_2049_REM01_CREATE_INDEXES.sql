--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE 
--## FECHA_CREACION=20161020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Crear diferentes índices si no existen para las vistas materializadas.
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
    V_TEXT_TABLA1 VARCHAR2(2400 CHAR) := 'ACT_HVA_HIST_VALORACIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'ACT_CAT_CATASTRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA3 VARCHAR2(2400 CHAR) := 'GEE_GESTOR_ENTIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA4 VARCHAR2(2400 CHAR) := 'DD_TGE_TIPO_GESTOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA5 VARCHAR2(2400 CHAR) := 'ACT_LOC_LOCALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.



BEGIN
	
	
	

	
	
	DBMS_OUTPUT.PUT_LINE('********Creación índices en ' ||V_TEXT_TABLA2|| '********'); 
	V_SQL := 'SELECT COUNT(1)
	  FROM (
	       SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
	       FROM ALL_IND_COLUMNS
	       WHERE table_name = ''' || V_TEXT_TABLA2 || ''' and index_owner=''' || V_ESQUEMA || '''
	       GROUP BY index_name
	       ) sqli
	--en el where tenemos cuidado de ponerlos alfabericamente
	WHERE sqli.columnas = ''ACT_ID, CAT_ID, CAT_REF_CATASTRAL''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el índice. Se creará '||V_ESQUEMA||'.CAT_ACT_REF_IDX.');  
		
		SELECT COUNT(1) INTO V_TEXT1 FROM ALL_INDEXES WHERE TABLE_NAME = V_TEXT_TABLA2 AND OWNER=V_ESQUEMA AND INDEX_NAME='CAT_ACT_REF_IDX';
		IF V_TEXT1 = 0 THEN
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.CAT_ACT_REF_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA2||'(ACT_ID, CAT_ID, CAT_REF_CATASTRAL) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.CAT_ACT_REF_IDX... Indice creado.');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe un índice sobre las columnas (ACT_ID, CAT_ID, CAT_REF_CATASTRAL) ');  
	END IF; 
	
	
	

	
	DBMS_OUTPUT.PUT_LINE('********Creación índices en ' ||V_TEXT_TABLA3|| '********'); 
	V_SQL := 'SELECT COUNT(1)
	  FROM (
	       SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
	       FROM ALL_IND_COLUMNS
	       WHERE table_name = ''' || V_TEXT_TABLA3 || ''' and index_owner=''' || V_ESQUEMA || '''
	       GROUP BY index_name
	       ) sqli
	--en el where tenemos cuidado de ponerlos alfabericamente
	WHERE sqli.columnas = ''DD_TGE_ID, GEE_ID, USU_ID''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el índice. Se creará '||V_ESQUEMA||'.GEE_TGE_USU_IDX.');  
		
		SELECT COUNT(1) INTO V_TEXT1 FROM ALL_INDEXES WHERE TABLE_NAME = V_TEXT_TABLA3 AND OWNER=V_ESQUEMA AND INDEX_NAME='GEE_TGE_USU_IDX';
		IF V_TEXT1 = 0 THEN
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.GEE_TGE_USU_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA3||'(DD_TGE_ID, GEE_ID, USU_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.GEE_TGE_USU_IDX... Indice creado.');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe un índice sobre las columnas (DD_TGE_ID, GEE_ID, USU_ID) ');  
	END IF; 
	
	
	
	
	
	
	DBMS_OUTPUT.PUT_LINE('********Creación índices en ' ||V_TEXT_TABLA4|| '********'); 
	V_SQL := 'SELECT COUNT(1)
	  FROM (
	       SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
	       FROM ALL_IND_COLUMNS
	       WHERE table_name = ''' || V_TEXT_TABLA4 || ''' and index_owner=''' || V_ESQUEMA || '''
	       GROUP BY index_name
	       ) sqli
	--en el where tenemos cuidado de ponerlos alfabericamente
	WHERE sqli.columnas = ''DD_TGE_CODIGO, DD_TGE_ID''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el índice. Se creará '||V_ESQUEMA||'.TGECOD_TGEID_IDX.');  
		
		SELECT COUNT(1) INTO V_TEXT1 FROM ALL_INDEXES WHERE TABLE_NAME = V_TEXT_TABLA4 AND OWNER=V_ESQUEMA AND INDEX_NAME='TGECOD_TGEID_IDX';
		IF V_TEXT1 = 0 THEN
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.TGECOD_TGEID_IDX ON '||V_ESQUEMA_M|| '.'||V_TEXT_TABLA4||'(DD_TGE_CODIGO, DD_TGE_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA_M||'.TGECOD_TGEID_IDX... Indice creado.');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe un índice sobre las columnas (DD_TGE_CODIGO, DD_TGE_ID) ');  
	END IF; 
	

	
	
	DBMS_OUTPUT.PUT_LINE('********Creación índices realizada ********'); 

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
