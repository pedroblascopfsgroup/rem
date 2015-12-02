--/*
--##########################################
--## AUTOR=OSCAR
--## FECHA_CREACION=20151201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=PRODUCTO-481
--## PRODUCTO=NO
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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

BEGIN

     DBMS_OUTPUT.PUT_LINE('[INICIO]');

    
	execute immediate 'update '||V_ESQUEMA||'.dpr_decisiones_procedimientos set borrado = 1, usuarioborrar=''PROD-481'', FECHABORRAR=SYSDATE WHERE DPR_ID IN (
SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS DPR
join '||V_ESQUEMA_M||'.dd_ede_estados_decision ede on dpr.dd_ede_id = ede.dd_ede_id
where EDE.DD_EDE_descripcion = ''EN CONFORMACIÓN''
)';


    COMMIT;
    
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;