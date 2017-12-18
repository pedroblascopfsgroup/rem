--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20171213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.11
--## INCIDENCIA_LINK=HREOS-3475
--## PRODUCTO=NO
--##
--## Finalidad: Script que  updatea la tabla act_agr_agrupacion, 
--## 			 AGR_IS_FORMALIZACION=1 en todas las agrupaciones restringidas ya creadas, 
--##			 cuyo activo principal tenga el pac_check_formalizacion=1.
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
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE tabla  ACT_AGR_AGRUPACION...');
	
	V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION agr SET agr.AGR_IS_FORMALIZACION = 1, agr.USUARIOMODIFICAR = ''HREOS-3475'', agr.FECHAMODIFICAR = SYSDATE
		where agr.dd_tag_id = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''02'')
		and EXISTS(
					SELECT 1 FROM ACT_ACTIVO act INNER JOIN ACT_PAC_PERIMETRO_ACTIVO  pac on act.ACT_ID = pac.ACT_ID 
					WHERE pac.PAC_CHECK_FORMALIZAR = 1 AND act.ACT_ID = agr.AGR_ACT_PRINCIPAL)
		and  NOT EXISTS (SELECT 1 FROM ACT_AGR_AGRUPACION agr2 WHERE agr2.AGR_ID = agr.AGR_ID and agr.AGR_IS_FORMALIZACION = 1)
		AND agr.BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ACT_AGR_AGRUPACION ACTUALIZADA CORRECTAMENTE');
   

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