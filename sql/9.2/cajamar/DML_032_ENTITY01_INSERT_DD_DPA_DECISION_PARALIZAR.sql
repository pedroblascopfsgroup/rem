--/* 
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.5
--## INCIDENCIA_LINK=PRODUCTO-1679
--## PRODUCTO=NO
--##
--## Finalidad: Inserta nuevos motivos de paralizacion en DD_DPA_DECISION_PARALIZAR.
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
        
        --Registro ADG.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''ADG'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''ADG'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''ADG'', ''Atípico de Gastos'', ''Atípico de Gastos'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''ADG'' ');
        END IF;
        
        --Registro CSR.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''CSR'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''CSR'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''CSR'', ''CSR Alta el 9/10/2000 para Comprobar'', ''CSR Alta el 9/10/2000 para Comprobar'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''CSR'' ');
        END IF;
        
        --Registro CFUA.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''CFUA'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''CFUA'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''CFUA'', ''Cartera Fallida Ulises-Alkali'', ''Cartera Fallida Ulises-Alkali'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''CFUA'' ');
        END IF;
        
        --Registro CFAG.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''CFAG'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''CFAG'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''CFAG'', ''Cartera Fallida Alcala-Gescobro'', ''Cartera Fallida Alcala-Gescobro'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''CFAG'' ');
        END IF;
        
        --Registro RD.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''RD'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''RD'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''RD'', ''PTE. Resolución Otras Operaciones'', ''PTE. Resolución Otras Operaciones'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''RD'' ');
        END IF;
        
        --Registro APLAU.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''APLAU'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''APLAU'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''APLAU'', ''Aplazamiento Autorizado'', ''Aplazamiento Autorizado'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''APLAU'' ');
        END IF;
        
        --Registro PPA.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''PPA'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''PPA'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''PPA'', ''Plan de Pagos Autorizado'', ''Plan de Pagos Autorizado'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''PPA'' ');
        END IF;
        
        --Registro IPE.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''IPE'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''IPE'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''IPE'', ''Insolvente Pendiente de Estudio'', ''Insolvente Pendiente de Estudio'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''IPE'' ');
        END IF;
        
        --Registro IPAEE.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''IPAEE'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''IPAEE'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''IPAEE'', ''Insolvente Pendiente Asignación Empresa Externa'', ''Insolvente Pendiente Asignación Empresa Externa'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''IPAEE'' ');
        END IF;
        
        --Registro CONCUR.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR WHERE DD_DPA_CODIGO = ''CONCUR'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Ya existe DD_DPA_CODIGO = ''CONCUR'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR(DD_DPA_ID,DD_DPA_CODIGO,DD_DPA_DESCRIPCION,DD_DPA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR.NEXTVAL, ''CONCUR'', ''Concurso de Acreedores'', ''Concurso de Acreedores'', 1, ''PRODUCTO-1679'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Registro insertado DD_DPA_CODIGO = ''CONCUR'' ');
        END IF;
              
	  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Datos actualizados ');
        
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
