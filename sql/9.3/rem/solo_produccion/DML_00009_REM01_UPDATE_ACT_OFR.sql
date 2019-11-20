--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5683
--## PRODUCTO=NO
--## 
--## Finalidad: INSERT OR UPDATE ACT_OFR
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5683'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    OFR_NUM_OFERTA NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('90224213','7072572','17833.40','33.40'),
			T_JBV('90226896','6868011','15000','50'),
			T_JBV('90226755','6858614','20000','50')
	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_OFR');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(2));

	OFR_NUM_OFERTA := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;

	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||OFR_NUM_OFERTA;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_2;
	
	IF V_NUM_FILAS = 1 AND V_NUM_FILAS_2 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_OFR 
				   SET ACT_OFR_IMPORTE = '||V_TMP_JBV(3)||' ,
				   OFR_ACT_PORCEN_PARTICIPACION = '||V_TMP_JBV(4)||' 
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||OFR_NUM_OFERTA||')';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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
