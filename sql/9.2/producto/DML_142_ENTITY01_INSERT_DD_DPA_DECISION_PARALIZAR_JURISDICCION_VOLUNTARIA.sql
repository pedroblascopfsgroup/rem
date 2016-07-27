--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERÁ
--## FECHA_CREACION=20160705
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2318
--## PRODUCTO=SI
--##
--## Finalidad: Se añade el valor "Jurisdicción Voluntaria" al diccionario DD_DPA_DECISION_PARALIZAR
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Empezando a insertar datos en DD_DPA_DECISION_PARALIZAR');
        
        --Registro JURISVOL.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''JURISVOL'' OR DD_DPA_DESCRIPCION = ''Jurisdicción Voluntaria'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''JURISVOL'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''JURISVOL'', ''Jurisdicción Voluntaria'', ''Jurisdicción Voluntaria'', 1, ''RECOVERY-2318'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''JURISVOL'' ');
        END IF;
              
	  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Datos actualizados ');
        
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
