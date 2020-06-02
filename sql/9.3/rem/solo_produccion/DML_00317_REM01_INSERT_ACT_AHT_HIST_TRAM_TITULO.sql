--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200527
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7237
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Actualizar fecha de presentación historico
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7237';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'ACT_AHT_HIST_TRAM_TITULO'; -- Variable para tabla.
	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_ACT_ID NUMBER(16); -- Vble. para almacenar el id del activo.
	V_TIT_ID NUMBER(16); -- Vble. para almacenar el id del titulo.

    TYPE T_TITULO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_TITULOS IS TABLE OF T_TITULO;
    V_TITULOS T_ARRAY_TITULOS := T_ARRAY_TITULOS(        
            --NUM_ACTIVO	FECHA_REGISTRO	FECHA_INSCRIPCION	ESTADO_PRESENTACION
        T_TITULO('7227056'),
	T_TITULO('7227111'),
	T_TITULO('7227067'),
	T_TITULO('7227063'),
	T_TITULO('7227110'),
	T_TITULO('7227098'),
	T_TITULO('7227084'),
	T_TITULO('7227123'),
	T_TITULO('7227065'),
	T_TITULO('7227132'),
	T_TITULO('7227070'),
	T_TITULO('7227049'),
	T_TITULO('7227069'),
	T_TITULO('7227116'),
	T_TITULO('7227057'),
	T_TITULO('7227118'),
	T_TITULO('7227089'),
	T_TITULO('7227120'),
	T_TITULO('7227047'),
	T_TITULO('7227052'),
	T_TITULO('7227115'),
	T_TITULO('7227128'),
	T_TITULO('7227133'),
	T_TITULO('7227108'),
	T_TITULO('7227079'),
	T_TITULO('7227113'),
	T_TITULO('7227124'),
	T_TITULO('7227060'),
	T_TITULO('7227086'),
	T_TITULO('7227076'),
	T_TITULO('7227121'),
	T_TITULO('7227103'),
	T_TITULO('7227055'),
	T_TITULO('7227087'),
	T_TITULO('7227085'),
	T_TITULO('7227130'),
	T_TITULO('7227077'),
	T_TITULO('7227064'),
	T_TITULO('7227122'),
	T_TITULO('7227100'),
	T_TITULO('7227125'),
	T_TITULO('7227075'),
	T_TITULO('7227088'),
	T_TITULO('7227101'),
	T_TITULO('7227096'),
	T_TITULO('7227081'),
	T_TITULO('7227050'),
	T_TITULO('7227058'),
	T_TITULO('7227104'),
	T_TITULO('7227099'),
	T_TITULO('7227112'),
	T_TITULO('7227135'),
	T_TITULO('7227117'),
	T_TITULO('7227054'),
	T_TITULO('7227107'),
	T_TITULO('7227074'),
	T_TITULO('7227078'),
	T_TITULO('7227126'),
	T_TITULO('7227080'),
	T_TITULO('7227097'),
	T_TITULO('7227053'),
	T_TITULO('7227048'),
	T_TITULO('7227092'),
	T_TITULO('7227129'),
	T_TITULO('7227061'),
	T_TITULO('7227062'),
	T_TITULO('7227134'),
	T_TITULO('7227068'),
	T_TITULO('7227093'),
	T_TITULO('7227131'),
	T_TITULO('7227105'),
	T_TITULO('7227059'),
	T_TITULO('7227095'),
	T_TITULO('7227102'),
	T_TITULO('7227082'),
	T_TITULO('7227114'),
	T_TITULO('7227127'),
	T_TITULO('7227071'),
	T_TITULO('7227073'),
	T_TITULO('7227090'),
	T_TITULO('7227091'),
	T_TITULO('7227109'),
	T_TITULO('7227051'),
	T_TITULO('7227072'),
	T_TITULO('7227066'),
	T_TITULO('7227094'),
	T_TITULO('7227106'),
	T_TITULO('7227083'),
	T_TITULO('7227119')
  
    );
    
    V_TMP_TITULO T_TITULO;

BEGIN

    FOR I IN V_TITULOS.FIRST .. V_TITULOS.LAST

    LOOP
        V_TMP_TITULO := V_TITULOS(I);


        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas para el activo  '||TRIM(V_TMP_TITULO(1)));
        
        V_SQL := 'SELECT ACT_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO
		WHERE ACT_NUM_ACTIVO  = '||TRIM(V_TMP_TITULO(1))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;
        
        V_SQL := 'SELECT TIT_ID
		FROM '||V_ESQUEMA||'.ACT_TIT_TITULO
		WHERE  ACT_ID = '||V_ACT_ID||'
		AND BORRADO = 0';
	
	    EXECUTE IMMEDIATE V_SQL INTO V_TIT_ID;        
       	
	    IF V_TIT_ID IS NOT NULL THEN       
	    
		    V_SQL := 	'SELECT COUNT(*)
				FROM '||V_ESQUEMA||'.'||V_TABLA||'
				WHERE TIT_ID = '||V_TIT_ID||'
				AND BORRADO = 0';
	
	        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;
	
	        IF V_EXISTE_REGISTRO = 0 THEN
	
		        V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'	(
										AHT_ID,
										TIT_ID,
										AHT_FECHA_PRES_REGISTRO,
										AHT_FECHA_INSCRIPCION,
										DD_ESP_ID,
										USUARIOCREAR,
										FECHACREAR,
										BORRADO)
	 								SELECT 
										'|| V_ESQUEMA ||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
										'||V_TIT_ID||',
										TO_DATE(''01/01/1900'', ''DD/MM/YYYY''),
										TO_DATE(''10/10/2019'', ''DD/MM/YYYY''),
										(SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO  = ''03''),
										'''||V_USUARIO||''',
										SYSDATE,
										0
	                        		FROM DUAL';                          
	
	            EXECUTE IMMEDIATE V_SQL;            
	            DBMS_OUTPUT.PUT_LINE('[INFO] Registro procesado correctamente.');
	            
	        ELSE
	            DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya tiene entradas en el histórico.');
		      END IF;
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro de titulo no encontrado.');
            
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso finalizado.');
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
