--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8121
--## PRODUCTO=NO
--## 
--## Finalidad: PONER DESCRIPCION DE EDIFICIO EN TABLA TEMPORAL Y ACTUALIZAR 
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-8121';

    V_TEXT VARCHAR(1000 CHAR):= 'Actualmente, tras la actualización de fecha 15/09/2020 del índex de referència de preus de lloguer de la Agència de l''''Habitatge de Catalunya, estamos en proceso de revisión del índice aplicable a esta vivienda. Asimismo, también estamos en proceso de revisión del resto de requisitos previstos en la Ley 11/2020, de 18 de septiembre, de medidas urgentes en materia de contención de rentas en los contratos de arrendamiento de vivienda y modificación de la Ley 18/2007, la Ley 24/2015 y la Ley 4/2016, relativas a la protección del derecho a la vivienda publicada en el BOC el 21 de septiembre de 2020 y que entró en vigor el 22 de septiembre de 2020. En todo caso, se facilitará el dato del índice aplicable y se cumplirá con todo lo previsto en la referida norma a la mayor brevedad y en todo caso con carácter previo a la suscripción del correspondiente documento de reserva o del contrato de arrendamiento';
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
      
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_REMVIP_8121 T1 USING (
                SELECT EDI.EDI_ID, EDI.EDI_DESCRIPCION FROM '||V_ESQUEMA||'.act_activo act
                join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id 
                join '||V_ESQUEMA||'.act_edi_edificio edi on ico.ico_id = edi.ico_id AND EDI.BORRADO = 0
                JOIN '||V_ESQUEMA||'.AUX_REMVIP_8121 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
                WHERE ACT.BORRADO = 0
            ) T2
            ON (T1.EDI_ID = T2.EDI_ID)
            WHEN NOT MATCHED THEN
            INSERT (EDI_ID, EDI_DESCRIPCION) VALUES (T2.EDI_ID, T2.EDI_DESCRIPCION)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros ');

    COMMIT;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO T1 USING (
                SELECT EDI_ID, EDI_DESCRIPCION FROM '||V_ESQUEMA||'.TMP_REMVIP_8121
                ) T2
            ON (T1.EDI_ID = T2.EDI_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.EDI_DESCRIPCION = CONCAT(T2.EDI_DESCRIPCION, '''||V_TEXT||'''),
            T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');
    
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