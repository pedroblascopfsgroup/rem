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
--## INSTRUCCIONES: Actualizar el registro donde sea OK_TECNICO en la tabla POP_PLANTILLAS_OPERACION
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
    V_COLUMNA_VALOR1 VARCHAR2(4000 CHAR);
    V_COLUMNA_VALOR2 VARCHAR2(4000 CHAR);
    V_COLUMNA_NOMBRE VARCHAR2(4000 CHAR);


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    V_NOMBRE_TABLA := 'POP_PLANTILLAS_OPERACION';
    V_NOM_COLUMNA1 := 'POP_NOMBRE';
    V_NOM_COLUMNA2 := 'POP_DIRECTORIO';
    V_COLUMNA_VALOR1 := 'OK_TECNICO_SELLO_CALIDAD';
    V_COLUMNA_VALOR2 := 'plantillas/plugin/masivo/OkTecnicoSelloCalidad.xls';
    V_COLUMNA_NOMBRE := 'OK_TECNICO';

    


  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' 
				SET '||V_NOM_COLUMNA1||'='''||V_COLUMNA_VALOR1||''','||V_NOM_COLUMNA2||'='''||V_COLUMNA_VALOR2||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE DD_OPM_ID = (SELECT DD_OPM_ID FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = ''OKTECSELLOCAL'')
                AND '||V_NOM_COLUMNA1||'='''||V_COLUMNA_NOMBRE||'''';
  	
	EXECUTE IMMEDIATE V_MSQL;
  	DBMS_OUTPUT.PUT_LINE('	[INFO] Campos '||V_NOM_COLUMNA1||', '||V_NOM_COLUMNA2||' con codigo '||V_COLUMNA_NOMBRE||' actualizados correctamente');

	
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