--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20181112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2361
--## PRODUCTO=NO
--## 
--## Finalidad: update tipo uso destino en la tabla DD_TUD_TIPO_USO_DESTINO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2361';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1500);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    ----DD_CODIGO_SUBTIPO_REC, DD_CODIGO_TUD_REM
	T_TIPO_DATA('00','05'),
	T_TIPO_DATA('0401','01'),
	T_TIPO_DATA('0402','01'),
	T_TIPO_DATA('0405','02'),
	T_TIPO_DATA('0406','01'),
	T_TIPO_DATA('0409','05'),
	T_TIPO_DATA('0411','01'),
	T_TIPO_DATA('0412','01'),
	T_TIPO_DATA('0413','01'),
	T_TIPO_DATA('0414','01'),
	T_TIPO_DATA('0416','03'),
	T_TIPO_DATA('0417','02'),
	T_TIPO_DATA('0418','02'),
	T_TIPO_DATA('0419','02'),
	T_TIPO_DATA('0420','03'),
	T_TIPO_DATA('0421','01'),
	T_TIPO_DATA('0423','01'),
	T_TIPO_DATA('0424','01'),
	T_TIPO_DATA('0425','01'),
	T_TIPO_DATA('0426','01'),
	T_TIPO_DATA('0428','05'),
	T_TIPO_DATA('0429','05'),
	T_TIPO_DATA('0430','05'),
	T_TIPO_DATA('0431','05'),
	T_TIPO_DATA('0432','05'),
	T_TIPO_DATA('0433','05'),
	T_TIPO_DATA('0434','05'),
	T_TIPO_DATA('0436','05'),
	T_TIPO_DATA('0439','05'),
	T_TIPO_DATA('0487','02'),
	T_TIPO_DATA('0488','02'),
	T_TIPO_DATA('CO00','02'),
	T_TIPO_DATA('CO01','02'),
	T_TIPO_DATA('CO02','02'),
	T_TIPO_DATA('CO03','02'),
	T_TIPO_DATA('ED00','05'),
	T_TIPO_DATA('ED01','01'),
	T_TIPO_DATA('ED02','02'),
	T_TIPO_DATA('ED03','03'),
	T_TIPO_DATA('ED04','02'),
	T_TIPO_DATA('ED05','04'),
	T_TIPO_DATA('ED06','02'),
	T_TIPO_DATA('ED07','02'),
	T_TIPO_DATA('IN00','03'),
	T_TIPO_DATA('IN01','03'),
	T_TIPO_DATA('IN02','03'),
	T_TIPO_DATA('IN03','03'),
	T_TIPO_DATA('IN04','03'),
	T_TIPO_DATA('OT00','05'),
	T_TIPO_DATA('OT01','02'),
	T_TIPO_DATA('OT02','02'),
	T_TIPO_DATA('OT03','02'),
	T_TIPO_DATA('OT04','02'),
	T_TIPO_DATA('OT05','05'),
	T_TIPO_DATA('SI','NULL'),
	T_TIPO_DATA('SU00','NULL'),
	T_TIPO_DATA('SU01','05'),
	T_TIPO_DATA('SU02','05'),
	T_TIPO_DATA('SU03','05'),
	T_TIPO_DATA('SU04','NULL'),
	T_TIPO_DATA('VI00','01'),
	T_TIPO_DATA('VI01','01'),
	T_TIPO_DATA('VI02','01'),
	T_TIPO_DATA('VI03','01'),
	T_TIPO_DATA('VI04','01'),
	T_TIPO_DATA('VI05','01')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en APR_AUX_MAPEO_DD_SAC -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE DD_CODIGO_TUD_REM EN LA TABLA APR_AUX_MAPEO_DD_SAC');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT (1) FROM REM01.APR_AUX_MAPEO_DD_SAC MAP 
		  WHERE MAP.DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		
       -- DBMS_OUTPUT.PUT_LINE(V_SQL);		
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       -- DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
       --Si existe realizamos otra comprobacion
			IF V_NUM_TABLAS > 0 THEN	
			
					V_MSQL := 'UPDATE '||V_ESQUEMA||'.APR_AUX_MAPEO_DD_SAC 
   						   SET 
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE, 
							DD_CODIGO_TUD_REM = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							WHERE DD_CODIGO_SUBTIPO_REC = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
					
					EXECUTE IMMEDIATE V_MSQL;	

					V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
				
			--El REGISTRO no existe
			ELSE
				  DBMS_OUTPUT.PUT_LINE('[ERROR]:  NO EXISTE EL CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');
			END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');

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
