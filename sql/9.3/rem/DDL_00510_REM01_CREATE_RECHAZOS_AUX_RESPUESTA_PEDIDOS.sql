--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17266
--## PRODUCTO=NO
--## Finalidad: Creación diccionario RECHAZOS_AUX_RESPUESTA_PEDIDOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-17266] - Alejandra García
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'RECHAZOS_AUX_RESPUESTA_PEDIDOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		 NUMFACTPROV			VARCHAR2(20 CHAR)
		,FECHAFACT				DATE
		,IMPORTOTAL				NUMBER(15,2)
		,BASE					NUMBER(15,2)
		,TOTIMPUESTOS			NUMBER(15,2)
		,NIF					VARCHAR2(14 CHAR)
		,PROVEEDOR				VARCHAR2(13 CHAR)
		,NUMFACTE				NUMBER(9,0)
		,FECHENTRADA			DATE
        ,ORIGEN                 VARCHAR2(2 CHAR)
		,ESTADO					VARCHAR2(12 CHAR)
		,OBSERVACIONES			VARCHAR2(40 CHAR)
		,NUMFACTUTF				VARCHAR2(10 CHAR)
		,EXTENSION 				VARCHAR2(500 CHAR)
		,FECHA_ULTIMA_SIT		DATE
		,CUENTA_ABONO			VARCHAR2(42 CHAR)
		,REFERENCIA				VARCHAR2(40 CHAR)
		,CLAVEFACTURA			VARCHAR2(13 CHAR)
        ,MOTIVO                 VARCHAR2(70 CHAR)
        ,SITUACION              VARCHAR2(25 CHAR)
        ,SERIE                  VARCHAR2(20 CHAR)
        ,ABONO                  VARCHAR2(1 CHAR)
		
	)
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	-- Creamos comentario   
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.NUMFACTPROV IS ''Num factura proveedor.''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.FECHAFACT IS ''Fecha factura.''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.IMPORTOTAL IS ''Importe total factura.''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.BASE IS ''Base imponible.''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.TOTIMPUESTOS IS ''Total impuesto.''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.NIF IS ''NIF del proveedor.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.PROVEEDOR IS ''Proveedor.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.NUMFACTE IS ''Número interno fac.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.FECHENTRADA IS ''Fecha entrada sistema.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.ORIGEN IS ''Origen.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.ESTADO IS ''Valores: Entregada, Anulada, Pagada.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.OBSERVACIONES IS ''Se rellena cuando el estado sea Anulada.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.NUMFACTUTF IS ''Número interno Cobsa.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.FECHA_ULTIMA_SIT IS ''fecha de la última acción sobre la factura.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.CUENTA_ABONO IS ''Cuenta abono.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.REFERENCIA IS ''Referencia/Pedido.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.CLAVEFACTURA IS ''Clave factura.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.MOTIVO IS ''Campo observaciones de factura.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');    

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.SITUACION IS ''Situación en FAC.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');    

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.SERIE IS ''Serie de la factura.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');    

    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.RECHAZOS_AUX_RESPUESTA_PEDIDOS.ABONO IS ''N-factura de cargo, S-factura de abono.''';          
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');        
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
		
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

EXIT;
