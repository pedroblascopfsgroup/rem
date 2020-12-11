--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20200720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10577
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: Actualizar registros en la tabla DD_OPM_OPERACION_MASIVA
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-10577'; -- Usuario modificar
    

    V_NOMBRE_TABLA VARCHAR2(4000 CHAR);
    V_NOM_COLUMNA1 VARCHAR2(100 CHAR);
    V_NOM_COLUMNA2 VARCHAR2(100 CHAR);
    V_NOM_COLUMNA3 VARCHAR2(100 CHAR);
    V_NOM_COLUMNA4 VARCHAR2(100 CHAR);
    V_COLUMNA_VALOR1 VARCHAR2(4000 CHAR);
    V_COLUMNA_VALOR2 VARCHAR2(4000 CHAR);
    V_COLUMNA_VALOR3 VARCHAR2(4000 CHAR);
    V_COLUMNA_ID VARCHAR2(100 CHAR);
    V_COLUMNA_VALOR_ANTERIOR VARCHAR2(100 CHAR);


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    V_NOMBRE_TABLA := 'DD_OPM_OPERACION_MASIVA';
    V_NOM_COLUMNA1 := 'DD_OPM_DESCRIPCION';
    V_NOM_COLUMNA2 := 'DD_OPM_DESCRIPCION_LARGA';
    V_NOM_COLUMNA3 := 'DD_OPM_CODIGO';
    V_NOM_COLUMNA4 := 'DD_OPM_VALIDACION_FORMATO';

    V_COLUMNA_VALOR1 := 'OK Técnico y sello de calidad';
    V_COLUMNA_VALOR2 := 'OKTECSELLOCAL';
    V_COLUMNA_VALOR3 := 'n*,b,b';

    V_COLUMNA_VALOR_ANTERIOR := 'OKTEC';


  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' 
				SET '||V_NOM_COLUMNA1||'='''||V_COLUMNA_VALOR1||''','||V_NOM_COLUMNA2||'='''||V_COLUMNA_VALOR1||''',
                    '||V_NOM_COLUMNA3||'='''||V_COLUMNA_VALOR2||''','||V_NOM_COLUMNA4||'='''||V_COLUMNA_VALOR3||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MASIVO_OK_TECNICO'')
                AND '||V_NOM_COLUMNA3||'='''||V_COLUMNA_VALOR_ANTERIOR||'''';
  	
	EXECUTE IMMEDIATE V_MSQL;
  	DBMS_OUTPUT.PUT_LINE('	[INFO] Campos '||V_NOM_COLUMNA1||', '||V_NOM_COLUMNA2||', '||V_NOM_COLUMNA3||', '||V_NOM_COLUMNA4||' actualizados correctamente');

	
	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[OK]');
   			
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE('KO');
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;
/
EXIT