--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160531
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1657
--## PRODUCTO=NO
--##
--## Finalidad: 
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
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.


	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.EXT_DD_IFC_INFO_CONTRATO
			SET DD_IFC_DESCRIPCION = ''HCJ Valor Bruto Contable'',
			DD_IFC_DESCRIPCION_LARGA = ''HCJ Valor Bruto Contable'',
			USUARIOMODIFICAR = ''PRODUCTO-1657'',
			FECHAMODIFICAR = SYSDATE
			WHERE UPPER(DD_IFC_CODIGO) = ''NUM_EXTRA1''
			AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.EXT_DD_IFC_INFO_CONTRATO
			SET DD_IFC_DESCRIPCION = ''HCJ Valor Neto Contable'',
			DD_IFC_DESCRIPCION_LARGA = ''HCJ Valor Neto Contable'',
			USUARIOMODIFICAR = ''PRODUCTO-1657'',
			FECHAMODIFICAR = SYSDATE
			WHERE UPPER(DD_IFC_CODIGO) = ''NUM_EXTRA3''
			AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
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
