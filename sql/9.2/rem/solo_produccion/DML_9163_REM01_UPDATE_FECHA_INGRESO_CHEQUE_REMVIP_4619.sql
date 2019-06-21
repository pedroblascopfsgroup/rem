--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4619
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4619';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_RECOVERY_ID_MALO NUMBER(16);
    ACT_RECOVERY_ID_BUENO NUMBER(16);
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
 	TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

 	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('171179','06/06/19'),
		T_JBV('171180','06/06/19'),
		T_JBV('171181','06/06/19'),
		T_JBV('171182','06/06/19'),
		T_JBV('171183','06/06/19'),
		T_JBV('171185','06/06/19'),
		T_JBV('171187','06/06/19'),
		T_JBV('171188','06/06/19'),
		T_JBV('171190','06/06/19'),
		T_JBV('171191','06/06/19'),
		T_JBV('171192','06/06/19'),
		T_JBV('171195','06/06/19'),
		T_JBV('171198','06/06/19'),
		T_JBV('171199','06/06/19'),
		T_JBV('171201','06/06/19'),
		T_JBV('171202','06/06/19'),
		T_JBV('171203','06/06/19'),
		T_JBV('171204','06/06/19'),
		T_JBV('171205','06/06/19'),
		T_JBV('171206','06/06/19'),
		T_JBV('171207','06/06/19'),
		T_JBV('171208','06/06/19'),
		T_JBV('171225','06/06/19'),
		T_JBV('171226','06/06/19'),
		T_JBV('171228','06/06/19'),
		T_JBV('171229','06/06/19'),
		T_JBV('171230','06/06/19'),
		T_JBV('171232','06/06/19'),
		T_JBV('171233','06/06/19'),
		T_JBV('171234','06/06/19'),
		T_JBV('171236','06/06/19'),
		T_JBV('171238','06/06/19'),
		T_JBV('171239','06/06/19'),
		T_JBV('171240','06/06/19'),
		T_JBV('171243','06/06/19'),
		T_JBV('171244','06/06/19'),
		T_JBV('171246','06/06/19'),
		T_JBV('171247','06/06/19'),
		T_JBV('171248','06/06/19'),
		T_JBV('171249','06/06/19'),
		T_JBV('171250','06/06/19'),
		T_JBV('171251','06/06/19'),
		T_JBV('171252','06/06/19'),
		T_JBV('171253','06/06/19'),
		T_JBV('171255','06/06/19'),
		T_JBV('171258','06/06/19'),
		T_JBV('171259','06/06/19'),
		T_JBV('171260','06/06/19'),
		T_JBV('171262','06/06/19'),
		T_JBV('171263','06/06/19'),
		T_JBV('171265','06/06/19'),
		T_JBV('171266','06/06/19'),
		T_JBV('171267','06/06/19'),
		T_JBV('171268','06/06/19'),
		T_JBV('171269','06/06/19'),
		T_JBV('171270','06/06/19'),
		T_JBV('171271','06/06/19'),
		T_JBV('171177','06/06/19'),
		T_JBV('171178','06/06/19')
	 	);   
    V_TMP_JBV T_JBV;
    
    
 BEGIN
 
 FOR I IN V_JBV.FIRST .. V_JBV.LAST
 LOOP
    V_TMP_JBV := V_JBV(I);

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_TMP_JBV(1)||'';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 = 1 THEN
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
					ECO_FECHA_CONT_PROPIETARIO = TO_DATE('''||V_TMP_JBV(2)||''',''DD/MM/RR''),
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE 
				WHERE ECO_NUM_EXPEDIENTE = '||V_TMP_JBV(1)||'';	  
	
	  EXECUTE IMMEDIATE V_SQL;
	  
	  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el expediente '||V_TMP_JBV(1)||'');
	  
	  V_COUNT_INSERT := V_COUNT_INSERT + 1;

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
  
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);
  
 COMMIT;
 
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

