--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Vista V_MSV_BUSQUEDA_ASU_TRAM
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_ENTIDAD#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** V_MSV_BUSQUEDA_ASUNTOS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS... Comprobaciones previas');
	

	-- Comprobamos si existe la vista
	V_MSQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''V_MSV_BUSQUEDA_ASUNTOS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.V_MSV_BUSQUEDA_ASUNTOS... ya existe, se reemplazará');
		EXECUTE IMMEDIATE 'DROP VIEW V_MSV_BUSQUEDA_ASUNTOS';
		V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS
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
                                                            tar_tarea
                                                           )
AS
   (SELECT vproc."ID_", vproc."ASU_ID", vproc."PRC_ID", vproc."ASU_NOMBRE",
           vproc."PLAZA", vproc."JUZGADO", vproc."AUTO", vproc."TIPO_PRC",
           vproc."PRINCIPAL", vproc."TEX_ID", vproc."COD_ESTADO_PRC",
           vproc."DES_ESTADO_PRC", vproc."PRC_SALDO_RECUPERACION",
           vproc."PRC_FECHA_CREAR", vproc."TAR_TAREA"
      FROM v_msv_busqueda_asu_proc vproc
    UNION ALL
    SELECT vtram."ID_", vtram."ASU_ID", vtram."PRC_ID", vtram."ASU_NOMBRE",
           vtram."PLAZA", vtram."JUZGADO", vtram."AUTO", vtram."TIPO_PRC",
           vtram."PRINCIPAL", vtram."TEX_ID", vtram."COD_ESTADO_PRC",
           vtram."DES_ESTADO_PRC", vtram."PRC_SALDO_RECUPERACION",
           vtram."PRC_FECHA_CREAR", vtram."TAR_TAREA"
      FROM v_msv_busqueda_asu_tram vtram)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS... Creando vista');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS... OK');
			
		ELSE
			V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS 
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
                                                            tar_tarea
                                                           )
AS
   (SELECT vproc."ID_", vproc."ASU_ID", vproc."PRC_ID", vproc."ASU_NOMBRE",
           vproc."PLAZA", vproc."JUZGADO", vproc."AUTO", vproc."TIPO_PRC",
           vproc."PRINCIPAL", vproc."TEX_ID", vproc."COD_ESTADO_PRC",
           vproc."DES_ESTADO_PRC", vproc."PRC_SALDO_RECUPERACION",
           vproc."PRC_FECHA_CREAR", vproc."TAR_TAREA"
      FROM v_msv_busqueda_asu_proc vproc
    UNION ALL
    SELECT vtram."ID_", vtram."ASU_ID", vtram."PRC_ID", vtram."ASU_NOMBRE",
           vtram."PLAZA", vtram."JUZGADO", vtram."AUTO", vtram."TIPO_PRC",
           vtram."PRINCIPAL", vtram."TEX_ID", vtram."COD_ESTADO_PRC",
           vtram."DES_ESTADO_PRC", vtram."PRC_SALDO_RECUPERACION",
           vtram."PRC_FECHA_CREAR", vtram."TAR_TAREA"
      FROM v_msv_busqueda_asu_tram vtram)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS... Creando vista');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASUNTOS... OK');
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