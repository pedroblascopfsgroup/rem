--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20180314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=HREOS-3916
--## PRODUCTO=NO
--## Finalidad: Se crea la tabla diccionario TMP_ACT_TO_GEN_TRB_CEE relaciona.
--## 
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuración Tablespace de Índices.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(27 CHAR) := 'TMP_ACT_TO_GEN_TRB_CEE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla temporal para guardar los activos que debemos crear trabajo de CEE.'; -- Vble. para los comentarios de las tablas.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 1 THEN
        V_MSQL := 'DROP TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Borrada.'); 		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... No existe.'); 
	END IF;

    -- Crear la tabla.
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
    V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
        (
            ACT_ID                  NUMBER(16)          NOT NULL,
            TBJ_ID                  NUMBER(16)          NOT NULL,
            TRA_ID                  NUMBER(16)          NOT NULL,
            TAR_ID                  NUMBER(16)          NOT NULL,
            TEX_ID                  NUMBER(16)          NOT NULL,
            ADO_FECHA_CALIFICACION  DATE                ,
            ADO_FECHA_CADUCIDAD     DATE                ,
            ACT_DESCRIPCION         VARCHAR2(250 CHAR)  ,
            USU_ID_GESTOR           NUMBER(16)          ,
            USU_ID_SUPERVISOR       NUMBER(16)          
        )
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');

	-- Crear comentario.
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID IS ''Clave principal con su correspondiente secuencia''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID ... Comentario creado.');
            
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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
