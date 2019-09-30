--/*
--##########################################
--## AUTOR=Salvador Puertes
--## FECHA_CREACION=20190718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.16.0
--## INCIDENCIA_LINK=HREOS-6989
--## PRODUCTO=NO
--## Finalidad: Crear vista para rellenar el grid de los expedientes liberbank con ofertas agrupadas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 [HREOS-6989] Versión inicial (Creación de la vista)
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_VIEWNAME VARCHAR2(50):= 'V_LISTADO_OFERTAS_AGRUPADAS_LBK';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT('[INFO] Creación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
V_MSQL := ('CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||' AS
				SELECT
					ROWNUM AS ID_VISTA,
				    PRINCIPAL.OFR_NUM_OFERTA OFR_NUM_OFERTA_PRINCIPAL,
				    DEPENDIENTE.OFR_NUM_OFERTA OFR_NUM_OFERTA_DEPENDIENTE,
				    ACT.ACT_NUM_ACTIVO ACT_NUM_ACTIVO,
				    DEPENDIENTE.OFR_IMPORTE OFR_IMPORTE,
				    (SELECT ACT_TAS.TAS_IMPORTE_TAS_FIN FROM '||V_ESQUEMA||'.ACT_TAS_TASACION ACT_TAS WHERE ACT_TAS.BORRADO=0 AND ACT_TAS.ACT_ID = ACT.ACT_ID ORDER BY ACT_TAS.TAS_FECHA_RECEPCION_TASACION DESC FETCH FIRST 1 ROW ONLY) TAS_IMPORTE_TAS_FIN,
				    (SELECT ACT_VAL.VAL_IMPORTE FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES ACT_VAL JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = ACT_VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''25'' WHERE ACT_VAL.ACT_ID = ACT.ACT_ID AND TPC.BORRADO = 0 AND ACT_VAL.BORRADO=0) VAL_IMPORTE_VNC,
				    (SELECT ACT_VAL.VAL_IMPORTE FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES ACT_VAL JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = ACT_VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''23'' WHERE ACT_VAL.ACT_ID = ACT.ACT_ID AND TPC.BORRADO = 0 AND ACT_VAL.BORRADO=0) VAL_IMPORTE_VR
				FROM '||V_ESQUEMA||'.OGR_OFERTAS_AGRUPADAS_LBK OGR 
				    JOIN '||V_ESQUEMA||'.OFR_OFERTAS PRINCIPAL ON (OGR.ID_OFERTA_PRINCIPAL = PRINCIPAL.OFR_ID AND PRINCIPAL.BORRADO=0 AND OGR.BORRADO= 0)
				    JOIN '||V_ESQUEMA||'.OFR_OFERTAS DEPENDIENTE ON (OGR.ID_OFERTA_DEPENDIENTE = DEPENDIENTE.OFR_ID AND DEPENDIENTE.BORRADO=0 AND OGR.BORRADO=0)
				    JOIN '||V_ESQUEMA||'.ACT_OFR ON ACT_OFR.OFR_ID = DEPENDIENTE.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACT_OFR.ACT_ID AND ACT.BORRADO=0
					JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO=0 WHERE CRA.DD_CRA_CODIGO = ''08'' ');

	execute immediate V_MSQL;

-- Insertando comentarios a las columnas
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.ID_VISTA is ''Campo auxiliar para Hibernate (NO USAR)''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.OFR_NUM_OFERTA_PRINCIPAL is ''Número de la oferta principal relacionada''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.OFR_NUM_OFERTA_DEPENDIENTE is ''Número de la oferta dependiente relacionada''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.ACT_NUM_ACTIVO is ''Número del activo relacionado con la oferta dependiente''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.OFR_IMPORTE is ''Importe de la oferta dependiente''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.TAS_IMPORTE_TAS_FIN is ''Importe de la tasación del activo relacionado por la oferta dependiente (VTA)''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.VAL_IMPORTE_VNC is ''Importe de la Valor Neto Contable del activo relacioado por la oferta depeniente (VNC)''';
	EXECUTE IMMEDIATE 'comment on column '||V_ESQUEMA||'.'||V_VIEWNAME||'.VAL_IMPORTE_VR is ''Importe de la Valor Razonable del activo relacionado por la oferta dependiente (VR)''';

COMMIT;

DBMS_OUTPUT.PUT_LINE('OK creación');

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
