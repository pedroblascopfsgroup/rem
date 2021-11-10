--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20211109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10703
--## PRODUCTO=NO
--##
--## Finalidad: Borrar documetnos
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
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-10703'; -- Usuario modificar


    TYPE T_FUNCION IS TABLE OF VARCHAR2(1500);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	    T_FUNCION('84'),
        T_FUNCION('87')
    );          
    V_TMP_FUNCION T_FUNCION;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    LOOP
    V_TMP_FUNCION := V_FUNCION(I);

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET BORRADO = 1, USUARIOBORRAR = '''||V_USUARIO||''', FECHABORRAR = SYSDATE
                    WHERE DD_SDE_CODIGO = '''||V_TMP_FUNCION(1)||''' ';
        
        EXECUTE IMMEDIATE V_MSQL; 

    END LOOP;


    
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
