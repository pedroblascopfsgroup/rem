--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10560
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica fases publicacion activos
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10560'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
			
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] actualizacion en '''||V_TEXT_TABLA||''' ');

        V_MSQL:='CREATE TABLE BACKUP_AUX_REMVIP_10560_GEH AS
                SELECT DISTINCT OFR.OFR_NUM_OFERTA AS NUMERO_OFERTA, 
                usu2.usu_username as username_gee,
                USU3.USU_USERNAME as username_geh,
                geh.*
                FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TRA ON eco.TBJ_ID = TRA.TBJ_ID 
                JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = 400 AND GEE.BORRADO = 0
                inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id
                inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gch.geh_id and geh.dd_tge_id = 400 and geh.borrado = 0
                INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.USU_ID = GEE.USU_ID AND USU2.BORRADO = 0
                join '||V_ESQUEMA_M||'.USU_USUARIOS USU3 ON USU3.USU_ID=geh.usu_id AND USU3.BORRADO=0

                WHERE OFR.BORRADO = 0 
                and (geh.usuariocrear = ''UNKNOWN'' AND GEH.FECHACREAR LIKE ''%28/09/2021%'')
                AND GEH.GEH_FECHA_HASTA IS not NULL
                AND GEH.GEH_FECHA_DESDE LIKE ''%28/09/2021%'' AND GEH.GEH_FECHA_HASTA LIKE ''%28/09/2021%''
                order by geh_fecha_desde
        ';
        EXECUTE IMMEDIATE V_MSQL;


                V_MSQL:='CREATE TABLE BACKUP_AUX_REMVIP_10560_GCH AS
                SELECT DISTINCT OFR.OFR_NUM_OFERTA AS NUMERO_OFERTA, 
                usu2.usu_username as username_gee,
                USU3.USU_USERNAME as username_geh,
                GCH.*
                FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TRA ON eco.TBJ_ID = TRA.TBJ_ID 
                JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = 400 AND GEE.BORRADO = 0
                inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id
                inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gch.geh_id and geh.dd_tge_id = 400 and geh.borrado = 0
                INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.USU_ID = GEE.USU_ID AND USU2.BORRADO = 0
                join '||V_ESQUEMA_M||'.USU_USUARIOS USU3 ON USU3.USU_ID=geh.usu_id AND USU3.BORRADO=0

                WHERE OFR.BORRADO = 0 
                and (geh.usuariocrear = ''UNKNOWN'' AND GEH.FECHACREAR LIKE ''%28/09/2021%'')
                AND GEH.GEH_FECHA_HASTA IS not NULL
                AND GEH.GEH_FECHA_DESDE LIKE ''%28/09/2021%'' AND GEH.GEH_FECHA_HASTA LIKE ''%28/09/2021%''
        ';
        EXECUTE IMMEDIATE V_MSQL;
	
		V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO WHERE GEH_ID IN (
                SELECT DISTINCT
                geh.geh_id
                FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TRA ON eco.TBJ_ID = TRA.TBJ_ID 
                JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = 400 AND GEE.BORRADO = 0
                inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id
                inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gch.geh_id and geh.dd_tge_id = 400 and geh.borrado = 0
                INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.USU_ID = GEE.USU_ID AND USU2.BORRADO = 0
                join '||V_ESQUEMA_M||'.USU_USUARIOS USU3 ON USU3.USU_ID=geh.usu_id AND USU3.BORRADO=0

                WHERE OFR.BORRADO = 0 
                and (geh.usuariocrear = ''UNKNOWN'' AND GEH.FECHACREAR LIKE ''%28/09/2021%'')
                AND GEH.GEH_FECHA_HASTA IS not NULL
                AND GEH.GEH_FECHA_DESDE LIKE ''%28/09/2021%'' AND GEH.GEH_FECHA_HASTA LIKE ''%28/09/2021%''


        ) ';
		EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS REGISTROS GCH : '||SQL%ROWCOUNT||' ');

        		V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST WHERE GEH_ID IN (
                SELECT DISTINCT
                geh.geh_id
                FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
                JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TRA ON eco.TBJ_ID = TRA.TBJ_ID 
                JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = 400 AND GEE.BORRADO = 0
                inner join '||V_ESQUEMA||'.gch_gestor_eco_historico gch on gch.eco_id = eco.eco_id
                inner join '||V_ESQUEMA||'.geh_gestor_entidad_hist geh on geh.geh_id = gch.geh_id and geh.dd_tge_id = 400 and geh.borrado = 0
                INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON USU2.USU_ID = GEE.USU_ID AND USU2.BORRADO = 0
                join '||V_ESQUEMA_M||'.USU_USUARIOS USU3 ON USU3.USU_ID=geh.usu_id AND USU3.BORRADO=0

                WHERE OFR.BORRADO = 0 
                and (geh.usuariocrear = ''UNKNOWN'' AND GEH.FECHACREAR LIKE ''%28/09/2021%'')
                AND GEH.GEH_FECHA_HASTA IS not NULL
                AND GEH.GEH_FECHA_DESDE LIKE ''%28/09/2021%'' AND GEH.GEH_FECHA_HASTA LIKE ''%28/09/2021%''


        ) ';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS REGISTROS GEH : '||SQL%ROWCOUNT||' ');

	COMMIT;

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