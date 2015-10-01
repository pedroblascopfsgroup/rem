--/*
--##########################################
--## AUTOR=GONZALO ESTELLES
--## FECHA_CREACION=20150927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hcj
--## INCIDENCIA_LINK=VARIAS
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de varias incidencias de Litigios
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] LINK CMREC-858');
	V_TAREA:='H036_CelebracionSubasta';
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores['''''||V_TAREA||'''''][''''celebrada''''] == DDSiNo.NO ? ''''SUSPENDIDA'''' : (dameEntidadAdjudicatariaBien() != '''''''' && dameEntidadAdjudicatariaBien() != ''''2'''' ? (bienConCesionRemate() ? ''''ADJUDICACICONCESION'''' : ''''ADJUDICACIONSINCESION'''') : ''''TERCEROS'''')'' WHERE TAP_CODIGO = '''||V_TAREA||'''';
	DBMS_OUTPUT.PUT_LINE('[FIN] LINK CMREC-858');
	
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