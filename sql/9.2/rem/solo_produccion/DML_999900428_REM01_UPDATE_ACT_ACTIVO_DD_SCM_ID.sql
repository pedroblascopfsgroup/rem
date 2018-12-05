--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20181127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2698
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2698'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_NUM_ACTIVO NUMBER(16);
    TIPO VARCHAR2(30 CHAR);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
						T_JBV(6080646,'Alquiler y venta'),
						T_JBV(6988683,'Alquiler y venta'),
						T_JBV(6999986,'Venta'),
						T_JBV(6999982,'Venta'),
						T_JBV(7000055,'Venta'),
						T_JBV(5930730,'Alquiler y venta'),
						T_JBV(7000070,'Venta'),
						T_JBV(5960315,'Venta'),
						T_JBV(5958931,'Venta'),
						T_JBV(6999983,'Venta'),
						T_JBV(5956558,'Venta'),
						T_JBV(5936103,'Venta'),
						T_JBV(6040718,'Alquiler y venta'),
						T_JBV(6788107,'Venta'),
						T_JBV(5932017,'Venta'),
						T_JBV(7000039,'Venta'),
						T_JBV(7000037,'Venta'),
						T_JBV(7000036,'Venta'),
						T_JBV(7000038,'Venta'),
						T_JBV(7000018,'Venta'),
						T_JBV(7000016,'Venta'),
						T_JBV(7001514,'Venta'),
						T_JBV(7000032,'Venta'),
						T_JBV(6843577,'Venta'),
						T_JBV(5944609,'Venta'),
						T_JBV(7001665,'Venta'),
						T_JBV(6988680,'Alquiler y venta'),
						T_JBV(7001513,'Venta'),
						T_JBV(7000041,'Venta'),
						T_JBV(7000073,'Venta'),
						T_JBV(6999990,'Venta'),
						T_JBV(7000030,'Venta'),
						T_JBV(6999981,'Venta'),
						T_JBV(7000019,'Venta'),
						T_JBV(5967912,'Alquiler y venta'),
						T_JBV(5935516,'Alquiler y venta'),
						T_JBV(6999947,'Venta'),
						T_JBV(6988681,'Alquiler y venta'),
						T_JBV(5963242,'Venta'),
						T_JBV(7000014,'Venta'),
						T_JBV(5938223,'Alquiler y venta'),
						T_JBV(6999965,'Venta'),
						T_JBV(6999995,'Venta'),
						T_JBV(6999993,'Venta'),
						T_JBV(6833606,'Venta'),
						T_JBV(5945758,'Venta'),
						T_JBV(5935622,'Venta'),
						T_JBV(5942812,'Venta'),
						T_JBV(5952599,'Venta'),
						T_JBV(5970235,'Venta'),
						T_JBV(6044914,'Venta'),
						T_JBV(6828221,'Venta'),
						T_JBV(5926272,'Venta'),
						T_JBV(5944746,'Venta'),
						T_JBV(5929995,'Venta'),
						T_JBV(5935677,'Venta'),
						T_JBV(5939392,'Venta'),
						T_JBV(5943464,'Venta'),
						T_JBV(6044514,'Venta'),
						T_JBV(6940750,'Venta'),
						T_JBV(5948694,'Venta'),
						T_JBV(6833610,'Venta'),
						T_JBV(5926041,'Venta'),
						T_JBV(5956721,'Venta'),
						T_JBV(5959015,'Venta'),
						T_JBV(5940457,'Venta'),
						T_JBV(5934251,'Venta'),
						T_JBV(5952418,'Venta'),
						T_JBV(6711561,'Venta'),
						T_JBV(5947549,'Venta'),
						T_JBV(6703023,'Venta'),
						T_JBV(6060639,'Venta'),
						T_JBV(6063823,'Venta'),
						T_JBV(5941492,'Venta'),
						T_JBV(5964766,'Venta'),
						T_JBV(5929892,'Venta'),
						T_JBV(5948455,'Venta'),
						T_JBV(5955612,'Venta'),
						T_JBV(5934637,'Venta'),
						T_JBV(5952226,'Venta'),
						T_JBV(5965835,'Venta'),
						T_JBV(6940741,'Venta'),
						T_JBV(5970095,'Venta'),
						T_JBV(6062540,'Venta'),
						T_JBV(5964894,'Venta')); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA DD_SCM_ID');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_NUM_ACTIVO := TRIM(V_TMP_JBV(1));
  	TIPO := TRIM(V_TMP_JBV(2));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO
					   SET DD_SCM_ID = 4,
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
					   AND ACT_ID IN (SELECT ACT_ID
										FROM ACT_APU_ACTIVO_PUBLICACION
										WHERE DD_MTO_V_ID = 7)
					   AND DD_SCM_ID <> 5';
	
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
