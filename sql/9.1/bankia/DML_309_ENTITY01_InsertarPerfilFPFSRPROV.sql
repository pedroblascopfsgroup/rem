--/*
--##########################################
--## AUTOR=ÓSCAR DORADO
--## FECHA_CREACION=20160204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.20-bk
--## INCIDENCIA_LINK=PRODUCTO-699
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PEF_PERFILES... Empezando a insertar datos en el diccionario');
    
    V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROV''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	    DBMS_OUTPUT.PUT_LINE('[INFO] Insertar Sí');
	    EXECUTE IMMEDIATE 'Insert into '||V_ESQUEMA||'.PEF_PERFILES
  		 (PEF_ID, PEF_DESCRIPCION_LARGA, PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE)
		 Values
  		 ('||V_ESQUEMA||'.s_pef_perfiles.nextval, ''Permiso para cambiar procurador con provisión activa'', ''Permiso para cambiar procurador con provisión'', 0, ''PRODUCTO-699'', sysdate, null, null, 0, ''FPFSRPROV'', 0, ''EXTPerfil'')';
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PEF_PERFILES...  nuevo perfil creado');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.PEF_PERFILES...  el perfil ya estaba creado');
  	END IF;
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
  	