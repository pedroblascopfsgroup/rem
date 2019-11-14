--/*
--#########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20191007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7803
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    	V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
   	 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
   		V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    	V_COUNT NUMBER(16); -- Vble. para contar.
    	V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    	V_USUARIO VARCHAR2(32 CHAR):= 'HREOS-7803';
    	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GTP_GES_TRANS_PERMITIDAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    	V_TFP_ID NUMBER(16);
    	V_DD_TPR_ID VARCHAR2(20 CHAR);
   		V_DD_TGE_ID VARCHAR2(20 CHAR);
	
    	TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
		V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
--			DD_TGE_COD
			  T_JBV('GALQ')--Gestor de alquiler
			, T_JBV('SUALQ')--Supervisor de alquiler
			, T_JBV('GSUE')	--Gestor de suelos
			, T_JBV('SUPSUE')--Supervisor de suelos
		); 

		V_TMP_JBV T_JBV;
	BEGIN

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME='''||V_TEXT_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
	DBMS_OUTPUT.PUT_LINE('La tabla  '''||V_TEXT_TABLA||''' no existe');	
	ELSE	
	DBMS_OUTPUT.PUT_LINE('La tabla  '''||V_TEXT_TABLA||''' existe');	

	 FOR I IN V_JBV.FIRST .. V_JBV.LAST
	 LOOP
 
 	V_TMP_JBV := V_JBV(I);

	V_SQL := 'SELECT COUNT(1)  FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TGE_ID =(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO= '''||TRIM(V_TMP_JBV(1))||''')';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
	DBMS_OUTPUT.PUT_LINE('En la  tabla  '||V_TEXT_TABLA||' no existen registros '''||TRIM(V_TMP_JBV(1))||''' que borrar');
	ELSE	
	DBMS_OUTPUT.PUT_LINE('Procedemos a borrar los '||V_COUNT||' registros de '''||TRIM(V_TMP_JBV(1))||''' de la tabla '||V_TEXT_TABLA||'');
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TGE_ID =(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO= '''||TRIM(V_TMP_JBV(1))||''')';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Borrados los '||V_COUNT||' registros de '''||TRIM(V_TMP_JBV(1))||''' en la tabla '||V_TEXT_TABLA||'');
	END IF;
	END LOOP;	
	END IF;
		    
    
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('--------------------------SQLERRM---------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE('--------------------------QUERY-----------------------------');
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

