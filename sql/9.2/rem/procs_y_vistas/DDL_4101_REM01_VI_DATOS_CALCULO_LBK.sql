--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20191125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8570
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    
    seq_count number(3); 						-- Vble. para validar la existencia de las Secuencias.
    table_count number(3); 						-- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); 					-- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); 				-- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; 							-- N?mero de errores
    err_msg VARCHAR2(2048); 					-- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_CALCULO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_CALCULO_LBK...');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DATOS_CALCULO_LBK';  
		DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DATOS_CALCULO_LBK... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DATOS_CALCULO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_CALCULO_LBK...');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_DATOS_CALCULO_LBK';  
		DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DATOS_CALCULO_LBK... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.V_DATOS_CALCULO_LBK...');
  V_MSQL := 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_DATOS_CALCULO_LBK
  	AS
		WITH TAS_TASACION (ACT_ID, VALOR_TASACION_ACTUAL)
        AS
        (
            SELECT ACT.ACT_ID,
            (SELECT ACT_TAS.TAS_IMPORTE_TAS_FIN
            FROM ' ||V_ESQUEMA|| '.ACT_TAS_TASACION ACT_TAS
            WHERE ACT_TAS.BORRADO=0
            AND ACT_TAS.ACT_ID = ACT.ACT_ID
            ORDER BY ACT_TAS.TAS_FECHA_RECEPCION_TASACION DESC, ACT_TAS.FECHACREAR DESC
            FETCH FIRST 1 ROW ONLY) VALOR_TASACION_ACTUAL
            FROM ' ||V_ESQUEMA|| '.ACT_ACTIVO ACT
        ),
        VAL_VALORACIONES (ACT_ID, VALOR_NETO_CONTABLE, VALOR_IMPORTE_MINIMO_AUTORIZADO, VALOR_RAZONABLE)
		AS 
		(
		    SELECT P.*
		    FROM
		    (    
		        SELECT ACT.ACT_ID, TPC.DD_TPC_CODIGO, VAL.VAL_IMPORTE
		        FROM ' ||V_ESQUEMA|| '.ACT_VAL_VALORACIONES 		VAL 
		        INNER JOIN ' ||V_ESQUEMA|| '.ACT_ACTIVO 			ACT ON ACT.ACT_ID = VAL.ACT_ID AND ACT.BORRADO = 0
		        INNER JOIN ' ||V_ESQUEMA|| '.DD_TPC_TIPO_PRECIO 	TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
		        WHERE TPC.DD_TPC_CODIGO IN (''25'', ''04'', ''23'')
		        AND (VAL.VAL_FECHA_FIN IS NULL OR TO_DATE(VAL.VAL_FECHA_FIN,''DD/MM/RRRR'') >= TO_DATE(SYSDATE,''DD/MM/RRRR''))
		        AND (VAL.VAL_FECHA_INICIO IS NULL OR TO_DATE(VAL.VAL_FECHA_INICIO,''DD/MM/RRRR'') <= TO_DATE(SYSDATE,''DD/MM/RRRR''))
		        AND VAL.BORRADO = 0 AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM ' ||V_ESQUEMA|| '.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'')
		    ) X
		    PIVOT
		    (
		      MAX(VAL_IMPORTE)
		      FOR DD_TPC_CODIGO IN (''25'', ''04'', ''23'')
		    ) P
		)SELECT VAL.*, TAS.VALOR_TASACION_ACTUAL
        FROM VAL_VALORACIONES VAL
        LEFT JOIN TAS_TASACION TAS ON VAL.ACT_ID = TAS.ACT_ID';
	
	DBMS_OUTPUT.put_line(V_MSQL);

    EXECUTE IMMEDIATE V_MSQL;
  
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

