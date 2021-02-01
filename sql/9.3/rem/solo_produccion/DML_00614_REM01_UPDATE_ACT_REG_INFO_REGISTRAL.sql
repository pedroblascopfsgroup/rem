--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8669
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8669'; -- USUARIO CREAR/MODIFICAR
    V_TABLA_REG  VARCHAR2(100 CHAR):= 'ACT_REG_INFO_REGISTRAL';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LA SUPERFICIE ÚTIL DEL ACTIVO 7269086');  

    --Comprobar si existe en la tabla el activo.
    V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7269086';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID;	

    --Comprobar si existe en la tabla el activo.
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_REG||' WHERE ACT_ID = '||V_ID;
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
    
    IF V_NUM_TABLAS > 0 THEN

        V_MSQL :='UPDATE '||V_ESQUEMA||'.'||V_TABLA_REG||' SET 
        REG_SUPERFICIE_UTIL = ''481'',
        USUARIOMODIFICAR = '''||V_USUARIO||''', 
        FECHAMODIFICAR = SYSDATE 
        WHERE ACT_ID = '||V_ID||'';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: SUPERFICIE ACTUALIZADA CORRECTAMENTE');

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO 7269086 NO EXISTE');

    END IF;

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
