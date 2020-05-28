--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200522
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7345
--## PRODUCTO=NO
--##
--## Finalidad: script para añadior los perfiles que no estan desde la migracion de DIVARIAN
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7345'; -- USUARIOCREAR/USUARIOMODIFICAR.
    FUN_ID NUMBER(16);
    PEF_ID NUMBER(16);

    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--FUN_ID, PEF_ID

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

	T_JBV(1734,443),
	T_JBV(1535,443),
	T_JBV(2285,443),
	T_JBV(2083,443),
	T_JBV(2080,443),
	T_JBV(1970,443),
	T_JBV(2055,443),
	T_JBV(2054,443),
	T_JBV(1985,443),
	T_JBV(1984,443),
	T_JBV(2545,164),
	T_JBV(2042,448),
	T_JBV(2042,446),
	T_JBV(2089,445),
	T_JBV(1965,445),
	T_JBV(2443,209),
	T_JBV(1980,231),
	T_JBV(1484,231),
	T_JBV(1981,231),
	T_JBV(2283,144),
	T_JBV(2100,210),
	T_JBV(2100,215),
	T_JBV(2223,446),
	T_JBV(2100,214),
	T_JBV(2100,209),
	T_JBV(1693,222),
	T_JBV(1693,445),
	T_JBV(1693,233),
	T_JBV(1971,145),
	T_JBV(2286,449),
	T_JBV(1954,449),
	T_JBV(1964,449),
	T_JBV(1831,211),
	T_JBV(2101,211),
	T_JBV(2084,211),
	T_JBV(2083,211),
	T_JBV(2069,211),
	T_JBV(1802,211),
	T_JBV(2063,211),
	T_JBV(2059,211),
	T_JBV(2057,211),
	T_JBV(1790,211),
	T_JBV(1791,211),
	T_JBV(2604,211),
	T_JBV(2603,211),
	T_JBV(2042,211),
	T_JBV(1792,211),
	T_JBV(1793,211),
	T_JBV(1975,211),
	T_JBV(1794,211),
	T_JBV(2067,211)

		); 
	V_TMP_JBV T_JBV;

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');

    FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	FUN_ID := TRIM(V_TMP_JBV(1));
  	
  	PEF_ID := TRIM(V_TMP_JBV(2));

        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = '||PEF_ID||' AND FUN_ID = '||FUN_ID||'';
			
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	-- Si existe la FUNCION PARA EL PERFIL
		IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion ');
		ELSE
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF
				 (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
				 VALUES
				 ('||FUN_ID||','||PEF_ID||', '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,  0, '''||V_USR||''', SYSDATE, 0)';

			EXECUTE IMMEDIATE V_MSQL;
		END IF;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');		
	
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
