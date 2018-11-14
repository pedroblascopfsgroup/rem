--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.19
--## INCIDENCIA_LINK=HREOS-4683
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

create or replace PROCEDURE SP_CREAR_AVISO (pACT_ID IN NUMBER DEFAULT NULL
														, pCODIGODEST VARCHAR2 DEFAULT NULL
                                                        , pUSUARIOMODIFICAR IN VARCHAR2 DEFAULT 'SP_CREAR_AVISO'
                                                        , pDESCRIPCION IN VARCHAR2 DEFAULT 'Aviso'
                                                        , pISAGRUPACION IN NUMBER DEFAULT NULL) IS

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar
    V_TAR_ID NUMBER(16); --Variable ID Tarea
    V_REG_ID NUMBER(16); --Variable ID MEJ Registro
    V_DESTINATARIO VARCHAR2(25 CHAR); --Variable Usuario Destino
    V_NUM_ACT NUMBER(16); --Variable NumActivo

    BEGIN

        IF pISAGRUPACION = 0 THEN
            V_MSQL := '
                SELECT ACT_NUM_ACTIVO FROM '|| V_ESQUEMA ||'.ACT_ACTIVO
                     WHERE ACT_ID = '||pACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_ACT;

            V_MSQL := '
                SELECT USU.USU_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC ON ACT.ACT_ID = GAC.ACT_ID
                    JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID AND GEE.BORRADO = 0
                    JOIN '|| V_ESQUEMA_MASTER ||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = '''|| pCODIGODEST ||''' AND TGE.BORRADO = 0
                    JOIN '|| V_ESQUEMA_MASTER ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID AND USU.BORRADO = 0
                    WHERE ACT.ACT_ID = '||pACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_DESTINATARIO;
        ELSE
            V_MSQL := '
                SELECT AGR_NUM_AGRUP_REM FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION
                     WHERE AGR_ID = '||pACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_ACT;

            V_MSQL := '
                SELECT USU.USU_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                    JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ACT_PRINCIPAL = ACT.ACT_ID
                    JOIN '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO GAC ON ACT.ACT_ID = GAC.ACT_ID
                    JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID AND GEE.BORRADO = 0
                    JOIN '|| V_ESQUEMA_MASTER ||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = '''|| pCODIGODEST ||''' AND TGE.BORRADO = 0
                    JOIN '|| V_ESQUEMA_MASTER ||'.USU_USUARIOS USU ON USU.USU_ID = GEE.USU_ID AND USU.BORRADO = 0
                    WHERE AGR.AGR_ID = '||pACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_DESTINATARIO;
        END IF;

        V_MSQL := '
            SELECT '|| V_ESQUEMA ||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_TAR_ID;

        V_MSQL := '
            SELECT '|| V_ESQUEMA ||'.S_MEJ_REG_REGISTRO.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_REG_ID;

        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, DD_EIN_ID
                                            ,DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION
                                            ,TAR_FECHA_INI, VERSION, USUARIOCREAR, FECHACREAR, DTYPE)
            SELECT '|| V_TAR_ID ||', 61, 701, ''3'', ''Aviso'', '''|| pDESCRIPCION ||''|| V_NUM_ACT ||''' TAR_DESCRIPCION
                                            ,SYSDATE TAR_FECHA_INI, 0 VERSION
                                            ,'''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR, ''EXTTareaNotificacion'' DTYPE
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.ETN_EXTAREAS_NOTIFICACIONES (TAR_ID
                                            ,TAR_TIPO_DESTINATARIO, TAR_ID_DEST)
            SELECT '|| V_TAR_ID ||' TAR_ID, ''U'' TAR_TIPO_DESTINATARIO
                                            ,'|| V_DESTINATARIO ||' TAR_ID_DEST
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_REG_REGISTRO (REG_ID, DD_TRG_ID, TRG_EIN_CODIGO
                                            ,TRG_EIN_ID, USU_ID, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_REG_ID ||' REG_ID, 8 DD_TRG_ID, 61 TRG_EIN_CODIGO, 181 TRG_EIN_ID
                                            ,'''|| V_DESTINATARIO ||''' USU_ID, 0 VERSION
                                            ,'''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --TIPO_ANO_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''TIPO_ANO_NOTIF'' IRG_CLAVE, ''A'' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --FECHA_CREAR_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''FECHA_CREAR_NOTIF'' IRG_CLAVE
                                            ,(SELECT TO_NUMBER(SYSDATE - TO_DATE(''01-01-1970'',''dd-mm-yyyy'')) * (1000 * 60 * 60 * 24) FROM DUAL) IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --ID_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''ID_NOTIF'' IRG_CLAVE, '|| V_TAR_ID ||' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --DESCRIPCION_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''DESCRIPCION_NOTIF'' IRG_CLAVE, '''|| pDESCRIPCION ||''|| V_NUM_ACT ||''' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --ASUNTO_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''ASUNTO_NOTIF'' IRG_CLAVE, '''|| pDESCRIPCION ||''|| V_NUM_ACT ||''' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --DESTINATARIO_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''DESTINATARIO_NOTIF'' IRG_CLAVE, '''|| V_DESTINATARIO ||''' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

        --EMISOR_NOTIF
        V_MSQL := '
            INSERT INTO '|| V_ESQUEMA ||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE
                                            ,IRG_VALOR, VERSION, USUARIOCREAR, FECHACREAR)
            SELECT '|| V_ESQUEMA ||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL IRG_ID, '|| V_REG_ID ||' REG_ID
                                            ,''EMISOR_NOTIF'' IRG_CLAVE, '''|| pUSUARIOMODIFICAR ||''' IRG_VALOR
                                            ,0 VERSION, '''|| pUSUARIOMODIFICAR ||''' USUARIOCREAR
                                            ,SYSDATE FECHACREAR
            FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;

    COMMIT;

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

	END SP_CREAR_AVISO;

	
/

EXIT;
