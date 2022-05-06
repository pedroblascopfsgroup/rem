--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17278
--## PRODUCTO=NO
--## Finalidad: DDL creación vista V_ADMISION_DOCUMENTOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial DANIEL GUTIERREZ
--## 		0.2 Versión - HREOS-3118 Añadidos campos fechaCaducidad, fechaEtiqueta, y tipoCalificacionCodigo DANIEL GUTIERREZ 20160408
--##		0.3 Versión -  Ivan Rubio - HREOS-7997 Añadir campos ADO.DATA_ID_DOCUMENTO, ADO.LETRA_CONSUMO, ADO.CONSUMO, ADO.EMISION, ADO.REGISTRO para admision activos 
--##		0.4 Versión - Carlos Santos - REMVIP-8402 Añadido filtrado por tipo y comprobación de comunidad autónoma
--##		0.5 Versión - Jesus Jativa - HREOS-13379 modificacion vista V_ADMISION_DOCUMENTO para mostrar nuevos documentos ln 75 y 87
--##		0.6 Versión - Sergio Gomez - HREOS-13379 modificacion vista para mostrar lista de emisiones
--##		0.7 Versión - Javier Esbrí - HREOS-17278 modificacion vista para mostrar motivo exoneración cee y incidencia cee
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_ADMISION_DOCUMENTOS 
	AS
		SELECT
			    	TPD.DD_TPD_ID,
			    	ACT.ACT_ID,
			    	ADO.ADO_ID,
				CFD.CFD_ID,
			    	TPD.DD_TPD_DESCRIPCION,
			    	CASE 
	            		WHEN ADO.ADO_APLICA IS NOT NULL THEN ADO.ADO_APLICA ELSE
	                		(CASE WHEN CFD.DD_TPD_ID = 14 AND CFD.CFD_OBLIGATORIO = 1 THEN 
	                		(CASE WHEN CMA.DD_CMA_CODIGO NOT IN (''02'', ''04'', ''09'', ''15'', ''17'') THEN 0 ELSE CFD.CFD_OBLIGATORIO END)
	                		ELSE CFD.CFD_OBLIGATORIO END)     
                    		END AS FLAG_APLICA,
			    	EDC.DD_EDC_CODIGO,
			    	ADO.ADO_FECHA_SOLICITUD,
			    	ADO.ADO_FECHA_OBTENCION,
			    	ADO.ADO_FECHA_VERIFICADO,
          			CTD.DD_TGE_ID,
				TGE.DD_TGE_CODIGO,
          			CTD.DD_STR_ID,
				ADO.ADO_FECHA_CADUCIDAD,
				ADO.ADO_FECHA_ETIQUETA,
				TCE.DD_TCE_CODIGO,
				ADO.DATA_ID_DOCUMENTO,
				ADO.LETRA_CONSUMO,
				ADO.CONSUMO,
				LEM.DD_LEM_CODIGO AS LETRA_EMISIONES,
				ADO.EMISION,
				ADO.REGISTRO,
				MEC.DD_MEC_CODIGO AS MOTIVO_EXONERACION_CEE,
				ICE.DD_ICE_CODIGO AS INCIDENCIA_CEE
		FROM ' || V_ESQUEMA || '.ACT_CFD_CONFIG_DOCUMENTO CFD
		CROSS JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT 
		INNER JOIN ' || V_ESQUEMA || '.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
		INNER JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION BIE ON BIE.BIE_LOC_ID = LOC.BIE_LOC_ID
		INNER JOIN ' || V_ESQUEMA || '.APR_AUX_DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE.DD_PRV_ID
		INNER JOIN ' || V_ESQUEMA || '.ACT_CMP_COMAUTONOMA_PROVINCIA CPV ON CPV.DD_PRV_ID = PRV.DD_PRV_ID
		INNER JOIN ' || V_ESQUEMA || '.DD_CMA_COMAUTONOMA CMA ON CMA.DD_CMA_ID = CPV.DD_CMA_ID
    		INNER JOIN ' || V_ESQUEMA || '.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID
    		LEFT JOIN ' || V_ESQUEMA || '.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID AND ADO.CFD_ID = CFD.CFD_ID AND ADO.BORRADO = 0 and ado.ADO_NO_VALIDADO = 0
    		LEFT JOIN ' || V_ESQUEMA || '.DD_EDC_ESTADO_DOCUMENTO EDC ON EDC.DD_EDC_ID = ADO.DD_EDC_ID
    		LEFT JOIN ' || V_ESQUEMA || '.ACT_CTD_CONFIG_TDOCUMENTO CTD ON CTD.DD_TPD_ID = TPD.DD_TPD_ID
		LEFT JOIN ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = CTD.DD_TGE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TCE_TIPO_CALIF_ENERGETICA TCE ON TCE.DD_TCE_ID = ADO.DD_TCE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_LEM_LISTA_EMISIONES LEM ON LEM.DD_LEM_ID = ADO.DD_LEM_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_MEC_MOTIVO_EXONERACION_CEE MEC ON MEC.DD_MEC_ID = ADO.DD_MEC_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_ICE_INCIDENCIA_CEE ICE ON ICE.DD_ICE_ID = ADO.DD_ICE_ID
    where act.borrado = 0 and (act.dd_sac_id = cfd.dd_sac_id or cfd.dd_sac_id is null) and (act.dd_tpa_id = cfd.dd_tpa_id or (cfd.dd_tpa_id is null and ado.ado_fecha_obtencion is not null)) and cfd.borrado = 0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS...Creada OK');
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
