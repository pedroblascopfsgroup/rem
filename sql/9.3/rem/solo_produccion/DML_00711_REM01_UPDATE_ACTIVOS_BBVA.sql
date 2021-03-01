--/*
--##########################################
--## AUTOR=Adrian Molina
--## FECHA_CREACION=20200301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9096
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    V_USUARIO VARCHAR2(25 CHAR) := 'REMVIP-9096';
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar activos BBVA con cesión de uso');
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO SET 
                    PAC_CHECK_COMERCIALIZAR =  0,
					PAC_CHECK_FORMALIZAR =  0,
					PAC_CHECK_PUBLICAR =  0,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID IN (533795, 
									535218, 
									535220, 
									560100)';
									
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO SET 
                    CHECK_HPM =  1,
					DD_CDU_ID = 3,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID IN (533795, 
									535218, 
									535220, 
									560100)';
									
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_ACTIVO SET 
                    DD_TAL_ID =  65,
					DD_TCO_ID =  1,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID IN (533795, 
									535218, 
									535220, 
									560100)';
									
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_BBVA_ACTIVOS SET 
                    DD_TAL_ID =  65,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID IN (533795, 
									535218, 
									535220, 
									560100)';
									
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION SET 
                    DD_TCO_ID =  1,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID IN (533795, 
									535218, 
									535220, 
									560100)';
									
	EXECUTE IMMEDIATE V_MSQL;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso finalizado correctamente');
	
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