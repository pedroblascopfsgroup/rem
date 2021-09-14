--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210907
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9840
--## PRODUCTO=NO
--##
--## Finalidad: Borrar usuarios gestoría formalización
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
    ERR_MSG VARCHAR2(124 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-9840'; -- USUARIOCREAR/USUARIOMODIFICAR.   
	V_COUNT NUMBER(16); 
	V_DES NUMBER(16); 
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL :='SELECT DES_ID FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO WHERE DES_DESPACHO = ''GESTORIAFORM''';
    EXECUTE IMMEDIATE V_MSQL INTO V_DES;

	V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE DES_ID = '||V_DES||' 
				AND USU_ID NOT IN (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN 
				(''garsa03'',
				''garsa03apple'',
				''garsa03_bbva'',
				''garsa03cajamar'',
				''garsa03lbk'',
				''garsa03sareb'',
				''pinos03'',
				''pinos03_bbva'',
				''knb03_bbva'',
				''ogf03'',
				''montalvo03'',
				''unidadff03'')) 
				AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT > 0 THEN

		V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.USD_USUARIOS_DESPACHOS SET 
			USUARIOBORRAR =  '''||V_USR||''',
			FECHABORRAR = SYSDATE,
			BORRADO = 1
			WHERE DES_ID = '||V_DES||' 
				AND USU_ID NOT IN (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME IN 
				(''garsa03'',
				''garsa03apple'',
				''garsa03_bbva'',
				''garsa03cajamar'',
				''garsa03lbk'',
				''garsa03sareb'',
				''pinos03'',
				''pinos03_bbva'',
				''knb03_bbva'',
				''ogf03'',
				''montalvo03'',
				''unidadff03'')) 
				AND BORRADO = 0'; 
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' USUARIOS GESTORIA FORMALIZACIÓN BORRADOS DE MANERA LÓGICA EN USD_USUARIOS_DESPACHO');

	ELSE 

		DBMS_OUTPUT.PUT_LINE('[INFO]: NO HAY NADA PARA ACTUALIZAR');

	END IF;
    
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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
EXIT;
