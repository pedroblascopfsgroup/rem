--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160705
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2066
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de intereses ordinarios de PCO_LIQ_LIQUIDACIONES a la suma de los campos DGC_IMCMPI y DGC_IMPRTV de DGC_DATOS_GENERALES_CNT_LIQ.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    
BEGIN		
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... UPDATEANDO PCO_LIQ_LIQUIDACIONES.PCO_LIQ_INTERESES_ORDINARIOS y PCO_LIQ_ORI_INTE_ORDINARIOS A (NVL(DGC.DGC_IMCMPI,0) + NVL(DGC.DGC_IMPRTV,0))');
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES
				SET PCO_LIQ_INTERESES_ORDINARIOS = (SELECT (NVL(DGC.DGC_IMCMPI,0) + NVL(DGC.DGC_IMPRTV,0)) FROM '||V_ESQUEMA||'.DGC_DATOS_GENERALES_CNT_LIQ DGC WHERE DGC.DGC_PCO_LIQ_ID = PCO_LIQ_ID AND DGC.BORRADO = 0)
				WHERE PCO_LIQ_INTERESES_ORDINARIOS = PCO_LIQ_ORI_INTE_ORDINARIOS
				AND PCO_LIQ_ID IS NOT NULL'; 			
		
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LIQ_LIQUIDACIONES
				SET PCO_LIQ_ORI_INTE_ORDINARIOS = (SELECT (NVL(DGC.DGC_IMCMPI,0) + NVL(DGC.DGC_IMPRTV,0)) FROM '||V_ESQUEMA||'.DGC_DATOS_GENERALES_CNT_LIQ DGC WHERE DGC.DGC_PCO_LIQ_ID = PCO_LIQ_ID AND DGC.BORRADO = 0)
				WHERE PCO_LIQ_ID IS NOT NULL'; 
	
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL;			
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... UPDATEADO PCO_LIQ_LIQUIDACIONES.PCO_LIQ_INTERESES_ORDINARIOS y PCO_LIQ_ORI_INTE_ORDINARIOS A (NVL(DGC.DGC_IMCMPI,0) + NVL(DGC.DGC_IMPRTV,0))');
    
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
