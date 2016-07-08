--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.7
--## INCIDENCIA_LINK=RECOVERY-140
--## PRODUCTO=SI
--## Finalidad: DML
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
  DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********');

  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobacion previa');
  
  V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRLETEXT''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
  
  IF V_NUM_EXISTE > 0 THEN
  
    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_BUSCAPROC''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;

      IF V_NUM_EXISTE > 0 THEN
      
            V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRLETEXT'') AND FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_BUSCAPROC'')';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS > 0 THEN	  
              DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla '||V_ESQUEMA||'.PEF_PERFILES.');
            ELSE
              V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_BUSCAPROC''), (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRLETEXT''),''RECOVERY-140'', SYSDATE, 0)';
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.PEF_PERFILES');
            END IF;

            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.FUN_FUNCIONES la funcion ROLE_BUSCAPROC NO existe. No se puede continuar...');
        END IF;
  
  ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES el perfil FPFSRLETEXT NO existe. No se puede continuar...');
  END IF;
	
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
