--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8402
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Actualización de CFD_ID por IDs de configuraciones nuevas
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8402'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ADO_ADMISION_DOCUMENTO'; --Vble. auxiliar para almacenar la tabla a insertar

    V_ID_DOCUMENTO_CEDULA NUMBER(16); 
    V_ID_DOCUMENTO_CEE NUMBER(16);
    V_ID_DOCUMENTO_ETIQUETA NUMBER(16);  

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    --Obtenemos el id de cédula de habitabilidad
    V_MSQL := 'SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''13'' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_DOCUMENTO_CEDULA;

    --Obtenemos el id de cee
    V_MSQL := 'SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''11'' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_DOCUMENTO_CEE;

    --Obtenemos el id de etiqueta
    V_MSQL := 'SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''25'' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_ID_DOCUMENTO_ETIQUETA;

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ID DE TIPO DE DOCUMENTO CÉDULA DE HABITABILIDAD ');

    --Actualizamos los registros
    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'|| V_TABLA ||' T1 USING 
			(SELECT ADO.ADO_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID 
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT 
            INNER JOIN '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID
            INNER JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID
            WHERE CFD.BORRADO = 1 AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_CEDULA||') T2
		    ON (T1.ADO_ID = T2.ADO_ID)
		    WHEN MATCHED THEN UPDATE SET 
			T1.CFD_ID = NVL((SELECT CASE WHEN CFD.CFD_ID IS NULL THEN 1 ELSE CFD.CFD_ID END
                        FROM '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD
                        WHERE CFD.DD_TPA_ID = T2.DD_TPA_ID 
                        AND CFD.DD_SAC_ID = T2.DD_SAC_ID 
                        AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_CEDULA||'), 64248),
			T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
			T1.FECHAMODIFICAR = SYSDATE ';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ID DE TIPO DE DOCUMENTO CEE');

    --Actualizamos los registros
    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'|| V_TABLA ||' T1 USING 
			(SELECT ADO.ADO_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID 
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT 
            INNER JOIN '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID
            INNER JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID
            WHERE CFD.BORRADO = 1 AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_CEE||') T2
		    ON (T1.ADO_ID = T2.ADO_ID)
		    WHEN MATCHED THEN UPDATE SET 
			T1.CFD_ID = NVL((SELECT CASE WHEN CFD.CFD_ID IS NULL THEN 1 ELSE CFD.CFD_ID END
                        FROM '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD
                        WHERE CFD.DD_TPA_ID = T2.DD_TPA_ID 
                        AND CFD.DD_SAC_ID = T2.DD_SAC_ID 
                        AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_CEE||'), 64246),
			T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
			T1.FECHAMODIFICAR = SYSDATE ';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros'); 

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ID DE TIPO DE DOCUMENTO ETIQUETA');

    --Actualizamos los registros
    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'|| V_TABLA ||' T1 USING 
			(SELECT ADO.ADO_ID, ACT.DD_TPA_ID, ACT.DD_SAC_ID 
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT 
            INNER JOIN '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO ON ADO.ACT_ID = ACT.ACT_ID
            INNER JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID
            WHERE CFD.BORRADO = 1 AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_ETIQUETA||') T2
		    ON (T1.ADO_ID = T2.ADO_ID)
		    WHEN MATCHED THEN UPDATE SET 
			T1.CFD_ID = NVL((SELECT CASE WHEN CFD.CFD_ID IS NULL THEN 1 ELSE CFD.CFD_ID END
                        FROM '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD
                        WHERE CFD.DD_TPA_ID = T2.DD_TPA_ID 
                        AND CFD.DD_SAC_ID = T2.DD_SAC_ID 
                        AND CFD.DD_TPD_ID = '||V_ID_DOCUMENTO_ETIQUETA||'), 64247),
			T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
			T1.FECHAMODIFICAR = SYSDATE ';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT