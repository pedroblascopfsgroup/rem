--/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2219
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las subastas para añadirle un valor por defecto a 0 a la columna SUB_TRAMITACION 
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(100 CHAR); --Vble. para guardar la tabla
    V_TABLA1 VARCHAR2(100 CHAR); --Vble. para guardar la tabla
    V_TABLA2 VARCHAR2(100 CHAR); --Vble. para guardar la tabla
BEGIN

	V_TABLA := 'SUB_SUBASTA';
	V_TABLA1 := 'PRC_PROCEDIMIENTOS';
	V_TABLA2 := 'DD_TPO_TIPO_PROCEDIMIENTO';

			DBMS_OUTPUT.PUT_LINE('Actualizamos en todas las subastas la columna SUB_TRAMITACION a 0 por defecto');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET SUB_TRAMITACION = 0 ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Actualizadas');
			
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
