--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20191023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL creación vista V_ADMISION_DOCUMENTOS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial DANIEL GUTIERREZ
--## 		0.2 Versión - HREOS-3118 Añadidos campos fechaCaducidad, fechaEtiqueta, y tipoCalificacionCodigo DANIEL GUTIERREZ 20160408
--##		0.3 Versión -  Ivan Rubio - HREOS-7997 Añadir campos ADO.DATA_ID_DOCUMENTO, ADO.LETRA_CONSUMO, ADO.CONSUMO, ADO.EMISION, ADO.REGISTRO para admision activos 
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
--v0.3
  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ADMISION_DOCUMENTOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ADMISION_DOCUMENTOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ADMISION_DOCUMENTOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ADMISION_DOCUMENTOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ADMISION_DOCUMENTOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_ADMISION_DOCUMENTOS 
	AS
		SELECT
			    TPD.DD_TPD_ID,
			    ACT.ACT_ID,
			    ADO.ADO_ID,
				CFD.CFD_ID,
			    TPD.DD_TPD_DESCRIPCION,
			    NVL(ADO.ADO_APLICA, CFD.CFD_OBLIGATORIO) AS FLAG_APLICA,
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
				ADO.EMISION,
				ADO.REGISTRO
		FROM ' || V_ESQUEMA || '.ACT_CFD_CONFIG_DOCUMENTO CFD
		INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.DD_TPA_ID = CFD.DD_TPA_ID
    	INNER JOIN ' || V_ESQUEMA || '.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID
    	LEFT JOIN ' || V_ESQUEMA || '.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID AND ADO.CFD_ID = CFD.CFD_ID AND ADO.BORRADO = 0
    	LEFT JOIN ' || V_ESQUEMA || '.DD_EDC_ESTADO_DOCUMENTO EDC ON EDC.DD_EDC_ID = ADO.DD_EDC_ID
    	LEFT JOIN ' || V_ESQUEMA || '.ACT_CTD_CONFIG_TDOCUMENTO CTD ON CTD.DD_TPD_ID = TPD.DD_TPD_ID
		LEFT JOIN ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = CTD.DD_TGE_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TCE_TIPO_CALIF_ENERGETICA TCE ON TCE.DD_TCE_ID = ADO.DD_TCE_ID
    where act.borrado = 0';

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