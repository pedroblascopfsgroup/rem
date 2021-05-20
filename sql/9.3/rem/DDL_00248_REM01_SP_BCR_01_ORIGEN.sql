--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13942
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_01_ORIGEN
        (     
	  FLAG_INS_UPD IN NUMBER
        , SALIDA OUT VARCHAR2
        , COD_RETORNO OUT NUMBER
   
    )

   AS

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

   IF FLAG_INS_UPD = 1 THEN

      DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A INSERTAR.');

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_ACTIVO(
               ACT_ID,
               ACT_NUM_ACTIVO,
               ACT_NUM_ACTIVO_REM,
               ACT_NUM_ACTIVO_CAIXA,
               DD_TTA_ID,
               DD_STA_ID,
               DD_PRP_ID,
               DD_SCR_ID,
               DD_CRA_ID,
               DD_SPG_ID,
               USUARIOCREAR,
               FECHACREAR)

               SELECT
               '|| V_ESQUEMA ||'.S_ACT_ACTIVO.NEXTVAL AS ACT_ID,
               ACT_NUM_ACTIVO,
               ACT_NUM_ACTIVO_REM,
               ACT_NUM_ACTIVO_CAIXA,
               DD_TTA_ID,
               DD_STA_ID,
               DD_PRP_ID,
               DD_SCR_ID,
               DD_CRA_ID,
               DD_SPG_ID,
               ''HREOS-14023'' AS USUARIOCREAR,
               sysdate AS FECHACREAR
               FROM(

               SELECT 
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO,
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_REM,
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
               STA.DD_TTA_ID AS DD_TTA_ID,
               STA.DD_STA_ID AS DD_STA_ID,
               prp.DD_PRP_ID,
               SCR.DD_SCR_ID AS DD_SCR_ID,
               SCR.DD_CRA_ID AS DD_CRA_ID,
               SPG.DD_SPG_ID

               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DD_STA_CODIGO''  AND eqv1.DD_CODIGO_CAIXA = aux.PRODUCTO
               LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_CODIGO = eqv1.DD_CODIGO_REM
               LEFT JOIN '|| V_ESQUEMA ||'.DD_PRP_PROCEDENCIA_PRODUCTO prp ON prp.DD_PRP_CODIGO = aux.PROCEDENCIA_PRODUCTO
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''DD_SCR_CODIGO''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_ORIGEN
               LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = eqv2.DD_CODIGO_REM
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''DD_SPG_CODIGO''  AND eqv3.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN
               LEFT JOIN '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR spg ON spg.DD_SPG_CODIGO = eqv3.DD_CODIGO_REM
               WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act 
                  WHERE aux.NUM_IDENTIFICATIVO  = act.ACT_NUM_ACTIVO_CAIXA AND act.borrado=0
               ))';
   
      EXECUTE IMMEDIATE V_MSQL;
   
   
   ELSE

      DBMS_OUTPUT.PUT_LINE('[INFO] SE VA A PROCEDER A ACTUALIZAR.');

       V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO act
				using (				
                SELECT 
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_REM,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
                  STA.DD_TTA_ID AS DD_TTA_ID,
                  STA.DD_STA_ID AS DD_STA_ID,
                  prp.DD_PRP_ID,
                  SCR.DD_SCR_ID AS DD_SCR_ID,
                  SCR.DD_CRA_ID AS DD_CRA_ID,
                  SPG.DD_SPG_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DD_STA_CODIGO''  AND eqv1.DD_CODIGO_CAIXA = aux.PRODUCTO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_CODIGO = eqv1.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PRP_PROCEDENCIA_PRODUCTO prp ON prp.DD_PRP_CODIGO = aux.PROCEDENCIA_PRODUCTO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''DD_SCR_CODIGO''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_ORIGEN
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = eqv2.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''DD_SPG_CODIGO''  AND eqv3.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR spg ON spg.DD_SPG_CODIGO = eqv3.DD_CODIGO_REM              
                                    
                              ) us ON (us.ACT_NUM_ACTIVO_CAIXA = act.ACT_NUM_ACTIVO_CAIXA)
                              when matched then update set
                                 act.DD_TTA_ID = us.DD_TTA_ID  
                                 ,act.DD_STA_ID = us.DD_STA_ID
                                    ,act.DD_PRP_ID = us.DD_PRP_ID
                                    ,act.DD_SCR_ID = us.DD_SCR_ID
                                    ,act.DD_CRA_ID = us.DD_CRA_ID
                                    ,act.DD_SPG_ID = us.DD_SPG_ID
                                    ,act.USUARIOMODIFICAR = ''HREOS-14023''
                                    ,act.FECHAMODIFICAR = sysdate';


   EXECUTE IMMEDIATE V_MSQL;
   END IF;
   
 

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_01_ORIGEN;
/
EXIT;
