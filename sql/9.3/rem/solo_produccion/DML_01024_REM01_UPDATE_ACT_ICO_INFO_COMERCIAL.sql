--/*
--###########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210830
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10391
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATE ACT_ICO_INFO_COMERCIAL
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-10391'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
    ACT_NUM_ACTIVO NUMBER(16);
    MEDIADOR_ID NUMBER(16);
    V_ID NUMBER(16):=0;
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	-- ACT_NUM_ACTIVO   ID_INFORME_WEBCOM
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
        T_JBV('7433721','886695'),
        T_JBV('7433777','892937'),
        T_JBV('7433780','872599'),
        T_JBV('7471429','886683'),
        T_JBV('7471431','892941')

	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_ICO_INFO_COMERCIAL');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));

	MEDIADOR_ID := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
    JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID=ACT.ACT_ID AND ICO.BORRADO = 0
    WHERE ACT.BORRADO = 0 AND ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1  THEN

    V_SQL := 'SELECT ICO.ICO_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
    JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID=ACT.ACT_ID AND ICO.BORRADO = 0
    WHERE ACT.BORRADO = 0 AND ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_ID;
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL 
				   SET ICO_WEBCOM_ID = '||MEDIADOR_ID||',
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE ICO_ID = '||V_ID||'';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE REGISTRO');
		
	END IF;
	
	END LOOP;
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han UPDATEADO en total '||V_COUNT_UPDATE||' registros');
 
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