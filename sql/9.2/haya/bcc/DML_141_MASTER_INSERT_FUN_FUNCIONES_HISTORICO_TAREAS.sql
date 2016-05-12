--/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1312
--## PRODUCTO=NO
--## Finalidad: DML 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
set linesize 2000
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA2 VARCHAR2(25 CHAR):= '#ESQUEMA02#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro  
    V_NUM_SEQUENCE NUMBER(16);     
    V_NUM_MAXID NUMBER(16);
  
BEGIN

	  V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    DBMS_OUTPUT.PUT_LINE(V_NUM_SEQUENCE);
    
    V_SQL := 'SELECT NVL(MAX(FUN_ID), 0) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
    DBMS_OUTPUT.PUT_LINE(V_NUM_MAXID);
    
    WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
    V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    
    END LOOP;
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''VER_SOLO_TAREAS_PROPIAS''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el VER_SOLO_TAREAS_PROPIAS');
	
	ELSE
	  V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Función que muestra solo las tareas propias'',''VER_SOLO_TAREAS_PROPIAS'',''0'',''PRODUCTO-727'',sysdate,''0'') ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
	
	END IF;
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
