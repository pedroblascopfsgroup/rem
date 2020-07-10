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
		T_TIPO_DATA('192759',0),
		T_TIPO_DATA('160274',0),
		T_TIPO_DATA('148805',0),
		T_TIPO_DATA('64434',0),
		T_TIPO_DATA('171455',1),
		T_TIPO_DATA('159888',0),
		T_TIPO_DATA('73932',0),
		T_TIPO_DATA('170436',0),
		T_TIPO_DATA('148804',0),
		T_TIPO_DATA('70572',1),
		T_TIPO_DATA('171854',0),
		T_TIPO_DATA('173808',0),
		T_TIPO_DATA('183555',0),
		T_TIPO_DATA('171855',0),
		T_TIPO_DATA('64550',0),
		T_TIPO_DATA('101061',0),
		T_TIPO_DATA('140918',0),
		T_TIPO_DATA('148258',0),
		T_TIPO_DATA('64832',0),
		T_TIPO_DATA('136037',0),
		T_TIPO_DATA('159889',0),
		T_TIPO_DATA('201605',0),
		T_TIPO_DATA('69414',0),
		T_TIPO_DATA('160275',0),
		T_TIPO_DATA('173810',0),
		T_TIPO_DATA('141173',0),
		T_TIPO_DATA('170192',0),
		T_TIPO_DATA('170454',0),
		T_TIPO_DATA('72486',0)

	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	 
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        V_MSQL := 'SELECT COUNT(bie_id) FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION
                    where bie_id = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO where ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(2)||')';
        
        EXECUTE IMMEDIATE V_MSQL INTO V_VALOR;

        IF V_VALOR > 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO EN  BIE_ADJ_ADJUDICACION...');

            V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET 
		  BIE_ADJ_LANZAMIENTO_NECES='||V_TMP_TIPO_DATA(2)||'
                , USUARIOMODIFICAR = ''REMVIP-7712''
		, FECHAMODIFICAR = SYSDATE
            WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(2)||')';
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
