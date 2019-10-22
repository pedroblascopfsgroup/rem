--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5537
--## PRODUCTO=NO
--## Finalidad: Ampliar la tabla de visitas con un nuevo campo.
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Inicio del proceso ');

	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.HLD_HISTORICO_LANZA_PER_DETA MODIFY HLD_VALOR_ORIGINAL VARCHAR2( 512 ) ';

	EXECUTE IMMEDIATE V_MSQL;		

	DBMS_OUTPUT.PUT_LINE('[INFO] Ampliado HLD_HISTORICO_LANZA_PER_DETA.HLD_VALOR_ORIGINAL a 512 carácteres ');

	V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.HLD_HISTORICO_LANZA_PER_DETA MODIFY HLD_VALOR_ACTUALIZADO VARCHAR2( 512 ) ';

	EXECUTE IMMEDIATE V_MSQL;		

	DBMS_OUTPUT.PUT_LINE('[INFO] Ampliado HLD_HISTORICO_LANZA_PER_DETA.HLD_VALOR_ACTUALIZADO a 512 carácteres ');


	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] Proceso realizado ');



EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
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
