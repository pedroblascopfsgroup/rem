--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20151029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1290
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_NUM1 NUMBER(20); -- Vble. auxiliar
    V_NUM2 NUMBER(20); -- Vble. auxiliar
    V_NUM3 NUMBER(20); -- Vble. auxiliar
    V_NUM4 NUMBER(20); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'select USU_ID from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A172244''';
	execute immediate V_SQL  INTO V_NUM1;
	V_SQL := 'select USU_ID from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A127028''';
	execute immediate V_SQL INTO V_NUM2;
	V_SQL := 'select USU_ID from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A112600''';
	execute immediate V_SQL INTO V_NUM3;
	V_SQL := 'select USU_ID from '||V_ESQUEMA_M||'.USU_USUARIOS where USU_USERNAME=''A168771''';
	execute immediate V_SQL INTO V_NUM4;
	--/**
	-- * Modificación de USD_USUARIOS_DESPACHOS, donde dejaremos solamente un 1 USD_GESTOR_DEFECTO activo por DES_ID (despacho)
	-- */
	execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0 where DES_ID=1218 and USU_ID='||V_NUM1||'';
	execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0 where DES_ID=5120 and USU_ID='||V_NUM2||'';
	execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0 where DES_ID=5120 and USU_ID='||V_NUM3||'';
	execute immediate 'update '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS set USD_GESTOR_DEFECTO=0 where DES_ID=142353 and USU_ID='||V_NUM4||'';

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;