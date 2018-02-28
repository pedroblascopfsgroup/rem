--/*
--##########################################
--## AUTOR=Josep Ros Del Campo
--## FECHA_CREACION=20180221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=RECOVERY-10706
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de activos
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
    V_CONTADOR_UNO NUMBER := 0; -- variable para contar filas.
    V_CONTADOR_DOS NUMBER := 0;

-- Creamos un array para el primer bloque de datos a actualizar
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--ACT_NUM_ACTIVO, ACT_NUM_ACTIVO_UVEM, ACT_NUM_ACTIVO_SAREB erroneo, ACT_NUM_ACTIVO_SAREB actualizar
		T_TIPO_DATA(190769, 30049379, '655066', '9009689'),
		T_TIPO_DATA(192028, 30049496, '692039', '655066'),
		T_TIPO_DATA(6939962, 30050095, '0', '9009686')
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


-- Creamos otro array para el segundo bloque de datos a actualizar
    TYPE T_INT is table of VARCHAR2(150); 
	TYPE T_ARRAY_INT IS TABLE OF T_INT;
	V_INT T_ARRAY_INT := T_ARRAY_INT(  
		-- ACT_NUMERO_ACTIVO_REM, ACT_RECOVERY_ID, ACT_NUM_ACTIVO erroneo,  ACT_NUM_ACTIVO actualizar, ACT_NUM_ACTIVO_SAREB erroneo, ACT_NUM_ACTIVO_SAREB actualizar
		T_INT(122831, 1000000000274806, 6129459, 6939961,'2803988','9009688'),
		T_INT(122847, 1000000000228303, 197684, 6939958,'893332', '9009478'),
		T_INT(122851, 1000000000308996, 192029, 6939960, '692042', '9009687'),
		T_INT(122877, 1000000000251867, 6355795, 6939959, '11001956','692039')
	); 
	V_TMP_INT T_INT;




BEGIN	
	
-- Actualizamos los datos con el array del primer bloque 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Empieza la actualización del primer bloque:');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
   		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET USUARIOMODIFICAR = ''RECOVERY-10706'', FECHAMODIFICAR = SYSDATE, ACT_NUM_ACTIVO_SAREB = '''||V_TMP_TIPO_DATA(4)||'''
		WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('UPDATEANDO EL ACT_NUM_ACTIVO_SAREB ERRÓNEO: '||V_TMP_TIPO_DATA(3)||' con el ACT_NUM_ACTIVO_SAREB CORRECTO: '||V_TMP_TIPO_DATA(4) || 'DEL ACT_NUM_ACTIVO: '
		||V_TMP_TIPO_DATA(1));
		V_CONTADOR_UNO := V_CONTADOR_UNO + SQL%ROWCOUNT;
    END LOOP;
	DBMS_OUTPUT.PUT_LINE('FILAS UPDATEADAS PRIMER BLOQUE: '||V_CONTADOR_UNO);



--Actualizamos los datos con el array del segundo bloque
DBMS_OUTPUT.PUT_LINE('[INICIO] Empieza la actualización del segundo bloque:');
    FOR I IN V_INT.FIRST .. V_INT.LAST
      LOOP
      
        V_TMP_INT := V_INT(I);
    
   		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET USUARIOMODIFICAR = ''RECOVERY-10706'', FECHAMODIFICAR = SYSDATE, ACT_NUM_ACTIVO = '||V_TMP_INT(4)||
		', ACT_NUM_ACTIVO_SAREB = '''||V_TMP_INT(6)||'''
		WHERE ACT_NUM_ACTIVO_REM = '||V_TMP_INT(1);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('UPDATEANDO EL ACT_NUM_ACTIVO ERRÓNEO: '||V_TMP_INT(3)||' CON EL ACT_NUM_ACTIVO CORRECTO: '||V_TMP_INT(4)||' Y EL ACT_NUM_ACTIVO_SAREB: '||V_TMP_INT(5)||
		'CON EL ACT_NUM_ACTIVO_SAREB CORRECTO: ' ||V_TMP_INT(6) || ' DEL ACT_NUM_ACTIVO_REM: '|| V_TMP_INT(1));
		V_CONTADOR_DOS := V_CONTADOR_DOS + SQL%ROWCOUNT;
    END LOOP;
	DBMS_OUTPUT.PUT_LINE('FILAS UPDATEADAS SEGUNDO BLOQUE: '||V_CONTADOR_DOS);


	DBMS_OUTPUT.PUT_LINE('TOTAL REGISTROS ACTUALIZADOS: '||(V_CONTADOR_UNO + V_CONTADOR_DOS));
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Terminadas todas las tareas del ticket RECOVERY-10706');
   

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
