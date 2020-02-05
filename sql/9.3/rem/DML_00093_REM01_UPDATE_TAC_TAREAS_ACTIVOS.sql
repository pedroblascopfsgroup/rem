--/*
--##########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9179
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza en GEE_GESTOR_ENTIDAD 
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
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INCIDENCIA VARCHAR2(25 CHAR) := 'HREOS-9179';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
    -- LOOP para actualizar los valores en TAC_TAREAS_ACTIVOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN TAC_TAREAS_ACTIVOS');
    
        --Modificamos los valores
		    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
        USING (
            SELECT TAC.TAR_ID FROM TAC_TAREAS_ACTIVOS TAC 
            JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID AND TRA.BORRADO = 0  AND TRA.TRA_FECHA_FIN IS NULL
            JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID AND TBJ.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TBJ.ACT_ID AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR_TAREA_FINALIZADA = 0  AND TAR.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''02''
        ) T2 
        ON (T1.TAR_ID =  T2.TAR_ID)
        WHEN MATCHED THEN UPDATE SET 
        T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''), T1.FECHAMODIFICAR = SYSDATE, T1.USUARIOMODIFICAR = '''||V_INCIDENCIA||'''';
    EXECUTE IMMEDIATE V_MSQL;
COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAC_TAREAS_ACTIVOS MODIFICADA CORRECTAMENTE ');
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT