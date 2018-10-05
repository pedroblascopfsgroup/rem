--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4528
--## PRODUCTO=NO
--##
--## Finalidad: Carga Inicial REP_REVISION_POSESION
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
    V_TABLA VARCHAR2(30 CHAR) := 'REP_REVISION_POSESION';  -- Tabla a modificar  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4528'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
         
			--Insertar datos
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO');
			EXECUTE IMMEDIATE '
				INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
					ACT_ID
					,REP_POSESION
					,REP_OCUPADO
					,REP_CON_TITULO
					,VERSION
					,USUARIOCREAR
					,FECHACREAR
					,BORRADO
					)   
				SELECT
				SPS.ACT_ID
				, (CASE WHEN CRA.DD_CRA_CODIGO = ''03'' 
					THEN
						(CASE WHEN SPS.DD_SIJ_ID IS NOT NULL AND DD_SIJ_INDICA_POSESION = ''1'' THEN ''1''
						ELSE ''0'' END)
					ELSE
						(CASE WHEN SPS.SPS_FECHA_REVISION_ESTADO IS NOT NULL AND SPS_FECHA_TOMA_POSESION IS NOT NULL THEN ''1''
						ELSE ''0'' END)
				END) AS REP_POSESION
				, SPS.SPS_OCUPADO
				, SPS.SPS_CON_TITULO
				, 0
				, '''||V_USR||'''
				, SYSDATE
				, 0
			FROM ACT_SPS_SIT_POSESORIA SPS
			JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = SPS.ACT_ID
			JOIN DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			JOIN DD_SIJ_SITUACION_JURIDICA SIJ ON SIJ.DD_SIJ_ID = SPS.DD_SIJ_ID
			'
			;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA REP_REVISION_POSESION ACTUALIZADA CORRECTAMENTE ');
   

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
