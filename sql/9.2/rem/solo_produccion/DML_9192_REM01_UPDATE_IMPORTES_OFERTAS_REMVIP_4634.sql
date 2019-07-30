--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190723
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4912
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4912'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('6864835','5755.48'),
			T_JBV('6864836','5755.48'),
			T_JBV('6865894','5755.48'),
			T_JBV('6865255','5755.48'),
			T_JBV('6865373','5755.48'),
			T_JBV('6863723','5755.48'),
			T_JBV('6865374','5755.48'),
			T_JBV('6865256','5755.48'),
			T_JBV('6864691','5755.48'),
			T_JBV('6865895','5755.48'),
			T_JBV('6865896','5755.48'),
			T_JBV('6864692','5755.48'),
			T_JBV('6865305','5755.48'),
			T_JBV('6865306','5755.48'),
			T_JBV('6865897','5755.48'),
			T_JBV('6865898','5755.48'),
			T_JBV('6865899','5755.48'),
			T_JBV('6864837','5755.48'),
			T_JBV('6865375','5755.48'),
			T_JBV('6864693','5755.48'),
			T_JBV('6865307','5755.48'),
			T_JBV('6864838','5755.48'),
			T_JBV('6865900','5755.48'),
			T_JBV('6865257','5755.48'),
			T_JBV('6865376','5755.48'),
			T_JBV('6863724','5755.48'),
			T_JBV('6865377','5755.48'),
			T_JBV('6863725','5755.48'),
			T_JBV('6864694','5755.48'),
			T_JBV('6865901','5755.48'),
			T_JBV('6865258','5755.48'),
			T_JBV('6865378','5755.48'),
			T_JBV('6865818','5755.48'),
			T_JBV('6865819','5755.48'),
			T_JBV('6865308','5755.48'),
			T_JBV('6865309','5755.48'),
			T_JBV('6865310','5755.48'),
			T_JBV('6864695','5755.48'),
			T_JBV('6865259','5755.48'),
			T_JBV('6865379','5755.48'),
			T_JBV('6865820','5755.48'),
			T_JBV('6864839','5755.48'),
			T_JBV('6865902','5755.48'),
			T_JBV('6865260','5755.48'),
			T_JBV('6865380','5755.48'),
			T_JBV('6863726','5755.48'),
			T_JBV('6865381','5755.48'),
			T_JBV('6863727','5755.48'),
			T_JBV('6864696','5755.48'),
			T_JBV('6865903','5755.48'),
			T_JBV('6865261','5755.48'),
			T_JBV('6865262','5755.48'),
			T_JBV('6865263','5755.48'),
			T_JBV('6863728','5755.48'),
			T_JBV('6865821','5755.48'),
			T_JBV('6865382','5755.48'),
			T_JBV('6866027','5755.48'),
			T_JBV('6866177','5755.48'),
			T_JBV('6864840','5755.48'),
			T_JBV('6865264','5755.48'),
			T_JBV('6863729','5755.48'),
			T_JBV('6863730','5755.48'),
			T_JBV('6866178','5755.48'),
			T_JBV('6866179','5755.48'),
			T_JBV('6864697','6248.40'),
			T_JBV('6864698','6248.40'),
			T_JBV('6864699','6248.40'),
			T_JBV('6866028','6248.40'),
			T_JBV('6865904','6248.40'),
			T_JBV('6863731','6248.40'),
			T_JBV('6866180','6248.40'),
			T_JBV('6865311','6248.40'),
			T_JBV('6864841','6248.40'),
			T_JBV('6865905','6248.40'),
			T_JBV('6863732','6248.40'),
			T_JBV('6865265','6248.40'),
			T_JBV('6863733','6248.40'),
			T_JBV('6865906','6248.40'),
			T_JBV('6866029','6248.40'),
			T_JBV('6864842','6248.40'),
			T_JBV('6864843','6248.40'),
			T_JBV('6864844','6248.40'),
			T_JBV('6865907','6248.40'),
			T_JBV('6865266','6248.40'),
			T_JBV('6866181','6248.40'),
			T_JBV('6863734','6248.40'),
			T_JBV('6866182','6248.40'),
			T_JBV('6863735','6248.40'),
			T_JBV('6864700','6248.40'),
			T_JBV('6865908','6248.40'),
			T_JBV('6865909','6248.40'),
			T_JBV('6866030','6248.40'),
			T_JBV('6864701','6248.40'),
			T_JBV('6864702','6248.40'),
			T_JBV('6864845','6248.40'),
			T_JBV('6864846','6248.40'),
			T_JBV('6864847','6248.40'),
			T_JBV('6865312','6248.40'),
			T_JBV('6863736','6248.40'),
			T_JBV('6866031','6248.40'),
			T_JBV('6864703','6248.40'),
			T_JBV('6866032','6248.40'),
			T_JBV('6863737','6248.40'),
			T_JBV('6866183','6248.40'),
			T_JBV('6866184','6248.40'),
			T_JBV('6866185','6248.40'),
			T_JBV('6865044','6248.40'),
			T_JBV('6865045','6248.40'),
			T_JBV('6865313','6248.40'),
			T_JBV('6863738','6248.40'),
			T_JBV('6866186','6248.40'),
			T_JBV('6863739','6248.40'),
			T_JBV('6865910','6248.40'),
			T_JBV('6865267','6248.40'),
			T_JBV('6865911','6248.40'),
			T_JBV('6865268','6248.40'),
			T_JBV('6864704','6248.40'),
			T_JBV('6864705','6248.40'),
			T_JBV('6866033','6248.40'),
			T_JBV('6865912','6248.40'),
			T_JBV('6865269','6248.40'),
			T_JBV('6864706','6248.40'),
			T_JBV('6863740','6248.40'),
			T_JBV('6866187','6248.40'),
			T_JBV('6866188','6248.40'),
			T_JBV('6866189','6248.40'),
			T_JBV('6865046','6248.31')
); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA BORRADO');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_OFR 
				   SET ACT_OFR_IMPORTE = '||V_TMP_JBV(2)||'
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
				   AND OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90143104)';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_NUM_ACTIVO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS  
				   SET OFR_IMPORTE = 761999.83,
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE OFR_NUM_OFERTA = 90143104';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] IMPORTE DE LA OFERTA 90143104 ACTUALUIZADO');


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
