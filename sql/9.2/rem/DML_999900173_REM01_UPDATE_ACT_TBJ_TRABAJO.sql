--/*
--##########################################
--## AUTOR=JOSE NAVARRO
--## FECHA_CREACION=20171227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3551
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza los trabajos con PVC_ID = 1894 a PVC_ID = 24152
--## luego borrado lógico del proveedor con PVC_ID = 1894
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    DBMS_OUTPUT.PUT_LINE('[INFO]:  actualiza los trabajos con PVC_ID = 1894 a PVC_ID = 24152 ');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO
	SET USUARIOMODIFICAR = ''HREOS-3551'', 
		FECHAMODIFICAR = SYSDATE, 
		PVC_ID = 24152
	WHERE PVC_ID = 1894';
	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_TBJ_TRABAJO ACTUALIZADA CORRECTAMENTE ');

    DBMS_OUTPUT.PUT_LINE('[INFO]:  se procede al borrado lógico del proveedor con PVC_ID = 1894 ');

    V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO
    				SET USUARIOBORRAR = ''HREOS-3551'',
    					FECHABORRAR = SYSDATE,
    					BORRADO = 1
    				WHERE PVC_ID = 1894';
    EXECUTE IMMEDIATE V_MSQL;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  BORRADO LÓGICO DEL PROVEEDOR CON PVC_ID = 1894 FINALIZADO CORRECTAMENTE ');
   			

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
