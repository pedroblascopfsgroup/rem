--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20160422
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3174
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
               
                
BEGIN


-- ACUERDOS PROCEDIMIENTOS

UPDATE CM01.acu_acuerdo_procedimientos acu
set acu.dd_eac_id = (select dd_eac_id from CMMASTER.DD_EAC_ESTADO_ACUERDO where dd_eac_codigo='06')
where acu.usuariocrear = 'MIGCM01PROPEX' 
and acu.dd_eac_id = (select dd_eac_id from CMMASTER.DD_EAC_ESTADO_ACUERDO where dd_eac_codigo='01');

DBMS_OUTPUT.put_line('[INFO] Registros actualizados de terminos acuerdo procedimientos' || '...' || sql%rowcount);



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