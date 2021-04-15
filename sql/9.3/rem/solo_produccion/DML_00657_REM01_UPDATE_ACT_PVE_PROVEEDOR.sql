--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8875
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar mediador a proveedor
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8875'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_TABLA_PROVEEDOR VARCHAR2(50 CHAR):= 'ACT_PVE_PROVEEDOR'; 

    V_ID_MEDIADOR NUMBER(16); -- Vble. para el id del proveedor

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('8627','6964'),
            T_TIPO_DATA('8485','662'),
            T_TIPO_DATA('8439','662'),
            T_TIPO_DATA('8104','96'),
            T_TIPO_DATA('8516','662'),
            T_TIPO_DATA('8470','6964'),
            T_TIPO_DATA('8499','96'),
            T_TIPO_DATA('8320','96'),
            T_TIPO_DATA('8323','662'),
            T_TIPO_DATA('8324','96'),
            T_TIPO_DATA('8329','662'),
            T_TIPO_DATA('8351','6964'),
            T_TIPO_DATA('7282','662'),
            T_TIPO_DATA('8319','10584'),
            T_TIPO_DATA('8334','662'),
            T_TIPO_DATA('8338','10584'),
            T_TIPO_DATA('8428','662'),
            T_TIPO_DATA('8336','3279'),
            T_TIPO_DATA('8352','2260'),
            T_TIPO_DATA('8712','662'),
            T_TIPO_DATA('8713','662'),
            T_TIPO_DATA('8444','662'),
            T_TIPO_DATA('8451','662'),
            T_TIPO_DATA('8467','96'),
            T_TIPO_DATA('8496','662'),
            T_TIPO_DATA('8501','662'),
            T_TIPO_DATA('8504','10584'),
            T_TIPO_DATA('8434','10584'),
            T_TIPO_DATA('8435','662'),
            T_TIPO_DATA('8437','662'),
            T_TIPO_DATA('8441','662'),
            T_TIPO_DATA('8443','10584'),
            T_TIPO_DATA('8321','662'),
            T_TIPO_DATA('8343','662'),
            T_TIPO_DATA('8345','662'),
            T_TIPO_DATA('8346','10584'),
            T_TIPO_DATA('8348','662'),
            T_TIPO_DATA('8353','662'),
            T_TIPO_DATA('7292','662'),
            T_TIPO_DATA('8423','662'),
            T_TIPO_DATA('8424','662'),
            T_TIPO_DATA('8425','662'),
            T_TIPO_DATA('8427','662'),
            T_TIPO_DATA('8430','662'),
            T_TIPO_DATA('8714','2996'),
            T_TIPO_DATA('8570','2260'),
            T_TIPO_DATA('8489','96'),
            T_TIPO_DATA('8495','3279'),
            T_TIPO_DATA('8503','662'),
            T_TIPO_DATA('8506','3279'),
            T_TIPO_DATA('8438','373'),
            T_TIPO_DATA('8442','2260'),
            T_TIPO_DATA('8322','662'),
            T_TIPO_DATA('8326','662'),
            T_TIPO_DATA('8339','2260'),
            T_TIPO_DATA('8347','662')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIR MEDIADORES A PROVEEDORES');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que existe el proveedor
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            --Obtenemos el id del mediador
             V_MSQL := 'SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(2)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID_MEDIADOR;

            --Actualizamos el mediador del proveedor
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PROVEEDOR||' SET
                    PVE_ID_MEDIADOR_REL = '''||V_ID_MEDIADOR||''',
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: SE HA ASIGNADO EL MEDIADOR: '''||V_TMP_TIPO_DATA(2)||''' AL PROVEEDOR: '''||V_TMP_TIPO_DATA(1)||''' ');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL PROVEEDOR CON PVE_COD_REM: '''||V_TMP_TIPO_DATA(1)||'''');
        
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