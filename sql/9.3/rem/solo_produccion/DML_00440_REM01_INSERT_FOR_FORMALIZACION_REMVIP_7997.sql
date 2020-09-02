--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200828
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7997
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_TABLA VARCHAR2(27 CHAR) := 'FOR_FORMALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-7997';
    
    V_ECO_ID NUMBER(16); 
    V_OFR_ID NUMBER(16); 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--      	 OFR_NUM_OFERTA
		T_TIPO_DATA(90262971),
		T_TIPO_DATA(90267405),
		T_TIPO_DATA(90261738),
		T_TIPO_DATA(90265028),
		T_TIPO_DATA(90264397),
		T_TIPO_DATA(90266983),
		T_TIPO_DATA(90265829),
		T_TIPO_DATA(90260888),
		T_TIPO_DATA(90267807),
		T_TIPO_DATA(90265030),
		T_TIPO_DATA(90265397),
		T_TIPO_DATA(90263658),
		T_TIPO_DATA(90261775),
		T_TIPO_DATA(90262297),
		T_TIPO_DATA(90260952),
		T_TIPO_DATA(90260743),
		T_TIPO_DATA(90264115)
		 ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

 BEGIN
	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
    	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_COUNT;

		IF V_COUNT > 0	THEN
	
			EXECUTE IMMEDIATE 'SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA  = '''||TRIM(V_TMP_TIPO_DATA(1))||'''' INTO V_OFR_ID;
			EXECUTE IMMEDIATE 'SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID  = '||V_OFR_ID||'' INTO V_ECO_ID;
		
			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ECO_ID  = '||V_ECO_ID||'' INTO V_COUNT;
		
			IF V_COUNT = 0	THEN
		
				V_SQL := '
				INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					FOR_ID,
					ECO_ID,
					FECHACREAR,
					USUARIOCREAR,
					VERSION
					)
					VALUES
					(
					'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,            		 		
					'||V_ECO_ID||',	
					SYSDATE,
					'''||V_USUARIO||''',
					0)'; 
		
				EXECUTE IMMEDIATE V_SQL ;
					
				DBMS_OUTPUT.put_line('[INFO] Se ha insertado num oferta '''||TRIM(V_TMP_TIPO_DATA(1))||''' en '||V_TABLA);
		
			ELSE
		
				DBMS_OUTPUT.put_line('[INFO] num oferta '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');
	
			END IF;
		    
	    ELSE
	
			DBMS_OUTPUT.put_line('[INFO] YA EXISTE REGISTRO');
	
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

