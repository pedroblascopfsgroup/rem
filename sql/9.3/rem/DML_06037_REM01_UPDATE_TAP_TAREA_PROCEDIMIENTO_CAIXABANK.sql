--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16258
--## PRODUCTO=NO
--##
--## Finalidad: Modificar JBPM para caixabank
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_TMP VARCHAR2(50 CHAR) := 'TMP_TAP_PROCEDIMIENTO_CAIXABANK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16258'; -- Usuario modificar

    V_BEFORE_VALIDATION VARCHAR2(1024 CHAR):= '!checkBankia() ? ';
    V_AFTER_VALIDATION VARCHAR2(1024 CHAR) := ' : ''''El avance de tareas en Caixabank est&aacute; bloqueado temporalmente''''';

    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	    T_FUNCION('T015'),
        T_FUNCION('T017'),
        T_FUNCION('T018')
    );          
    V_TMP_FUNCION T_FUNCION;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO] TRUNCATE '||V_TEXT_TABLA_TMP);
    --¡¡¡IMPORTANTEEEEEEEEEE!!!CUANDO SE VAYA A REALIZAR EL RETORNO DE LOS VALORES, COMENTAR/ELIMINAR ESTA LINEA
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||'';

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    LOOP
    V_TMP_FUNCION := V_FUNCION(I);

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||' 
                    (TAP_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM)
                    SELECT TAP_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION_JBPM
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                    WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO
                    WHERE DD_TPO_CODIGO = '''||V_TMP_FUNCION(1)||''') AND BORRADO = 0';
        
        EXECUTE IMMEDIATE V_MSQL; 

        DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA PROCEDIMIENTO '''||V_TMP_FUNCION(1)||''' EN '||V_TEXT_TABLA_TMP);

    END LOOP;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||' 
                    SET TAP_SCRIPT_VALIDACION_JBPM = ''null''
                    WHERE TAP_SCRIPT_VALIDACION_JBPM IS NULL';
        
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                    SELECT TAP.TAP_ID, TMP.TAP_SCRIPT_VALIDACION_JBPM
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TAP
                    JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||' TMP ON TMP.TAP_ID = TAP.TAP_ID
                ) T2 ON (T1.TAP_ID = T2.TAP_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.TAP_SCRIPT_VALIDACION_JBPM = CONCAT(CONCAT('''||V_BEFORE_VALIDATION||''',TRIM(T2.TAP_SCRIPT_VALIDACION_JBPM)),	'''||V_AFTER_VALIDATION||'''),
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA BLOQUEAR EL AVANCE DE CAIXABANK EN '||V_TEXT_TABLA);

    /*V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||' 
                    SET TAP_SCRIPT_VALIDACION_JBPM = NULL
                    WHERE TAP_SCRIPT_VALIDACION_JBPM = ''null''';
        
    EXECUTE IMMEDIATE V_MSQL; 
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                    SELECT TAP_ID, TAP_SCRIPT_VALIDACION_JBPM
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_TMP||'
                ) T2 ON (T1.TAP_ID = T2.TAP_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.TAP_SCRIPT_VALIDACION_JBPM = T2.TAP_SCRIPT_VALIDACION_JBPM,
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARA DESBLOQUEAR EL AVANCE DE CAIXABANK EN '||V_TEXT_TABLA);
    */
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
