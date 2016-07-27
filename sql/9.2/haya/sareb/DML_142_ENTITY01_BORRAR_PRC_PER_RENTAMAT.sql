--/*
--##########################################
--## AUTOR=Rafael Aracil López
--## FECHA_CREACION=20160630
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=RECOVERY-2110
--## PRODUCTO=SI
--## Finalidad: Borramos relacion RENTAMAT con asunto 0004977
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER; 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN


DBMS_OUTPUT.PUT_LINE('[INFO] BORRAMOS REGISTROS EN '||V_ESQUEMA||'.PRC_PER (relacion RENTAMAT con asunto 0004977)');


execute immediate'
delete  FROM '||V_ESQUEMA||'.PRC_PER WHERE (PRC_ID,PER_ID) IN(
select PRC_ID,PER_ID from '||V_ESQUEMA||'.PRC_PER where prc_id in
(
select prc_id from '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS where asu_id in (
select ASU_ID from '||V_ESQUEMA||'.ASU_ASUNTOS where ASU_ID_EXTERNO = 0004977))
and per_id in
(select per_id from '||V_ESQUEMA||'.PER_PERSONAS where per_nom50 like ''%RENTAMAT S.L.%''))';

DBMS_OUTPUT.PUT_LINE('[INFO] Registros BORRADOS en '||V_ESQUEMA||'.PRC_PER');



	
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


;

