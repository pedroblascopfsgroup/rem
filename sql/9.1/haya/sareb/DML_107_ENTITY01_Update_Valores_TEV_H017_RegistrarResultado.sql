--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-hy-rc01
--## INCIDENCIA_LINK=HR-1100
--## PRODUCTO=NO
--## Finalidad: DML para actualizar los valores de las TEV_TAREA_EXTERNA_VALOR de la tarea H017_RegistrarResultado
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
    V_MSQL VARCHAR2(4000 CHAR);
   
BEGIN
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR' ||
			' SET TEV_VALOR    = ''02''' ||
			' WHERE TEV_NOMBRE = ''comboAlgunConvenio''' ||
			' AND TEX_ID IN (SELECT TEX_ID FROM ' || V_ESQUEMA || '.TEX_TAREA_EXTERNA WHERE TAP_ID IN' ||
    		' (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO LIKE ''H017_registrarResultado''))' ||
  			' AND TEV_VALOR = ''2''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando valores de las TEV_TAREA_EXTERNA_VALOR de la tarea H017_RegistrarResultado');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Valores actualizados.');
     
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;