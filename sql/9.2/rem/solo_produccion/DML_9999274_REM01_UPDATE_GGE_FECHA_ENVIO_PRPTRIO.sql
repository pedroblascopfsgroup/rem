--/*
--##########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20190128
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2878
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de gastos
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
	V_TIPO_ID NUMBER(16); --Vle para el id DD_TTR_TIPO_TRABAJO
           
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- Updatear los valores en GGE_GASTOS_GESTION -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN GGE_GASTOS_GESTION] ');
         
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: QUITAMOS LA FECHA DE ENVIO A PROPIETARIO DE LOS GASTOS');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE
						SET GGE_FECHA_ENVIO_PRPTRIO = NULL,
						USUARIOMODIFICAR = ''REMVIP-2878'',
						FECHAMODIFICAR = SYSDATE
						WHERE EXISTS(
						SELECT 1
						FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
						INNER JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE1 ON GGE1.GPV_ID = GPV.GPV_ID
						WHERE GGE1.GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL
						AND GGE.GGE_ID = GGE1.GGE_ID
						AND GPV.GPV_NUM_GASTO_HAYA IN (
						9668112,
						9668113,
						9668114,
						9668115,
						9668116,
						9668424,
						9668477,
						9668478,
						9668479,
						9668483,
						9668484,
						9704175,
						9704178,
						9704179,
						9704180,
						9704181,
						9704323,
						9704454,
						9704455,
						9704456,
						9704465,
						9704466,
						9704557,
						9704558,
						9704569,
						9704570,
						9704571,
						9704572,
						9704573,
						9704574,
						9704575,
						9704576,
						9704577,
						9704578,
						9704579,
						9704580,
						9704581,
						9704582,
						9704583,
						9704584,
						9704648,
						9704649,
						9704650,
						9704651,
						9704652,
						9704653,
						9704654,
						9704655,
						9704656,
						9704657,
						9704658,
						9704659,
						9704660,
						9704661,
						9704662,
						9704663,
						9704664,
						9704665,
						9704766,
						9704767,
						9704768,
						9704769,
						9704770,
						9704771,
						9704772,
						9704773,
						9704774,
						9704775,
						9704776,
						9704777,
						9704802,
						9704803,
						9727127,
						9727128,
						9727129,
						9727136,
						9727145,
						9727146,
						9727147,
						9727183,
						9727184,
						9727185,
						9727186,
						9727187,
						9727197,
						9727198,
						9727199,
						9727200,
						9727217,
						9727218,
						9727219,
						9727220,
						10010400,
						10010413,
						10010510,
						10010522,
						10010539,
						10010551,
						10010555,
						10010556,
						10010557,
						10010558,
						10010559,
						10010560,
						10010609,
						10010649,
						10010650,
						10010677,
						10010678,
						10010739,
						10010766,
						10010767,
						10010768,
						10010777,
						10010778,
						10010779,
						10010780,
						10010781,
						10010790,
						10010908,
						10010936,
						10010937,
						10010938,
						10010939,
						10010948,
						10059464,
						10059480,
						10059481,
						10059482,
						10059490,
						10059660,
						10059662,
						10059663,
						10059664,
						10059665,
						10059711,
						10059712,
						10059713,
						10059714,
						10059715,
						10059716,
						10059717,
						10059811,
						10059972,
						10162788))';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: FECHA DE ENVIO A PROPIETARIO  ELIMINADA PARA '||SQL%ROWCOUNT||' GASTOS');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR ACTUALIZADA CORRECTAMENTE');   

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


