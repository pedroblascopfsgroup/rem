--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8894
--## PRODUCTO=NO
--## 
--## Finalidad: Reasignar tareas Informe Comercial
--##            
--## INSTRUCCIONES:  
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
    V_TABLA VARCHAR2(25 CHAR):= '';
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-8894';
    ACT_NUM_ACTIVO NUMBER(16);
	TPO_ID NUMBER(16);
    ACT_ID NUMBER(16);
	TRA_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('6036085','mpascuall'),
			T_TIPO_DATA('6078593','mpascuall'),
			T_TIPO_DATA('6078881','mpascuall'),
			T_TIPO_DATA('6079180','mpascuall'),
			T_TIPO_DATA('6082919','mpascuall'),
			T_TIPO_DATA('6083073','mpascuall'),
			T_TIPO_DATA('6084057','mpascuall'),
			T_TIPO_DATA('6084058','mpascuall'),
			T_TIPO_DATA('6084059','mpascuall'),
			T_TIPO_DATA('6133601','mpascuall'),
			T_TIPO_DATA('6134012','mpascuall'),
			T_TIPO_DATA('6134396','mpascuall'),
			T_TIPO_DATA('6134739','mpascuall'),
			T_TIPO_DATA('6135732','mpascuall'),
			T_TIPO_DATA('6136003','mpascuall'),
			T_TIPO_DATA('6710904','mpascuall'),
			T_TIPO_DATA('6710912','mpascuall'),
			T_TIPO_DATA('6711013','mpascuall'),
			T_TIPO_DATA('6711114','mpascuall'),
			T_TIPO_DATA('6716381','mpascuall'),
			T_TIPO_DATA('6730611','mpascuall'),
			T_TIPO_DATA('6740669','mpascuall'),
			T_TIPO_DATA('6760736','mpascuall'),
			T_TIPO_DATA('6785326','mpascuall'),
			T_TIPO_DATA('6819184','mpascuall'),
			T_TIPO_DATA('6832988','mpascuall'),
			T_TIPO_DATA('6834661','mpascuall'),
			T_TIPO_DATA('6834665','mpascuall'),
			T_TIPO_DATA('6834672','mpascuall'),
			T_TIPO_DATA('6834740','mpascuall'),
			T_TIPO_DATA('6889114','mpascuall'),
			T_TIPO_DATA('6890840','mpascuall'),
			T_TIPO_DATA('6890917','mpascuall'),
			T_TIPO_DATA('6941089','mpascuall'),
			T_TIPO_DATA('6946678','mpascuall'),
			T_TIPO_DATA('6967626','mpascuall'),
			T_TIPO_DATA('7013301','mpascuall'),
			T_TIPO_DATA('7013302','mpascuall'),
			T_TIPO_DATA('7013303','mpascuall'),
			T_TIPO_DATA('7013307','mpascuall'),
			T_TIPO_DATA('7013310','mpascuall'),
			T_TIPO_DATA('7013311','mpascuall'),
			T_TIPO_DATA('7013312','mpascuall'),
			T_TIPO_DATA('7013313','mpascuall'),
			T_TIPO_DATA('7013315','mpascuall'),
			T_TIPO_DATA('7013316','mpascuall'),
			T_TIPO_DATA('7013317','mpascuall'),
			T_TIPO_DATA('7013318','mpascuall'),
			T_TIPO_DATA('7031346','mpascuall'),
			T_TIPO_DATA('7031972','mpascuall'),
			T_TIPO_DATA('7101666','mpascuall'),
			T_TIPO_DATA('7224014','mpascuall'),
			T_TIPO_DATA('7224016','mpascuall'),
			T_TIPO_DATA('7224017','mpascuall'),
			T_TIPO_DATA('7224018','mpascuall'),
			T_TIPO_DATA('7224021','mpascuall'),
			T_TIPO_DATA('7224022','mpascuall'),
			T_TIPO_DATA('7224041','mpascuall'),
			T_TIPO_DATA('7224043','mpascuall'),
			T_TIPO_DATA('7224051','mpascuall'),
			T_TIPO_DATA('7224054','mpascuall'),
			T_TIPO_DATA('7224059','mpascuall'),
			T_TIPO_DATA('7224063','mpascuall'),
			T_TIPO_DATA('7224068','mpascuall'),
			T_TIPO_DATA('7224074','mpascuall'),
			T_TIPO_DATA('7224083','mpascuall'),
			T_TIPO_DATA('7224087','mpascuall'),
			T_TIPO_DATA('7224088','mpascuall'),
			T_TIPO_DATA('7224090','mpascuall'),
			T_TIPO_DATA('7294818','mpascuall'),
			T_TIPO_DATA('7294945','mpascuall'),
			T_TIPO_DATA('7295252','mpascuall'),
			T_TIPO_DATA('7295256','mpascuall'),
			T_TIPO_DATA('7297715','mpascuall'),
			T_TIPO_DATA('7298206','mpascuall'),
			T_TIPO_DATA('7299226','mpascuall'),
			T_TIPO_DATA('7300310','mpascuall'),
			T_TIPO_DATA('7300313','mpascuall'),
			T_TIPO_DATA('7300323','mpascuall'),
			T_TIPO_DATA('7300329','mpascuall'),
			T_TIPO_DATA('7300993','mpascuall'),
			T_TIPO_DATA('7301022','mpascuall'),
			T_TIPO_DATA('7301995','mpascuall'),
			T_TIPO_DATA('7302367','mpascuall'),
			T_TIPO_DATA('7302473','mpascuall'),
			T_TIPO_DATA('7302583','mpascuall'),
			T_TIPO_DATA('7302584','mpascuall'),
			T_TIPO_DATA('7302586','mpascuall'),
			T_TIPO_DATA('7302590','mpascuall'),
			T_TIPO_DATA('7302598','mpascuall'),
			T_TIPO_DATA('7302601','mpascuall'),
			T_TIPO_DATA('7302908','mpascuall'),
			T_TIPO_DATA('7302910','mpascuall'),
			T_TIPO_DATA('7303202','mpascuall'),
			T_TIPO_DATA('7303500','mpascuall'),
			T_TIPO_DATA('7303549','mpascuall'),
			T_TIPO_DATA('7328454','mpascuall'),
			T_TIPO_DATA('7330470','mpascuall'),
			T_TIPO_DATA('7403021','mpascuall'),
			T_TIPO_DATA('7403404','mpascuall'),
			T_TIPO_DATA('7432283','mpascuall'),
			T_TIPO_DATA('6948268','rdura'),
			T_TIPO_DATA('6948337','rdura'),
			T_TIPO_DATA('6948376','rdura'),
			T_TIPO_DATA('6948549','rdura'),
			T_TIPO_DATA('6948586','rdura'),
			T_TIPO_DATA('6948593','rdura'),
			T_TIPO_DATA('6948624','rdura'),
			T_TIPO_DATA('6949039','rdura'),
			T_TIPO_DATA('6949079','rdura'),
			T_TIPO_DATA('6949302','rdura'),
			T_TIPO_DATA('6949445','rdura'),
			T_TIPO_DATA('6949662','rdura'),
			T_TIPO_DATA('6949708','rdura'),
			T_TIPO_DATA('6949711','rdura'),
			T_TIPO_DATA('7008738','rdura'),
			T_TIPO_DATA('7015153','rdura'),
			T_TIPO_DATA('7030208','rdura')
			
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACIÓN DE TAREAS');

		V_MSQL := 'SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T011''';
		EXECUTE IMMEDIATE V_MSQL INTO TPO_ID;

		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos que existe la tarea activa
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
				 	INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID
					WHERE TAC.ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''')
					AND TAC.BORRADO = 0 AND TRA.DD_TPO_ID = '''||TPO_ID||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

			V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO ACT_ID;

			V_MSQL := 'SELECT TRA_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE ACT_ID = '''||ACT_ID||''' AND DD_TPO_ID = '''||TPO_ID||''' AND TRA_FECHA_FIN IS NULL AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO TRA_ID;
		
			V_MSQL := ' UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET 
						USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(2)||'''),
						USUARIOMODIFICAR = '''||V_USUARIO||''',
						FECHAMODIFICAR = SYSDATE
						WHERE ACT_ID = '''||ACT_ID||''' AND TRA_ID = '''||TRA_ID||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] TAREA DEL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADA.');

		ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE UNA TAREA VIVA DEL TRÁMITE Trámite Aprobación Informe Comercial PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');
        
		END IF;

		END LOOP;

		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
