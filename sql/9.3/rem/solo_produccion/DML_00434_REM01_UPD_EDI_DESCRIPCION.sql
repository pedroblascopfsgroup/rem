--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7971
--## PRODUCTO=NO
--## 
--## Finalidad: PONER DESCRIPCION DE EDIFICIO EN TABLA TEMPORAL Y ACTUALIZAR CON INFO DE TABLA AUX
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-7971';
    V_COUNT NUMBER(16):= 0;
    V_KOUNT NUMBER(16):= 0;
    V_VALIDATOR NUMBER(16); -- Longitud de la cadena total
    V_EXTRA_CHAR NUMBER(16):= 0; -- Cantidad de caracteres a eliminar
    V_EDI_ID NUMBER(16);

    V_TEXT VARCHAR(100 CHAR):= '*Oferta válida para contratos formalizados entre el 15 de agosto y el 15 de septiembre de 2020';
    V_TEXT_1 VARCHAR(120 CHAR):= 'Celebra tu regreso de las vacaciones. ¡Alquila tu hogar y disfruta de UN MES GRATIS hasta el 15 de septiembre!';
    V_TEXT_2 VARCHAR(120 CHAR):= 'Celebra tu regreso de las vacaciones. ¡Alquila tu hogar y consigue DOS MESES GRATIS hasta el 15 de septiembre!';
    
    CURSOR ACTIVOS IS 
        SELECT ACT_NUM
        FROM REM01.AUX_REMVIP_7971;

    FILA ACTIVOS%ROWTYPE;
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
      
    OPEN ACTIVOS;
    
    V_COUNT := 0;
    
    LOOP
        FETCH ACTIVOS INTO FILA;
        EXIT WHEN ACTIVOS%NOTFOUND;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.AUX_REMVIP_7971
                    WHERE ACT_DESC LIKE ''%UN MES%'' AND ACT_NUM = '||FILA.ACT_NUM||'';

        EXECUTE IMMEDIATE V_MSQL INTO V_KOUNT;

        IF V_KOUNT = 1 THEN 

            --MODIFICAMOS DESC EN LA TABLA AUXILIAR
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_REMVIP_7971
                        SET ACT_DESC = '''||V_TEXT_1||'''
                        WHERE ACT_DESC LIKE ''%UN MES%'' AND ACT_NUM = '||FILA.ACT_NUM||'';

            EXECUTE IMMEDIATE V_MSQL;

        ELSE

            --MODIFICAMOS DESC EN LA TABLA AUXILIAR
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.AUX_REMVIP_7971
                        SET ACT_DESC = '''||V_TEXT_2||'''
                        WHERE ACT_DESC LIKE ''%DOS MESES%'' AND ACT_NUM = '||FILA.ACT_NUM||'';

            EXECUTE IMMEDIATE V_MSQL;
    
        END IF;

    COMMIT;

    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.act_activo act
                join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id
                join '||V_ESQUEMA||'.act_edi_edificio edi on ico.ico_id = edi.ico_id
                where (edi.edi_descripcion not like ''%Celebra tu regreso de las vacaciones.%'' or edi.edi_descripcion is null)
                and act.act_num_activo = '||FILA.ACT_NUM||' AND ACT.BORRADO = 0';

	EXECUTE IMMEDIATE V_MSQL INTO V_KOUNT;

    IF V_KOUNT = 1 THEN
    
        --INICIALIZAMOS EDI_ID
        V_MSQL := 'SELECT EDI.EDI_ID FROM '||V_ESQUEMA||'.act_activo act
                    join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id
                    join '||V_ESQUEMA||'.act_edi_edificio edi on ico.ico_id = edi.ico_id
                    where act.act_num_activo = '||FILA.ACT_NUM||' AND ACT.BORRADO = 0';

        EXECUTE IMMEDIATE V_MSQL INTO V_EDI_ID;

        --INSERTAMOS DESCRIPCION EN LA TABLA TEMPORAL
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_REMVIP_7971
                (EDI_ID,EDI_DESCRIPCION) VALUES (
                '||V_EDI_ID||',
                (SELECT EDI_DESCRIPCION FROM '||V_ESQUEMA||'.ACT_EDI_EDIFICIO WHERE EDI_ID = '||V_EDI_ID||'))';

        EXECUTE IMMEDIATE V_MSQL;

        --COMPROBAMOS LONGITUD DEL CAMPO A INTRODUCIR
        V_MSQL := 'SELECT LENGTH(
                        CONCAT(
                            CONCAT((SELECT ACT_DESC FROM '||V_ESQUEMA||'.AUX_REMVIP_7971 WHERE ACT_NUM = '||FILA.ACT_NUM||'), 
                            (SELECT EDI_DESCRIPCION FROM '||V_ESQUEMA||'.TMP_REMVIP_7971 WHERE EDI_ID = '||V_EDI_ID||')), 
                        '''||V_TEXT||''')
                    ) FROM DUAL';

        EXECUTE IMMEDIATE V_MSQL INTO V_VALIDATOR;

            V_EXTRA_CHAR := 0;
            
            IF V_VALIDATOR > 3000 THEN

                V_MSQL := 'SELECT LENGTH(EDI_DESCRIPCION) FROM '||V_ESQUEMA||'.TMP_REMVIP_7971 WHERE EDI_ID = '||V_EDI_ID||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXTRA_CHAR;

                V_EXTRA_CHAR := V_EXTRA_CHAR - (V_VALIDATOR - 3000);

                -- ACTUALIZAMOS DESCRIPCION CON VALOR DE TABLA AUX 
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_EDI_EDIFICIO
                    SET EDI_DESCRIPCION = CONCAT(
                                                CONCAT((SELECT ACT_DESC FROM '||V_ESQUEMA||'.AUX_REMVIP_7971 WHERE ACT_NUM = '||FILA.ACT_NUM||'),
                                                (SELECT SUBSTR(EDI_DESCRIPCION,0,'||V_EXTRA_CHAR||') FROM '||V_ESQUEMA||'.TMP_REMVIP_7971 WHERE EDI_ID = '||V_EDI_ID||')),
                                        '''||V_TEXT||'''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE 
                    WHERE EDI_ID = '||V_EDI_ID||' AND BORRADO = 0';				
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');

            ELSE
            
                -- ACTUALIZAMOS DESCRIPCION CON VALOR DE TABLA AUX 
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_EDI_EDIFICIO
                    SET EDI_DESCRIPCION = CONCAT(
                                                CONCAT((SELECT ACT_DESC FROM '||V_ESQUEMA||'.AUX_REMVIP_7971 WHERE ACT_NUM = '||FILA.ACT_NUM||'),
                                                (SELECT EDI_DESCRIPCION FROM '||V_ESQUEMA||'.TMP_REMVIP_7971 WHERE EDI_ID = '||V_EDI_ID||')),
                                        '''||V_TEXT||'''),
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE 
                    WHERE EDI_ID = '||V_EDI_ID||' AND BORRADO = 0';				
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');
            
            END IF;

    END IF;
        V_COUNT := V_COUNT + 1;

    END LOOP;
     
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se han iterado con '||V_COUNT||' activos de AUX_REMVIP_7971');
    CLOSE ACTIVOS;
     
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
EXIT;