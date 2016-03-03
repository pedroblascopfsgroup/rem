--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-671
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

	-- Se van a borrar los rastros del perfil PROCUCAJAMAR y PROCUINTEGRAL, con sus asociaciones a FUN_PEF y ZON_PEF_USU
	-- y una función que ya no se va a utilizar, y que se creó en este item

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_PEF
    TYPE ROL_ARRAY IS VARRAY(11) OF VARCHAR2(128);
    V_FUNCION_ROL ROL_ARRAY := ROL_ARRAY(
     	'TAB_ASUNTO_TITULOS', 'TAB_ASUNTO_ACUERDOS', 'TAB_ASUNTO_ADJUNTOS',
      	'TAB_ASUNTO_CONVENIOS','TAB_ASUNTO_FASECOMUN', 'TAB_PRC_ADJUNTO',
      	'TAB_PRC_DECISION',  'TAB_PRC_CONTRATO',
      	'TAB_BIEN_PROCEDIMIENTOS', 'TAB_BIEN_DATOSENTIDAD', 'TAB_BIEN_RELACIONES'
    );
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

   	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR'')';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FUN_PEF... NO hay registros que borrar ');
	ELSE
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF' ||
					' WHERE PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR'') ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos BORRADOS de la tabla '||V_ESQUEMA||'.FUN_PEF -- donde los perfiles son PROCUINTEGRAL o PROCUCAJAMAR');
	END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('******** ZON_PEF_USU ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ZON_PEF_USU... Comprobaciones previas'); 

   	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR'')';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ZON_PEF_USU... NO hay registros que borrar ');
	ELSE
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ZON_PEF_USU' ||
					' WHERE PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR'') ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos BORRADOS de la tabla '||V_ESQUEMA||'.ZON_PEF_USU -- donde los perfiles son PROCUINTEGRAL o PROCUCAJAMAR');
	END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('******** PEF_PERFILES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... BORRADO DE PROCUINTEGRAL y PROCUCAJAMAR '); 

   	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PEF_PERFILES... NO hay registros que borrar ');
	ELSE
		V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.PEF_PERFILES' ||
					' WHERE PEF_CODIGO=''PROCUINTEGRAL'' OR PEF_CODIGO=''PROCUCAJAMAR'' ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos BORRADOS de la tabla '||V_ESQUEMA||'.PEF_PERFILES -- donde los perfiles son PROCUINTEGRAL o PROCUCAJAMAR');
	END IF;
    
	
	DBMS_OUTPUT.PUT_LINE('******** FUN_FUNCIONES ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... BORRADO DE TAB_HISTORICO_RESOLUCIONES_PROCURADOR '); 

   	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''TAB_HISTORICO_RESOLUCIONES_PROCURADOR'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... NO hay registros que borrar ');
	ELSE
		V_MSQL := 'DELETE FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES' ||
					' WHERE FUN_DESCRIPCION=''TAB_HISTORICO_RESOLUCIONES_PROCURADOR'' ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos BORRADOS de la tabla '||V_ESQUEMA_M||'.FUN_FUNCIONES -- donde la funcion era TAB_HISTORICO_RESOLUCIONES_PROCURADOR ');
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
