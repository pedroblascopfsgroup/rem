--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2-7
--## INCIDENCIA_LINK=RECOVERY-1833
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

	  V_SQL := ' SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EPF_ESTADO_PROCES_FICH WHERE DD_EPF_CODIGO = ''AVA''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.put_line('[INFO] Ya existe el registro');
  ELSE
    DBMS_OUTPUT.put_line('[INFO] Insertando nuevo valor');

    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.DD_EPF_ESTADO_PROCES_FICH
    		 (DD_EPF_ID, DD_EPF_CODIGO, DD_EPF_DESCRIPCION, DD_EPF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 				Values
  			 ('||V_ESQUEMA||'.S_DD_EPF_ESTADO_PROCES_FICH.nextval, ''AVA'', ''Avanzado'', ''Avanzado'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
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
  	