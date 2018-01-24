--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180123
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=v2.0.14-rem
--## INCIDENCIA_LINK=HREOS-3631
--## PRODUCTO=NO
--## Finalidad: Updatear la condicion del rechazo F16 de la tabla DD_MRG_MOTIVO_RECHAZO
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_M#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_QUERY_ITER VARCHAR2(2400 CHAR);
    V_MRG_CODIGO VARCHAR2(16 CHAR) := 'F16';  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de update del registro de rechazo con código '||V_MRG_CODIGO)
    ;
    
    V_QUERY_ITER := 'WHERE AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS (SELECT * FROM GPV_GASTOS_PROVEEDOR GPV JOIN GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID JOIN DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON EAH.DD_EAH_ID = GGE.DD_EAH_ID AND EAH.DD_EAH_CODIGO = ''''03'''' WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#)'
	;
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_MRG_MOTIVO_RECHAZO_GASTO SET QUERY_ITER = '''||V_QUERY_ITER||''' WHERE DD_MRG_CODIGO = '''||V_MRG_CODIGO||''''
    ;
      
	EXECUTE IMMEDIATE V_SQL
	; 
	
	DBMS_OUTPUT.PUT_LINE('[FIN] del updateo de la tabla DD_MRG_MOTIVO_RECHAZO')
	;
	
	COMMIT
	;    
    
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
