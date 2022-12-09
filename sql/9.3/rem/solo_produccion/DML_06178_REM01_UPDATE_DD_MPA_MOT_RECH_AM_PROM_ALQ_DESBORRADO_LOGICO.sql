--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20221209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18998
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    V_EXISTE_LOCALIDAD NUMBER(16); -- Vble. para almacenar la busqueda del perfil.
    V_EXISTE_UNIDAD NUMBER(16); -- Vble. para almacenar la busqueda de la función.

    V_FP_ID NUMBER(16); -- Vble. para almacenar el id de la tabla FUN_PEF con la relación perfil/función.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error



BEGIN	
    


                V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_MPA_MOT_RECH_AM_PROM_ALQ
                           SET BORRADO = 0,
                           FECHABORRAR = NULL,
                           USUARIOBORRAR = NULL,
                           USUARIOMODIFICAR = ''HREOS-18998-REVERT'',
                           FECHAMODIFICAR = SYSDATE
			    WHERE DD_MPA_CODIGO IN (''SI01'',''SI02'',''SI03'',''SI04'',''SI06'',''SI07'',''SI08'',''SI10'')
                            ';

                EXECUTE IMMEDIATE V_MSQL;


    
    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
