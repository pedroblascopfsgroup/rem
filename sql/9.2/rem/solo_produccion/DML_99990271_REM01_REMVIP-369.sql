--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180322
--## ARTEFACTO=9.2
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-369
--## PRODUCTO=NO
--## Finalidad:
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	 
    EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL (ICO_ID,ACT_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
							values (S_ACT_ICO_INFO_COMERCIAL.NEXTVAL,(select ACT_ID from ACT_ACTIVO where ACT_NUM_ACTIVO = 6957783),0,''REMVIP-369'',SYSDATE,0)';  
					
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha insertado la ICO del para el activo 133959, '||SQL%ROWCOUNT||' registros insertados.');
    
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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