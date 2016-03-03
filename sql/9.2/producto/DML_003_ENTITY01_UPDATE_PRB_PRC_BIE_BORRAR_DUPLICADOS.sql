--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160225	
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=HR-1958
--## PRODUCTO=SI
--## Finalidad: DML Borrado lógico de filas duplicadas en la tabla PRB_PRC_BIE.
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

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para la realización de la sentencia.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    BEGIN

	    V_MSQL := 'UPDATE ' || V_ESQUEMA || '.PRB_PRC_BIE SET BORRADO = 1, USUARIOBORRAR = ''JLG'', FECHABORRAR = SYSDATE WHERE PRB_ID IN (SELECT PRB_ID FROM (SELECT PRB_ID, ROW_NUMBER() OVER (PARTITION BY PRC_ID,BIE_ID order by PRB_ID) AS ORD FROM (SELECT PRB_ID, PRC_ID, BIE_ID FROM ' ||V_ESQUEMA|| '.PRB_PRC_BIE WHERE (BORRADO = 0 OR FECHABORRAR IS NULL)))WHERE ORD > 1)';
    	EXECUTE IMMEDIATE V_MSQL;
  		
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... filas actualizadas');  	
 
    COMMIT;
    	
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