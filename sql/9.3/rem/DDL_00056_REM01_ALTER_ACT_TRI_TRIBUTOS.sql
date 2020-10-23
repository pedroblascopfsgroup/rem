--/*
--##########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20200709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10458
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar valores del diccionario DD_TST_TIPO_SOLICITUD_TRIB
--## INSTRUCCIONES:
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TRI_TRIBUTOS';  -- Tabla a modificar
    V_TABLA_DOS VARCHAR2(30 CHAR) := 'ACT_ADT_ADJUNTO_TRIBUTOS';  -- Tabla a RETIRAR REGISTROS.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-10457'; -- USUARIOBORRAR
    V_COUNT NUMBER(16); 
    
BEGIN				
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_TRI_FECHA_RECEPCION_TRIBUTO IS NULL';
	
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZACION COLUMNA ACT_TRI_FECHA_RECEPCION_TRIBUTO');
			V_MSQL := 'update '||V_ESQUEMA||'.'||V_TABLA||' set ACT_TRI_FECHA_RECEPCION_TRIBUTO = ''01/01/1900''
						where ACT_TRI_FECHA_RECEPCION_TRIBUTO is null';
			EXECUTE IMMEDIATE V_MSQL;

        END IF;
        
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TPT_ID IS NULL';
	
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZACION COLUMNA DD_TPT_ID');
			V_MSQL := 'update '||V_ESQUEMA||'.'||V_TABLA||' set DD_TPT_ID = (SELECT DD_TPT_ID FROM DD_TPT_TIPO_TRIBUTO WHERE DD_TPT_CODIGO = 14)
						where DD_TPT_ID is null';
			EXECUTE IMMEDIATE V_MSQL;

        END IF;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] SE MIRA DE MODIFICAR LA NULLABILIDAD DE LAS COLUMNAS');
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME like ''%ACT_TRI_FECHA_RECEPCION_PROPIETARIO%'' AND NULLABLE LIKE ''N'' AND OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] SE MODIFICAR LA COLUMNA ACT_TRI_FECHA_RECEPCION_PROPIETARIO');

		--se borra el campo  GPV_ID not null, debido a que causa conflicto con la parte de front, aunque el campo en bbdd deberia ser not null
	        V_MSQL :=   'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
	                    modify (
								ACT_TRI_FECHA_RECEPCION_PROPIETARIO null,
								ACT_TRI_FECHA_RECEPCION_GESTORIA null,
								DD_TST_ID null,
								ACT_TRI_FECHA_RECEPCION_RECURSO_PROPIETARIO null,
								ACT_TRI_FECHA_RECEPCION_RECURSO_GESTORIA null,
								ACT_TRI_FECHA_RESPUESTA_RECURSO null,
								DD_FAV_ID null,
								DD_TPT_ID not null,
								ACT_TRI_FECHA_RECEPCION_TRIBUTO default sysdate not null	
						)';        
	    	EXECUTE IMMEDIATE V_MSQL;

        END IF;
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HA MODIFICADO LA NULLABILIDAD DE LAS COLUMNAS');
        
        
        DBMS_OUTPUT.PUT_LINE('[FIN] registros modificados correctamente.');
        
        COMMIT;
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT