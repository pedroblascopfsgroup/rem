--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10208
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Cambiar cartera y subcartera
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
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10208';
	V_NUM_TABLAS NUMBER(16);
	V_ID NUMBER(16);
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('6895347'),
			T_TIPO_DATA('6892704'),
			T_TIPO_DATA('6892703'),
			T_TIPO_DATA('6892702'),
			T_TIPO_DATA('6892701')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_ACTIVO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN	

			V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''),
						DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''38''),
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT_ID = '||V_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '||V_TMP_TIPO_DATA(1)||' MODIFICADO');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '||V_TMP_TIPO_DATA(1)||'');

		END IF;
        
	END LOOP;

    COMMIT;

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