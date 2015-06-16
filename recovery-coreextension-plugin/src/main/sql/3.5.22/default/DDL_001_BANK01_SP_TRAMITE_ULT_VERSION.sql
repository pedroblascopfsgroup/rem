--/*
--##########################################
--## AUTOR=G ESTELLES
--## FECHA_CREACION=20150506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.7
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--##
--## Finalidad: Procedimiento almacenado para pasar las instancias de un trámite a su última versión.
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

BEGIN
	
    DBMS_OUTPUT.put_line('[INICIO] CREA SP REFRESCAR_TRAMITE *****************************');
    V_MSQL:='CREATE OR REPLACE PROCEDURE TRAMITE_A_ULTIMA_VERSION (V_DD_TPO_CODIGO VARCHAR) AS
    		BEGIN

		    DBMS_OUTPUT.put_line(''[INICIO] ACTUALIZA PROCESSINSTANCE *****************************'');
        MERGE INTO '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE DEST
			      USING (
			        WITH T_MAX AS (
			          SELECT NAME_,MAX(VERSION_) AS VERSION_ FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD GROUP BY NAME_
			        ),
			        PD_LAST AS (
			        SELECT PD_LAST.NAME_, PD_LAST.ID_ FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD_LAST 
			          JOIN T_MAX ON T_MAX.NAME_=PD_LAST.NAME_ AND PD_LAST.VERSION_=T_MAX.VERSION_
			        )
			        SELECT PI.ID_ PI_ID_, PD_LAST.ID_ PD_DEST_ 
			          FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD 
			          JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_XML_JBPM=PD.NAME_ AND TPO.DD_TPO_CODIGO=V_DD_TPO_CODIGO
			          JOIN PD_LAST ON PD_LAST.NAME_=PD.NAME_
			          JOIN '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE PI ON PD.ID_=PI.PROCESSDEFINITION_
			          -- JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_PROCESS_BPM=PI.ID_ AND PRC.PRC_ID=0000 -- QUITAR, ES PARA UN PROCEdIMIENTO
			        ) SOURCE
			      ON (SOURCE.PI_ID_=DEST.ID_)
			      WHEN MATCHED THEN
			        UPDATE SET 
			          PROCESSDEFINITION_=SOURCE.PD_DEST_;
		    DBMS_OUTPUT.put_line(''[FIN] ACTUALIZA PROCESSINSTANCE *****************************'');
		
		    DBMS_OUTPUT.put_line(''[INICIO] ACTUALIZA TOKEN *****************************'');
        MERGE INTO '||V_ESQUEMA_M||'.JBPM_TOKEN DEST
        USING (
            WITH T_MAX AS (
              SELECT NAME_,MAX(VERSION_) AS VERSION_ FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD GROUP BY NAME_
          ),
          T_NODOS AS (
          SELECT ND.ID_, ND.NAME_, PD_LAST.NAME_ PD_NAME FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD_LAST 
            JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_XML_JBPM=PD_LAST.NAME_ AND TPO.DD_TPO_CODIGO=V_DD_TPO_CODIGO
            JOIN T_MAX ON T_MAX.NAME_=PD_LAST.NAME_ AND PD_LAST.VERSION_=T_MAX.VERSION_
            JOIN '||V_ESQUEMA_M||'.JBPM_NODE ND ON ND.PROCESSDEFINITION_=PD_LAST.ID_
          )
          SELECT TK.ID_ TK_ID_, ND.ID_ ID_ORIG, ND.NAME_ NAME_ORIG, TNOD.ID_ ID_DEST, TNOD.NAME_ NAME_DEST
          FROM '||V_ESQUEMA_M||'.JBPM_PROCESSDEFINITION PD 
            --JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_XML_JBPM=PD.NAME_ AND TPO.DD_TPO_CODIGO=V_DD_TPO_CODIGO
            JOIN '||V_ESQUEMA_M||'.JBPM_NODE ND ON PD.ID_=ND.PROCESSDEFINITION_
            -- JOIN '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE PI ON PI.PROCESSDEFINITION_=PD.ID_
            -- JOIN '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC ON PRC.PRC_PROCESS_BPM=PI.ID_ AND PRC.PRC_ID=00000
            JOIN '||V_ESQUEMA_M||'.JBPM_TOKEN TK ON TK.NODE_=ND.ID_
                JOIN T_NODOS TNOD ON TNOD.NAME_=ND.NAME_ AND TNOD.PD_NAME=PD.NAME_
              ) SOURCE
          ON (SOURCE.TK_ID_=DEST.ID_)
          WHEN MATCHED THEN
            UPDATE SET 
              NODE_=SOURCE.ID_DEST;
        DBMS_OUTPUT.put_line(''[FIN] ACTUALIZA TOKEN *****************************'');
        COMMIT;

		END TRAMITE_A_ULTIMA_VERSION;';
	    EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.put_line('[FIN] CREA SP REFRESCAR_TRAMITE *****************************');
    
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;
