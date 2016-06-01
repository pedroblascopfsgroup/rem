--/* 
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=CMREC-3258
--## PRODUCTO=NO
--##
--## Finalidad: Inserta EN DD_DPA_DECISION_PARALIZAR DD_DPA_CODIGO = 'GEX'
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualizaciÃ³n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Empezando a insertar datos en DD_DPA_DECISION_PARALIZAR');
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''GEEX'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''GEEX'' ');
        ELSE
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''GEEX'', ''Gestión en empresa externa'', ''Gestión en empresa externa'', 1, ''DML'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
	  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Insertado DD_DPA_CODIGO = ''GEEX'' ');
        END IF;
    COMMIT;
           
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
