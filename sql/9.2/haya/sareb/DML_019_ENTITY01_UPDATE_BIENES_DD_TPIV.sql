--/*
--##########################################
--## AUTOR=José Luis Gauxachs	
--## FECHA_CREACION=20160419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2289
--## PRODUCTO=NO
--## Finalidad: Actualizar valores en la columna DD_TPIV de la tabla BIENES.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.BIE_BIEN SET DD_TPIV_ID =(SELECT DD_IMV_ID FROM '|| V_ESQUEMA_M ||'.DD_IMV_IMPOSICION_VENTA WHERE DD_IMV_CODIGO = ''10'') ' ||
			', USUARIOMODIFICAR = ''HR-2289'', FECHAMODIFICAR = SYSDATE' ||	
			' WHERE DD_TPIV_ID = (SELECT DD_IMV_ID FROM '|| V_ESQUEMA_M ||'.DD_IMV_IMPOSICION_VENTA WHERE DD_IMV_CODIGO = ''1021'')';
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');

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
