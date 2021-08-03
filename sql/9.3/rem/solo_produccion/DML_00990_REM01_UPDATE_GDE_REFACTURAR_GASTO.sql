--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10277
--## PRODUCTO=NO
--##
--## Finalidad: Script marca gastos como refacturables
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_GDE VARCHAR2(100 CHAR):='GDE_GASTOS_DETALLE_ECONOMICO';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10277'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;
    V_NUM_TABLAS NUMBER(16);
    V_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 		GPV_NUM_GASTO_HAYA
            T_TIPO_DATA('14051458'),
            T_TIPO_DATA('14079420'),
            T_TIPO_DATA('14079419'),
            T_TIPO_DATA('14079422'),
            T_TIPO_DATA('14079423'),
            T_TIPO_DATA('14079421'),
            T_TIPO_DATA('14090962'),
            T_TIPO_DATA('14054985'),
            T_TIPO_DATA('14054990'),
            T_TIPO_DATA('14054992'),
            T_TIPO_DATA('14054994'),
            T_TIPO_DATA('14086566'),
            T_TIPO_DATA('14086567'),
            T_TIPO_DATA('14086568'),
            T_TIPO_DATA('14086569'),
            T_TIPO_DATA('14086570'),
            T_TIPO_DATA('14086571'),
            T_TIPO_DATA('14090959'),
            T_TIPO_DATA('14051450'),
            T_TIPO_DATA('14051451'),
            T_TIPO_DATA('14051452'),
            T_TIPO_DATA('14051453'),
            T_TIPO_DATA('14051454'),
            T_TIPO_DATA('14051455'),
            T_TIPO_DATA('14051456'),
            T_TIPO_DATA('14051457')


	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR REFACTURACION GASTO EN '||V_TABLA_GDE);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_GDE||' GDE ON GDE.GPV_ID=GPV.GPV_ID        
                    WHERE GPV.GPV_NUM_GASTO_HAYA = '||V_TMP_TIPO_DATA(1)||' AND GPV.BORRADO = 0 AND GDE.BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 1 THEN

            V_MSQL:= 'SELECT GDE.GDE_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' GPV
                    JOIN '||V_ESQUEMA||'.'||V_TABLA_GDE||' GDE ON GDE.GPV_ID=GPV.GPV_ID        
                    WHERE GPV.GPV_NUM_GASTO_HAYA = '||V_TMP_TIPO_DATA(1)||' AND GPV.BORRADO = 0 AND GDE.BORRADO = 0';
		    EXECUTE IMMEDIATE V_MSQL INTO V_ID;

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GDE||' SET
						GDE_GASTO_REFACTURABLE = 1 ,
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE GDE_ID = '||V_ID||' ';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS GASTOS A REFACTURABLE '||V_TMP_TIPO_DATA(1)||'');
            V_COUNT:=V_COUNT+1;

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: GASTO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

		END IF;

	END LOOP;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificados correctamente '''||V_COUNT||''' de '''||V_COUNT_TOTAL||''' ');
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT