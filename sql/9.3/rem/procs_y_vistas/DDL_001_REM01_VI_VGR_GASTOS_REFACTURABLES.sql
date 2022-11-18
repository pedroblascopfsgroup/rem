--/*
--##########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20221114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11281
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-11281 - Juan Alfonso - Añadir a Titulizadas y BFA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_VIEWNAME VARCHAR2(30):= 'VGR_GASTOS_REFACTURABLES';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
V_MSQL := ('CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||'(NUM_GASTO_HAYA) AS
	SELECT GPV.GPV_NUM_GASTO_HAYA
	FROM '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE
	LEFT JOIN '||V_ESQUEMA||'.GRG_REFACTURACION_GASTOS GRG ON GRG.GRG_GPV_ID_REFACTURADO= GDE.GPV_ID AND GRG.BORRADO=0 
	INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GDE.GPV_ID=GPV.GPV_ID AND GPV.BORRADO=0
	INNER JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON GPV.DD_DEG_ID=DEG.DD_DEG_ID AND DD_DEG_CODIGO=''02'' AND DEG.BORRADO=0
	INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID AND PRO.BORRADO=0
	INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.dd_cra_id=pro.DD_CRA_ID AND DD_CRA_CODIGO in (''02'',''03'',''18'',''17'') AND CRA.BORRADO=0
	WHERE GDE.GDE_GASTO_REFACTURABLE=1 AND GRG.GRG_ID IS NULL');

execute immediate V_MSQL;

--/* Recompilar nueva vista
--************************************************************/
execute immediate ('alter view '||V_ESQUEMA||'.'||V_VIEWNAME||' compile');


COMMIT;

DBMS_OUTPUT.PUT_LINE('OK modificada');

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
	  DBMS_OUTPUT.put_line('--------------------------------SQL------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;          

END;

/

EXIT
