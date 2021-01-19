--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-8527
--## PRODUCTO=NO
--##
--## Finalidad: Script que replica los valores de la cartera Apple para la cartera Divarian en la tabla ACT_CFT_CONFIG_TARIFA.
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_DD_SCR VARCHAR2(30 CHAR) := 'DD_SCR_SUBCARTERA'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.
    V_TABLA_DD_CRA VARCHAR2(30 CHAR):='DD_CRA_CARTERA'; --Vble. auxiliar para almacenar el nombre de la tabla diccionario
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8527'; --USUARIOCREAR/USUARIOMODIFICAR
    V_TABLA_DD_TTF VARCHAR2(30 CHAR):='DD_TTF_TIPO_TARIFA';

    V_ID_SCR_APPLE VARCHAR2(20 CHAR);
    V_ID_SCR_1TO1 VARCHAR2(20 CHAR);
    V_ID_CRA_CER NUMBER(16);
    V_ID_CRA_PARTIES NUMBER(16);

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('COMPROBAMOS QUE NO EXISTAN TARIFAS EN DD_TTF_TIPO_TARIFA');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_DD_TTF||' TTF
                WHERE TTF.DD_TTF_CODIGO LIKE ''%TP1-%'' AND BORRADO=0';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
           
        DBMS_OUTPUT.PUT_LINE('RECOGEMOS IDS DE CARTERAS Y SUBCARTERAS');

        V_SQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_CRA||' WHERE DD_CRA_CODIGO = ''07'' AND BORRADO=0';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_CRA_CER;

        V_SQL := 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_CRA||' WHERE DD_CRA_CODIGO = ''11'' AND BORRADO=0 ';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_CRA_PARTIES;


        V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SCR||' WHERE DD_SCR_CODIGO = ''138'' AND BORRADO=0';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_APPLE;    
        
        
        V_SQL := 'SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_SCR||' WHERE DD_SCR_CODIGO = ''68'' AND BORRADO=0';
        EXECUTE IMMEDIATE V_SQL INTO V_ID_SCR_1TO1;
        
        IF V_ID_CRA_CER IS NOT NULL AND V_ID_CRA_PARTIES IS NOT NULL AND V_ID_SCR_APPLE IS NOT NULL AND V_ID_SCR_1TO1 IS NOT NULL THEN
        

            DBMS_OUTPUT.PUT_LINE('[INFO]: COMIENZA PROCESO DE REPLICAR DATOS DE APPLE PARA SUBCARTERA 1 TO 1 ');
            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EN TABLA '||V_TABLA_DD_TTF||' ');

        --INSERTAR TARIFAS EN DD_TTF_TIPO_TARIFA
            V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_DD_TTF||'(DD_TTF_ID, DD_TTF_CODIGO, 
                    DD_TTF_DESCRIPCION,DD_TTF_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR)
                    SELECT S_'||V_TABLA_DD_TTF||'.NEXTVAL,DD_TTF_CODIGO,DD_TTF_DESCRIPCION,DD_TTF_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR FROM
                    (
                        SELECT DISTINCT REPLACE(TTF.DD_TTF_CODIGO,''AP'',''TP1'') AS DD_TTF_CODIGO,TTF.DD_TTF_DESCRIPCION,TTF.DD_TTF_DESCRIPCION_LARGA,'''||V_USUARIO||''' AS USUARIOCREAR,SYSDATE AS FECHACREAR
                        FROM '||V_ESQUEMA||'.'||V_TABLA_DD_TTF||' TTF
                        JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CFT ON TTF.DD_TTF_ID=CFT.DD_TTF_ID
                        WHERE CFT.DD_CRA_ID='||V_ID_CRA_CER||' 
                        AND CFT.DD_SCR_ID='||V_ID_SCR_APPLE||'
                        AND TTF.BORRADO=0
                        AND CFT.BORRADO=0
                        AND TTF.DD_TTF_CODIGO LIKE ''AP%''
                    )
                    ';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS EN: '||V_TABLA_DD_TTF||' -- '||SQL%ROWCOUNT||' REGISTROS CORRECTAMENTE ');

            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EN TABLA '||V_TEXT_TABLA||' ');

        --INSERTAR CONFIGURACION TARIFAS EN ACT_CFT_CONFIG_TARIFA
            V_SQL :='INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, 
                        DD_CRA_ID, CFT_PRECIO_UNITARIO,	CFT_UNIDAD_MEDIDA, USUARIOCREAR,
                        FECHACREAR, PVE_ID, DD_SCR_ID)
                        SELECT S_'||V_TEXT_TABLA||'.NEXTVAL,
                        (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.'||V_TABLA_DD_TTF||' WHERE DD_TTF_CODIGO=REPLACE(TTF.DD_TTF_CODIGO,''AP'',''TP1'')),
                        CFT.DD_TTR_ID,
                        CFT.DD_STR_ID,
                        '||V_ID_CRA_PARTIES||',
                        CFT.CFT_PRECIO_UNITARIO,
                        CFT.CFT_UNIDAD_MEDIDA,
                        '''||V_USUARIO||''',
                        SYSDATE,
                        CFT.PVE_ID,
                        '||V_ID_SCR_1TO1||'
                        FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CFT
                        JOIN '||V_ESQUEMA||'.'||V_TABLA_DD_TTF||' TTF ON TTF.DD_TTF_ID=CFT.DD_TTF_ID
                        WHERE CFT.DD_CRA_ID='||V_ID_CRA_CER||' AND CFT.DD_SCR_ID='||V_ID_SCR_APPLE||' AND CFT.BORRADO=0 AND TTF.BORRADO=0
                        AND TTF.DD_TTF_CODIGO LIKE ''AP%''
                        ';
            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS EN: '||V_TEXT_TABLA||' -- '||SQL%ROWCOUNT||' REGISTROS CORRECTAMENTE ');
                        
            DBMS_OUTPUT.PUT_LINE('[FIN] FINALIZADO LA INSERCCION DE TARIFAS DE APPLE A SUBCARTERA 1 TO 1');

        ELSE
            DBMS_OUTPUT.PUT_LINE('[FIN] NO SE HA PODIDO OBTENER EL ID DE UNA CARTERA O SUBCARTERA');

        END IF;

    ELSE
        DBMS_OUTPUT.PUT_LINE('[FIN] YA EXISTEN TARIFAS EN '||V_TABLA_DD_TTF||' CON CODIGO THIRD1-, NO SE REALIZA NINGUNA ACCION');
    END IF;

    COMMIT;
   

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
