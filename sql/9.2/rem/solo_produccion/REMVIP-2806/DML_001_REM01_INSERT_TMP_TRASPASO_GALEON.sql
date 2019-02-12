--/*
--##########################################
--## AUTOR=Ivan Castelló 
--## FECHA_CREACION=20181120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2806
--## PRODUCTO=NO
--##
--## Finalidad: DML para rellenar la tabla AUX_ACT_TRASPASO_GALEON_2
--## INSTRUCCIONES: 
--## VERSIONES:
--##         0.1 - Maria Presencia  - Versión inicial (20181028)
--##         0.2 - Ivan Castelló    - Versión inicial (20181028)
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas 
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TABLA VARCHAR2(25 CHAR):= 'AUX_ACT_TRASPASO_GALEON_2'; -- Configuracion Esquemas  

	--Array que contiene los registros que se van a actualizar
	TYPE T_INT is table of VARCHAR2(32000); 
	TYPE T_ARRAY_INT IS TABLE OF T_INT;
	V_INT T_ARRAY_INT := T_ARRAY_INT(  
		T_INT('6973040', '7010168'),
		T_INT('6973037', '7019847'),
		T_INT('6972891', '7010257'),
		T_INT('7004034', '7010222'),
		T_INT('7004029', '7010223'),
		T_INT('6977592', '7010206'),
		T_INT('6977608', '7010207'),
		T_INT('6977606', '7010208'),
		T_INT('6977590', '7010209'),
		T_INT('6977578', '7010210'),
		T_INT('6977595', '7010211'),
		T_INT('6977587', '7010212'),
		T_INT('6977603', '7010213'),
		T_INT('6977610', '7010214'),
		T_INT('6977586', '7010215'),
		T_INT('6977593', '7010216'),
		T_INT('7008639', '7010202'),
		T_INT('7008631', '7010203'),
		T_INT('7008638', '7010204'),
		T_INT('7008690', '7010205'),
		T_INT('6781166', '7010184'),
		T_INT('6781229', '7010185'),
		T_INT('6964828', '7010252'),
		T_INT('6978774', '7010247'),
		T_INT('6978776', '7010248'),
		T_INT('6973229', '7010246'),
		T_INT('6973052', '7010260'),
		T_INT('7003812', '7010239'),
		T_INT('6979138', '7010244')
	);
	V_TMP_INT T_INT;

BEGIN

    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INSERCCION/ACTUALIZACION DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.....');

	FOR I IN V_INT.FIRST .. V_INT.LAST LOOP
		V_TMP_INT := V_INT(I);
    
			-- Insert del registro que no esta en el DD
			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO '||V_TABLA||': ['||V_TMP_INT(1)||' - '||V_TMP_INT(2) || ']');
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					ACT_NUM_ACTIVO_ANT,
					ACT_NUM_ACTIVO_NUV,
					DD_CRA_ID
					) VALUES (
					'||V_TMP_INT(1)||', /*ACT_NUM_ACTIVO_NUV*/
					'||V_TMP_INT(2)||', /*ACT_NUM_ACTIVO_NUV*/
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15'') /*DD_CRA_ID*/
					)';
			EXECUTE IMMEDIATE V_MSQL;
	
    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[INFO] FINALIZACION EL PROCESO DE INSERCCION/ACTUALIZACION DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.....');

	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT;
