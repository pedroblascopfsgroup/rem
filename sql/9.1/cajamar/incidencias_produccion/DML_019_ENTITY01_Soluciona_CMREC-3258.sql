--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-3258
--## PRODUCTO=NO
--## Finalidad: DML Soluciona CMREC-3258
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'CM01'; -- Configuracion Esquema este caso haya01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'CMMASTER'; -- Configuracion Esquema Master este caso hayamaster
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
	V_AUXILIAR VARCHAR2(200 CHAR); -- Vble. auxiliar en este caso peticion o nombre del sql
    V_TABLA VARCHAR2(50 CHAR); -- Vble. Tabla con la que trabajamos.
	V_Campo VARCHAR2(50 CHAR);--Campo de búsqueda.
	V_Valor VARCHAR2(1000 CHAR);--Valor buscado.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO PROCEDIMIENTO]******** Soluciona_CMREC-3258 ********'); 
	  

	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC set PRC.PRC_PARALIZADO=0 ' ||
			' where USUARIOMODIFICAR= ''SINCRO_CM_HAYA_PARALIZADO'' ' ;

          EXECUTE IMMEDIATE V_MSQL;

	  V_MSQL := 'DELETE from '||V_ESQUEMA||'.PRD_PROCEDIMIENTOS_DERIVADOS where usuariocrear=''SINCRO_CM_HAYA_PARALIZADO'' ';
	  EXECUTE IMMEDIATE V_MSQL;

	  V_MSQL := 'DELETE from '||V_ESQUEMA||'.DPR_DECISIONES_PROCEDIMIENTOS where usuariocrear=''SINCRO_CM_HAYA_PARALIZADO'' ';
	  EXECUTE IMMEDIATE V_MSQL;

	  V_MSQL := 'DELETE from '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP where usuariocrear=''SINCRO_CM_HAYA_PARALIZADO'' ';
	  EXECUTE IMMEDIATE V_MSQL;


	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN PROCEDIMIENTO]******** Soluciona_CMREC-3258 ********'); 

	EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR PROCEDIMIENTO]-----------Soluciona_CMREC-3289-----------');
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('[FIN PROCEDIMIENTO]-------------Soluciona_CMREC-3289-----------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
    
END;
/

EXIT;
