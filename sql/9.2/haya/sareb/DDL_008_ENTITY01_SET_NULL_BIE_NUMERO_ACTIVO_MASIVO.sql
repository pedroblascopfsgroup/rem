--/*
--##########################################
--## AUTOR=RAFAEL ARACIL
--## FECHA_CREACION=20160331
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-849
--## PRODUCTO=SI
--##
--## Finalidad: Actualizacion masiva bie:numero_activo
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN		
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... SET NULL BIE_NUMERO_ACTIVOEN TABLA BIE_BIEN BIE_CODIGO_INTERNO=BIE_NUMERO_ACTIVO');
    V_SQL := 
    'UPDATE '||V_ESQUEMA||'.BIE_BIEN
     SET BIE_NUMERO_ACTIVO=NULL 
     WHERE BIE_ID IN (
     select bie_id FROM '||V_ESQUEMA||'.BIE_BIEN WHERE  BIE_CODIGO_INTERNO=BIE_NUMERO_ACTIVO)
    ';
    EXECUTE IMMEDIATE V_SQL;
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... SET NULL BIE_NUMERO_ACTIVO' );    



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