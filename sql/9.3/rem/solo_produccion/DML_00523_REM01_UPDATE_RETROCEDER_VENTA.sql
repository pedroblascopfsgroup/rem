--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8337
--## PRODUCTO=NO
--## 
--## Finalidad: Retroceder venta de activos
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

    -- Ejecutar
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USU VARCHAR2(50 CHAR) := 'REMVIP_8337';
    -- IDs
    V_SITUACION_COMERCIAL_ID NUMBER(16); -- Vble. para el id de la situacion comercial
    V_ACTIVO_ID NUMBER(16); -- Vble. para el id del activo
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('32063539'),
            T_TIPO_DATA('33722701'),
            T_TIPO_DATA('33067107'),
            T_TIPO_DATA('33661773'),
            T_TIPO_DATA('31946923'),
            T_TIPO_DATA('31409366'),
            T_TIPO_DATA('11896561'),
            T_TIPO_DATA('29844981'),
            T_TIPO_DATA('29844864'),
            T_TIPO_DATA('33711623'),
            T_TIPO_DATA('6858091'),
            T_TIPO_DATA('9649001'),
            T_TIPO_DATA('9649118'),
            T_TIPO_DATA('33692445'),
            T_TIPO_DATA('12581398'),
            T_TIPO_DATA('20858237'),
            T_TIPO_DATA('33638550'),
            T_TIPO_DATA('31947097'),
            T_TIPO_DATA('32076792'),
            T_TIPO_DATA('32129513'),
            T_TIPO_DATA('33260031'),
            T_TIPO_DATA('33431247'),
            T_TIPO_DATA('33611582'),
            T_TIPO_DATA('33611600'),
            T_TIPO_DATA('33611717'),
            T_TIPO_DATA('33611834'),
            T_TIPO_DATA('33611951')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: RETROCEDER VENTA DE ACTIVOS');

    --Obtener id de situación comercial 'Disponible para la venta'
    V_MSQL := 'SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02''';
        EXECUTE IMMEDIATE V_MSQL INTO V_SITUACION_COMERCIAL_ID;

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;			

        IF V_COUNT = 1 THEN
               
            --Actualizamos el activo en los campos DD_SCM_ID, ACT_VENTA_EXTERNA_FECHA, ACT_VENTA_EXTERNA_IMPORTE
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
                DD_SCM_ID = NULL,
                ACT_VENTA_EXTERNA_FECHA = NULL,
                ACT_VENTA_EXTERNA_IMPORTE = NULL,
                USUARIOMODIFICAR = '''||V_USU||''',
                FECHAMODIFICAR = SYSDATE
                WHERE ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''';
            
            EXECUTE IMMEDIATE V_MSQL;

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_ID;	
        
            --Actualizamos el perímetro del activo para que los checks de Publicación, Comercializar, Formalizar estén activos
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET
                PAC_CHECK_GESTIONAR = 1,
                PAC_FECHA_GESTIONAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
                PAC_MOTIVO_GESTIONAR = NULL,
                PAC_CHECK_PUBLICAR = 1,
                PAC_FECHA_PUBLICAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
                PAC_MOTIVO_PUBLICAR = NULL,
                PAC_CHECK_COMERCIALIZAR = 1,
                PAC_FECHA_COMERCIALIZAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
                PAC_CHECK_FORMALIZAR = 1,
                PAC_FECHA_FORMALIZAR = TO_DATE(SYSDATE, ''DD/MM/YY''),
                PAC_MOTIVO_FORMALIZAR = NULL,
                USUARIOMODIFICAR = '''||V_USU||''', 
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '''||V_ACTIVO_ID||'''';
            
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO CON ÉXITO');
                
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REFRESCAR SITUACIÓN COMERCIAL DE LOS ACTIVOS');

    -- Refresca la situación comercial de los activos que tienen el DD_SCM_ID en null
    REM01.SP_ASC_ACT_SIT_COM_VACIOS_V2(0);

    DBMS_OUTPUT.PUT_LINE('[INFO]: CAMBIAR ESTADO DE PUBLICACIÓN DE LOS ACTIVOS');

    -- Cambiamos el estado de publicación de los activos del array
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACTIVO_ID;

            -- Cambia el estado de publicación
            REM01.SP_CAMBIO_ESTADO_PUBLICACION(V_ACTIVO_ID, 1, 'REMVIP_8337');

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