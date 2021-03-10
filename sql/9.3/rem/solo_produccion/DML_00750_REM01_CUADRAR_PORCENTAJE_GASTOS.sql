--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210310
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9182_2
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar porcentajes gasto
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9182_2'; --Vble USUARIOMODIFICAR/USUARIOCREAR

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_ID_PROVEEDOR NUMBER(16); -- Vble. para el id del proveedor

    V_TABLA_GASTO VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; 
    V_TABLA_LINEA VARCHAR2(100 CHAR):='GLD_GASTOS_LINEA_DETALLE'; 
    V_TABLA_ENTIDAD VARCHAR2(100 CHAR):='GLD_ENT'; 

	V_COUNT NUMBER(16); -- Vble. para comprobar

    
    --ACT_NUM_ACTIVO        GPV_NUM_GASTO_HAYA      GLD_PARTICIPACION_GASTO
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('6878443','13601778','5,8816'),
            T_TIPO_DATA('7008331','13601777','0,4632'),
            T_TIPO_DATA('6872487','13619790','2,1258'),
            T_TIPO_DATA('6938739','13619746','3,0304'),
            T_TIPO_DATA('7075689','13619743','11,0616'),
            T_TIPO_DATA('6973414','13619736','33.3334')



    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PORCENTAJE PARTICIPACION ACTIVO GASTO');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que existe el activo, el gasto y que esten asociados a traves de la linea de detalle
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_LINEA||' GLD ON GPV.GPV_ID=GLD.GPV_ID
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' GLENT ON GLENT.GLD_ID=GLD.GLD_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
                    WHERE GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(2)||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||'''
                    AND GPV.BORRADO=0 AND ACT.BORRADO=0 AND GLD.BORRADO=0 AND GLENT.BORRADO=0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            --Obtenemos el id de la entidad

             V_MSQL := 'SELECT GLENT.GLD_ENT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GASTO||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_LINEA||' GLD ON GPV.GPV_ID=GLD.GPV_ID
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' GLENT ON GLENT.GLD_ID=GLD.GLD_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=GLENT.ENT_ID
                    WHERE GPV.GPV_NUM_GASTO_HAYA='''||V_TMP_TIPO_DATA(2)||''' AND ACT.ACT_NUM_ACTIVO='''||V_TMP_TIPO_DATA(1)||'''
                    AND GPV.BORRADO=0 AND ACT.BORRADO=0 AND GLD.BORRADO=0 AND GLENT.BORRADO=0 ';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;


            --Actualizamos el porcentaje de participacion del activo en el gasto
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ENTIDAD||' SET
                    GLD_PARTICIPACION_GASTO='''||V_TMP_TIPO_DATA(3)||''',
                    USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE GLD_ENT_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' GASTO '''||V_TMP_TIPO_DATA(2)||'''   ACTUALIZADO CON PORCENTAJE '''||V_TMP_TIPO_DATA(3)||'''');

            
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA RELACION ACTIVO:'''||V_TMP_TIPO_DATA(1)||''' GASTO: '''||V_TMP_TIPO_DATA(2)||''' PARTICIPACION: '''||V_TMP_TIPO_DATA(3)||'''');
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