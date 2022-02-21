--/*
--######################################### 
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10745
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10745';
	V_NUM_TABLAS NUMBER(16);
	V_ACT_NUM_ACTIVO NUMBER(16);
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --           ID_PROVEEDOR_REM       ID_ACTIVO_HAYA
        T_TIPO_DATA('110167380'             , null),
        T_TIPO_DATA('963'                   ,'6953104'),
        T_TIPO_DATA('110117995'             , '7032677')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INICIO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST

    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    --Busqueda y eliminacion para la tabla PWH_PROVEEDOR_WEBCOM_HIST
        IF V_TMP_TIPO_DATA(1) is null THEN	
            V_COUNT:= 0;
        ELSE
            V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST WHERE ID_PROVEEDOR_REM = '''||V_TMP_TIPO_DATA(1)||'''';
		    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        END IF;

		IF V_COUNT > 0 THEN	

			V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.PWH_PROVEEDOR_WEBCOM_HIST
						WHERE ID_PROVEEDOR_REM  = '''||V_TMP_TIPO_DATA(1)||'''';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO PWH_PROVEEDOR_WEBCOM_HIST CON ID_PROVEEDOR_REM '||V_TMP_TIPO_DATA(1)||' BORRADDO '|| SQL%ROWCOUNT ||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ID_PROVEEDOR_REM '||V_TMP_TIPO_DATA(1)||' EN PWH_PROVEEDOR_WEBCOM_HIST');

		END IF;


        --Busqueda y eliminacion para la tabla SWH, IWH y OWH
        --Busqueda y eliminacion para la tabla SWH_STOCK_ACT_WEBCOM_HIST
        IF V_TMP_TIPO_DATA(2) is null THEN	
            V_COUNT:= 0;
        ELSE
		    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST WHERE ID_ACTIVO_HAYA = '''||V_TMP_TIPO_DATA(2)||'''';
		    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        END IF;

		IF V_COUNT > 0 THEN	

			V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST
						WHERE ID_ACTIVO_HAYA  = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO SWH_STOCK_ACT_WEBCOM_HIST CON ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' BORRADDO '|| SQL%ROWCOUNT ||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' EN SWH_STOCK_ACT_WEBCOM_HIST');

		END IF;

        --Busqueda y eliminacion para la tabla IWH_INFORME_WEBCOM_HIST
        IF V_TMP_TIPO_DATA(2) is null THEN	
            V_COUNT:= 0;
        ELSE
		    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.IWH_INFORME_WEBCOM_HIST WHERE ID_ACTIVO_HAYA = '''||V_TMP_TIPO_DATA(2)||'''';
		    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        END IF;

		IF V_COUNT > 0 THEN	

			V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.IWH_INFORME_WEBCOM_HIST
						WHERE ID_ACTIVO_HAYA  = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO IWH_INFORME_WEBCOM_HIST CON ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' BORRADDO '|| SQL%ROWCOUNT ||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' EN IWH_INFORME_WEBCOM_HIST');

		END IF;


        --Busqueda y eliminacion para la tabla IWH_INFORME_WEBCOM_HIST
        IF V_TMP_TIPO_DATA(2) is null THEN	
            V_COUNT:= 0;
        ELSE
		    V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.OWH_OFERTAS_WEBCOM_HIST WHERE ID_ACTIVO_HAYA = '''||V_TMP_TIPO_DATA(2)||'''';
		    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
        END IF;

		IF V_COUNT > 0 THEN	

			V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.OWH_OFERTAS_WEBCOM_HIST
						WHERE ID_ACTIVO_HAYA  = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO OWH_OFERTAS_WEBCOM_HIST CON ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' BORRADDO '|| SQL%ROWCOUNT ||'');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ID_ACTIVO_HAYA '||V_TMP_TIPO_DATA(2)||' EN OWH_OFERTAS_WEBCOM_HIST');

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
