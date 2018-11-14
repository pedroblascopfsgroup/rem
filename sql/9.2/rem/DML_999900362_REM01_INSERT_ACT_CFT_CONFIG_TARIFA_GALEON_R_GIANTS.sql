--/*
--##########################################
--## AUTOR=Sergio Beleña Boix
--## FECHA_CREACION=20181106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4630
--## PRODUCTO=NO
--##
--## Finalidad: replicarse el tarifario GIANTS en GALEON
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
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.	


	
	V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-4630';
	V_TABLA_CFT VARCHAR2(30 CHAR) := 'ACT_CFT_CONFIG_TARIFA';
	V_TABLA_CRA VARCHAR2(30 CHAR) := 'DD_CRA_CARTERA';

BEGIN	
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empieza la insercción de  tarifario que actualmente tiene la cartera GIANTS para GALEON');   
		V_MSQL := '
		INSERT INTO '|| V_ESQUEMA ||'.'|| V_TABLA_CFT ||' (
		BORRADO
		,CFT_ID
		,CFT_PRECIO_UNITARIO
		,CFT_UNIDAD_MEDIDA
		,DD_CRA_ID
		,DD_STR_ID
		,DD_TTF_ID
		,DD_TTR_ID
		,FECHABORRAR
		,FECHACREAR
		,FECHAMODIFICAR
		,PVE_ID
		,USUARIOBORRAR
		,USUARIOCREAR
		,USUARIOMODIFICAR
		,VERSION
		)
		SELECT 
		0 BORRADO
		,'|| V_ESQUEMA ||'.S_ACT_CFT_CONFIG_TARIFA.NEXTVAL 				CFT_ID
		,TA.CFT_PRECIO_UNITARIO 							CFT_PRECIO_UNITARIO
		,TA.CFT_UNIDAD_MEDIDA 								CFT_UNIDAD_MEDIDA
		,(SELECT DD_CRA_ID FROM '|| V_TABLA_CRA ||'  WHERE DD_CRA_CODIGO=''15'') 	DD_CRA_ID
		,TA.DD_STR_ID 									DD_STR_ID
		,TA.DD_TTF_ID 									DD_TTF_ID
		,TA.DD_TTR_ID 									DD_TTR_ID
		,NULL 										FECHABORRAR
		,SYSDATE 									FECHACREAR
		,NULL 										FECHAMODIFICAR
		,TA.PVE_ID 									PVE_ID
		,NULL 										USUARIOBORRAR
		,'''||V_USUARIO||''' 								USUARIOCREAR
		,NULL 										USUARIOMODIFICAR
		,0  										VERSION

		
	FROM '|| V_ESQUEMA ||'.'|| V_TABLA_CFT ||' TA  WHERE
		 TA.DD_CRA_ID = (SELECT CRA.DD_CRA_ID FROM '|| V_ESQUEMA ||'.'|| V_TABLA_CRA ||' CRA WHERE CRA.DD_CRA_CODIGO=''12'')
	AND  NOT EXISTS 
		(SELECT 1 FROM '|| V_ESQUEMA ||'.'|| V_TABLA_CFT ||' TAC  WHERE 
		TAC.DD_CRA_ID = (SELECT DD.DD_CRA_ID FROM '|| V_ESQUEMA ||'.'|| V_TABLA_CRA ||' DD WHERE DD.DD_CRA_CODIGO=''15'') AND TA.DD_TTF_ID= TAC.DD_TTF_ID AND TAC.DD_STR_ID=TA.DD_STR_ID )';

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||sql%rowcount||' en la tabla '||V_TABLA_CFT);

		DBMS_OUTPUT.PUT_LINE('');
		
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN] '|| V_TABLA_CFT || ' INSERTADO EN GALEON LOS REGITROS DE GIANTS ACTUALES');



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
