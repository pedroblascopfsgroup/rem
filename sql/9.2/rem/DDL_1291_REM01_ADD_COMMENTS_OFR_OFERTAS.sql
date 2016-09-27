--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir comentarios a las tablas
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
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    	T_ALTER('OFR_OFERTAS','OFR_ID','Id de la oferta'),
		T_ALTER('OFR_OFERTAS','OFR_NUM_OFERTA','Número de la oferta'),
		T_ALTER('OFR_OFERTAS','OFR_WEBCOM_ID','Id de webcom'),
		T_ALTER('OFR_OFERTAS','AGR_ID','Id de la agrupación'),
		T_ALTER('OFR_OFERTAS','OFR_IMPORTE','Importe oferta'),
		T_ALTER('OFR_OFERTAS','CLC_ID','Id cliente comercial'),
		T_ALTER('OFR_OFERTAS','DD_EOF_ID','Estado de la oferta'),
		T_ALTER('OFR_OFERTAS','DD_TOF_ID','Tipo de Oferta'),
		T_ALTER('OFR_OFERTAS','VIS_ID','Id de la visita '),
		T_ALTER('OFR_OFERTAS','DD_EVO_ID','Estado de la visita para la oferta'),
		T_ALTER('OFR_OFERTAS','OFR_FECHA_ACCION','Fecha de acción'),
		T_ALTER('OFR_OFERTAS','OFR_FECHA_ALTA','Fecha de alta'),
		T_ALTER('OFR_OFERTAS','OFR_FECHA_NOTIFICACION','Fecha de notificación'),
		T_ALTER('OFR_OFERTAS','OFR_IMPORTE_CONTRAOFERTA','Importe contraoferta'),
		T_ALTER('OFR_OFERTAS','OFR_FECHA_CONTRAOFERTA','Fecha contraoferta'),
		T_ALTER('OFR_OFERTAS','USU_ID','Id de usuario que realiza una acción'),
		T_ALTER('OFR_OFERTAS','PVE_ID_PRESCRIPTOR','Id proveedor del subscriptor'),
		T_ALTER('OFR_OFERTAS','PVE_ID_API_RESPONSABLE','Id del proveedor responsable'),
		T_ALTER('OFR_OFERTAS','PVE_ID_CUSTODIO','Id del proveedor custodio'),
		T_ALTER('OFR_OFERTAS','PVE_ID_FDV','Id del proveedor FDV')
		);
    V_T_ALTER T_ALTER;


BEGIN
	

	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna EXISTE.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(2)||''' and TABLE_NAME = '''||V_T_ALTER(1)||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_ALTER(1)||'.'||V_T_ALTER(2)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(1)||'.'||V_T_ALTER(2)||'... Comentario en columna creado.');
		END IF;

	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(1)||' Añadidos comentarios ... OK *************************************************');
	COMMIT;	


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