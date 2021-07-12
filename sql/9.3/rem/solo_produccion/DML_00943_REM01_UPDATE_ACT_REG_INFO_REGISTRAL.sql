--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10111
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza la superficie útil
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10111'; -- USUARIO CREAR/MODIFICAR
    V_TABLA_REG  VARCHAR2(100 CHAR):= 'ACT_REG_INFO_REGISTRAL';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_ID NUMBER(16);
    V_ID_HAYA NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_TIPO_DATA IS TABLE OF T_TIPO_DATA; 
	V_TIPO_DATA T_ARRAY_TIPO_DATA := T_ARRAY_TIPO_DATA(
		    T_TIPO_DATA(' 7042854 '),
            T_TIPO_DATA(' 7042929 '),
            T_TIPO_DATA(' 7042931 '),
            T_TIPO_DATA(' 7043056 '),
            T_TIPO_DATA(' 7043076 '),
            T_TIPO_DATA(' 7043149 '),
            T_TIPO_DATA(' 7043213 '),
            T_TIPO_DATA(' 7043260 '),
            T_TIPO_DATA(' 7043282 '),
            T_TIPO_DATA(' 7043314 '),
            T_TIPO_DATA(' 7043525 '),
            T_TIPO_DATA(' 7043532 '),
            T_TIPO_DATA(' 7043561 '),
            T_TIPO_DATA(' 7043586 '),
            T_TIPO_DATA(' 7043614 '),
            T_TIPO_DATA(' 7043645 '),
            T_TIPO_DATA(' 7043655 '),
            T_TIPO_DATA(' 7043660 '),
            T_TIPO_DATA(' 7043661 '),
            T_TIPO_DATA(' 7043662 '),
            T_TIPO_DATA(' 7043680 '),
            T_TIPO_DATA(' 7043797 '),
            T_TIPO_DATA(' 7043812 '),
            T_TIPO_DATA(' 7043817 '),
            T_TIPO_DATA(' 7043819 '),
            T_TIPO_DATA(' 7043838 '),
            T_TIPO_DATA(' 7043853 '),
            T_TIPO_DATA(' 7043923 '),
            T_TIPO_DATA(' 7044027 '),
            T_TIPO_DATA(' 7044033 '),
            T_TIPO_DATA(' 7044238 '),
            T_TIPO_DATA(' 7044485 '),
            T_TIPO_DATA(' 7044501 '),
            T_TIPO_DATA(' 7044695 '),
            T_TIPO_DATA(' 7044744 '),
            T_TIPO_DATA(' 7044811 '),
            T_TIPO_DATA(' 7044857 '),
            T_TIPO_DATA(' 7044930 '),
            T_TIPO_DATA(' 7045025 '),
            T_TIPO_DATA(' 7045033 '),
            T_TIPO_DATA(' 7045044 '),
            T_TIPO_DATA(' 7045182 '),
            T_TIPO_DATA(' 7045183 '),
            T_TIPO_DATA(' 7045306 '),
            T_TIPO_DATA(' 7045315 '),
            T_TIPO_DATA(' 7045388 '),
            T_TIPO_DATA(' 7045462 '),
            T_TIPO_DATA(' 7045484 '),
            T_TIPO_DATA(' 7045512 '),
            T_TIPO_DATA(' 7045570 '),
            T_TIPO_DATA(' 7045586 '),
            T_TIPO_DATA(' 7045649 '),
            T_TIPO_DATA(' 7045703 '),
            T_TIPO_DATA(' 7045730 '),
            T_TIPO_DATA(' 7045761 '),
            T_TIPO_DATA(' 7045769 '),
            T_TIPO_DATA(' 7045816 '),
            T_TIPO_DATA(' 7045865 '),
            T_TIPO_DATA(' 7045917 '),
            T_TIPO_DATA(' 7045919 '),
            T_TIPO_DATA(' 7045927 '),
            T_TIPO_DATA(' 7045967 '),
            T_TIPO_DATA(' 7046138 '),
            T_TIPO_DATA(' 7046160 '),
            T_TIPO_DATA(' 7046181 '),
            T_TIPO_DATA(' 7046196 '),
            T_TIPO_DATA(' 7046271 '),
            T_TIPO_DATA(' 7046393 '),
            T_TIPO_DATA(' 7046428 '),
            T_TIPO_DATA(' 7046430 '),
            T_TIPO_DATA(' 7046483 '),
            T_TIPO_DATA(' 7046565 '),
            T_TIPO_DATA(' 7046572 '),
            T_TIPO_DATA(' 7046581 '),
            T_TIPO_DATA(' 7046582 '),
            T_TIPO_DATA(' 7046698 '),
            T_TIPO_DATA(' 7047040 '),
            T_TIPO_DATA(' 7047094 '),
            T_TIPO_DATA(' 7047120 '),
            T_TIPO_DATA(' 7047172 '),
            T_TIPO_DATA(' 7047205 '),
            T_TIPO_DATA(' 7047206 '),
            T_TIPO_DATA(' 7047284 '),
            T_TIPO_DATA(' 7047306 '),
            T_TIPO_DATA(' 7047507 '),
            T_TIPO_DATA(' 7047710 '),
            T_TIPO_DATA(' 7047786 '),
            T_TIPO_DATA(' 7048197 '),
            T_TIPO_DATA(' 7048202 '),
            T_TIPO_DATA(' 7055405 ')

          
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;


    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
 	LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

 		V_ID_HAYA := TRIM(V_TMP_TIPO_DATA(1));
		
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LA SUPERFICIE ÚTIL DEL ACTIVO ');  

    --Comprobar si existe en la tabla el activo.
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ID_HAYA;
    EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

    --Comprobar si existe en la tabla el activo.
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_REG||' WHERE ACT_ID = '||V_ID;
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
    
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_REG||' SET 
        REG_SUPERFICIE_PARCELA = ''0'',
        USUARIOMODIFICAR = '''||V_USUARIO||''', 
        FECHAMODIFICAR = SYSDATE 
        WHERE ACT_ID = '||V_ID||'';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: SUPERFICIE ACTUALIZADA CORRECTAMENTE DEL ACTIVO '||V_ID_HAYA);

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '||V_ID_HAYA||' NO EXISTE');

    END IF;

END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');
   

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
