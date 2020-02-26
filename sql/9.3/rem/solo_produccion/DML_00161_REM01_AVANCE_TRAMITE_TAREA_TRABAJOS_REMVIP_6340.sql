--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6340
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

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6340'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    TBJ_ID NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, TEX_ID, TEX_TOKEN, ACT_ID, USU_ID, SUP_ID

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(446928, 4918897, 9668358, 60357988, 356855, 86356, 60579, 9000286757),
		T_JBV(446949, 4918918, 9668379, 60358179, 51851, 86356, 60579, 9000286779),
		T_JBV(446977, 4918946, 9668407, 60358434, 38861, 86356, 60579, 9000286807),
		T_JBV(446978, 4918947, 9668408, 60358443, 2891, 86356, 60579, 9000286808),
		T_JBV(447022, 4919002, 9668461, 60358863, 412328, 86356, 60579, 9000286852),
		T_JBV(447025, 4919005, 9668464, 60358890, 431912, 86356, 60579, 9000286855),
		T_JBV(446829, 4918792, 9668253, 60357083, 267294, 86356, 60579, 9000286659),
		T_JBV(446832, 4918796, 9668257, 60357112, 267270, 86356, 60579, 9000286662),
		T_JBV(446854, 4918820, 9668281, 60357315, 412334, 86356, 60579, 9000286684),
		T_JBV(446873, 4918842, 9668303, 60357493, 4705, 86356, 60579, 9000286703),
		T_JBV(446906, 4918875, 9668336, 60357790, 324879, 86356, 60579, 9000286735),
		T_JBV(446930, 4918899, 9668360, 60358006, 431973, 86356, 60579, 9000286759),
		T_JBV(446936, 4918905, 9668366, 60358062, 73266, 86356, 60579, 9000286765),
		T_JBV(446963, 4918932, 9668393, 60358305, 412337, 86356, 60579, 9000286793),
		T_JBV(446983, 4918953, 9668413, 60358490, 73145, 86356, 60579, 9000286813),
		T_JBV(447074, 4919056, 9668515, 60359333, 354087, 86356, 60579, 9000286904),
		T_JBV(447113, 4919096, 9668555, 60359686, 421958, 86356, 60579, 9000286943),
		T_JBV(447128, 4919111, 9668570, 60359821, 412338, 86356, 60579, 9000286958),
		T_JBV(447133, 4919117, 9668576, 60359868, 412321, 86356, 60579, 9000286963),
		T_JBV(446828, 4918791, 9668252, 60357073, 267209, 86356, 60579, 9000286658),
		T_JBV(446843, 4918808, 9668269, 60357214, 267274, 86356, 60579, 9000286673),
		T_JBV(446867, 4918836, 9668297, 60357439, 4953, 86356, 60579, 9000286697),
		T_JBV(446909, 4918878, 9668339, 60357817, 354088, 86356, 60579, 9000286738),
		T_JBV(446918, 4918887, 9668348, 60357898, 354085, 86356, 60579, 9000286747),
		T_JBV(446919, 4918888, 9668349, 60357907, 356749, 86356, 60579, 9000286748),
		T_JBV(446920, 4918889, 9668350, 60357916, 122383, 86356, 60579, 9000286749),
		T_JBV(446933, 4918902, 9668363, 60358035, 421682, 86356, 60579, 9000286762),
		T_JBV(446934, 4918903, 9668364, 60358044, 390785, 86356, 60579, 9000286763),
		T_JBV(446965, 4918934, 9668395, 60358323, 412340, 86356, 60579, 9000286795),
		T_JBV(446970, 4918939, 9668400, 60358371, 2363, 86356, 60579, 9000286800),
		T_JBV(446972, 4918941, 9668402, 60358389, 421625, 86356, 60579, 9000286802),
		T_JBV(446975, 4918944, 9668405, 60358416, 417483, 86356, 60579, 9000286805),
		T_JBV(446980, 4918950, 9668410, 60358461, 421602, 86356, 60579, 9000286810),
		T_JBV(447027, 4919007, 9668466, 60358908, 266906, 86356, 60579, 9000286857),
		T_JBV(447081, 4919063, 9668522, 60359396, 354078, 86356, 60579, 9000286911),
		T_JBV(446857, 4918823, 9668284, 60357342, 37226, 86356, 60579, 9000286687),
		T_JBV(446874, 4918843, 9668304, 60357502, 4255, 86356, 60579, 9000286704),
		T_JBV(446875, 4918844, 9668305, 60357511, 2520, 86356, 60579, 9000286705),
		T_JBV(446902, 4918871, 9668332, 60357754, 272955, 86356, 60579, 9000286731),
		T_JBV(446917, 4918886, 9668347, 60357889, 356840, 86356, 60579, 9000286746),
		T_JBV(446971, 4918940, 9668401, 60358380, 2377, 86356, 60579, 9000286801),
		T_JBV(446979, 4918949, 9668409, 60358452, 421665, 86356, 60579, 9000286809),
		T_JBV(447046, 4919026, 9668485, 60359079, 1976, 86356, 60579, 9000286876),
		T_JBV(446865, 4918834, 9668295, 60357421, 4253, 86356, 60579, 9000286695),
		T_JBV(446910, 4918879, 9668340, 60357826, 356848, 86356, 60579, 9000286739),
		T_JBV(446932, 4918901, 9668362, 60358024, 421707, 86356, 60579, 9000286761),
		T_JBV(446953, 4918922, 9668383, 60358215, 50782, 86356, 60579, 9000286783),
		T_JBV(446957, 4918926, 9668387, 60358251, 1511, 86356, 60579, 9000286787),
		T_JBV(446969, 4918938, 9668399, 60358359, 412310, 86356, 60579, 9000286799),
		T_JBV(446985, 4918955, 9668415, 60358508, 421616, 86356, 60579, 9000286815),
		T_JBV(447012, 4918991, 9668450, 60358771, 267347, 86356, 60579, 9000286842),
		T_JBV(447029, 4919009, 9668468, 60358926, 435153, 86356, 60579, 9000286859),
		T_JBV(447059, 4919039, 9668498, 60359196, 42100, 86356, 60579, 9000286889),
		T_JBV(446824, 4918787, 9668248, 60357037, 267350, 86356, 60579, 9000286654),
		T_JBV(446830, 4918793, 9668254, 60357093, 267273, 86356, 60579, 9000286660),
		T_JBV(446835, 4918799, 9668260, 60357139, 73646, 86356, 60579, 9000286665),
		T_JBV(446861, 4918829, 9668290, 60357384, 435202, 86356, 60579, 9000286691),
		T_JBV(446907, 4918876, 9668337, 60357799, 354079, 86356, 60579, 9000286736),
		T_JBV(446916, 4918885, 9668346, 60357880, 356725, 86356, 60579, 9000286745),
		T_JBV(446922, 4918891, 9668352, 60357934, 354089, 86356, 60579, 9000286751),
		T_JBV(446940, 4918909, 9668370, 60358098, 73139, 86356, 60579, 9000286769),
		T_JBV(446950, 4918919, 9668380, 60358188, 74288, 86356, 60579, 9000286780),
		T_JBV(446966, 4918935, 9668396, 60358332, 435155, 86356, 60579, 9000286796),
		T_JBV(446984, 4918954, 9668414, 60358499, 73574, 86356, 60579, 9000286814),
		T_JBV(447011, 4918990, 9668449, 60358762, 267226, 86356, 60579, 9000286841),
		T_JBV(447030, 4919010, 9668469, 60358935, 39038, 86356, 60579, 9000286860),
		T_JBV(447031, 4919011, 9668470, 60358944, 3387, 86356, 60579, 9000286861),
		T_JBV(447130, 4919113, 9668572, 60359839, 412322, 86356, 60579, 9000286960),
		T_JBV(446822, 4918785, 9668246, 60357019, 73010, 86356, 60579, 9000286652),
		T_JBV(446880, 4918849, 9668310, 60357556, 3867, 86356, 60579, 9000286710),
		T_JBV(446959, 4918928, 9668389, 60358269, 412323, 86356, 60579, 9000286789),
		T_JBV(446961, 4918930, 9668391, 60358287, 412320, 86356, 60579, 9000286791),
		T_JBV(446987, 4918957, 9668417, 60358526, 5439, 86356, 60579, 9000286817),
		T_JBV(447023, 4919003, 9668462, 60358872, 412339, 86356, 60579, 9000286853),
		T_JBV(447036, 4919016, 9668475, 60358989, 3866, 86356, 60579, 9000286866),
		T_JBV(447037, 4919017, 9668476, 60358998, 3868, 86356, 60579, 9000286867),
		T_JBV(447097, 4919080, 9668539, 60359542, 421695, 86356, 60579, 9000286927),
		T_JBV(447104, 4919087, 9668546, 60359605, 73566, 86356, 60579, 9000286934),
		T_JBV(447105, 4919088, 9668547, 60359614, 73386, 86356, 60579, 9000286935),
		T_JBV(447126, 4919109, 9668568, 60359803, 412327, 86356, 60579, 9000286956),
		T_JBV(447147, 4919132, 9668591, 60359996, 421678, 86356, 60579, 9000286977),
		T_JBV(447152, 4919137, 9668596, 60360041, 73062, 86356, 60579, 9000286982),
		T_JBV(446852, 4918818, 9668279, 60357297, 267352, 86356, 60579, 9000286682),
		T_JBV(446868, 4918837, 9668298, 60357448, 3677, 86356, 60579, 9000286698),
		T_JBV(446881, 4918850, 9668311, 60357565, 3987, 86356, 60579, 9000286711),
		T_JBV(446937, 4918906, 9668367, 60358071, 73492, 86356, 60579, 9000286766),
		T_JBV(446968, 4918937, 9668398, 60358350, 412333, 86356, 60579, 9000286798),
		T_JBV(446974, 4918943, 9668404, 60358407, 421630, 86356, 60579, 9000286804),
		T_JBV(446994, 4918973, 9668432, 60358609, 267220, 86356, 60579, 9000286824),
		T_JBV(446998, 4918977, 9668436, 60358645, 267255, 86356, 60579, 9000286828),
		T_JBV(447018, 4918997, 9668456, 60358825, 267302, 86356, 60579, 9000286848),
		T_JBV(447033, 4919013, 9668472, 60358962, 4707, 86356, 60579, 9000286863),
		T_JBV(447038, 4919018, 9668477, 60359007, 4021, 86356, 60579, 9000286868),
		T_JBV(447066, 4919046, 9668505, 60359259, 74867, 86356, 60579, 9000286896),
		T_JBV(447139, 4919123, 9668582, 60359922, 421684, 86356, 60579, 9000286969)

		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	TEX_ID := TRIM(V_TMP_JBV(3));

	TEX_TOKEN := TRIM(V_TMP_JBV(4));
  	
  	ACT_ID := TRIM(V_TMP_JBV(5));

	USU_ID := TRIM(V_TMP_JBV(6));

	SUP_ID := TRIM(V_TMP_JBV(7));

	TBJ_ID := TRIM(V_TMP_JBV(8));

	--COMPROBAMOS SI EXISTE TRABAJO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||TBJ_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAMOS TRABAJO '||TBJ_ID);

		--ACTUALIZAMOS ESTADO DE TRABAJO A 'EN TRAMITE'

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
					   SET DD_EST_ID = 4,
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE TBJ_NUM_TRABAJO = '||TBJ_ID;
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] ESTADO TRABAJO '||TBJ_ID||' ACTUALIZADO');

	--CREAMOS CAMPOS FORMULARIO TAREA

		--INSERT EN LA TEV

		V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''titulo'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
		EXECUTE IMMEDIATE V_SQL;
		V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''comboTramitar'',''01'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
		EXECUTE IMMEDIATE V_SQL;
		V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''motivoDenegacion'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
		EXECUTE IMMEDIATE V_SQL;
		V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''observaciones'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
		EXECUTE IMMEDIATE V_SQL;
	
		DBMS_OUTPUT.PUT_LINE('[INSERT] Insertado REGISTROS en TEV');
	
	--QUITAMOS EL TOKEN DEL TRAMITE

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TRA_ID = '||TRA_ID;
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
					   SET TRA_PROCESS_BPM = NULL,
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE TRA_ID = '||TRA_ID;
	

			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TRA_ID: '||TRA_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF;
	
	--CERRAMOS TAREA ACTUAL

		--UPDATE TAR_TAREAS_NOTIFICACIONES

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = '||TAR_ID;
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_2;
	
		IF V_NUM_FILAS_2 = 1 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES 
							   SET TAR_TAREA_FINALIZADA = 1, 
							   BORRADO = 1, 
							   FECHABORRAR = SYSDATE, 
							   USUARIOBORRAR = '''||V_USR||''', 
							   TAR_FECHA_FIN = SYSDATE
							   WHERE TAR_ID = '||TAR_ID;

	
			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TAR_ID: '||TAR_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_2 := V_COUNT_UPDATE_2 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF;

		--UPDATE TEX_TAREA_EXTERNA

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TEX_ID = '||TEX_ID;
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_3;
	
		IF V_NUM_FILAS_3 = 1 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA 
					   		  SET USUARIOBORRAR = '''||V_USR||''' 
							  , FECHABORRAR = SYSDATE
							  , BORRADO = 1 
					   		  WHERE TEX_ID = '||TEX_ID;

	
			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TEX_ID: '||TEX_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_3 := V_COUNT_UPDATE_3 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF; 

	--CREAMOS NUEVA TAREA 

		V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
				
		EXECUTE IMMEDIATE V_SQL INTO SEQ_TAR_ID;

		V_SQL := 'Insert into REM01.TAR_TAREAS_NOTIFICACIONES (TAR_ID,CLI_ID,EXP_ID,ASU_ID,TAR_TAR_ID,SPR_ID,SCX_ID,DD_EST_ID,DD_EIN_ID,DD_STA_ID,TAR_CODIGO,TAR_TAREA,TAR_DESCRIPCION,TAR_FECHA_FIN,TAR_FECHA_INI,TAR_EN_ESPERA,TAR_ALERTA,TAR_TAREA_FINALIZADA,TAR_EMISOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,PRC_ID,CMB_ID,SET_ID,TAR_FECHA_VENC,OBJ_ID,TAR_FECHA_VENC_REAL,DTYPE,NFA_TAR_REVISADA,NFA_TAR_FECHA_REVIS_ALER,NFA_TAR_COMENTARIOS_ALERTA,DD_TRA_ID,CNT_ID,TAR_DESTINATARIO,TAR_TIPO_DESTINATARIO,TAR_ID_DEST,PER_ID,RPR_REFERENCIA,T_REFERENCIA,SYS_GUID) 
			  values 
			  ('||SEQ_TAR_ID||',null,null,null,null,null,null,null,''61'',''839'',''1'',''Solicitud Cédula por gestoría'',''Solicitud Cédula por gestoría'',null,SYSDATE,''0'',''0'',''0'',null,''1'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',null,null,null,SYSDATE+20,null,null,''EXTTareaNotificacion'',''0'',null,null,null,null,null,null,null,null,null,null,null)';
	
		EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAR_TAREAS_NOTIFICACIONES');

	--CREAMOS REGISTRO EN TEX

		V_SQL := 'Insert into REM01.TEX_TAREA_EXTERNA (TEX_ID,TAR_ID,TAP_ID,TEX_TOKEN_ID_BPM,TEX_DETENIDA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEX_CANCELADA,TEX_NUM_AUTOP,DTYPE,RPR_REFERENCIA,T_REFERENCIA) 
			  values 
			  (S_TEX_TAREA_EXTERNA.NEXTVAL,'||SEQ_TAR_ID||',''10000000004688'',null,''0'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',null,''0'',''EXTTareaExterna'',null,null)';

		EXECUTE IMMEDIATE V_SQL;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TEX_TAREA_EXTERNA');

	--CREAMOS REGISTRO EN TAC

		V_SQL := 'Insert into REM01.TAC_TAREAS_ACTIVOS (TAR_ID,TRA_ID,ACT_ID,USU_ID,SUP_ID,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
			  values 
			  ('||SEQ_TAR_ID||','||TRA_ID||','||ACT_ID||','||USU_ID||','||SUP_ID||',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'')';

		EXECUTE IMMEDIATE V_SQL;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAC_TAREAS_ACTIVOS');

	--CREAMOS REGISTRO EN ETN

		V_SQL := 'Insert into REM01.ETN_EXTAREAS_NOTIFICACIONES (TAR_ID,TAR_FECHA_VENC_REAL,NFA_TAR_REVISADA,NFA_TAR_FECHA_REVIS_ALER,NFA_TAR_COMENTARIOS_ALERTA,DD_TRA_ID,TAR_TIPO_DESTINATARIO,TAR_ID_DEST,CNT_ID,PER_ID,SYS_GUID) 
			  values 
			  ('||SEQ_TAR_ID||',SYSDATE+6,null,null,null,null,null,null,null,null,null)';

		EXECUTE IMMEDIATE V_SQL;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAC_TAREAS_ACTIVOS');
        
   	ELSE
		
	DBMS_OUTPUT.PUT_LINE('[INFO] TRABAJO NO EXISTE');
		
	END IF; 

   	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN ACT_TRA_TRAMITE');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_2||' registros EN TAR_TAREAS_NOTIFICACIONES');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_3||' registros EN TEX_TAREA_EXTERNA');

	DBMS_OUTPUT.PUT_LINE('[INFO] SE LANZA SP ALTA_BPM_INSTANCES');

	REM01.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[FIN] FINAL EJECUCION SP ALTA_BPM_INSTANCES');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
