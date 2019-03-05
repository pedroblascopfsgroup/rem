--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3083
--## PRODUCTO=NO
--##
--## Finalidad: Añadir propietario a un activo en especifico
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
	V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-3428';


BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a insertar el propietario CIMENTADOS3, S.A. al activo 6945155.');
    
			V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
			V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
				(PAC_ID
				,ACT_ID
				,PRO_ID
				,DD_TGP_ID
				,PAC_PORC_PROPIEDAD
				,VERSION
				,USUARIOCREAR
				,FECHACREAR
				,BORRADO
				)
				SELECT '|| V_ID ||'
				, (SELECT ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6945155)
				, (SELECT PRO_ID FROM '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO WHERE PRO_NOMBRE = ''CIMENTADOS3, S.A.'')
				, (SELECT DD_TGP_ID FROM '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_DESCRIPCION = ''Pleno dominio'')
				, 100
				, 0
				, '''||V_USU||'''
				, SYSDATE
				, 0 FROM DUAL
			';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Insertado correctamente el propietario CIMENTADOS3, S.A. en el activo 6945155.');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
		  DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;          

END;
/

EXIT
