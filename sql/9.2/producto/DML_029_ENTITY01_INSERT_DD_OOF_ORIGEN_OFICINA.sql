--/* 
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1491
--## PRODUCTO=SI
--##
--## Finalidad: Inserta nuevo diccionario origen oficina en DD_OOF_ORIGEN_OFICINA.
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
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Empezando a insertar datos en DD_OOF_ORIGEN_OFICINA');
        
        --Registro CENGESCLI.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA WHERE DD_OOF_CODIGO = ''CENGESCLI'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Ya existe DD_OOF_CODIGO = ''CENGESCLI'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA(DD_OOF_ID,DD_OOF_CODIGO,DD_OOF_DESCRIPCION,DD_OOF_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_OOF_ORIGEN_OFICINA.NEXTVAL, ''CENGESCLI'', ''Centro gestor del cliente'', ''Centro gestor del cliente'', 1, ''PRODUCTO-1491'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Registro insertado DD_OOF_CODIGO = ''CENGESCLI'' ');
        END IF;
        
        --Registro CENCONTABCONTR.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA WHERE DD_OOF_CODIGO = ''CENCONTABCONTR'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Ya existe DD_OOF_CODIGO = ''CENCONTABCONTR'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA(DD_OOF_ID,DD_OOF_CODIGO,DD_OOF_DESCRIPCION,DD_OOF_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_OOF_ORIGEN_OFICINA.NEXTVAL, ''CENCONTABCONTR'', ''Centro contable del contrato'', ''Centro contable del contrato'', 1, ''PRODUCTO-1491'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Registro insertado DD_OOF_CODIGO = ''CENCONTABCONTR'' ');
        END IF;
        
        --Registro CENADMCONTR.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA WHERE DD_OOF_CODIGO = ''CENADMCONTR'' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
        
        IF V_NUM_REG > 0 THEN                                
          DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Ya existe DD_OOF_CODIGO = ''CENADMCONTR'' ');
        ELSE
          	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA(DD_OOF_ID,DD_OOF_CODIGO,DD_OOF_DESCRIPCION,DD_OOF_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,
										FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
                        VALUES('||V_ESQUEMA||'.S_DD_OOF_ORIGEN_OFICINA.NEXTVAL, ''CENADMCONTR'', ''Centro administrativo del contrato'', ''Centro administrativo del contrato'', 1, ''PRODUCTO-1491'', 
				sysdate, null, null, null, null, ''0'') ';
              EXECUTE IMMEDIATE V_MSQL;
          
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Registro insertado DD_OOF_CODIGO = ''CENADMCONTR'' ');
        END IF;
        
              
	  DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.DD_OOF_ORIGEN_OFICINA... Datos actualizados ');
        
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
