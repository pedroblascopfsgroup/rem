--/*
--##########################################
--## AUTOR=Jose Manuel Perez Barberá
--## FECHA_CREACION=20160222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-2211
--## PRODUCTO=NO
--## Finalidad: Arreglo campos PER_SITUACION_CONCURSAL,DD_SIC_ID en PER_PERSONAS no aprovisionadas
--##                               , esquemas CM01 y HAYA02.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
DBMS_OUTPUT.put_line('--INICIO--');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.PER_PERSONAS P 
			SET P.PER_SITUACION_CONCURSAL = (SELECT DD_SIC_CODIGO FROM '||V_ESQUEMA||'.DD_SIC_SITUAC_CONCURSAL WHERE DD_SIC_ID = P.PER_SITUACION_CONCURSAL)
			WHERE P.PER_SITUACION_CONCURSAL NOT IN (SELECT DD_SIC_CODIGO FROM '||V_ESQUEMA||'.DD_SIC_SITUAC_CONCURSAL)';
EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE PER_SITUACION_CONCURSAL OK');

V_MSQL := 'UPDATE '||V_ESQUEMA||'.PER_PERSONAS P 
			SET P.DD_SIC_ID = (SELECT DD_SIC_ID FROM '||V_ESQUEMA||'.DD_SIC_SITUAC_CONCURSAL WHERE DD_SIC_CODIGO = P.PER_SITUACION_CONCURSAL)
			WHERE P.DD_SIC_ID IS NULL
			AND P.PER_SITUACION_CONCURSAL IS NOT NULL';

EXECUTE IMMEDIATE(V_MSQL);
DBMS_OUTPUT.put_line('UPDATE DD_SIC_ID OK');

COMMIT;  

DBMS_OUTPUT.put_line('--FIN--');

EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;

    DBMS_OUTPUT.put_line('Error:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
  
    ROLLBACK;
	RAISE;
END;
/
EXIT;   
