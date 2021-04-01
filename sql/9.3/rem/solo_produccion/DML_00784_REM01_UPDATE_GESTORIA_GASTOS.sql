--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9382
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar proveedor contacto trabajos y proveedor prefacturas
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9382'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; --Vble. Tabla a modificar proveedores

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_PROVEEDOR_REM VARCHAR2(100 CHAR):='110187531'; --Vble. codigo proveedor rem
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('12579598'),
            T_TIPO_DATA('12579599'),
            T_TIPO_DATA('12579600'),
            T_TIPO_DATA('12579601'),
            T_TIPO_DATA('12587327'),
            T_TIPO_DATA('12583141'),
            T_TIPO_DATA('12583142'),
            T_TIPO_DATA('12583143'),
            T_TIPO_DATA('12583144'),
            T_TIPO_DATA('12583145'),
            T_TIPO_DATA('12583146')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;



BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: REALIZAMOS COMPROBACIONES');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM ='||V_PROVEEDOR_REM||' AND BORRADO=0 ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS GESTORIA GASTOS');

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del gasto
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN               

                --Obtenemos el ID del Gasto
                V_MSQL := 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_NUM_GASTO_HAYA = '''||V_TMP_TIPO_DATA(1)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                --Obtenemos el id del proveedor (gestoria)
                V_MSQL := 'SELECT PVE.PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE                            
                            WHERE PVE.PVE_COD_REM='||V_PROVEEDOR_REM||' AND BORRADO=0';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID_PROVEEDOR;

                --Actualizamos el pve_id_gestoria del gasto
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                PVE_ID_GESTORIA='||V_ID_PROVEEDOR||',
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE
                WHERE GPV_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '''||V_TMP_TIPO_DATA(1)||''' MODIFICADO');                
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL GASTO '''||V_TMP_TIPO_DATA(1)||'''');
            END IF;

        END LOOP;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL PROVEEDOR CON EL PVE_COD_REM: '||V_PROVEEDOR_REM||'');
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