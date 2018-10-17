--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2095
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


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
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_ACTIVO';  -- Tabla a modificar
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2095'; -- USUARIOCREAR/USUARIOMODIFICAR
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --ACT_NUM_ACTIVO (MALO) , ACT_NUM_ACTIVO (BUENO) , RECOVERY ID (BUENO)
		T_TIPO_DATA(6894254,6898365,3000000000424237),
		T_TIPO_DATA(6894248,6898360,3000000000424454),
		T_TIPO_DATA(6894253,6898364,3000000000425038),
		T_TIPO_DATA(6894247,6898359,3000000000421994),
		T_TIPO_DATA(6894249,6898361,3000000000421366),
		T_TIPO_DATA(6894251,6898362,3000000000422171),
		T_TIPO_DATA(6894246,6898358,3000000000423637),
		T_TIPO_DATA(6894252,6898363,3000000000422133)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN DE ACTIVOS ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    		
    		V_SQL := 'UPDATE REM01.ACT_ACTIVO SET 
							ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(2)||',
							ACT_RECOVERY_ID = '||V_TMP_TIPO_DATA(3)||',
							USUARIOMODIFICAR = '''||V_USR||''',
							FECHAMODIFICAR = SYSDATE
						WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
    		
    		EXECUTE IMMEDIATE V_SQL;    
    		
      END LOOP;
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
						SET
							BORRADO = 1,
							USUARIOBORRAR  = '''||V_USR||''',
							FECHABORRAR = SYSDATE
					WHERE
						ACT_NUM_ACTIVO = 6892090';
		
			EXECUTE IMMEDIATE V_SQL;    
		
		    DBMS_OUTPUT.PUT_LINE('[INFO]: SE BORRA EL ACTIVO 6892090 ');
	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN ACTUALIZADO CORRECTAMENTE LOS ACTIVOS ');
   

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
