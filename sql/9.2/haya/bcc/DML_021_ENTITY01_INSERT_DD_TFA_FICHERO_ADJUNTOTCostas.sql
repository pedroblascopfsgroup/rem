--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.1-cj-rc14
--## INCIDENCIA_LINK= CMREC-2969
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

       
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM WHERE TFA_CODIGO_EXTERNO  = ''00370'' AND DD_TFA_ID = (SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''TJC'')';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
	    --Lo relacionamos con el gestor documental
	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MTT_MAP_ADJRECOVERY_ADJCM (MTT_ID,DD_TFA_ID,TFA_CODIGO_EXTERNO,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_MTT_METRICAS_TIPO.NEXTVAL,(SELECT DD_TFA_ID FROM '||V_ESQUEMA||'.DD_TFA_FICHERO_ADJUNTO WHERE DD_TFA_CODIGO = ''TJC''),''00370'',''0'',''CMREC-2886'',SYSDATE ,null,null,null,null,''0'')';
	    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
	
	ELSE
		DBMS_OUTPUT.PUT_LINE('ya esta INSERTADO');
	END IF;
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	