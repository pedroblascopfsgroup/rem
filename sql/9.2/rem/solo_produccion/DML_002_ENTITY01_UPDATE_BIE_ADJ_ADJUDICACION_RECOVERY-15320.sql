--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20190320
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-15320
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar REM01.ACT_ACTIVO, campo ACT_RECOVERY_ID con el datos de la columna M. Utilizar como clave la columna O (ACT_RECOVERY_ID)
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
    V_CONTADOR NUMBER := 0; -- variable para contar filas.
    V_VALOR NUMBER(16); -- Vble. para validar la existencia de un valor.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        ----------- ACT_RECOVERY_ID --- ACT_RECOVERY_ID ---
        T_TIPO_DATA(1000000000313964,86904),
        T_TIPO_DATA(1000000000224646,89882)

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	 
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_MSQL := 'SELECT COUNT(ACT_NUM_ACTIVO) FROM '||V_ESQUEMA||'.ACT_ACTIVO where ACT_NUM_ACTIVO ='||V_TMP_TIPO_DATA(2);
        
        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR;

        IF V_VALOR > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO EN  ACT_ACTIVO...');

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET ACT_RECOVERY_ID='||V_TMP_TIPO_DATA(1)||'
                , USUARIOMODIFICAR = ''RECOVERY-15320'', FECHAMODIFICAR = SYSDATE
            WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(2);
            EXECUTE IMMEDIATE V_MSQL;
            V_CONTADOR := V_CONTADOR + SQL%ROWCOUNT;

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INICIO] NO EXISTE EL REGISTRO EN ACT_ACTIVO.');
            
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO] FILAS ACTUALIZADAS: '||V_CONTADOR);
    
    COMMIT;
	
    DBMS_OUTPUT.PUT_LINE('[FIN] Filas actualizadas en la tabla ACT_ACTIVO');
   

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
