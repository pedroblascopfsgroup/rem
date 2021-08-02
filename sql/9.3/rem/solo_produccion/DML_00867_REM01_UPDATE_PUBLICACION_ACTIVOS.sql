--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9764
--## PRODUCTO=NO
--## 
--## Finalidad: Poner activos en Publicado venta
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9764';

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('936583'),
            T_TIPO_DATA('936700'),
            T_TIPO_DATA('936841'),
            T_TIPO_DATA('936920'),
            T_TIPO_DATA('936924'),
            T_TIPO_DATA('937043'),
            T_TIPO_DATA('937121'),
            T_TIPO_DATA('937145'),
            T_TIPO_DATA('937398'),
            T_TIPO_DATA('937430'),
            T_TIPO_DATA('937439'),
            T_TIPO_DATA('937453'),
            T_TIPO_DATA('937474'),
            T_TIPO_DATA('937481'),
            T_TIPO_DATA('937645'),
            T_TIPO_DATA('937689'),
            T_TIPO_DATA('937932'),
            T_TIPO_DATA('937950'),
            T_TIPO_DATA('937996'),
            T_TIPO_DATA('938151'),
            T_TIPO_DATA('938165'),
            T_TIPO_DATA('938293'),
            T_TIPO_DATA('938307'),
            T_TIPO_DATA('938454'),
            T_TIPO_DATA('938632'),
            T_TIPO_DATA('938736'),
            T_TIPO_DATA('938764'),
            T_TIPO_DATA('938847'),
            T_TIPO_DATA('938979'),
            T_TIPO_DATA('938984'),
            T_TIPO_DATA('938994'),
            T_TIPO_DATA('939005'),
            T_TIPO_DATA('939006'),
            T_TIPO_DATA('939074'),
            T_TIPO_DATA('939134'),
            T_TIPO_DATA('939406'),
            T_TIPO_DATA('939424'),
            T_TIPO_DATA('939916'),
            T_TIPO_DATA('939935'),
            T_TIPO_DATA('940086'),
            T_TIPO_DATA('940167'),
            T_TIPO_DATA('940218'),
            T_TIPO_DATA('940267'),
            T_TIPO_DATA('940304'),
            T_TIPO_DATA('940388'),
            T_TIPO_DATA('940565'),
            T_TIPO_DATA('940662'),
            T_TIPO_DATA('940923'),
            T_TIPO_DATA('940933'),
            T_TIPO_DATA('940948'),
            T_TIPO_DATA('940967'),
            T_TIPO_DATA('941029'),
            T_TIPO_DATA('941094'),
            T_TIPO_DATA('941237'),
            T_TIPO_DATA('941272'),
            T_TIPO_DATA('941350'),
            T_TIPO_DATA('941501'),
            T_TIPO_DATA('941551'),
            T_TIPO_DATA('941849'),
            T_TIPO_DATA('941883'),
            T_TIPO_DATA('941960'),
            T_TIPO_DATA('941992'),
            T_TIPO_DATA('942110'),
            T_TIPO_DATA('942175'),
            T_TIPO_DATA('942222'),
            T_TIPO_DATA('942245'),
            T_TIPO_DATA('942278'),
            T_TIPO_DATA('942283'),
            T_TIPO_DATA('942323'),
            T_TIPO_DATA('942339'),
            T_TIPO_DATA('942388'),
            T_TIPO_DATA('942491'),
            T_TIPO_DATA('942531'),
            T_TIPO_DATA('942580'),
            T_TIPO_DATA('942669'),
            T_TIPO_DATA('942696'),
            T_TIPO_DATA('942800'),
            T_TIPO_DATA('942831'),
            T_TIPO_DATA('942967'),
            T_TIPO_DATA('943008'),
            T_TIPO_DATA('943015'),
            T_TIPO_DATA('943087'),
            T_TIPO_DATA('943207'),
            T_TIPO_DATA('943242'),
            T_TIPO_DATA('943255'),
            T_TIPO_DATA('943313'),
            T_TIPO_DATA('943349'),
            T_TIPO_DATA('943374'),
            T_TIPO_DATA('943394'),
            T_TIPO_DATA('943405'),
            T_TIPO_DATA('943478'),
            T_TIPO_DATA('943580'),
            T_TIPO_DATA('943658'),
            T_TIPO_DATA('943895'),
            T_TIPO_DATA('943992'),
            T_TIPO_DATA('944101'),
            T_TIPO_DATA('944311'),
            T_TIPO_DATA('944568'),
            T_TIPO_DATA('944599'),
            T_TIPO_DATA('944632'),
            T_TIPO_DATA('944642'),
            T_TIPO_DATA('944736'),
            T_TIPO_DATA('944807'),
            T_TIPO_DATA('944853'),
            T_TIPO_DATA('945003'),
            T_TIPO_DATA('945023'),
            T_TIPO_DATA('945031'),
            T_TIPO_DATA('945038'),
            T_TIPO_DATA('945076'),
            T_TIPO_DATA('945129'),
            T_TIPO_DATA('945307'),
            T_TIPO_DATA('945516'),
            T_TIPO_DATA('945559')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR OFERTAS A SOLICITA FINANCIACIÓN - NO');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Actualizamos el estado de publicación
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
               DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''04''),               
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE               
               WHERE ACT_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
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