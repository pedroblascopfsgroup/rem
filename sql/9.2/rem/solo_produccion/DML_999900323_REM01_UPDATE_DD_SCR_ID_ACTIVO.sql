--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1886
--## PRODUCTO=NO
--##
--## Finalidad: Script que updatea en ACT_ACTIVO 
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
	  
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID_ACTIVO NUMBER(16);
	V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-1886';
    V_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

		T_TIPO_DATA(136436),
		T_TIPO_DATA(142882),
		T_TIPO_DATA(155859),
		T_TIPO_DATA(153480),
		T_TIPO_DATA(143184),
		T_TIPO_DATA(142982),
		T_TIPO_DATA(155860),
		T_TIPO_DATA(142711),
		T_TIPO_DATA(152966),
		T_TIPO_DATA(136857),
		T_TIPO_DATA(155908),
		T_TIPO_DATA(152968),
		T_TIPO_DATA(152964),
		T_TIPO_DATA(136682),
		T_TIPO_DATA(153479),
		T_TIPO_DATA(153189),
		T_TIPO_DATA(143342),
		T_TIPO_DATA(142981),
		T_TIPO_DATA(155862),
		T_TIPO_DATA(143341),
		T_TIPO_DATA(142712),
		T_TIPO_DATA(153484),
		T_TIPO_DATA(155757),
		T_TIPO_DATA(155861),
		T_TIPO_DATA(152967),
		T_TIPO_DATA(136432),
		T_TIPO_DATA(153481),
		T_TIPO_DATA(136856),
		T_TIPO_DATA(155465),
		T_TIPO_DATA(143340),
		T_TIPO_DATA(153478),
		T_TIPO_DATA(153483),
		T_TIPO_DATA(136434),
		T_TIPO_DATA(136613),
		T_TIPO_DATA(142881),
		T_TIPO_DATA(142713),
		T_TIPO_DATA(155755)

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO  = '||TRIM(V_TMP_TIPO_DATA(1))||'' INTO V_ID_ACTIVO;
        
        IF V_ID_ACTIVO < 1 THEN
        
        	DBMS_OUTPUT.PUT_LINE('[WARNING] NO EXISTE EL ACTIVO '||TRIM(V_TMP_TIPO_DATA(1))||' NO SE HACE NADA!');
        	
        ELSE
        
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
 			  DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''04'')
 			, USUARIOMODIFICAR = '''||V_USUARIO||'''
 			, FECHAMODIFICAR = SYSDATE
 			WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_TIPO_DATA(1))||'';
	        EXECUTE IMMEDIATE V_SQL;
	        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        END IF;

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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
