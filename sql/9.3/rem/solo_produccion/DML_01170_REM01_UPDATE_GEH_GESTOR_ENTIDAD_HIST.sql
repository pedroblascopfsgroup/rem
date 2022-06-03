--/*
--##########################################
--## AUTOR=Carlos Santi Monzó
--## FECHA_CREACION=20220519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11672
--## PRODUCTO=NO
--##
--## Finalidad: Script que asignar al usuario jleandro como gestor
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11672'; -- USUARIO CREAR/MODIFICAR
    V_USUARIO_ORIGEN VARCHAR2(50 CHAR) := 'eperezc';
    V_USUARIO_DESTINO VARCHAR2(50 CHAR) := 'jleandro';
    V_TGE_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    V_MSQL:='SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SFORM''';
		EXECUTE IMMEDIATE V_MSQL INTO V_TGE_ID;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SET
                    USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_DESTINO||'''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_TGE_ID = '||V_TGE_ID||' AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_ORIGEN||''')';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEE_GESTOR_ENTIDAD: ' ||sql%rowcount);


    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
                GEH_ID,
                USU_ID,
                DD_TGE_ID,
                GEH_FECHA_DESDE,      
                VERSION,
                USUARIOCREAR,
                FECHACREAR
                )

                SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL           GEH_ID,
                   (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_DESTINO||''')         USU_ID,
                    '''||V_TGE_ID||'''                  DD_TGE_ID,
                    SYSDATE                         GEH_FECHA_DESDE,      
                    0                               VERSION,
                    '''||V_USUARIO||'''                 USUARIOCREAR,
                    SYSDATE                         FECHACREAR
                    FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
                    WHERE DD_TGE_ID = '||V_TGE_ID||' AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_ORIGEN||''')';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS EN GEH_GESTOR_ENTIDAD_HIST: ' ||sql%rowcount);


    V_MSQL := 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST SET
                    GEH_FECHA_HASTA = SYSDATE,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE DD_TGE_ID = '||V_TGE_ID||' AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_ORIGEN||''')';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEH_GESTOR_ENTIDAD_HIST: ' ||sql%rowcount);




    
    
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
