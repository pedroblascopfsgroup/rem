--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20170808
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=HREOS-2339
--## PRODUCTO=SI
--## Finalidad: Insercion registros tabla 
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN
	--TNO: COBRO RECIBIDO
	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TNO_TIPO_NOTIFICACION WHERE DD_TNO_CODIGO = (''AVI_VENC'')';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.DD_TNO_TIPO_NOTIFICACION (DD_TNO_ID, DD_TNO_CODIGO, ETL_NOTIFICADOR, DD_TNO_DESCRIPCION, DD_TNO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
				  VALUES('||V_ESQUEMA_M||'.S_DD_TNO_TIPO_NOTIFICACION.NEXTVAL, ''AVI_VENC'', ''AVISO_VENCIMIENTO_RESERVA'', ''Aviso'', ''Aviso vencimiento de reserva'', ''HREOS-2339'', SYSDATE)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
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
EXIT
