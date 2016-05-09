--/*
--##########################################
--## AUTOR=Daniel Albert Pérez
--## FECHA_CREACION=20160318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2078
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
 

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables
    
 BEGIN
    
    DBMS_OUTPUT.put_line('- INICIO PROCESO -');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PCO_OBS_OBSERVACIONES
            (PCO_OBS_ID, PCO_PRC_ID, PCO_OBS_FECHA_ANOTACION, PCO_OBS_TEXTO_ANOTACION
            , PCO_OBS_SECUENCIA_ANOTACION, USUARIOCREAR, FECHACREAR)
SELECT
  S_PCO_OBS_OBSERVACIONES.NEXTVAL AS PCO_OBS_ID
  , PCO.PCO_PRC_ID
  , OBS.FECHA_ANOTACION
  , OBS.TEXTO_ANOTACION
  , OBS.SECUENCIA_ANOTACION
  , OBS.USUARIO_ANOTACION
  , SYSDATE
FROM
  '||V_ESQUEMA||'.MIG_EXPEDIENTES_OBSERVACIONES OBS
INNER JOIN
  '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS PCO
  ON PCO.PCO_PRC_NUM_EXP_INT = TO_CHAR(OBS.CD_EXPEDIENTE)';
    
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.put_line('- FIN PROCESO -');
    
 EXCEPTION

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
