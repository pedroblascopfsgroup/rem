--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11137
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Borrar activos
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
      V_USU VARCHAR2(30 CHAR) := 'REMVIP-11137';
	V_NUM_TABLAS NUMBER(16);
	V_ACT_NUM_ACTIVO NUMBER(16);
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('648950'),
T_TIPO_DATA('654937'),
T_TIPO_DATA('662798'),
T_TIPO_DATA('666468'),
T_TIPO_DATA('666469'),
T_TIPO_DATA('666482'),
T_TIPO_DATA('671375'),
T_TIPO_DATA('671376'),
T_TIPO_DATA('671377'),
T_TIPO_DATA('675560'),
T_TIPO_DATA('681281'),
T_TIPO_DATA('681282'),
T_TIPO_DATA('681380'),
T_TIPO_DATA('685917'),
T_TIPO_DATA('691904'),
T_TIPO_DATA('691905'),
T_TIPO_DATA('691906'),
T_TIPO_DATA('691907'),
T_TIPO_DATA('692019'),
T_TIPO_DATA('700843'),
T_TIPO_DATA('705626'),
T_TIPO_DATA('705627'),
T_TIPO_DATA('705628'),
T_TIPO_DATA('705732'),
T_TIPO_DATA('716482'),
T_TIPO_DATA('725308'),
T_TIPO_DATA('725325'),
T_TIPO_DATA('735612'),
T_TIPO_DATA('735613'),
T_TIPO_DATA('735614')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_NUM_ACTIVO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_SAREB = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN	

			V_MSQL := 'SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_SAREB = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_NUM_ACTIVO;	

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
						ACT_NUM_ACTIVO = -999'||V_ACT_NUM_ACTIVO||',
						BORRADO = 1,
						FECHABORRAR = SYSDATE,
                                    USUARIOBORRAR = '''||V_USU||'''
						WHERE ACT_NUM_ACTIVO = '||V_ACT_NUM_ACTIVO||'
                                    AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO DE ACT_NUM_ACTIVO_SAREB '||V_TMP_TIPO_DATA(1)||' MODIFICADA '|| SQL%ROWCOUNT ||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACT_NUM_ACTIVO_SAREB '||V_TMP_TIPO_DATA(1)||'');

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