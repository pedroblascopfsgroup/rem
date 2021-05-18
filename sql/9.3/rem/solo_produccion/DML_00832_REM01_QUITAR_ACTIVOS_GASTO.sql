--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9618
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  quitar activos gasto y repartir porcentaje participacion
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
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-9618'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='GLD_ENT'; --Vble. auxiliar para almacenar la tabla a insertar    
	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar    
    
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente
    V_COUNT_TOTAL NUMBER(16):=0; --Vble. Para contar el total de registros de la iteracion

    V_COUNT_ACTIVOS NUMBER(16):=0;
    V_PARTICIPACION NUMBER(16,4):=0;
    V_ACTIVO_CUADRAR VARCHAR2(100 CHAR);
    V_PARTICIPACION_ACTIVO NUMBER(16,4);


 TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --GPV_NUM_GASTO_HAYA
        T_TIPO_DATA('12464663')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TABLA||' ');            

        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            
            V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

            --Comprobar si el gasto ya existe
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;            
            
            IF V_NUM_TABLAS > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PROPIETARIO DEL GASTO GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');


                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
                                    SELECT GLENT.GLD_ENT_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                                    JOIN '||V_ESQUEMA||'.GLD_ENT GLENT ON GLENT.GLD_ID=GLD.GLD_ID
                                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
                                    WHERE GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' AND GLD.BORRADO=0 AND GLENT.BORRADO=0 AND GPV.BORRADO=0
                                    AND ACT.ACT_NUM_ACTIVO IN (
                                    7281753,7281754,7281755,7290943
                                    )
                                ) T2
                            ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
                            WHEN MATCHED THEN UPDATE SET
                            BORRADO = 1,
                            USUARIOBORRAR = '''||V_USUARIO||''',
                            FECHABORRAR = SYSDATE';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN GLD_ENT DEL GASTO '''||V_TMP_TIPO_DATA(1)||''' ');


                V_MSQL :='SELECT COUNT(GENT.GLD_ENT_ID) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                                    JOIN '||V_ESQUEMA||'.GLD_ENT GENT ON GENT.GLD_ID=GLD.GLD_ID
                                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GENT.ENT_ID
                                    AND GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO=0
                                    AND GPV.BORRADO=0 AND GLD.BORRADO=0 AND GENT.BORRADO=0';

                EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_ACTIVOS;                


                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
                            SELECT GENT.GLD_ENT_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                                JOIN '||V_ESQUEMA||'.GLD_ENT GENT ON GENT.GLD_ID=GLD.GLD_ID
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GENT.ENT_ID
                                AND GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(1)||''' AND ACT.BORRADO=0
                                AND GPV.BORRADO=0 AND GLD.BORRADO=0 AND GENT.BORRADO=0
                        ) T2
                    ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
                    WHEN MATCHED THEN UPDATE SET
                    GLD_PARTICIPACION_GASTO = (SELECT CAST((100/'||V_COUNT_ACTIVOS||') AS NUMBER(16,4)) FROM DUAL),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS PARTICIPACION  '|| SQL%ROWCOUNT ||' ACTIVOS DEL GASTO '''||V_TMP_TIPO_DATA(1)||''' ');

                DBMS_OUTPUT.PUT_LINE('[INFO]: Modificado el GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||'''  CORRECTAMENTE ');
                V_COUNT:=V_COUNT+1;

            ELSE                
                DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL GASTO CON GPV_NUM_GASTO_HAYA: '''||V_TMP_TIPO_DATA(1)||''' ');

            END IF;

        END LOOP;

         DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZADOS CORRECTAMENTE '''||V_COUNT||''' DE '''||V_COUNT_TOTAL||''' ');

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