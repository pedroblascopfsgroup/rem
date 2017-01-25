--/*
--###########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20170109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-1365
--## PRODUCTO=NO
--## 
--## Finalidad: Corrección información adjudicación 
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_SQL1 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
--  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

--  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
--  V_ENTIDAD_ID NUMBER(16);
--  V_ID NUMBER(16);

  
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');


 
       -------------------------------------------------
       --Actualizamos dd_eti_id de tabla ACT_TIT_TITULO
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TABLA ACT_TIT_TITULO');
       
       V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO
                 SET   dd_eti_id = (select DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO where DD_ETI_CODIGO =  ''02'')
                     , usuariomodificar = ''HREOS-1365''
                     , fechamodificar    = sysdate
                 WHERE TIT_FECHA_INSC_REG is not null
                   AND (usuariomodificar = ''SP_UPA'' or usuariocrear = ''SP_UPA'')
                   AND dd_eti_id = (select DD_ETI_ID FROM  '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO where DD_ETI_CODIGO =  ''04'')'
                 ;
       
       
       EXECUTE IMMEDIATE V_SQL;
       
			
       DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.ACT_TIT_TITULO');
			

			
       -------------------------------------------------
       --Actualizamos dd_eti_id de tabla BIE_ADJ_ADJUDICACION
       -------------------------------------------------
       
       DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO TABLA BIE_ADJ_ADJUDICACION');
       
       V_SQL1 := ' MERGE INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ USING
                 (
                 WITH DISTINTOS AS (
                   SELECT APR_ID, NUMERO_ACTIVO, ROW_NUMBER () OVER (PARTITION BY NUMERO_ACTIVO ORDER BY APR_ID DESC) ORDEN
                   FROM '||V_ESQUEMA||'.APR_AUX_STOCK_BIENES APR
                 )
                 SELECT FECHA_AUTO_ADJUD, ACT.BIE_ID
                 FROM '||V_ESQUEMA||'.APR_AUX_STOCK_BIENES APR
                 LEFT JOIN DISTINTOS             ON DISTINTOS.APR_ID = APR.APR_ID
                 LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT  ON ACT.ACT_NUM_ACTIVO_UVEM = APR.NUMERO_ACTIVO
                 WHERE FECHA_AUTO_ADJUD IS NOT NULL         
                   AND ACT.BIE_ID       IS NOT NULL
                   AND DISTINTOS.ORDEN = 1
                 ) TMP
                 ON (ADJ.BIE_ID = TMP.BIE_ID)
                 WHEN MATCHED THEN UPDATE SET
                    ADJ.BIE_ADJ_F_DECRETO_N_FIRME = TMP.FECHA_AUTO_ADJUD,
                    ADJ.USUARIOMODIFICAR = ''HREOS-1365'',        
                    ADJ.FECHAMODIFICAR = sysdate
                 WHERE ADJ.BIE_ADJ_F_DECRETO_N_FIRME IS NOT NULL     
                   AND ADJ.USUARIOMODIFICAR = ''SP_UPA''
                   AND ADJ.BIE_ADJ_F_DECRETO_N_FIRME <> TMP.FECHA_AUTO_ADJUD'
                  ;
       
       
       EXECUTE IMMEDIATE V_SQL1;
       
			
       DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS EN '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION');
			
			
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

EXIT;

