--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210105
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8547
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualizar importe tasaciones
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8547'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_TAS_TASACION'; --Vble. auxiliar para almacenar la tabla a insertar
    V_TABLA_ACTIVO VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla de los activos a buscar
    V_ID VARCHAR2(100 CHAR); --Vble para almacenar el id de la tasacion
    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            --ACT_NUM_ACTIVO TAS_FECHA_INI_TASACION TAS_IMPORTE_TAS_FIN
    		T_TIPO_DATA('7234562','31/12/2017','23000'),
            T_TIPO_DATA('7269590','31/12/2017','4000'),
            T_TIPO_DATA('7281369','14/02/2017','23424,57'),
            T_TIPO_DATA('7276079','31/12/2017','2430000'),
            T_TIPO_DATA('7267372','31/10/2017','121752,14'),
            T_TIPO_DATA('7246416','15/09/2017','214090,19'),
            T_TIPO_DATA('7269599','31/12/2017','23000'),
            T_TIPO_DATA('7269593','31/12/2017','4000'),
            T_TIPO_DATA('7269596','31/12/2017','4000'),
            T_TIPO_DATA('7267369','31/10/2017','121371,36'),
            T_TIPO_DATA('7267378','31/10/2017','144531,03'),
            T_TIPO_DATA('7269591','31/12/2017','4000'),
            T_TIPO_DATA('7233988','31/12/2017','161500'),
            T_TIPO_DATA('7233985','31/12/2017','154500'),
            T_TIPO_DATA('7249783','29/05/2017','6157'),
            T_TIPO_DATA('7252723','27/07/2015','155378,87'),
            T_TIPO_DATA('7284802','25/02/2016','1'),
            T_TIPO_DATA('7267375','31/10/2017','150617,68'),
            T_TIPO_DATA('7259604','19/11/2015','170500'),
            T_TIPO_DATA('7269594','31/12/2017','4000'),
            T_TIPO_DATA('7257973','21/01/2016','47870'),
            T_TIPO_DATA('7291629','31/12/2017','3396165,02'),
            T_TIPO_DATA('7233989','31/12/2017','160500'),
            T_TIPO_DATA('7267373','31/10/2017','125311,88'),
            T_TIPO_DATA('7291661','31/12/2017','3703796,63'),
            T_TIPO_DATA('7281368','14/03/2016','22794,37'),
            T_TIPO_DATA('7267370','31/10/2017','115731,98'),
            T_TIPO_DATA('7267376','31/10/2017','141651,01'),
            T_TIPO_DATA('7276476','08/08/2016','2956461,31'),
            T_TIPO_DATA('7291023','10/06/2016','1'),
            T_TIPO_DATA('7291662','31/12/2017','2918690,3'),
            T_TIPO_DATA('7291633','31/12/2017','1794892,86'),
            T_TIPO_DATA('7269592','31/12/2017','4000'),
            T_TIPO_DATA('7269595','31/12/2017','4000'),
            T_TIPO_DATA('7267368','31/10/2017','120808,44'),
            T_TIPO_DATA('7252993','16/05/2017','463,76'),
            T_TIPO_DATA('7267371','31/10/2017','113093,39'),
            T_TIPO_DATA('7269598','31/12/2017','4000'),
            T_TIPO_DATA('7267377','31/10/2017','144331,84'),
            T_TIPO_DATA('7277809','05/08/2016','1'),
            T_TIPO_DATA('7233848','31/12/2017','474500'),
            T_TIPO_DATA('7277569','06/06/2013','24761,41'),
            T_TIPO_DATA('7269597','31/12/2017','4000'),
            T_TIPO_DATA('7285596','08/05/2017','28110,09')


    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||'
                    WHERE ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'';

        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        --Si existe el activo
        IF V_NUM_TABLAS = 1 THEN

            --Comprobamos si existen tasaciones para el activo indicado

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA||' TAS ON TAS.ACT_ID=ACT.ACT_ID
                        WHERE ACT.ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'';

            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
            -- Si existen tasaciones
            IF V_NUM_TABLAS > 0 THEN       

                --Actualizamos TAS_IMPORTE_TAS_FIN con valor del excel
                V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                            TAS_IMPORTE_TAS_FIN = TO_NUMBER('''||V_TMP_TIPO_DATA(3)||'''),
                            USUARIOMODIFICAR = '''||V_USUARIO||''',
                            FECHAMODIFICAR = SYSDATE                            
                            WHERE TAS_ID IN (
                                SELECT TAS.TAS_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACTIVO||' ACT
                                JOIN '||V_ESQUEMA||'.'||V_TABLA||' TAS ON TAS.ACT_ID=ACT.ACT_ID
                                WHERE ACT.ACT_NUM_ACTIVO='||V_TMP_TIPO_DATA(1)||'
                                AND TAS_FECHA_INI_TASACION=TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''DD/MM/YYYY'')
                            ) ';
                EXECUTE IMMEDIATE V_MSQL;
                V_COUNT:=V_COUNT+1;    

                DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizadas '||SQL%ROWCOUNT||' tasaciones');

                DBMS_OUTPUT.PUT_LINE('[INFO]: Se han modificado las tasaciones del num activo: '''||V_TMP_TIPO_DATA(1)||''' ');

            ELSE
                --Si no existen tasaciones
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTEN TASACIONES PARA EL NUM ACTIVO: '''||V_TMP_TIPO_DATA(1)||''' ');
            END IF;

        ELSE
            --Si no existe activo
            DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL NUM ACTIVO:'''||V_TMP_TIPO_DATA(1)||''' ');
        END IF;
    END LOOP;

    
    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]: '''||V_COUNT||''' TASACIONES MODIFICADAS CORRECTAMENTE DE:'''||V_COUNT_TOTAL||''' ');
    
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