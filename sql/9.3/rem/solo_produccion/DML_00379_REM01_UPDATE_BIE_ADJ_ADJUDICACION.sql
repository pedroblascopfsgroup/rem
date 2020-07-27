--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7712
--## PRODUCTO=NO
--## Finalidad: Actualizar REM01.BIE_ADJ_ADJUDICACION 
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
        -- BIE_ADJ_F_REA_POSESION -- ACT_NUM_ACTIVO ---
	T_TIPO_DATA('119674','2020/02/28'),
T_TIPO_DATA('121144','2020/02/28'),
T_TIPO_DATA('163699','2020/04/29'),
T_TIPO_DATA('117655','2020/03/12'),
T_TIPO_DATA('171455','2020/02/21'),
T_TIPO_DATA('70572','2020/02/21'),
T_TIPO_DATA('118157','2020/03/12'),
T_TIPO_DATA('119673','2020/02/28'),
T_TIPO_DATA('120131','2020/02/28'),
T_TIPO_DATA('119676','2020/03/12')

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	 
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_MSQL := 'SELECT COUNT(bie_id) FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION
                    where bie_id = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO where ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||')';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR;

        IF V_VALOR > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO EN  BIE_ADJ_ADJUDICACION...');

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET 
		  BIE_ADJ_F_REA_LANZAMIENTO=TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''YYYY/MM/DD'')
                , USUARIOMODIFICAR = ''REMVIP-7712''
		, FECHAMODIFICAR = SYSDATE
            WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||')';
            EXECUTE IMMEDIATE V_MSQL;
            V_CONTADOR := V_CONTADOR + SQL%ROWCOUNT;
            
        END IF;

    END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO] FILAS ACTUALIZADAS: '||V_CONTADOR);
    
    COMMIT;
	
    DBMS_OUTPUT.PUT_LINE('[FIN] Filas actualizadas en la tabla BIE_ADJ_ADJUDICACION');
   

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
