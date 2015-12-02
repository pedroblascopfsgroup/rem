
--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20150812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-476
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar los gestores en las tareas para HRE-BCC
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
	PAR_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';               -- [PARAMETRO] Configuracion Esquemas

	ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.
	
    V_COD_PROCEDIMIENTO VARCHAR(20 CHAR); -- Código de procedimiento para reemplazar
	TYPE procedimiento_tab_t IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(20);
  	procedimiento_tab procedimiento_tab_t;
BEGIN	
  
	procedimiento_tab('H001') := 'P. hipotecario - HCJ';
  	procedimiento_tab('HC103') := 'T. Provisión Fondos - HCJ';
  	procedimiento_tab('H008') := 'T. de saneamiento de cargas - HCJ';
  	procedimiento_tab('H005') := 'Trámite de Adjudicación - HCJ';
  	procedimiento_tab('H006') := 'T. de cesión de remate - HCJ';
  	procedimiento_tab('H002') := 'T. de subasta - HCJ';
  	procedimiento_tab('H004') := 'T. de subasta TERCEROS - HCJ';
  
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comenzando la actualización de nombres de trámites.');  
  
	V_COD_PROCEDIMIENTO := procedimiento_tab.first;
	WHILE V_COD_PROCEDIMIENTO IS NOT NULL LOOP
	
    	DBMS_OUTPUT.PUT_LINE('Se actualiza el trámite con código ' || V_COD_PROCEDIMIENTO || '.');
		EXECUTE IMMEDIATE 'UPDATE '||PAR_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO SET DD_TPO_DESCRIPCION=''' || procedimiento_tab(V_COD_PROCEDIMIENTO) || ''' WHERE DD_TPO_CODIGO = '''||V_COD_PROCEDIMIENTO||'''';
	
		V_COD_PROCEDIMIENTO := procedimiento_tab.next(V_COD_PROCEDIMIENTO);
	END LOOP;
	
	COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Nombres de trámites actualizados.');

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