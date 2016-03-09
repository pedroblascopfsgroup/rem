--/*
--##########################################
--## AUTOR=IVAN PICAZO PICAZO
--## FECHA_CREACION=20160308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2052
--## PRODUCTO=SI
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Migración de datos de la tabla DD_TPI_TIPO_IMPOSICION a DD_IMV_IMPOSICION_VENTA
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    v_numero NUMBER(16);
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

BEGIN    
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION WHERE DD_TPI_ID IN (SELECT DISTINCT DD_TPIV_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE DD_TPIV_ID IS NOT NULL) ' ||
         ' AND DD_TPI_ID NOT IN (SELECT DD_IMV_ID FROM '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA)';
	
	EXECUTE IMMEDIATE V_SQL INTO v_numero;
	
  		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA' ||
				 ' (DD_IMV_ID, DD_IMV_CODIGO, DD_IMV_DESCRIPCION, DD_IMV_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
				 ' SELECT DD_TPI_ID, DD_TPI_ID+1000, DD_TPI_DESCRIPCION, DD_TPI_DESCRIPCION_LARGA, VERSION, ''HR-2052'', SYSDATE, 1 '||
				' FROM '||V_ESQUEMA_M||'.DD_TPI_TIPO_IMPOSICION WHERE DD_TPI_ID IN (SELECT DISTINCT DD_TPIV_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE DD_TPIV_ID IS NOT NULL) ' ||
         ' AND DD_TPI_ID NOT IN (SELECT DD_IMV_ID FROM '||V_ESQUEMA_M||'.DD_IMV_IMPOSICION_VENTA)';
		EXECUTE IMMEDIATE V_MSQL;
				
			
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||v_numero||' registros insertados en la tabla DD_IMV_IMPOSICION_VENTA ');

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