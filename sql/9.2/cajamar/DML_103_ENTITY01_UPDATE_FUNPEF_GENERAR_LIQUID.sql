--/*
--##########################################
--## AUTOR=Luis Caballero	
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1342
--## PRODUCTO=SI
--## Finalidad: Borrado de la función GENERAR-LIQUIDACIONES de todos los perfiles.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    FUN_ID_ANTERIOR NUMBER(16); -- Vble. para guardar el id FUN_ID que tenia antes del script
    FUN_ID_NUEVO NUMBER(16); -- Vble. para guardar el id FUN_ID que se quiere añadir



BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Comprobando si existe la función');
	
	V_SQL := 'SELECT COUNT(FUN_ID) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''GENERAR-LIQUIDACIONES''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    V_SQL := 'SELECT COUNT(FUN_ID) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''VER_TAB_CALCULO_LIQUIDACIONES''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS_2;
    
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('Existe función GENERAR-LIQUIDACIONES en '||V_ESQUEMA_M||'.FUN_FUNCIONES... Empezando a modificar funciones del perfil');
    	
    	IF V_NUM_TABLAS_2 = 1 THEN
    	
	    	V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''GENERAR-LIQUIDACIONES'' AND BORRADO=0';
	    	EXECUTE IMMEDIATE V_SQL INTO FUN_ID_ANTERIOR;
	    	
	    	V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''VER_TAB_CALCULO_LIQUIDACIONES'' AND BORRADO=0';
	    	EXECUTE IMMEDIATE V_SQL INTO FUN_ID_NUEVO;
	    	
		
			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.FUN_PEF SET FUN_ID = '||FUN_ID_NUEVO||' WHERE FUN_ID = '||FUN_ID_ANTERIOR||'';
		
	    	DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.FUN_PEF');
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('No existe la función con Descripcion: VER_TAB_CALCULO_LIQUIDACIONES o está duplicada');
			DBMS_OUTPUT.PUT_LINE('En caso de no existir ejecute el script DML_104_ENTITY01_INSERT_FUN_FUNCIONES_CALCULO_LIQUID.sql para insertar la función');
		END IF;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('No existe la función con Descripcion: GENERAR-LIQUIDACIONES o está duplicada');	
	END IF;

COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	
