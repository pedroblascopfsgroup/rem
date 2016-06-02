--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Vista V_MSV_BUSQUEDA_ASUNTOS_USUARIO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(5000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** V_MSV_BUSQUEDA_ASUNTOS_USUARIO ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... Comprobaciones previas');
	

	-- Comprobamos si existe la vista
	V_MSQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''V_MSV_BUSQUEDA_ASUNTOS_USUARIO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... ya existe, se reemplazará');
		EXECUTE IMMEDIATE 'DROP VIEW V_MSV_BUSQUEDA_ASUNTOS_USUARIO';
		V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO
		(id_,
                                                                    asu_id,
                                                                    prc_id,
                                                                    asu_nombre,
                                                                    plaza,
                                                                    juzgado,
                                                                    AUTO,
                                                                    tipo_prc,
                                                                    principal,
                                                                    tex_id,
                                                                    cod_estado_prc,
                                                                    des_estado_prc,
                                                                    prc_saldo_recuperacion,
                                                                    prc_fecha_crear,
                                                                    usu_id,
                                                                    tar_tarea
                                                                   )
AS
   SELECT DISTINCT asu."ID_", asu."ASU_ID", asu."PRC_ID", asu."ASU_NOMBRE",
                   asu."PLAZA", asu."JUZGADO", asu."AUTO", asu."TIPO_PRC",
                   asu."PRINCIPAL", asu."TEX_ID", asu."COD_ESTADO_PRC",
                   asu."DES_ESTADO_PRC", asu."PRC_SALDO_RECUPERACION",
                   asu."PRC_FECHA_CREAR", usu.usu_id, asu."TAR_TAREA"
              FROM v_msv_busqueda_asuntos asu LEFT JOIN vtar_asu_vs_usu usu
                   ON asu.asu_id = usu.asu_id';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... Creando vista');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... OK');
			
		ELSE
			V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO
		(id_,
                                                                    asu_id,
                                                                    prc_id,
                                                                    asu_nombre,
                                                                    plaza,
                                                                    juzgado,
                                                                    AUTO,
                                                                    tipo_prc,
                                                                    principal,
                                                                    tex_id,
                                                                    cod_estado_prc,
                                                                    des_estado_prc,
                                                                    prc_saldo_recuperacion,
                                                                    prc_fecha_crear,
                                                                    usu_id,
                                                                    tar_tarea
                                                                   )
AS
   SELECT DISTINCT asu."ID_", asu."ASU_ID", asu."PRC_ID", asu."ASU_NOMBRE",
                   asu."PLAZA", asu."JUZGADO", asu."AUTO", asu."TIPO_PRC",
                   asu."PRINCIPAL", asu."TEX_ID", asu."COD_ESTADO_PRC",
                   asu."DES_ESTADO_PRC", asu."PRC_SALDO_RECUPERACION",
                   asu."PRC_FECHA_CREAR", usu.usu_id, asu."TAR_TAREA"
              FROM v_msv_busqueda_asuntos asu LEFT JOIN vtar_asu_vs_usu usu
                   ON asu.asu_id = usu.asu_id';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... Creando vista');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS_USUARIO... OK');
	END IF;

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;