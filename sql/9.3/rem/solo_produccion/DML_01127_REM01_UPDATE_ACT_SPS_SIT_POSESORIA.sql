--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11024
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11024';
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('7461382'),
        T_TIPO_DATA('6980398'),
        T_TIPO_DATA('6980489'),
        T_TIPO_DATA('6966910'),
        T_TIPO_DATA('6981332'),
        T_TIPO_DATA('6982161'),
        T_TIPO_DATA('6984400'),
        T_TIPO_DATA('6989187'),
        T_TIPO_DATA('6989913'),
        T_TIPO_DATA('6996495'),
        T_TIPO_DATA('6997809'),
        T_TIPO_DATA('7386522'),
        T_TIPO_DATA('6966886'),
        T_TIPO_DATA('6965794')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ACT_SPS_SIT_POSESORIA');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN	

			V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA T1 USING (
                            SELECT SPS_ID, SPS_FECHA_TOMA_POSESION FROM '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = SPS.ACT_ID AND ACT.BORRADO = 0
                            WHERE SPS.BORRADO = 0 AND ACT.ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||') T2
                        ON (T1.SPS_ID = T2.SPS_ID)
                        WHEN MATCHED THEN UPDATE SET
                        T1.SPS_FECHA_REVISION_ESTADO = T2.SPS_FECHA_TOMA_POSESION,
                        T1.USUARIOMODIFICAR = '''||V_USU||''',
                        T1.FECHAMODIFICAR = SYSDATE';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADA SITUACION POSESORIA DEL ACTIVO '||V_TMP_TIPO_DATA(1)||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACT_NUM_ACTIVO '||V_TMP_TIPO_DATA(1)||'');

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