--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3461
--## PRODUCTO=NO
--##
--## Finalidad: Script que pone fecha de caducidad a los documentos de admision
--## INSTRUCCIONES:
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ADO_ADMISION_DOCUMENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3461';
    
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
						SET ADO_FECHA_CADUCIDAD = ADD_MONTHS(ADO_FECHA_EMISION, 10*12),
						ADO_APLICA = 1,
						DD_EDC_ID = ( SELECT DD_EDC_ID FROM '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO WHERE DD_EDC_CODIGO = ''01'' )
						USUARIOMODIFICAR = '''||V_USUARIO||''',
						FECHAMODIFICAR = SYSDATE
						WHERE CFD_ID IN ( SELECT CFD_ID 
						                  FROM '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO
						                  WHERE DD_TPD_ID = ( SELECT DD_TPD_ID 
						                                    FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO 
						                                    WHERE DD_TPD_CODIGO = ''11'' )
						                ) 
						AND ADO_FECHA_EMISION IS NOT NULL AND ADO_FECHA_CADUCIDAD IS NULL AND BORRADO = 0';
						
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Fecha caducidad actualizada correctamente para Documentos CEE');
	
	EXCEPTION
	 WHEN OTHERS THEN
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