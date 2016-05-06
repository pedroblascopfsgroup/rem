--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v_Febrero
--## INCIDENCIA_LINK=CMREC-2026
--## PRODUCTO=SI
--## Finalidad: Actualizar filas repetidas.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN
    
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''CRI_CONTRATO_RIESGOOPERACIONAL'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 1 THEN
		V_MSQL:= 'UPDATE '||V_ESQUEMA|| '.CRI_CONTRATO_RIESGOOPERACIONAL SET BORRADO = 1, FECHABORRAR=SYSDATE, USUARIOBORRAR = ''JLG'' WHERE CRI_ID IN' ||
			' (SELECT CRI_ID FROM (SELECT CRI_ID, CNT_ID, ROW_NUMBER() OVER (PARTITION BY CNT_ID ORDER BY CRI_ID DESC) ORD' ||
	        ' FROM '||V_ESQUEMA|| '.CRI_CONTRATO_RIESGOOPERACIONAL WHERE BORRADO = 0) WHERE ORD > 1)';
		
	    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No se han podido actualizar los registros de la tabla '||V_ESQUEMA||'.CRI_CONTRATO_RIESGOOPERACIONAL');
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

EXIT	