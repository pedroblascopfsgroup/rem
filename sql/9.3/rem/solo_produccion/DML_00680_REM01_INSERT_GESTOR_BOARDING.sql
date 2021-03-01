--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9022
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9022'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_EXPEDIENTE NUMBER(16); -- Vble. para el id del proveedor
     V_ID_TGE NUMBER(16); -- Vble. para el id del proveedor
      V_ID_USU NUMBER(16); -- Vble. para el id del proveedor
      V_GEE_ID NUMBER(16); -- Vble. para el id del proveedor
      V_GEH_ID NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA VARCHAR2(50 CHAR):= 'OFR_OFERTA'; --Vble. Tabla a modificar proveedores
    

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_PROVEEDOR_REM VARCHAR2(100 CHAR):='110187531'; --Vble. codigo proveedor rem
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7007955'),
            T_TIPO_DATA('7007962'),
            T_TIPO_DATA('7012887'),
            T_TIPO_DATA('7007637'),
            T_TIPO_DATA('7007691'),
            T_TIPO_DATA('7008159'),
            T_TIPO_DATA('7013257'),
            T_TIPO_DATA('7013258'),            
            T_TIPO_DATA('7013259'),
            T_TIPO_DATA('7013263'),
            T_TIPO_DATA('7008105'),            
            T_TIPO_DATA('7008186'),            
            T_TIPO_DATA('7013273'),
            T_TIPO_DATA('7007937'),
            T_TIPO_DATA('7008139'),
            T_TIPO_DATA('7013254'),
            T_TIPO_DATA('90298543'),
            T_TIPO_DATA('7009326'),
            T_TIPO_DATA('7010549'),
            T_TIPO_DATA('7008133'),
            T_TIPO_DATA('90299418')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;



BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS GESTOR BOARDING PARA EXPEDIENTES');

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

            --Comprobamos la existencia del gasto
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA='''||V_TMP_TIPO_DATA(1)||''' AND BORRADO=0 ';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT = 1 THEN    


                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                            JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID
                            WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND OFR.BORRADO=0 AND ECO.BORRADO=0';
                EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

                IF V_COUNT = 1 THEN
                                        --Obtenemos el ID del activo
                    V_MSQL := 'SELECT ECO_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                                JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID=OFR.OFR_ID
                                WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND OFR.BORRADO=0 AND ECO.BORRADO=0';
                    EXECUTE IMMEDIATE V_MSQL INTO V_ID_EXPEDIENTE;


                    --Obtenemos el ID del activo
                    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE                           
                                WHERE DD_TGE_CODIGO = ''GBOAR'' AND BORRADO=0 ';
                    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

                    IF V_COUNT = 1 THEN
                            --Obtenemos el ID del activo
                        V_MSQL := 'SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE                           
                                    WHERE DD_TGE_CODIGO = ''GBOAR'' AND BORRADO=0 ';
                        EXECUTE IMMEDIATE V_MSQL INTO V_ID_TGE;

                        --Obtenemos el ID del activo
                            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU                           
                                        WHERE USU_USERNAME = ''gruboarding'' AND BORRADO=0 ';
                            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;


                        IF V_COUNT = 1 THEN
                                            --Obtenemos el ID del activo
                            V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU                           
                                        WHERE USU_USERNAME = ''gruboarding'' AND BORRADO=0 ';
                            EXECUTE IMMEDIATE V_MSQL INTO V_ID_USU;

            --INSERTAMOS GEE

                            EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL FROM DUAL' INTO V_GEE_ID;

                            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (GEE_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR) VALUES
                                ('||V_GEE_ID||','||V_ID_USU||','||V_ID_TGE||','''||V_USUARIO||''', SYSDATE)';
                            EXECUTE IMMEDIATE V_MSQL;
            --INSERTAMOS GEH

                            EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL FROM DUAL' INTO V_GEH_ID;

                            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, GEH_FECHA_DESDE, USUARIOCREAR, FECHACREAR) VALUES
                                    ('||V_GEH_ID||', '||V_ID_USU||', '||V_ID_TGE||', TO_DATE(SYSDATE,''DD/MM/RRRR''), '''||V_USUARIO||''', SYSDATE)';
                            EXECUTE IMMEDIATE V_MSQL;

            --INSERTAMOS GCH
                            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO (GEH_ID, ECO_ID) VALUES
                                    ('||V_GEH_ID||', '||V_ID_EXPEDIENTE||')';
                            EXECUTE IMMEDIATE V_MSQL;

            --INSERTAMOS GCO
                            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO (GEE_ID, ECO_ID) VALUES
                                    ('||V_GEE_ID||', '||V_ID_EXPEDIENTE||')';
                            EXECUTE IMMEDIATE V_MSQL;


                            DBMS_OUTPUT.PUT_LINE('[INFO]: OFERTA '''||V_TMP_TIPO_DATA(1)||''' MODIFICADO CORRECTAMENTE');        
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL USUARIO INDICADO');     
                        END IF;

                    ELSE
                        DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL TIPO GESTOR INDICADO');   
                    END IF;
                ELSE
                     DBMS_OUTPUT.PUT_LINE('[INFO] LA OFERTA: '''||V_TMP_TIPO_DATA(1)||''' NO TIENE EXPEDIENTE COMERCIAL');
                END IF;
            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA'''||V_TMP_TIPO_DATA(1)||'''');
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