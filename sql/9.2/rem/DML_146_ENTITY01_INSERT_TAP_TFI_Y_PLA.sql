--/*
--##########################################
--## AUTOR=Juan Torrella
--## FECHA_CREACION=20191021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7986
--## PRODUCTO=SI
--##
--## Finalidad: 
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO T013_PBCReserva ----------------------------

  EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'' ' INTO V_COUNT;

    IF V_COUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [TAP_TAREA_PROCEDIMIENTO] ');
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
    VALUES(
            '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL 
            ,(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO LIKE ''%T013%'') 
            ,''T013_PBCReserva'' 
            ,null 
            ,null
            ,null
            ,''valores[''''T013_PBCReserva''''][''''comboRespuesta''''] == DDApruebaDeniega.CODIGO_APRUEBA ? ''''Aprueba'''' :  ''''Deniega'''' '' 
            ,null  
            ,''0''  
            ,''PBC Reserva'' 
            ,''0''
            ,''HREOS-7986''
            ,SYSDATE
            ,null 
            ,null 
            ,null 
            ,null 
            ,''0'' 
            , null 
            , null
            , null
            , ''0'' 
            ,''EXTTareaProcedimiento'' 
            ,''3''
            , (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GFORM'') 
            , (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''811'') 
            ,null
            ,null
            ,null
        )';
	EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('INSERCION EN [TAP_TAREA_PROCEDIMIENTO] CORRECTA');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO]');
    END IF;

    --UPDATE TAP_TAREA DefinicionOferta (Modificación decisión)
    DBMS_OUTPUT.PUT_LINE('UPDATE DE LA TAREA Definición oferta');
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
            SET TAP_SCRIPT_DECISION = ''checkFormalizacion() ? valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? checkAtribuciones() ? checkReserva() == false ? esYubai() ? ''''esYubai'''': ''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''' : esYubai() ? ''''esYubai'''': 
esOmega()  ? ''''esOmegaConReserva'''' :  ''''ConFormalizacionSinTanteoConAtribucionConReserva'''' : ''''ConFormalizacionSinTanteoSinAtribucion''''  : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''SinFormalizacion''''''
            , USUARIOMODIFICAR = ''HREOS-7986''
            , FECHAMODIFICAR = SYSDATE
            WHERE TAP_CODIGO = ''T013_DefinicionOferta''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando decisión tarea T013_DefinicionOferta');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;


--INSERT TFI_TAREA_FORMS_ITEMS
 
   DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [TFI_TAREAS_FORM_ITEMS] ');
    EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'') ' INTO V_COUNT;

    IF V_COUNT = 0 THEN
    	V_MSQL := ' INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
                VALUES (
                        '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
                        ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'')
                        ,  0
                        , ''label''  , ''titulo''   , ''"<p style="margin-bottom: 10px">En la presente tarea deberá reflejar si se ha aprobado el proceso de PBC de la reserva.</p> <p style="margin-bottom: 10px">Si no se ha aprobado, el expediente quedará anulado, finalizándose el trámite</p> <p style="margin-bottom: 10px"> Si se ha aprobado, se lanzará al gestor la tarea de "instrucciones de reserva"</p> <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite</p>"''
                        , null , null  , null , null  , 1 , ''HREOS-7986'', SYSDATE , null, null, null , null  , 0)';
        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE('INSERTADO PRIMER CAMPO');

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
                    VALUES (
                        '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
                        ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'')
                        ,  1, ''comboboxinicial''  , ''comboRespuesta'' , ''Respuesta'' , null , null  
                        , null , null  , 1 , ''HREOS-7986'', SYSDATE , null, null, null , null  , 0
                    )';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('INSERTADO SEGUNDO CAMPO');

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
                    VALUES (
                        '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
                        ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'')
                        ,  2, ''textarea''  , ''observaciones'' , ''Observaciones'' , null , null  
                        , null , null  , 1 , ''HREOS-7986'', SYSDATE , null, null, null , null  , 0
                    )';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('INSERTADO TERCER CAMPO');

        DBMS_OUTPUT.PUT_LINE('INSERCION EN [TFI_TAREAS_FORM_ITEMS] CORRECTA');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TFI_TAREAS_FORM_ITEMS]');
    END IF;

--INSERT DD_PTP_PLAZOS_TAREAS_PLAZAS T013_PBCReserva ----------------------------
    DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] ');
    EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'') ' INTO V_COUNT;

    IF V_COUNT = 0 THEN
        V_MSQL := ' INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
            VALUES (
                '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL
                ,null ,null
                ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PBCReserva'')
                ,''3*24*60*60*1000L''
                ,0
                ,''HREOS-7986''
                ,SYSDATE
                , null,null,null,null
                ,0
                ,0
                ,null
            )';
        EXECUTE IMMEDIATE V_MSQL;
        
        DBMS_OUTPUT.PUT_LINE(' INSERCION EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] CORRECTA');
    ELSE
        DBMS_OUTPUT.PUT_LINE(' LA FILA YA EXISE EN [DD_PTP_PLAZOS_TAREAS_PLAZAS]');
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
   			

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
