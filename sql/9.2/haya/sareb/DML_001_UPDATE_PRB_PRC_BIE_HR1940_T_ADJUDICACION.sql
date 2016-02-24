--/*
--##########################################
--## AUTOR=SALVADOR GORRITA
--## FECHA_CREACION=20160223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-1940
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICAR TABLA COMENTARIOS_VENTA_CARTERA
--## INSTRUCCIONES: EJECUTAR Y LISTO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
    
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PRB_PRC_BIE'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 1 THEN
		V_MSQL:= 'UPDATE '||V_ESQUEMA|| '.PRB_PRC_BIE SET USUARIOBORRAR = NULL, FECHABORRAR = NULL , BORRADO = 0 ' ||
			' WHERE PRC_ID = 1000000000038617' ||
	        ' AND BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA|| '.BIE_BIEN WHERE BIE_CODIGO_BIEN = 000009290000000000002151091000000000000000)';
		
	    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.PRB_PRC_BIE');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No se han podido actualizar los registros de la tabla '||V_ESQUEMA||'.PRB_PRC_BIE');
	END IF;
	
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
