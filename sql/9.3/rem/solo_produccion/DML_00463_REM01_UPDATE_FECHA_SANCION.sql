--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20200924
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8106
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar fecha sancion expediente
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8106'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ECO_EXPEDIENTE_COMERCIAL'; --Vble. auxiliar para almacenar la tabla a insertar
    
    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    	-- Numero oferta        Fecha sancion
        T_TIPO_DATA('90266467','17/08/2020'),
        T_TIPO_DATA('90264384','26/08/2020'),
        T_TIPO_DATA('90256014','07/07/2020'),
        T_TIPO_DATA('90256019','07/07/2020'),
        T_TIPO_DATA('90260120','07/07/2020'),
        T_TIPO_DATA('90265181','05/08/2020'),
        T_TIPO_DATA('90261410','15/07/2020'),
        T_TIPO_DATA('90264664','31/07/2020'),
        T_TIPO_DATA('90264197','14/08/2020'),
        T_TIPO_DATA('6010102','15/04/2020'),
        T_TIPO_DATA('90260457','21/07/2020'),
        T_TIPO_DATA('90256884','01/07/2020'),
        T_TIPO_DATA('90260124','08/07/2020'),
        T_TIPO_DATA('90260124','08/07/2020'),
        T_TIPO_DATA('90266467','17/08/2020')
       

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN ECO_EXPEDIENTE_COMERCIAL ');
            
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);


            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA='|| TRIM(V_TMP_TIPO_DATA(1)) ||' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN
              V_SQL := 'SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA='|| TRIM(V_TMP_TIPO_DATA(1)) ||' ';

            EXECUTE IMMEDIATE V_SQL INTO V_ID;

            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_ID='||V_ID||' ';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos oferta: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');

              V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                        ECO_FECHA_SANCION = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', ''DD/MM/YYYY'') ,
                        USUARIOMODIFICAR = '''||V_USUARIO||''', 
                        FECHAMODIFICAR = SYSDATE
                        WHERE OFR_ID='||V_ID||'';
                        
                EXECUTE IMMEDIATE V_SQL;
               
                V_COUNT:=V_COUNT+1;

            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EXPEDIENTE COMERCIAL PARA LA OFERTA: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            END IF;

                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE:= '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
                DBMS_OUTPUT.PUT_LINE('[INFO]:                                    ');
            ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE OFERTA CON EL NUMERO DE OFERTA INDICADO: '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
            END IF;                
            
        END LOOP;   
    
        DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADOS CORRECTAMENTE: '''||V_COUNT||''' REGISTROS ');

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
EXIT