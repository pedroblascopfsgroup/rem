--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12710
--## PRODUCTO=NO
--##
--## Finalidad: Backup tablas del modelo de gastos
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('GPV_GASTOS_PROVEEDOR','GPV_GASTOS_PROVEEDOR_BACKUP'),
		T_TIPO_DATA('GDE_GASTOS_DETALLE_ECONOMICO','GDE_GASTOS_DETALLE_BACKUP'),
		T_TIPO_DATA('GIC_GASTOS_INFO_CONTABILIDAD','GIC_GASTOS_CONTABILIDAD_BACKUP'),
		T_TIPO_DATA('GGE_GASTOS_GESTION','GGE_GASTOS_GESTION_BACKUP'),
		T_TIPO_DATA('GPV_ACT','GPV_ACT_BACKUP'),
		T_TIPO_DATA('GPV_TBJ','GPV_TBJ_BACKUP'),
		T_TIPO_DATA('ACT_CONFIG_DEST_GASTO','ACT_CONFIG_DEST_GASTO_BACKUP'),
		T_TIPO_DATA('GEX_GASTOS_EXPEDIENTE','GEX_GASTOS_EXPEDIENTE_BACKUP'),
		T_TIPO_DATA('GIM_GASTOS_IMPUGNACION','GIM_GASTOS_IMPUGNACION_BACKUP'),
		T_TIPO_DATA('GPL_GASTOS_PRINEX_LBK','GPL_GASTOS_PRINEX_LBK_BACKUP'),
		T_TIPO_DATA('GRG_REFACTURACION_GASTOS','GRG_REF_GASTOS_BACKUP'),
		T_TIPO_DATA('GSS_GASTOS_SUPLIDOS','GSS_GASTOS_SUPLIDOS_BACKUP'),
		T_TIPO_DATA('PRG_PROVISION_GASTOS','PRG_PROVISION_GASTO_BACKUP')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.put_line('	[INFO]: Tabla '||V_TMP_TIPO_DATA(1)||'.'); 

		V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_TIPO_DATA(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 0 THEN

			DBMS_OUTPUT.PUT_LINE('	[INFO]: No existe la tabla '||V_TMP_TIPO_DATA(1)||'.');

		ELSE

			V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_TIPO_DATA(2)||''' AND OWNER = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS = 1 THEN

				DBMS_OUTPUT.PUT_LINE('	[INFO]: Ya existe la tabla '||V_TMP_TIPO_DATA(2)||'.');

			ELSE

	        	DBMS_OUTPUT.put_line('	[INFO]: Creando tabla backup '||V_TMP_TIPO_DATA(2)||'.'); 
				V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(2)||' AS
					SELECT *
					FROM '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(1)||'';             
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('	[INFO]: Tabla '||V_TMP_TIPO_DATA(2)||' creada a partir de la tabla '||V_TMP_TIPO_DATA(1)||' correctamente.');

			END IF;

		END IF;
	        
	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL); 
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
