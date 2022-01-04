--/*
--######################################### 
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16534
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar config proveedores para Jaguar
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'HREOS-16534';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);

    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    

	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM  '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''16'')
	 AND DD_SCR_ID = (SELECT DD_SCR_ID FROM  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''153'') AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CPP_ID,DD_CRA_ID,DD_SCR_ID,DD_TTR_ID,DD_STR_ID,PVE_ID,USUARIOCREAR,FECHACREAR,DD_PRV_ID) 
					 SELECT  '||V_ESQUEMA||'.S_CFG_PVE_PREDETERMINADO.NEXTVAL
			,(SELECT DD_CRA_ID FROM  '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'')
			,(SELECT DD_SCR_ID FROM  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''70'')
			,DD_TTR_ID
			,DD_STR_ID
			,PVE_ID
			,'''||V_USU||'''
			,SYSDATE
			,DD_PRV_ID
			FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
			WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM  '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''16'')
				AND DD_SCR_ID = (SELECT DD_SCR_ID FROM  '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''153'')
				AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO]  '||SQL%ROWCOUNT||'  REGISTROS INSERTADOS EN '||V_TEXT_TABLA);

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS NO INSERTADOS');

	END IF;
        
	

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;