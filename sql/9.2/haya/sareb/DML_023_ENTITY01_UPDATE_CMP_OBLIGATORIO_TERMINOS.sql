--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160415
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-1242
--## PRODUCTO=SI
--##
--## Finalidad: DDL Alterar la tabla ACU_CAMPOS_TIPO_ACUERDO y crear un nuevo campo CMP_OBLIGATORIO para comprobar la obligatoriedad de los campos de los términos
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

    -- ******** Update de la tabla ACU_CAMPOS_TIPO_ACUERDO *******
    DBMS_OUTPUT.PUT_LINE('******** Update de la tabla ACU_CAMPOS_TIPO_ACUERDO *******'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACU_CAMPOS_TIPO_ACUERDO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si NO existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO... Tabla NO existe, imposible continuar');    
    ELSE
    
    	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ACU_CAMPOS_TIPO_ACUERDO'' and owner = '''||V_ESQUEMA||''' and column_name = ''CMP_OBLIGATORIO''';
   		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	-- Si existe el campo lo actualizamos sino informamos
    	IF V_NUM_TABLAS = 1 THEN
        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO... Comienza la actualización');
        	V_MSQL := 'update '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET CMP_OBLIGATORIO = 1 WHERE CMP_NOMBRE_CAMPO IN(''fechaSolucionPrevista'',''solicitarAlquiler'',''nombreCesionario'',''relacionCesionarioTitular'',''importeCesion'',''importeQuita'',''porcentajeQuita'')
				or  (CMP_NOMBRE_CAMPO= ''fechaPrevistaFirma'' and DD_TPA_ID IN(SELECT DD_TPA_ID FROM ' || V_ESQUEMA || '.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO IN (''VEN_CRED'',''01'',''QUITA''))) ';
        	DBMS_OUTPUT.PUT_LINE(V_MSQL);
        	EXECUTE IMMEDIATE V_MSQL; 
        	COMMIT;	
        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO... Actualizados los valores del campo CMP_OBLIGATORIO');
        	
    	ELSE
       	 	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO... CMP_OBLIGATORIO no existe');
       	 	DBMS_OUTPUT.PUT_LINE('[INFO] Ejecute antes DDL_361_ENTITY01_ALTER_TABLE_CMP_OBLIGATORIO.sql para crea la columna');
    	END IF;
    
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');
	

    
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
