--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181024
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2348
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR SITUACION COMERCIAL DEL ACTIVO
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
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-2348';
  
  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
  TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    -- 	 	ACTIVO, ESTADO ACTIVO
	T_TIPO_DATA('6343492','04')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para actualizar los valores en ACT_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE ESTADO ACTIVO');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT
						COUNT(1)
					FROM
						REM01.ACT_ACTIVO ACT
					WHERE
						ACT.ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
				
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe realizamos otra comprobacion
        IF V_NUM_TABLAS = 1 THEN		

			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL ESTADO DEL ACTIVO '||TRIM(V_TMP_TIPO_DATA(1))||'');
			
			V_MSQL := 'UPDATE REM01.ACT_ACTIVO SET 
							DD_SCM_ID = (SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''),
							USUARIOMODIFICAR = '''||V_USUARIO||''',
							FECHAMODIFICAR = SYSDATE
						  WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';

			EXECUTE IMMEDIATE V_MSQL;
			

			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE EL ESTADO DEL ACTIVO '||TRIM(V_TMP_TIPO_DATA(1))||'');
			
		--El activo no existe
		ELSE
			  DBMS_OUTPUT.PUT_LINE('[ERROR]: EL ESTADO DEL ACTIVO '''||TRIM(V_TMP_TIPO_DATA(1))||' NO HAN SIDO ACTUALIZADO');
		END IF;
		
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: LOS ACTIVOS HAN SIDO ACTUALIZADOS CORRECTAMENTE ');

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
