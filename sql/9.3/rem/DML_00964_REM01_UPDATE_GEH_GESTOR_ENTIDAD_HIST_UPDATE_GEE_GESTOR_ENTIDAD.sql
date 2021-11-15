--/*
--##########################################
--## AUTOR=juan José Sanjuan Cortina
--## FECHA_CREACION=20211102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16043
--## PRODUCTO=NO
--##
--## Finalidad: Script que elimina  gestores comerciales en activo de un activo
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
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16043'; -- USUARIO CREAR/MODIFICAR
    V_CRA_CODIGO VARCHAR2(50 CHAR) := '18';
    
BEGIN	


	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: REASIGNACIÓN DE GESTOR GCOM DE CARTERA TITULIZADAS');  

    --Localizamos el historico de gestores comerciales y lo damos de baja GEH_GESTOR_ENTIDAD_HIST
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST T1
		USING (
		    SELECT DISTINCT ggeh.GEH_ID
		   FROM '||V_ESQUEMA||'.ACT_ACTIVO aa 
                    JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO ggah ON ggah.ACT_ID = aa.ACT_ID
                    JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST ggeh ON ggeh.GEH_ID = ggah.GEH_ID
                    JOIN  '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR dttg  ON dttg.DD_TGE_ID = ggeh.DD_TGE_ID
                WHERE 
                    aa.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_CRA_CODIGO||''')
                    AND ggeh.GEH_FECHA_HASTA IS NULL
                    AND dttg.DD_TGE_CODIGO = ''GCOM'') T2
		ON (T1.GEH_ID = T2.GEH_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.GEH_FECHA_HASTA = SYSDATE, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEH_GESTOR_ENTIDAD_HIST: ' ||sql%rowcount);


    --Localizamos el gestor actual  del activo y lo marcamos GEE_GESTOR_ENTIDAD
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD T1
		USING (
		   SELECT DISTINCT gge.GEE_ID
		   FROM REM01.ACT_ACTIVO aa 
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO ggaa ON ggaa.ACT_ID = aa.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gge ON gge.GEE_ID = ggaa.GEE_ID
                        JOIN  '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR dttg  ON dttg.DD_TGE_ID = gge.DD_TGE_ID
                    WHERE 
                        aa.DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_CRA_CODIGO||''')
                        AND dttg.DD_TGE_CODIGO = ''GCOM''
                        AND gge.BORRADO = 0) T2
		ON (T1.GEE_ID = T2.GEE_ID)
		WHEN MATCHED THEN UPDATE SET
		     T1.USUARIOBORRAR = '''||V_USUARIO||'''';
    
    EXECUTE IMMEDIATE V_MSQL;



    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN GEE_GESTOR_ENTIDAD: ' ||sql%rowcount);


    --eliminamos el registro de la tabla intermedia que señala al gestor actual del activo GAC_GESTOR_ADD_ACTIVO
    V_MSQL := 'DELETE 
                FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO ggaa
                WHERE ggaa.GEE_ID IN (SELECT DISTINCT gge.GEE_ID FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO ggaa1
                                    JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gge ON gge.GEE_ID = ggaa1.GEE_ID
                            WHERE gge.USUARIOBORRAR = '''||V_USUARIO||''')';
    EXECUTE IMMEDIATE V_MSQL;



    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ELIMINADOS EN GAC_GESTOR_ADD_ACTIVO: ' ||sql%rowcount);


    --eliminamos el registro de la tabla que señala al gestor actual del activo	GEE_GESTOR_ENTIDAD		
    V_MSQL := 'DELETE 
                FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gge
                WHERE gge.GEE_ID IN (SELECT DISTINCT gge1.GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD gge1 
                            WHERE gge1.USUARIOBORRAR = '''||V_USUARIO||''')';
    EXECUTE IMMEDIATE V_MSQL;



    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ELIMINADOS EN GEE_GESTOR_ENTIDAD: ' ||sql%rowcount);

    
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
