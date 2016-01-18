--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=15-12-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-414
--## PRODUCTO=SI
--## Finalidad: DDL Reemplazamos vista por una mucha mas optimizada
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'V_LIS_PREPROYECT_MOV';    
    
BEGIN
	
    -- Comprobamos si existe la vista materializada
    V_SQL := 'SELECT COUNT(1) FROM ALL_MVIEWS WHERE MVIEW_NAME = '''||V_NOMBRE_VISTA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    if V_NUM_TABLAS > 0 then          
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' Ya Existe');
          V_MSQL := 'DROP MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA;
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'... Vista materializada borrada');
    END IF;
    
        
    EXECUTE IMMEDIATE '
		CREATE MATERIALIZED VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA|| ' REFRESH FORCE ON DEMAND AS 
		SELECT  CNT_ID, MOV_RIESGO, MOV_DEUDA_IRREGULAR, MOV_FECHA_POS_VENCIDA FROM (
          SELECT M.CNT_ID, M.MOV_RIESGO, M.MOV_DEUDA_IRREGULAR, M.MOV_FECHA_POS_VENCIDA
            , ROW_NUMBER() OVER (PARTITION BY M.CNT_ID ORDER BY M.MOV_ID DESC) N 
          FROM '||V_ESQUEMA||'.MOV_MOVIMIENTOS M
              INNER JOIN '||V_ESQUEMA||'.CNT_CONTRATOS C ON M.CNT_ID =C.CNT_ID AND C.BORRADO=0
          WHERE M.BORRADO = 0
        ) WHERE N = 1';
			
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada');
	
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'_CNT_INDEX ON '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (CNT_ID)';
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||'_CNT_INDEX Creado');

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
