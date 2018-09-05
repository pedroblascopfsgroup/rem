--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4448
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4448'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION CARTERA Y SUBCARTERA');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		   SET DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''15''),
		       DD_SCR_ID = (SELECT DD_SCR_ID FROM DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''02''),
		       FECHAMODIFICAR = SYSDATE, 
		       USUARIOMODIFICAR = '''||V_USR||''' 
		   WHERE ACT_ID IN (SELECT ACT.ACT_ID
					FROM ACT_ACTIVO ACT 
					JOIN ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID
					WHERE CAT.CAT_REF_CATASTRAL IN (
					''8076007WF4787N0004OU'',
					''1549037WF1714N0048OH'',
					''1549037WF1714N0002ZT'',
					''1549037WF1714N0008RA'',
					''1549037WF1714N0009TS'',
					''1549037WF1714N0013YD'',
					''1549037WF1714N0016OH'',
					''1549037WF1714N0020PJ'',
					''1549037WF1714N0021AK'',
					''1549037WF1714N0022SL'',
					''1549037WF1714N0024FZ'',
					''1549037WF1714N0027JQ'',
					''1549037WF1714N0032LE'',
					''1549037WF1714N0033BR'',
					''1549037WF1714N0036MU'',
					''1549037WF1714N0037QI'',
					''1549037WF1714N0044TS'',
					''1549037WF1714N0045YD'',
					''0206501WF5800N0002XO'',
					''0206501WF5800N0002XO'',
					''8455504UF7985N0003OG'',
					''7459704XG8675N0002MG'',
					''7459704XG8675N0004WJ'',
					''7459704XG8675N0005EK'',
					''7459704XG8675N0006RL'',
					''7459704XG8675N0008YZ'',
					''7459704XG8675N0009UX'',
					''7459704XG8675N0020SR'',
					''7459704XG8675N0011YZ'',
					''7459704XG8675N0012UX'',
					''7459704XG8675N0013IM'',
					''7459704XG8675N0014OQ'',
					''7459704XG8675N0015PW'',
					''7459704XG8675N0017SR'',
					''7459704XG8675N0018DT'',
					''9546621XH6094N0019IR'',
					''9546621XH6094N0020YW'',
					''5615235XG1751F0011TQ'',
					''5615235XG1751F0013UE'',
					''5615235XG1751F0014IR'',
					''7205604XG6870N0001MU'',
					''8480008XG0488A0003DO'',
					''8480008XG0488A0005GA'',
					''8480008XG0488A0006HS'',
					''8480008XG0488A0007JD'',
					''8480008XG0488A0008KF'',
					''8480008XG0488A0010JD'',
					''6297113TF9568F0005TW'',
					''6297113TF9568F0010UR'',
					''6297113TF9568F0012OY'',
					''6297113TF9568F0013PU'',
					''6729711XG9962N0007FG'',
					''6773401WF4767S0068SU'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''0371506VF4607A0001WZ'',
					''2617110VG4121H0014AD'',
					''2617110VG4121H0015SF'',
					''2617110VG4121H0019HK'',
					''1893940YK5219S0129KH'',
					''2700522UM5120S0015IP'',
					''8289603YJ1688N0001TB'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''3099206YJ2539N0023KJ'',
					''5474905YJ1257S0001SW'',
					''1140805YJ2114A0004LR'',
					''4710805YJ2741B0002KW'',
					''7938401YJ3973H0022ZM'',
					''8501901YJ1980S0004EW'',
					''4963821YH0046S0056XG'',
					''7586015YH1678N0023EW'',
					''7586015YH1678N0006GF'',
					''7586015YH1678N0007HG'',
					''7586015YH1678N0047ZB'',
					''2993801YK5229S0206GY'',
					''6365608TF8066N0015YP'',
					''6365608TF8066N0018OD'',
					''6365608TF8066N0020IS'',
					''7243601XH5074C0004FA'',
					''1735101UF7613N0028UE'',
					''4590604WF3649S0007EL'',
					''4763106XG7846D0001RL'',
					''8436508XH6083N0006YL'',
					''0567406XG9806H0003WL'',
					''0570601WF5707S0398LW'',
					''3504010XH6130S0003HR'',
					''0310507DD7801A0002RA'',
					''5063104XH5156S0003AP'',
					''8309110YJ1480N0004SG'',
					''0453107DS4005S0001LX''))';
    EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA CARTERA Y SUBCARTERA');
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION PROPIETARIO');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO 
		   SET PRO_ID = (SELECT PRO_ID FROM ACT_PRO_PROPIETARIO WHERE TRIM(PRO_NOMBRE) = ''Vauxhall Propiedades SLU''),
		       FECHAMODIFICAR = SYSDATE, 
		       USUARIOMODIFICAR = '''||V_USR||''' 
		   WHERE ACT_ID IN (SELECT ACT.ACT_ID
					FROM ACT_ACTIVO ACT 
					JOIN ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID
					WHERE CAT.CAT_REF_CATASTRAL IN (
					''8076007WF4787N0004OU'',
					''1549037WF1714N0048OH'',
					''1549037WF1714N0002ZT'',
					''1549037WF1714N0008RA'',
					''1549037WF1714N0009TS'',
					''1549037WF1714N0013YD'',
					''1549037WF1714N0016OH'',
					''1549037WF1714N0020PJ'',
					''1549037WF1714N0021AK'',
					''1549037WF1714N0022SL'',
					''1549037WF1714N0024FZ'',
					''1549037WF1714N0027JQ'',
					''1549037WF1714N0032LE'',
					''1549037WF1714N0033BR'',
					''1549037WF1714N0036MU'',
					''1549037WF1714N0037QI'',
					''1549037WF1714N0044TS'',
					''1549037WF1714N0045YD'',
					''0206501WF5800N0002XO'',
					''0206501WF5800N0002XO'',
					''8455504UF7985N0003OG'',
					''7459704XG8675N0002MG'',
					''7459704XG8675N0004WJ'',
					''7459704XG8675N0005EK'',
					''7459704XG8675N0006RL'',
					''7459704XG8675N0008YZ'',
					''7459704XG8675N0009UX'',
					''7459704XG8675N0020SR'',
					''7459704XG8675N0011YZ'',
					''7459704XG8675N0012UX'',
					''7459704XG8675N0013IM'',
					''7459704XG8675N0014OQ'',
					''7459704XG8675N0015PW'',
					''7459704XG8675N0017SR'',
					''7459704XG8675N0018DT'',
					''9546621XH6094N0019IR'',
					''9546621XH6094N0020YW'',
					''5615235XG1751F0011TQ'',
					''5615235XG1751F0013UE'',
					''5615235XG1751F0014IR'',
					''7205604XG6870N0001MU'',
					''8480008XG0488A0003DO'',
					''8480008XG0488A0005GA'',
					''8480008XG0488A0006HS'',
					''8480008XG0488A0007JD'',
					''8480008XG0488A0008KF'',
					''8480008XG0488A0010JD'',
					''6297113TF9568F0005TW'',
					''6297113TF9568F0010UR'',
					''6297113TF9568F0012OY'',
					''6297113TF9568F0013PU'',
					''6729711XG9962N0007FG'',
					''6773401WF4767S0068SU'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''7985715XL9978N0001QY'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''5283704XG0558B0001KO'',
					''0371506VF4607A0001WZ'',
					''2617110VG4121H0014AD'',
					''2617110VG4121H0015SF'',
					''2617110VG4121H0019HK'',
					''1893940YK5219S0129KH'',
					''2700522UM5120S0015IP'',
					''8289603YJ1688N0001TB'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''9284720XH6098S0001RL'',
					''3099206YJ2539N0023KJ'',
					''5474905YJ1257S0001SW'',
					''1140805YJ2114A0004LR'',
					''4710805YJ2741B0002KW'',
					''7938401YJ3973H0022ZM'',
					''8501901YJ1980S0004EW'',
					''4963821YH0046S0056XG'',
					''7586015YH1678N0023EW'',
					''7586015YH1678N0006GF'',
					''7586015YH1678N0007HG'',
					''7586015YH1678N0047ZB'',
					''2993801YK5229S0206GY'',
					''6365608TF8066N0015YP'',
					''6365608TF8066N0018OD'',
					''6365608TF8066N0020IS'',
					''7243601XH5074C0004FA'',
					''1735101UF7613N0028UE'',
					''4590604WF3649S0007EL'',
					''4763106XG7846D0001RL'',
					''8436508XH6083N0006YL'',
					''0567406XG9806H0003WL'',
					''0570601WF5707S0398LW'',
					''3504010XH6130S0003HR'',
					''0310507DD7801A0002RA'',
					''5063104XH5156S0003AP'',
					''8309110YJ1480N0004SG'',
					''0453107DS4005S0001LX''))';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO PROPIETARIO');
    
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
