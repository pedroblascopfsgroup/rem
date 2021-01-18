--/*
--##########################################
--## AUTOR=Javier Urbán
--## FECHA_CREACION=20201202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11156
--## PRODUCTO=NO
--## Finalidad: DDL
--## V1: Daniel Algaba creación vista          
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Añadimos el booleano validar albarán para saber cuando tenemos posibilidad de hacerlo
--##		0.3 Cogemos el año del trabajo para poder filtrarlo
--##		0.4 Añadimos el id del trabajo par facilitar abrirlo desde JS
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  /*SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;
*/
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ALBARANES...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ALBARANES 

	AS
  		SELECT
		  ALB.ALB_ID,
		  ALB.ALB_NUM_ALBARAN,
		  ALB.ALB_FECHA_ALBARAN,
		  ESTALB.DD_ESA_CODIGO,
		  ESTALB.DD_ESA_DESCRIPCION,
		  PFA.PFA_NUM_PREFACTURA,
		  EPF.DD_EPF_CODIGO,
		  EPF.DD_EPF_DESCRIPCION,
		  PVE.PVE_ID,
		  PVE.PVE_NOMBRE,
		  PRO.PRO_NOMBRE,
		  PRO.PRO_DOCIDENTIF,
		  TBJ.TBJ_ID,
		  TBJ.TBJ_NUM_TRABAJO,
		  TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'') ANYO_TRABAJO,
		  PFA.PFA_FECHA_PREFACTURA,
		  TBJ.TBJ_FECHA_VALIDACION,
		  TTR.DD_TTR_CODIGO,
		  TTR.DD_TTR_DESCRIPCION,
		  EST.DD_EST_CODIGO,
		  EST.DD_EST_DESCRIPCION,
		  IRE.DD_IRE_CODIGO,
		  (SELECT COUNT(PFA_ID) FROM ' || V_ESQUEMA || '.PFA_PREFACTURA PFAP INNER JOIN ' || V_ESQUEMA || '.ALB_ALBARAN ALBA ON ALBA.ALB_ID = PFAP.ALB_ID AND ALBA.BORRADO = 0 WHERE PFAP.BORRADO = 0 AND ALBA.ALB_ID = ALB.ALB_ID) NUMPREFACTURA,
		  COUNT(1) OVER(PARTITION BY ALB.ALB_ID) NUMTRABAJO,
		  SUM(NVL(TBJ.TBJ_IMPORTE_TOTAL,0)) OVER(PARTITION BY ALB.ALB_ID) SUM_TOTAL,
		  SUM(NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO,0)) OVER(PARTITION BY ALB.ALB_ID) SUM_PRESUPUESTO,
          CASE WHEN VALA.ALB_ID IS NULL THEN 0
            ELSE 1 END VALIDARALBARAN
		FROM ' || V_ESQUEMA || '.ALB_ALBARAN ALB
		LEFT JOIN ' || V_ESQUEMA || '.DD_ESA_ESTADO_ALBARAN ESTALB ON ALB.DD_ESA_ID = ESTALB.DD_ESA_ID AND ESTALB.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.PFA_PREFACTURA PFA ON ALB.ALB_ID = PFA.ALB_ID AND ALB.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_EPF_ESTADO_PREFACTURA EPF ON EPF.DD_EPF_ID = PFA.DD_EPF_ID AND EPF.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE ON PFA.PVE_ID = PVE.PVE_ID AND PVE.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.ACT_PRO_PROPIETARIO PRO ON PFA.PRO_ID = PRO.PRO_ID AND PRO.BORRADO = 0
		JOIN ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ ON PFA.PFA_ID = TBJ.PFA_ID AND TBJ.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_IRE_IDENTIFICADOR_REAM IRE ON IRE.DD_IRE_ID = TBJ.DD_IRE_ID AND IRE.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_TTR_TIPO_TRABAJO TTR ON TBJ.DD_TTR_ID = TTR.DD_TTR_ID AND TTR.BORRADO = 0
		LEFT JOIN ' || V_ESQUEMA || '.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID AND EST.BORRADO = 0
        LEFT JOIN (SELECT ALB.ALB_ID
                    FROM ' || V_ESQUEMA || '.ALB_ALBARAN ALB
                    LEFT JOIN ' || V_ESQUEMA || '.DD_ESA_ESTADO_ALBARAN ESA ON ALB.DD_ESA_ID = ESA.DD_ESA_ID AND ESA.BORRADO = 0
                    WHERE ALB.BORRADO = 0
                    AND ESA.DD_ESA_CODIGO = ''PEN''
                    AND NOT EXISTS (SELECT 1
                    FROM ' || V_ESQUEMA || '.PFA_PREFACTURA PFA
                    LEFT JOIN ' || V_ESQUEMA || '.DD_EPF_ESTADO_PREFACTURA EPF ON EPF.DD_EPF_ID = PFA.DD_EPF_ID AND EPF.BORRADO = 0
                    WHERE PFA.BORRADO = 0 AND PFA.ALB_ID = ALB.ALB_ID AND EPF.DD_EPF_CODIGO = ''PEN'')) VALA ON VALA.ALB_ID = ALB.ALB_ID
		WHERE ALB.BORRADO = 0
		';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ALBARANES...Creada OK');

  COMMIT;

  EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;   
  
END;
/

EXIT;
