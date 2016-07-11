--/*
--###########################################
--## AUTOR=Pablo Meseguer 
--## FECHA_CREACION=20160523
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-477
--## PRODUCTO=NO
--## 
--## Finalidad: Crear los registros correspondientes en ACT_PAC_PROPIETARIO_ACTIVO tras su alta en ACT_ACTIVO
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
  V_COL_EXISTS NUMBER(16); -- Vble. para almacenar la existencia de una columna.
  V_NUM_INSERTS NUMBER(16); -- Vble. para almacenar los inserts realizados.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO, DE INSERCION DE ACT_PAC_PROPIETARIO_ACTIVO');
          
    
    -- INSERTAMOS EN ACT_PAC_PROPIETARIO_ACTIVO LOS REGISTROS CORRESPONDIENTES A LOS NUEVOS ACTIVOS DE ACT_ACTIVO
    
    V_SQL := '
		 MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
		 USING (
				SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				WHERE ACT.USUARIOCREAR = ''APR''
				AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CARTERA.DD_CRA_CODIGO = ''02'')
		 ) TMP
		 ON (PAC.ACT_ID = TMP.ACT_ID)
		 WHEN NOT MATCHED THEN INSERT (
		 PAC_ID, 
		 ACT_ID, 
		 PRO_ID, 
		 DD_TGP_ID, 
		 PAC_PORC_PROPIEDAD, 
		 USUARIOCREAR, 
		 FECHACREAR)
		 VALUES (
		 '||V_ESQUEMA||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL,
		 TMP.ACT_ID,
		 (SELECT PRO_ID FROM ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_CODIGO_UVEM = 100000002),
		 NULL,
		 0,
		 ''HREOS-477'',
		 SYSDATE)
		 '
         ;
         
    EXECUTE IMMEDIATE V_SQL;
    
    V_NUM_INSERTS := sql%rowcount;
    
    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO ANALIZADA.');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INSERTADO '||V_NUM_INSERTS||' REGISTROS EN ACT_PAC_PROPIETARIO_ACTIVO.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA ACT_PAC_PROPIETARIO_ACTIVO SE HA ACTUALIZADO CORRECTAMENTE');
 
 
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
