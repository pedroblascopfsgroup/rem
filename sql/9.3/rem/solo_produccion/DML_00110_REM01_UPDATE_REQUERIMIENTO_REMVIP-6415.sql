--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6415
--##
--## PRODUCTO=NO
--## Finalidad: Activa requerimiento en los trabajos dados
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
    V_TABLA VARCHAR2(30 CHAR); -- Vble para nombre de la tabla prinipal
    V_USUARIO VARCHAR2(25 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	  
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_VALORES IS TABLE OF T_TABLA;
    --Primer valor indica el número de trabajo, el segundo el valor de TBJ_REQUERIMIENTO
    V_VALORES T_ARRAY_VALORES := T_ARRAY_VALORES(
	      T_TABLA(9000290074,1), 
        T_TABLA(9000290014,1)
    ); 
    V_TMP_VALORES T_TABLA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  V_TABLA := 'ACT_TBJ_TRABAJO';
  ---- TODO ---------------------
	V_USUARIO := 'REMVIP-6415'; -- Contiene el nombre del usuario que crea, modifica o borra, normalmente el Nº de item
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE '|| V_TABLA);
    FOR I IN V_VALORES.FIRST .. V_VALORES.LAST
      LOOP
      V_TMP_VALORES := V_VALORES(I);  
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||
              '  SET TBJ_REQUERIMIENTO = '||V_TMP_VALORES(2)||
              ', VERSION = VERSION + 1, USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE, BORRADO = 0
              WHERE TBJ_NUM_TRABAJO = '||V_TMP_VALORES(1);
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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
EXIT;