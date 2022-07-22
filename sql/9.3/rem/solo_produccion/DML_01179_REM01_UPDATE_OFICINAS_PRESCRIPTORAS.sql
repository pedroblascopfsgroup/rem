--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12058
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar oficinas prescriptoras
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12058';
    V_TABLA_PVE VARCHAR2(50 CHAR):= 'ACT_PVE_PROVEEDOR';
    V_TABLA_OFR VARCHAR2(50 CHAR):= 'OFR_OFERTAS';

    V_COUNT NUMBER(16); -- Vble. para comprobar
	V_COUNT_OFR NUMBER(16); -- Vble. para comprobar
    V_COUNT_PVE NUMBER(16); -- Vble. para comprobar
    V_PVE_ID NUMBER(16); -- Vble. para comprobar
    V_PVE_COD_REM NUMBER(36); -- Vble. para comprobar
    V_OUTPUT VARCHAR2(3000 CHAR); -- Sentencia a ejecutar   
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA(90322822,'1297'),
            T_TIPO_DATA(90379244,'8630'),
            T_TIPO_DATA(90406369,'6112'),
            T_TIPO_DATA(90397944,'1859'),
            T_TIPO_DATA(90406912,'8278'),
            T_TIPO_DATA(90402617,'5614'),
            T_TIPO_DATA(90381085,'8606'),
            T_TIPO_DATA(90398250,'7676')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR OFICINAS PRESCRIPTORAS');

    V_OUTPUT := 'AHORA REVISAMOS HONORARIOS'||CHR(10);
    V_OUTPUT := 'OFERTA -> CODIGO PROVEEDOR'||CHR(10);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_OFR||' WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||'''
                             AND BORRADO = 0'
        INTO V_COUNT_OFR;	

        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PVE||' WHERE PVE_COD_API_PROVEEDOR = '''||V_TMP_TIPO_DATA(2)||'''
                            AND UPPER(PVE_NOMBRE) LIKE ''%CAIXA%'' AND BORRADO = 0'
        INTO V_COUNT_PVE;	

        IF V_COUNT_OFR = 1 AND V_COUNT_PVE = 1 THEN

            EXECUTE IMMEDIATE 'SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PVE||' WHERE PVE_COD_API_PROVEEDOR = '''||V_TMP_TIPO_DATA(2)||'''
                            AND UPPER(PVE_NOMBRE) LIKE ''%CAIXA%'' AND BORRADO = 0'
            INTO V_PVE_ID;

            EXECUTE IMMEDIATE 'SELECT PVE_COD_REM FROM '||V_ESQUEMA||'.'||V_TABLA_PVE||' WHERE PVE_COD_API_PROVEEDOR = '''||V_TMP_TIPO_DATA(2)||'''
                            AND UPPER(PVE_NOMBRE) LIKE ''%CAIXA%'' AND BORRADO = 0'
            INTO V_PVE_COD_REM;

            EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_OFR||' WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||'''
                             AND BORRADO = 0 AND PVE_ID_PRESCRIPTOR = '||V_PVE_ID||''
            INTO V_COUNT;

            IF V_COUNT = 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS OFICINA DE LA OFERTA '''||V_TMP_TIPO_DATA(1)||'''');

                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_OFR||' SET
                PVE_ID_PRESCRIPTOR = '||V_PVE_ID||',USUARIOMODIFICAR = '''|| V_USUARIO ||''', FECHAMODIFICAR = SYSDATE
                WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';

                DBMS_OUTPUT.PUT_LINE('[INFO]: OFICINA DE LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' YA TIENE LA OFICINA '||V_TMP_TIPO_DATA(2)||'');

            END IF;

            V_OUTPUT := V_OUTPUT || 'OFERTA: ' || V_TMP_TIPO_DATA(1) || ' -> PVE_COD_REM: ' ||V_PVE_COD_REM||CHR(10);
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA '''||V_TMP_TIPO_DATA(1)||''' O OFICINA '||V_TMP_TIPO_DATA(2)||'');

        END IF;

    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    DBMS_OUTPUT.PUT_LINE(V_OUTPUT);
 
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