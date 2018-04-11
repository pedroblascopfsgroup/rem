--/*
--##########################################
--## AUTOR=Adrian Daniel Casiean 
--## FECHA_CREACION=20180314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMNIVUNO-475
--## PRODUCTO=NO
--##
--## Finalidad: Pasar activos judiciales a no judiciales
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA2 VARCHAR2(27 CHAR) := 'ACT_ADN_ADJNOJUDICIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMNIVUNO-475';
	V_ACT_ID_HAYA VARCHAR2(32 CHAR);
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--INICIO DATOS
		T_TIPO_DATA( '6963982' ),
		T_TIPO_DATA( '6963983' ),
		T_TIPO_DATA( '6963984' ),
		T_TIPO_DATA( '6964194' ),
		T_TIPO_DATA( '6964195' ),
		T_TIPO_DATA( '6964221' ),
		T_TIPO_DATA( '6964222' ),
		T_TIPO_DATA( '6964225' )


	--FIN DATOS	
	  );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
 BEGIN
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
        V_ACT_ID_HAYA := V_TMP_TIPO_DATA(1);
        
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||'' INTO V_COUNT;
        
		IF V_COUNT = 1 THEN
			
			
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||' AND DD_TTA_ID = (SELECT DD_TTA_ID FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = ''02'')' INTO V_COUNT;
		IF V_COUNT = 0 THEN
		
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
			  DD_TTA_ID = (SELECT DD_TTA_ID FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = ''02'')
			, USUARIOMODIFICAR = '''||V_USUARIO||'''
			, FECHAMODIFICAR = SYSDATE
			WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||'';
		
			EXECUTE IMMEDIATE V_SQL;
			
		END IF;
		
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||' AND DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO WHERE DD_STA_CODIGO = ''04'')' INTO V_COUNT;
		IF V_COUNT = 0 THEN
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
			   DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO WHERE DD_STA_CODIGO = ''04'')
	 		 , USUARIOMODIFICAR = '''||V_USUARIO||'''
			 , FECHAMODIFICAR = SYSDATE
			 WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||'';

			EXECUTE IMMEDIATE V_SQL;
		END IF;
		
			V_SQL :=  'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA2||' WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||')';
		
			EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
			IF V_COUNT = 0 THEN
		
				V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA2||' (
				  ADN_ID
				, ACT_ID
				, USUARIOCREAR
				, FECHACREAR
				) VALUES (
				  S_'||V_TABLA2||'.NEXTVAL
				, (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_ACT_ID_HAYA||')
				, '''||V_USUARIO||'''
				, SYSDATE
				)
				';
		
				EXECUTE IMMEDIATE V_SQL;
		  	END IF;
		  END IF;
      END LOOP;

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
END;
/
EXIT;
