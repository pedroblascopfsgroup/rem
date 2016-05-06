--/*
--##########################################
--## AUTOR=Jose Manuel Perez Barberá
--## FECHA_CREACION=20160219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-2194
--## PRODUCTO=NO
--## Finalidad: Mergea en PER_PERSONAS la referencia a SCL para que apunte al valor correcto de SCL (con nuevos datos de SCE)
--##                               , esquema CM01.
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
                       
V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.PER_PERSONAS per
	USING 
	  (  
          SELECT DISTINCT PER.PER_ID, PER.DD_SCL_ID, PER.DD_SCE_ID, SCL.DD_SCL_ID NUEVO_DD_SCL_ID
          FROM '||V_ESQUEMA||'.PER_PERSONAS PER 
          INNER JOIN '||V_ESQUEMA||'.DD_SCE_SEGTO_CLI_ENTIDAD SCE ON (PER.DD_SCE_ID = SCE.DD_SCE_ID)
          INNER JOIN '||V_ESQUEMA||'.DD_SCL_SEGTO_CLI SCL ON (SCL.DD_SCL_CODIGO = SCE.DD_SCE_CODIGO)
      ) tmp   
    ON (tmp.PER_ID=per.PER_ID)
    WHEN MATCHED THEN
         UPDATE SET 
		         per.DD_SCL_ID=	tmp.NUEVO_DD_SCL_ID';
             
EXECUTE IMMEDIATE(V_MSQL);  
DBMS_OUTPUT.put_line('MERGE OK'); 

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
