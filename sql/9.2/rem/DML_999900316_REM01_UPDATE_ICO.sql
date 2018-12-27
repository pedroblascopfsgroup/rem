--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4449
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4449'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACT_ICO_INFO_COMERCIAL');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL
			   SET ICO_MEDIADOR_ID = (SELECT PVE_ID FROM ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = ''B02386431''),
				   FECHAMODIFICAR = SYSDATE, 
				   USUARIOMODIFICAR = '''||V_USR||''' 
			   WHERE ACT_ID IN (SELECT ACT.ACT_ID
								FROM ACT_ACTIVO ACT
								JOIN ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID
								WHERE CAT.CAT_REF_CATASTRAL IN (''5615235XG1751F0011TQ'',
																''5615235XG1751F0013UE'',
																''5615235XG1751F0014IR'',
																''8480008XG0488A0003DO'',
																''8480008XG0488A0005GA'',
																''8480008XG0488A0006HS'',
																''8480008XG0488A0007JD'',
																''8480008XG0488A0008KF'',
																''8480008XG0488A0010JD'',
																''5283703XG0558B0004SS'',
																''5283703XG0558B0005DD'',
																''5283703XG0558B0006FF'',
																''5283703XG0558B0007GG'',
																''5283703XG0558B0008HH'',
																''5283703XG0558B0009JJ'',
																''5283703XG0558B0010GG'',
																''5283703XG0558B0011HH'',
																''5283703XG0558B0012JJ'',
																''5283703XG0558B0013KK'',
																''5283703XG0558B0016ZZ''))';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA ACT_ICO_INFO_COMERCIAL');
	
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
