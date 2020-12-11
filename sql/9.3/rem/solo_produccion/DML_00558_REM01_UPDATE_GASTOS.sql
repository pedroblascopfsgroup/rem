--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8430
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar gastos
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8430';
    -- ID
    V_GASTO_ID NUMBER(16); -- Vble. para el id del activo
    V_NUM_PROVISION NUMBER(16):= 20700003200;
    -- Tablas
    V_TABLA_GASTOS VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR';
    V_TABLA_PROVISION VARCHAR2(50 CHAR):= 'PRG_PROVISION_GASTOS';
    V_TABLA_DETALLE VARCHAR2(50 CHAR):= 'GDE_GASTOS_DETALLE_ECONOMICO';
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('9575800'),
            T_TIPO_DATA('9575801'),
            T_TIPO_DATA('9575802'),
            T_TIPO_DATA('9575803'),
            T_TIPO_DATA('9575804'),
            T_TIPO_DATA('9575805'),
            T_TIPO_DATA('9575811')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR GASTOS');

    -- Actualizamos los gastos para que estén rechazados
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del gasto
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del gasto
            V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_GASTO_ID;

            -- Cambiamos el estado del gasto
            V_MSQL:= 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_GASTOS ||' SET
               DD_EGA_ID = (SELECT DD_EGA_ID from '|| V_ESQUEMA ||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = 02),
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE 
               WHERE GPV_ID = '|| V_GASTO_ID ||'';

            EXECUTE IMMEDIATE V_MSQL;

            -- Quitamos la fecha del pago y el motivo del pago
            V_MSQL:= 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_DETALLE ||' SET
               GDE_FECHA_PAGO = NULL,
               DD_TPA_ID = NULL,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE 
               WHERE GPV_ID = '|| V_GASTO_ID ||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL GASTO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

    --Comprobamos la existencia de la provisión
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'|| V_TABLA_PROVISION ||' WHERE PRG_NUM_PROVISION = '|| V_NUM_PROVISION;
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            -- Actualizamos el estado de provisión
            V_MSQL:= 'UPDATE '|| V_ESQUEMA ||'.'|| V_TABLA_PROVISION ||' SET
               DD_EPR_ID = (SELECT DD_EPR_ID FROM '|| V_ESQUEMA ||'.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = 03),
               PRG_FECHA_ENVIO = NULL,
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE 
               WHERE PRG_NUM_PROVISION = '|| V_NUM_PROVISION ||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: PROVISIÓN '''||V_NUM_PROVISION||''' ACTUALIZADA');
        
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA PROVISION '''||V_NUM_PROVISION||'''');

        END IF;

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