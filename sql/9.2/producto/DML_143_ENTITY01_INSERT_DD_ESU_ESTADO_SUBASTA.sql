--/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160704
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2220
--## PRODUCTO=SI
--## Finalidad: DML para crear un nuevo estado para la subasta
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
BEGIN

	V_TABLA := 'DD_ESU_ESTADO_SUBASTA';
  V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_ESU_CODIGO = ''EPU''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_ESU_ID, DD_ESU_CODIGO, DD_ESU_DESCRIPCION, DD_ESU_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)VALUES ( '||V_ESQUEMA||'.S_DD_ESU_ESTADO_SUBASTA.NEXTVAL, ''EPU'',''EN PUJA'', ''EN PUJA'', 0 ,''RECOVERY-2220'', SYSDATE, 0)'; 
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
	ELSE
		 	DBMS_OUTPUT.PUT_LINE('Ya existe el valor del diccionario');		
	
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
