--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12523
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tipos/subtipos trabajo
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USU VARCHAR2(50 CHAR):= 'REMVIP-12523';

BEGIN

      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización act_tbj_trabajo');
		     
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 USING (
SELECT DISTINCT
tbj.tbj_id,
TTR.DD_TTR_CODIGO,
STR.DD_STR_CODIGO,
TTR2.DD_TTR_CODIGO AS TIPO_PONER,
STR2.DD_STR_CODIGO AS SUBTIPO_PONER
FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
JOIN '||V_ESQUEMA||'.dd_ttr_tipo_trabajo TTR ON TTR.DD_TTR_ID=TBJ.DD_TTR_ID AND TTR.BORRADO = 0 AND ttr.dd_ttr_filtrar IS NULL
JOIN '||V_ESQUEMA||'.dd_str_subtipo_trabajo STR ON STR.DD_STR_ID=TBJ.DD_STR_ID AND STR.BORRADO = 0
JOIN '||V_ESQUEMA||'.AUX_REMVIP_12523 AUX ON aux.trabajo=TBJ.TBJ_NUM_TRABAJO
JOIN '||V_ESQUEMA||'.dd_str_subtipo_trabajo STR2 ON STR2.DD_STR_CODIGO=aux.subtipo_cod AND STR2.BORRADO = 0
JOIN '||V_ESQUEMA||'.dd_ttr_tipo_trabajo TTR2 ON TTR2.DD_TTR_ID=STR2.DD_TTR_ID AND TTR2.BORRADO = 0 --AND ttr.dd_ttr_filtrar IS NULL

WHERE TBJ.BORRADO = 0 AND STR.DD_STR_CODIGO!=STR2.DD_STR_CODIGO
AND TBJ.TBJ_ID NOT IN (SELECT DISTINCT GLTJ.TBJ_ID FROM '||V_ESQUEMA||'.gld_tbj GLTJ WHERE GLTJ.BORRADO = 0)
and TBJ.tbj_id not in (992358,
895622,
1034125,
1053729,
984262,
972604,
985767,
1135736,
1105679,
1098265,
945616,
963724,
776366,
959524,
1033782,
1052218,
1062732,
1150214,
976912,
967368,
986107,
1063180,
1045780,
1064112,
887675,
974822,
1013258,
1100529,
1115291,
1091626,
970868,
1091558,
1080636,
970030,
1146796,
1144364,
1073112,
1080612,
1043052,
1110091,
1123836,
1031525,
1013099,
771596,
881522,
887651,
982911,
1093452,
874455,
773908,
1034752,
1155599,
1032674,
1026298,
1094408,
923038,
985663,
959568,
893768,
1089474,
1093532,
972064,
1113961,
1120827,
1084400,
1066642,
773950,
926066,
977948,
986091,
1134732,
773956,
1131416,
979697,
985008,
1124082,
885868,
988229)

                            ) T2
                        ON (T1.TBJ_ID = T2.TBJ_ID)
                        WHEN MATCHED THEN UPDATE SET
                        T1.DD_STR_ID = T2.SUBTIPO_PONER ,
                        T1.DD_TTR_ID = T2.TIPO_PONER ,
                        T1.USUARIOMODIFICAR = '''||V_USU||''',
                        T1.FECHAMODIFICAR = SYSDATE';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS  '||SQL%ROWCOUNT||' ACTUALIZADOS');

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;