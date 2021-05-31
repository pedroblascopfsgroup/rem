--/*
--##########################################
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13790
--## PRODUCTO=NO
--## Finalidad: Cambio de obtención de datos SIN_INFORME_APROBADO_REM(Mejora de rendimiento)
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Daniel Gallego
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
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEM_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_SIN_INFORME_APROBADO_REM' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_SIN_INFORME_APROBADO_REM...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_SIN_INFORME_APROBADO_REM';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_SIN_INFORME_APROBADO_REM... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_SIN_INFORME_APROBADO_REM...');
  V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.v_sin_informe_aprobado_rem (act_id,sin_informe_aprobado_REM)
AS
SELECT act.act_id, 
DECODE (vei.dd_aic_codigo, ''02'', 0, 1) AS sin_informe_aprobado_REM
FROM ACT_ACTIVO ACT
LEFT JOIN REM01.act_ico_info_comercial ico ON ico.act_id = act.act_id and ico.borrado = 0
LEFT JOIN REM01.vi_estado_actual_infmed vei ON vei.ico_id = ico.ico_id';
EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_SIN_INFORME_APROBADO_REM...Creada OK');

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

