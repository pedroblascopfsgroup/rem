--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8829
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8829'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; --Vble. Tabla a modificar proveedores
    V_TABLA_PREFACTURA VARCHAR2(100 CHAR):='PFA_PREFACTURA'; --Vble. Tabla a modificar prefacturas

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_PROVEEDOR_REM VARCHAR2(100 CHAR):='110113457'; --Vble. codigo proveedor rem
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('916964314263'),
            T_TIPO_DATA('916964314265'),
            T_TIPO_DATA('916964314274'),
            T_TIPO_DATA('916964314278'),
            T_TIPO_DATA('916964314290'),
            T_TIPO_DATA('916964314297'),
            T_TIPO_DATA('916964314300'),
            T_TIPO_DATA('916964314650'),
            T_TIPO_DATA('916964314688'),
            T_TIPO_DATA('916964323132'),
            T_TIPO_DATA('916964323141'),
            T_TIPO_DATA('916964330456'),
            T_TIPO_DATA('916964330459'),
            T_TIPO_DATA('916964331833'),
            T_TIPO_DATA('916964331842'),
            T_TIPO_DATA('916964331850'),
            T_TIPO_DATA('916964331863'),
            T_TIPO_DATA('916964331868'),
            T_TIPO_DATA('916964331873'),
            T_TIPO_DATA('916964331876'),
            T_TIPO_DATA('916964331877'),
            T_TIPO_DATA('916964331879'),
            T_TIPO_DATA('916964331880'),
            T_TIPO_DATA('916964331887'),
            T_TIPO_DATA('916964331890'),
            T_TIPO_DATA('916964331892'),
            T_TIPO_DATA('916964331895'),
            T_TIPO_DATA('916964331896'),
            T_TIPO_DATA('916964331897'),
            T_TIPO_DATA('916964331898'),
            T_TIPO_DATA('916964331899'),
            T_TIPO_DATA('916964331902'),
            T_TIPO_DATA('916964331904'),
            T_TIPO_DATA('916964331908'),
            T_TIPO_DATA('916964331918'),
            T_TIPO_DATA('916964331929'),
            T_TIPO_DATA('916964331932'),
            T_TIPO_DATA('916964331938'),
            T_TIPO_DATA('916964331941'),
            T_TIPO_DATA('916964331946'),
            T_TIPO_DATA('916964331950'),
            T_TIPO_DATA('916964331952'),
            T_TIPO_DATA('916964331953'),
            T_TIPO_DATA('916964336171'),
            T_TIPO_DATA('916964336217'),
            T_TIPO_DATA('916964340533'),
            T_TIPO_DATA('916964340548'),
            T_TIPO_DATA('916964340556'),
            T_TIPO_DATA('916964340564'),
            T_TIPO_DATA('916964343204'),
            T_TIPO_DATA('916964343206'),
            T_TIPO_DATA('916964343207'),
            T_TIPO_DATA('916964343208'),
            T_TIPO_DATA('916964343210'),
            T_TIPO_DATA('916964343211'),
            T_TIPO_DATA('916964343212'),
            T_TIPO_DATA('916964343214'),
            T_TIPO_DATA('916964343216'),
            T_TIPO_DATA('916964343217'),
            T_TIPO_DATA('916964343218'),
            T_TIPO_DATA('916964343220'),
            T_TIPO_DATA('916964343221'),
            T_TIPO_DATA('916964343222'),
            T_TIPO_DATA('916964343223'),
            T_TIPO_DATA('916964343224'),
            T_TIPO_DATA('916964343225'),
            T_TIPO_DATA('916964343227'),
            T_TIPO_DATA('916964343228'),
            T_TIPO_DATA('916964343229'),
            T_TIPO_DATA('916964343230'),
            T_TIPO_DATA('916964343232'),
            T_TIPO_DATA('916964343389'),
            T_TIPO_DATA('916964343556'),
            T_TIPO_DATA('916964343575'),
            T_TIPO_DATA('916964343654'),
            T_TIPO_DATA('916964343655'),
            T_TIPO_DATA('916964343656'),
            T_TIPO_DATA('916964343657'),
            T_TIPO_DATA('916964343658'),
            T_TIPO_DATA('916964343659'),
            T_TIPO_DATA('916964343660'),
            T_TIPO_DATA('916964343661'),
            T_TIPO_DATA('916964345219'),
            T_TIPO_DATA('916964345237'),
            T_TIPO_DATA('916964345785'),
            T_TIPO_DATA('916964345787'),
            T_TIPO_DATA('916964345795'),
            T_TIPO_DATA('916964345805'),
            T_TIPO_DATA('916964345817'),
            T_TIPO_DATA('916964345827'),
            T_TIPO_DATA('916964345830'),
            T_TIPO_DATA('916964346254'),
            T_TIPO_DATA('916964349771'),
            T_TIPO_DATA('916964349775'),
            T_TIPO_DATA('916964349778'),
            T_TIPO_DATA('916964349782'),
            T_TIPO_DATA('916964349785'),
            T_TIPO_DATA('916964349789'),
            T_TIPO_DATA('916964356570'),
            T_TIPO_DATA('916964358380'),
            T_TIPO_DATA('916964331956'),
            T_TIPO_DATA('916964331958'),
            T_TIPO_DATA('916964331960'),
            T_TIPO_DATA('916964331967'),
            T_TIPO_DATA('916964331970'),
            T_TIPO_DATA('916964331972'),
            T_TIPO_DATA('916964331976'),
            T_TIPO_DATA('916964331978'),
            T_TIPO_DATA('916964331980'),
            T_TIPO_DATA('916964331982')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

        TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    	V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2(
            T_TIPO_DATA2('133'),
            T_TIPO_DATA2('134')

    	); 
    	V_TMP_TIPO_DATA2 T_TIPO_DATA2;


BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PROVEEDOR PREFACTURAS');

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM ='||V_PROVEEDOR_REM||' AND BORRADO=0 ';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT = 1 THEN

        FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
            LOOP
        V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
            --Comprobamos si existe la prefactura
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PREFACTURA||' WHERE PFA_NUM_PREFACTURA ='||V_TMP_TIPO_DATA2(1)||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

            IF V_COUNT =1 THEN

                V_MSQL := 'SELECT PFA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PREFACTURA||' WHERE PFA_NUM_PREFACTURA ='||V_TMP_TIPO_DATA2(1)||' ';
                EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PREFACTURA||' SET                
                    PVE_ID=(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM='||V_PROVEEDOR_REM||' AND BORRADO=0),
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE PFA_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: PREFACTURA: '||V_TMP_TIPO_DATA2(1)||' MODIFICADA CORRECTAMENTE ');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO]: LA PREFACTURA CON EL PFA_NUM_PREFACTURA: '||V_TMP_TIPO_DATA2(1)||' NO EXISTE ');
            END IF;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PROVEEDOR CONTACTO TRABAJOS');


        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del trabajo
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TBJ_NUM_TRABAJO='||V_TMP_TIPO_DATA(1)||' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN

                 --Comprobamos la existencia del trabajo
                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                            JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_ID=PVE.PVE_ID
                            WHERE PVE.PVE_COD_REM='||V_PROVEEDOR_REM||' AND PVC.PVC_PRINCIPAL=1 ';
                EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

                IF V_COUNT = 1 THEN

                    --Obtenemos el ID del activo
                    V_MSQL := 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TBJ_NUM_TRABAJO = '''||V_TMP_TIPO_DATA(1)||'''';
                    EXECUTE IMMEDIATE V_MSQL INTO V_ID;

                    --Obtenemos el id del proveedor contacto
                    V_MSQL := 'SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
                            JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVE_ID=PVE.PVE_ID
                            WHERE PVE.PVE_COD_REM='||V_PROVEEDOR_REM||' AND PVC.PVC_PRINCIPAL=1 ';
                    EXECUTE IMMEDIATE V_MSQL INTO V_ID_PROVEEDOR;

                    --Actualizamos el estado de publicación
                    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                    PVC_ID='||V_ID_PROVEEDOR||',
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TBJ_ID = '||V_ID||'';

                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

                ELSE
                     DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE PROVEEDOR CONTACTO PRINCIPAL PARA EL PROVEEDOR CON COD REM: '||V_PROVEEDOR_REM||'');
                END IF;
                
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TRABAJO '''||V_TMP_TIPO_DATA(1)||'''');
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