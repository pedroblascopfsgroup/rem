--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3425
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
	V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
	V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
	V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TABLA VARCHAR2(40 CHAR) := 'JOB_PERIMETRO';
    TABLE_COUNT NUMBER(1,0) := 0;
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
	X NUMBER;

  BEGIN



  	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

	IF TABLE_COUNT > 0 THEN

	    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
	    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	    
	END IF;


	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'. BORRADA');  




	DBMS_OUTPUT.PUT_LINE('[INFO] BORRAMOS EL JOB');  

  
   	-- Verificar si ya existe el JOB
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SCHEDULER_JOBS WHERE JOB_NAME = ''JOB_MONITORIZAR_PERIMETRO''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.JOB_MONITORIZAR_PERIMETRO... Ya existe. Se borrará.');
		DBMS_SCHEDULER.DROP_JOB(JOB_NAME => 'JOB_MONITORIZAR_PERIMETRO');
	END IF;
	
 
  
	DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Job borrado.');
	
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
