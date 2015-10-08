--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20150901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-231
--## PRODUCTO=SI
--## Finalidad: DML , Cambio de la descripcion del estado de preparación Preturnado x En Estudio
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_DDNAME VARCHAR2(30):= 'DD_PCO_PRC_ESTADO_PREPARACION';

   
BEGIN


	V_SQL := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.' || V_DDNAME || ' WHERE DD_PCO_PEP_CODIGO = ''PT''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
	    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizar Sí');
	    V_SQL := 'UPDATE ' || V_ESQUEMA || '.' || V_DDNAME || ' SET DD_PCO_PEP_DESCRIPCION = ''En estudio'' , DD_PCO_PEP_DESCRIPCION_LARGA = ''En estudio'' WHERE DD_PCO_PEP_CODIGO = ''PT''';
	    EXECUTE IMMEDIATE V_SQL;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] El código PT (Preturnado) no existe');    
	END IF;


COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

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




