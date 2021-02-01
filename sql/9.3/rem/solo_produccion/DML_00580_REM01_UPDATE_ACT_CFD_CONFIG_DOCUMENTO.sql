--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8402
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Borrado lógico en configuraciones antiguas
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
    V_TABLA VARCHAR2(100 CHAR) :='ACT_CFD_CONFIG_DOCUMENTO'; --Vble. auxiliar para almacenar la tabla a insertar

    V_ID_DOCUMENTO NUMBER(16); 

    V_COUNT NUMBER(16):=0; --Vble. para contar registros correctos
    V_COUNT_TOTAL NUMBER(16):=0; --Vble para contar registros totales
    
    	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('11'),
            T_TIPO_DATA('25'),
            T_TIPO_DATA('13')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	    LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        
        --Obtenemos el id de la configuración
        V_MSQL := 'SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '||V_TMP_TIPO_DATA(1)||' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID_DOCUMENTO;

        --Actualizamos el registro
        V_MSQL :=   'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
                    BORRADO = 1,
                    USUARIOBORRAR= '''||V_USUARIO||''', 
                    FECHABORRAR = SYSDATE
                    WHERE DD_TPD_ID = '||V_ID_DOCUMENTO||'
                    AND DD_SAC_ID IS NULL';

        EXECUTE IMMEDIATE V_MSQL;

        V_COUNT:=V_COUNT+1;    	

    END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN BORRADO LÓGICAMENTE '''||V_COUNT||''' CONFIGURACIONES ');
    
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