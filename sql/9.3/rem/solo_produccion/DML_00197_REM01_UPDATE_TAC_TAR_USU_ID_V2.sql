--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6688
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6688_2'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    ECO_ID NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, ACT_ID, USU_ID, ECO_NUM_EXPEDIENTE

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(328221, 4344980 ,46033 ,39429 ,167282),
		T_JBV(339594, 4386790 ,48835 ,39429 ,169790),
		T_JBV(342439, 4415973 ,46379 ,39314 ,170298),
		T_JBV(360346, 4478390 ,42920 ,39745 ,174597),
		T_JBV(377855, 4573613 ,48186 ,39457 ,178762),
		T_JBV(380093, 4575802 ,39734 ,81064 ,179356),
		T_JBV(398672, 4839677 ,50782 ,39745 ,184755),
		T_JBV(401723, 4723830 ,73960 ,81064 ,185563),
		T_JBV(402879, 4703568 ,262302 ,39745 ,185842),
		T_JBV(406887, 4726361 ,263974 ,81064 ,186920),
		T_JBV(408495, 4731872 ,46306 ,39745 ,187171),
		T_JBV(412949, 4783247 ,42266 ,69814 ,188205),
		T_JBV(413644, 4918277 ,416178 ,81064 ,188344),
		T_JBV(413645, 4763989 ,13316 ,39429 ,188345),
		T_JBV(416360, 4772854 ,74964 ,39745 ,189064),
		T_JBV(417261, 4775922 ,49694 ,39745 ,189221),
		T_JBV(419524, 4842679 ,2861 ,81064 ,189574),
		T_JBV(420180, 4788345 ,67567 ,39688 ,189732),
		T_JBV(427099, 4843932 ,4061 ,39429 ,190983),
		T_JBV(429614, 4956294 ,40380 ,39745 ,191498),
		T_JBV(430606, 4854969 ,40070 ,39429 ,191694),
		T_JBV(432001, 4841632 ,2103 ,81064 ,192229),
		T_JBV(432235, 4855494 ,2992 ,40000 ,192267),
		T_JBV(433171, 4856955 ,54302 ,81064 ,192464),
		T_JBV(433519, 4936776 ,3800 ,81064 ,192506),
		T_JBV(435827, 4859595 ,39732 ,69814 ,193174),
		T_JBV(435890, 4953240 ,4466 ,81064 ,193202),
		T_JBV(437072, 4883678 ,3153 ,39745 ,193478),
		T_JBV(438070, 4909992 ,3892 ,81064 ,193668),
		T_JBV(438946, 4889009 ,2047 ,39429 ,193793),
		T_JBV(439323, 4924074 ,409910 ,81064 ,193921),
		T_JBV(440024, 4900443 ,4045 ,39429 ,194125),
		T_JBV(440339, 4894767 ,139 ,39745 ,194198),
		T_JBV(441309, 4903604 ,44653 ,39429 ,194291),
		T_JBV(441736, 4909774 ,42961 ,81064 ,194368),
		T_JBV(442676, 4962587 ,40364 ,39429 ,194590),
		T_JBV(442786, 4911895 ,3427 ,39429 ,194617),
		T_JBV(443208, 4909718 ,245 ,81064 ,194698),
		T_JBV(443500, 4921444 ,272545 ,81064 ,194719),
		T_JBV(443861, 4899305 ,13185 ,42892 ,194826),
		T_JBV(444161, 4957520 ,74030 ,39745 ,194894),
		T_JBV(444369, 4933724 ,46548 ,39422 ,194934),
		T_JBV(444892, 4915754 ,260666 ,39429 ,195055),
		T_JBV(445505, 4923488 ,3679 ,81064 ,195285),
		T_JBV(445689, 4988438 ,291482 ,39745 ,195334),
		T_JBV(445819, 4917059 ,53866 ,39429 ,195359),
		T_JBV(446368, 4917028 ,73520 ,81064 ,195580),
		T_JBV(446464, 4922299 ,4570 ,81064 ,195604),
		T_JBV(446485, 4916658 ,6080 ,81064 ,195614),
		T_JBV(446572, 4924892 ,4860 ,39745 ,195635),
		T_JBV(446685, 4921034 ,4941 ,39429 ,195684),
		T_JBV(446700, 4918067 ,73640 ,81064 ,195688),
		T_JBV(447167, 4940439 ,123049 ,39745 ,195708),
		T_JBV(447875, 4975104 ,49612 ,81064 ,195742),
		T_JBV(448029, 4920822 ,73162 ,81064 ,195753),
		T_JBV(448292, 4923868 ,73635 ,81064 ,195848),
		T_JBV(448321, 4926880 ,73341 ,39429 ,195856),
		T_JBV(448482, 4949793 ,2167 ,39745 ,195867),
		T_JBV(448728, 4938091 ,4194 ,81064 ,195938),
		T_JBV(448942, 4956690 ,53006 ,39745 ,195986),
		T_JBV(449220, 4927585 ,49470 ,81064 ,196073),
		T_JBV(449330, 4984820 ,262379 ,39745 ,196114),
		T_JBV(449543, 4929011 ,2341 ,39429 ,196141),
		T_JBV(449607, 4976403 ,4192 ,81064 ,196166),
		T_JBV(449938, 4931017 ,73080 ,39429 ,196227),
		T_JBV(449990, 4935130 ,73258 ,81064 ,196246),
		T_JBV(450218, 4956044 ,263225 ,39745 ,196283),
		T_JBV(450341, 4988030 ,267474 ,39745 ,196315),
		T_JBV(450462, 4940614 ,272974 ,39548 ,196371),
		T_JBV(450516, 4948642 ,73786 ,81064 ,196399),
		T_JBV(450939, 4936667 ,73689 ,81064 ,196505),
		T_JBV(450941, 4937052 ,73473 ,81064 ,196507),
		T_JBV(450970, 4936361 ,73297 ,81064 ,196529),
		T_JBV(451275, 4940298 ,73342 ,39429 ,196614),
		T_JBV(451985, 4941743 ,3183 ,39745 ,196646),
		T_JBV(452274, 4941200 ,1173 ,81064 ,196684),
		T_JBV(452474, 4956615 ,53819 ,39745 ,196703),
		T_JBV(452544, 4956213 ,40365 ,39429 ,196733),
		T_JBV(452565, 4987167 ,418253 ,39429 ,196744),
		T_JBV(452847, 4943658 ,73415 ,81064 ,196814),
		T_JBV(452981, 4970704 ,333941 ,81064 ,196849),
		T_JBV(453093, 4945146 ,415140 ,39745 ,196887),
		T_JBV(453105, 4945316 ,73638 ,39745 ,196891),
		T_JBV(453134, 4945511 ,73036 ,39429 ,196897),
		T_JBV(453187, 4968713 ,344965 ,39745 ,196921),
		T_JBV(453325, 4946670 ,75098 ,39745 ,196963),
		T_JBV(453612, 4948368 ,75078 ,39429 ,197046),
		T_JBV(453962, 4949588 ,73458 ,39745 ,197108),
		T_JBV(454202, 4951408 ,1920 ,39429 ,197209),
		T_JBV(455483, 4957013 ,73581 ,39429 ,197443),
		T_JBV(455541, 4957076 ,73417 ,39745 ,197478),
		T_JBV(455716, 4957779 ,73330 ,39745 ,197535),
		T_JBV(455730, 4960311 ,1919 ,39745 ,197541),
		T_JBV(455822, 4958380 ,73441 ,81064 ,197566),
		T_JBV(455866, 4958552 ,73044 ,39745 ,197582),
		T_JBV(455880, 4958648 ,72994 ,39745 ,197588),
		T_JBV(456061, 4969283 ,122729 ,39745 ,197673),
		T_JBV(456222, 4983015 ,263220 ,39745 ,197726),
		T_JBV(456379, 4961948 ,13167 ,39429 ,197773),
		T_JBV(457243, 4991099 ,52237 ,39429 ,197880),
		T_JBV(457403, 4965830 ,42360 ,39429 ,197953),
		T_JBV(457445, 5017680 ,422451 ,39745 ,197971),
		T_JBV(457455, 4971627 ,2759 ,81064 ,197976),
		T_JBV(457506, 4975133 ,42155 ,39745 ,198001),
		T_JBV(457621, 4967312 ,37717 ,39429 ,198062),
		T_JBV(457698, 4967857 ,73637 ,39429 ,198078),
		T_JBV(457780, 4986441 ,123003 ,39429 ,198111),
		T_JBV(457873, 4968385 ,73381 ,81064 ,198127),
		T_JBV(457888, 5000452 ,272584 ,81064 ,198131),
		T_JBV(457891, 5019378 ,4697 ,39429 ,198133),
		T_JBV(457903, 4968750 ,73177 ,81064 ,198136),
		T_JBV(458208, 4977970 ,350536 ,81064 ,198173),
		T_JBV(458331, 4970610 ,73032 ,39429 ,198223),
		T_JBV(458344, 5001526 ,73288 ,39429 ,198231),
		T_JBV(458362, 4972348 ,73432 ,39429 ,198243),
		T_JBV(458428, 5018731 ,47002 ,39429 ,198271),
		T_JBV(458635, 4991731 ,259564 ,39745 ,198332),
		T_JBV(458687, 4972648 ,73525 ,81064 ,198344),
		T_JBV(458694, 4972674 ,73658 ,39429 ,198346),
		T_JBV(458950, 4974232 ,73163 ,39745 ,198402),
		T_JBV(459651, 4977000 ,37719 ,81064 ,198539),
		T_JBV(459677, 5009145 ,46312 ,81064 ,198552),
		T_JBV(459681, 5019153 ,411577 ,39745 ,198555),
		T_JBV(460122, 5016543 ,258884 ,81064 ,198666),
		T_JBV(460272, 4983285 ,53858 ,81064 ,198718),
		T_JBV(460285, 4983287 ,53869 ,39745 ,198723),
		T_JBV(460888, 5006646 ,122715 ,81064 ,198767),
		T_JBV(461325, 5003335 ,334326 ,39745 ,198888),
		T_JBV(461351, 5017413 ,291848 ,39429 ,198898),
		T_JBV(461993, 5003818 ,2655 ,39429 ,199059),
		T_JBV(462434, 5000230 ,2168 ,39429 ,199172),
		T_JBV(462825, 5026450 ,46546 ,39745 ,199223),
		T_JBV(462862, 5022398 ,291818 ,39745 ,199239),
		T_JBV(463092, 5012249 ,42812 ,39745 ,199300),
		T_JBV(464321, 5005640 ,122860 ,39429 ,199597),
		T_JBV(465484, 5016616 ,269735 ,39745 ,199850),
		T_JBV(466231, 5021664 ,354842 ,39429 ,199912),
		T_JBV(466787, 5026496 ,412005 ,39745 ,200072),
		T_JBV(466890, 5014958 ,347683 ,39429 ,200098),
		T_JBV(467080, 5016297 ,346536 ,39429 ,200149),
		T_JBV(467126, 5016183 ,260467 ,39429 ,200162),
		T_JBV(468072, 5025334 ,42363 ,39429 ,200359)


		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	ACT_ID := TRIM(V_TMP_JBV(3));

	USU_ID := TRIM(V_TMP_JBV(4));
  	
  	ECO_ID := TRIM(V_TMP_JBV(5));


	--COMPROBAMOS SI EXISTE TRABAJO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||ECO_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 
	
	--QUITAMOS EL TOKEN DEL TRAMITE

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
					   SET USU_ID = '||USU_ID||',
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	

			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TRA_ID: '||TRA_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF;
        
   	ELSE
		
	DBMS_OUTPUT.PUT_LINE('[INFO] EXPEDIENTE NO EXISTE');
		
	END IF; 

   	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN TAC_TAREAS_ACTIVOS');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

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
