--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6048
--## PRODUCTO=NO
--## Finalidad: Rellenar la columna CPU_VALOR_BANKIA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_TABLAS NUMBER(25);
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6048';
	V_TABLA VARCHAR2(50 CHAR) := 'CPU_CRITERIO_PUNTUACION_ACT';
	V_COLUMN VARCHAR2(50 CHAR) := 'CPU_VALOR_BANKIA';
	
	TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('09', '50'),
		T_JBV('10', '50'),
		T_JBV('11', '50'),
		T_JBV('12', '50'),
		T_JBV('13', '50'),
		T_JBV('14', '50'),
		T_JBV('15', '50'),
		T_JBV('17', '100'),
		T_JBV('21', '25'),
		T_JBV('22', '25'),
		T_JBV('23', '25'),
		T_JBV('24', '25'),
		T_JBV('25', '10'),
		T_JBV('26', '10'),
		T_JBV('77', '30'),
		T_JBV('78', '30'),
		T_JBV('79', '50'),
		T_JBV('80', '30'),
		T_JBV('81', '30'),
		T_JBV('82', '50')
	); 
	V_TMP_JBV T_JBV;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	LOOP
 
		V_TMP_JBV := V_JBV(I);
	
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	  
	  	IF V_NUM_TABLAS > 0 THEN
	  		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
						SET CPU_VALOR_BANKIA = '''||V_TMP_JBV(2)||'''
							,USUARIOMODIFICAR = '''||V_USUARIO||'''
							,FECHAMODIFICAR = SYSDATE
						WHERE CPU_CODIGO = '''||V_TMP_JBV(1)||'''
						';
	        EXECUTE IMMEDIATE V_MSQL;
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[INFO] Error al actualizar los datos de '||V_TABLA||'.'||V_COLUMN||'');
			
		END IF;
	
	END LOOP;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
				SET CPU_VALOR_BANKIA = CPU_VALOR
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
					,FECHAMODIFICAR = SYSDATE
				WHERE CPU_VALOR_BANKIA IS NULL
				';
    EXECUTE IMMEDIATE V_MSQL;
	
	COMMIT;
  	DBMS_OUTPUT.PUT_LINE('[FIN]');
  	
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;   
END;
/
EXIT;