--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210813
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10299
--## PRODUCTO=NO
--##
--## Finalidad: Script informa area peticionaria RAM trabajos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_ACT VARCHAR2(27 CHAR) := 'AUX_ESPARTA_PUBL_ACT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_AGR VARCHAR2(27 CHAR) := 'AUX_ESPARTA_PUBL_AGR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10299'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    V_ID_VIEJO NUMBER(16);
    V_ID_NUEVO NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	DBMS_OUTPUT.PUT_LINE('[INFO]:  INSERTAR ACTIVOS Y AGRUPACIONES A RECALCULAR ');


                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT||'

                        SELECT DISTINCT 
                            ACT.ACT_ID
                            , 0 PROCESADO
                            FROM '||V_ESQUEMA||'.H_CCN_CAMBIOS_CONV_SAREB CCN
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON CCN.ACT_ID = ACT.ACT_ID
                            JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID=CCN.DD_COS_ID
                            WHERE TRUNC(CCN.FECHACREAR)>TO_DATE(''02/08/2021'',''DD/MM/YYYY'') AND COS.DD_COS_CODIGO IN (''009'',''011'',''013'',''029'',''086'',''097'',''173'',''177'',''175'',''178'',''179'',''181'',''183'',''185'')
                            AND NOT EXISTS (SELECT 1
                            FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO = ''02''
                            WHERE AGA.ACT_ID = ACT.ACT_ID
                            AND AGR.AGR_FECHA_BAJA IS NULL
                            AND AGA.BORRADO = 0)
                            ';
                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS: '|| SQL%ROWCOUNT ||' activos ');

                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AGR||'

                            SELECT DISTINCT 
                            AGR.AGR_ID
                            , 0 PROCESADO
                            FROM '||V_ESQUEMA||'.H_CCN_CAMBIOS_CONV_SAREB CCN
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON CCN.ACT_ID = ACT.ACT_ID
                            JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON COS.DD_COS_ID=CCN.DD_COS_ID
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID =ACT.ACT_ID AND AGA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO = ''02''
                            WHERE TRUNC(CCN.FECHACREAR)>TO_DATE(''02/08/2021'',''DD/MM/YYYY'') AND COS.DD_COS_CODIGO IN (''009'',''011'',''013'',''029'',''086'',''097'',''173'',''177'',''175'',''178'',''179'',''181'',''183'',''185'')
                            AND AGR.AGR_FECHA_BAJA IS NULL
                            ';
                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS: '|| SQL%ROWCOUNT ||' agrupaciones ');


	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
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