--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10028
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar situación posesoria
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10028';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_BIE_ID NUMBER(16); 
	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7288046','1'),
            T_TIPO_DATA('7318618','0')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR SITUACIÓN POSESORIA DE ACTIVOS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET
            SPS_FECHA_REVISION_ESTADO = NULL,
            SPS_FECHA_TOMA_POSESION = NULL,
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE
            WHERE ACT_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            IF V_TMP_TIPO_DATA(2) = 1 THEN

                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL SET
                FECHA_POSESION = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE
                WHERE ACT_ID = '||V_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

            ELSE 

                V_MSQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_BIE_ID;

                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET
                BIE_ADJ_F_REA_LANZAMIENTO = NULL,
                BIE_ADJ_F_REA_POSESION = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE
                WHERE BIE_ID = '||V_BIE_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

            END IF;

            DBMS_OUTPUT.PUT_LINE('[INFO] SITUACIÓN POSESORIA DEL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');

        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;