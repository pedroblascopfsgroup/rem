--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8763
--## PRODUCTO=NO
--## 
--## Finalidad: Poner activos en Publicado venta
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8763';

    V_ID NUMBER(16); -- Vble. para el id del activo

    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ICO_INFO_COMERCIAL';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    V_NUM_ACTIVO VARCHAR2(100 CHAR):='7432249';

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
        DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS SI EXISTE EL ACTIVO '''||V_NUM_ACTIVO||''' ');
        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID=ACT.ACT_ID WHERE ACT.ACT_NUM_ACTIVO = '''||V_NUM_ACTIVO||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] OBTENEMOS IDS ');

            --Obtenemos el ID del informe comercial
            V_MSQL := 'SELECT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICO ON ICO.ACT_ID=ACT.ACT_ID WHERE ACT.ACT_NUM_ACTIVO = '''||V_NUM_ACTIVO||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Actualizamos el tipo de informe comercial
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
               DD_TIC_ID=(SELECT DD_TIC_ID FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL WHERE DD_TIC_CODIGO=''01''),
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
               FECHAMODIFICAR = SYSDATE
               WHERE ICO_ID = '||V_ID||'';

            EXECUTE IMMEDIATE V_MSQL;         
            
             DBMS_OUTPUT.PUT_LINE('[INFO] Modificacion realizada correctamente ');
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_NUM_ACTIVO||''' ');

        END IF;

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
EXIT;