--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4631
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4631'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_ID NUMBER(16);
    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--ACT_NUM_ACTIVO 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV(6870111),
			T_JBV(6870913),
			T_JBV(6869676),
			T_JBV(6870914),
			T_JBV(6870912),
			T_JBV(6825242),
			T_JBV(7005072),
			T_JBV(6875918),
			T_JBV(6880554),
			T_JBV(6947728),
			T_JBV(6865301),
			T_JBV(6873835),
			T_JBV(6856550),
			T_JBV(6861122),
			T_JBV(6869678),
			T_JBV(6852828),
			T_JBV(6854209),
			T_JBV(7030359),
			T_JBV(7031396),
			T_JBV(7072902),
			T_JBV(6869954),
			T_JBV(6869674),
			T_JBV(7032211),
			T_JBV(7068165),
			T_JBV(7005843),
			T_JBV(7071690),
			T_JBV(6877116),
			T_JBV(7029985),
			T_JBV(6858900),
			T_JBV(6877568),
			T_JBV(6938672),
			T_JBV(6873166),
			T_JBV(6870191),
			T_JBV(6870654),
			T_JBV(202219),
			T_JBV(5943428),
			T_JBV(5970173),
			T_JBV(5965295),
			T_JBV(5951554),
			T_JBV(5965834),
			T_JBV(5951740),
			T_JBV(5965585),
			T_JBV(5954226),
			T_JBV(5944594),
			T_JBV(5966563),
			T_JBV(6133465),
			T_JBV(6991277),
			T_JBV(6990755)
				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACTIVOS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));

	--UPDATE ACT_ACTIVO
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION 
				   SET DD_TCO_ID = 2
				   , USUARIOMODIFICAR = '''||V_USR||''' 
				   , FECHAMODIFICAR = SYSDATE 
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_ID||')';
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_ID||' ACTUALIZADO EN ACT_APU_ACTIVO_PUBLICACION');

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
				   SET DD_TCO_ID = 2
				   , USUARIOMODIFICAR = '''||V_USR||''' 
				   , FECHAMODIFICAR = SYSDATE 
				   WHERE ACT_NUM_ACTIVO = '||ACT_ID||'';
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_ID||' ACTUALIZADO EN ACT_ACTIVO');


		
		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;

	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN ACT_TRA_TRAMITE');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
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
