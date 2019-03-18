--/*
--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3500
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar un registro en ACT_TIT_TITULO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


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
  V_COUNT NUMBER(16);
        
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] SE INSERTAN REGISTROS EN ACT_TIT_TITULO VACIOS ');

 V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.ACT_TIT_TITULO
	(
	TIT_ID,
	ACT_ID,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT ' || V_ESQUEMA || '.S_ACT_TIT_TITULO.NEXTVAL AS TIT_ID, 
	ACT.ACT_ID,
	''REMVIP-3500'' AS USUARIOCREAR,
	SYSDATE AS FECHACREAR,
	0 AS BORRADO
	FROM ' || V_ESQUEMA || '.ACT_ACTIVO ACT
	LEFT JOIN ' || V_ESQUEMA || '.ACT_TIT_TITULO TIT ON 
	 ACT.ACT_ID = TIT.ACT_ID
	WHERE 1 = 1
	AND TIT.TIT_ID IS NULL
	AND ACT.ACT_NUM_ACTIVO IN
	(
	
	62831	,
	82059	,
	82259	,
	82332	,
	82333	,
	107580	,
	107856	,
	120770	,
	122896	,
	122897	,
	122948	,
	122949	,
	123825	,
	124052	,
	128676	,
	133887	,
	134058	,
	134486	,
	134947	,
	135220	,
	135330	,
	136900	,
	137017	,
	138552	,
	140677	,
	140678	,
	141726	,
	141841	,
	142989	,
	144476	,
	144723	,
	148770	,
	149476	,
	149516	,
	150092	,
	150093	,
	151116	,
	152872	,
	153806	,
	158493	,
	158933	,
	159250	,
	159425	,
	159770	,
	160041	,
	161160	,
	162151	,
	164285	,
	164595	,
	164719	,
	166804	,
	170416	,
	171563	,
	171564	,
	176987	,
	177083	,
	178989	,
	7005111	,
	7005112	,
	7005113	,
	7005114	,
	7005115	,
	7007126	,
	7012492	,
	7012493	,
	7012494	,
	7012495	,
	7012496	,
	7012497	,
	7012498	,
	7012499	,
	7012500	,
	7012501	,
	7012502	,
	7012503	,
	7030510	,
	7030512	,
	7030513	,
	7030515	,
	7071155	,
	7071156	,
	7071184	,
	7071207	,
	7071208	,
	7071656	,
	7071657	,
	7074356	,
	7074357	
	
	) 
	';			
    
   EXECUTE IMMEDIATE V_MSQL;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

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
