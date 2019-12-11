--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5915
--## PRODUCTO=NO
--## Finalidad: Vista para conocer el estado de los gastos
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20191210 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF; 

DECLARE
  V_MSQL VARCHAR2(16000 CHAR); 
  TABLE_COUNT NUMBER(1,0) := 0;  -- Vble. para validar la existencia de las Tablas.
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
  V_COLUMN_COUNT number(3); -- Vble. para validar la existencia de las Columnas.    
  V_COSTRAINT_COUNT number(3); -- Vble. para validar la existencia de las Constraints.
  ERR_NUM NUMBER; -- Numero de errores
  ERR_MSG VARCHAR2(2048); -- Mensaje de error
  V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_ESTADO_GASTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista que indica si la agrupación tiene activos que ha superado los 7 dias de margen para la publicación de oferas.'; -- Vble. para los comentarios de las tablas
    
BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  SELECT COUNT(*) INTO TABLE_COUNT FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRANDO VISTA  '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA);
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('[INFO] VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' BORRADA');
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA);
  V_MSQL:= '


CREATE VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' AS 
  WITH CARTERA AS 
      (  SELECT DD_CRA_DESCRIPCION, GPV_ACT.GPV_ID
         FROM REM01.DD_CRA_CARTERA CRA, REM01.ACT_ACTIVO ACT, REM01.GPV_ACT
         WHERE CRA.DD_CRA_ID = ACT.DD_CRA_ID
         AND ACT.ACT_ID = GPV_ACT.ACT_ID
       ) ,
       SUBCARTERA AS
       ( SELECT DD_SCR_DESCRIPCION, GPV_ACT.GPV_ID
         FROM REM01.DD_SCR_SUBCARTERA SCR, REM01.ACT_ACTIVO ACT, REM01.GPV_ACT
         WHERE SCR.DD_SCR_ID = ACT.DD_SCR_ID
         AND ACT.ACT_ID = GPV_ACT.ACT_ID
       ),
       DD_EAH AS
       ( SELECT DD_EAH_DESCRIPCION, GPV_ID, DD_EAH_CODIGO
         FROM REM01.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH, REM01.GGE_GASTOS_GESTION GGE
         WHERE GGE.DD_EAH_ID = EAH.DD_EAH_ID
       ),
       DD_EAP AS
       ( SELECT DD_EAP_DESCRIPCION, GPV_ID
         FROM REM01.DD_EAP_ESTADOS_AUTORIZ_PROP EAP, REM01.GGE_GASTOS_GESTION GGE
         WHERE GGE.DD_EAP_ID = EAP.DD_EAP_ID
       )
SELECT DESTINO,
       GPV_NUM_GASTO_HAYA,
       NUM_PROVISION_FONDOS,
       FECHA_ENVIO,
       TIPO,              
       ( SELECT MAX( DD_CRA_DESCRIPCION )
         FROM CARTERA
         WHERE 1 = 1
         AND TABLA.GPV_ID = CARTERA.GPV_ID
       ) AS DD_CRA_NOMBRE,  
       ( SELECT MAX(DD_SCR_DESCRIPCION)
         FROM SUBCARTERA
         WHERE 1 = 1
         AND TABLA.GPV_ID = SUBCARTERA.GPV_ID
       ) AS DD_SCR_NOMBRE,
       DD_EGA_DESCRIPCION AS ESTADO_GASTO,
       ( SELECT DD_EAH_DESCRIPCION FROM DD_EAH WHERE DD_EAH.GPV_ID = TABLA.GPV_ID ) AS ESTADO_AUTORIZACION_HAYA,
       ( SELECT DD_EAP_DESCRIPCION FROM DD_EAP WHERE DD_EAP.GPV_ID = TABLA.GPV_ID ) AS ESTADO_AUTORIZACION_PROPIETARIO,
       MOTIVO AS MOTIVO_NO_ENVIO
FROM
(  
  
SELECT ''UVEM'' AS DESTINO, 
       GPV_NUM_GASTO_HAYA,
       NUM_PROVISION_FONDOS,
       FECHA_PROCESADO AS FECHA_ENVIO,
       ''PROVISION'' AS TIPO,
       GPV.GPV_ID,
       EGA.DD_EGA_DESCRIPCION,
       NULL AS MOTIVO
FROM REM01.H_APR_AUX_I_RU_FACT_PROV HIS, REM01.GPV_GASTOS_PROVEEDOR GPV, DD_EGA_ESTADOS_GASTO EGA
WHERE TO_NUMBER( HIS.FAC_ID_REM ) = GPV.GPV_NUM_GASTO_HAYA
AND EGA.DD_EGA_ID = GPV.DD_EGA_ID
UNION
SELECT ''UVEM'' AS DESTINO, 
       GPV_NUM_GASTO_HAYA,
       NULL AS NUM_PROVISION_FONDOS,
       FECHA_PROCESADO AS FECHA_ENVIO,
       ''INDIVIDUAL'' AS TIPO,
       GPV.GPV_ID,
       EGA.DD_EGA_DESCRIPCION,       
       NULL AS MOTIVO       
FROM REM01.H_APR_AUX_I_RU_LFACT_SIN_PROV HIS, REM01.GPV_GASTOS_PROVEEDOR GPV, DD_EGA_ESTADOS_GASTO EGA
WHERE TO_NUMBER( HIS.FAC_ID_REM )  = GPV.GPV_NUM_GASTO_HAYA
AND EGA.DD_EGA_ID = GPV.DD_EGA_ID
UNION
SELECT ''ASPRO'' AS DESTINO,
       GPV_NUM_GASTO_HAYA,
       NULL AS NUM_PROVISION_FONDOS,
       FECHA_ENVIO,
       ''INDIVIDUAL'' AS TIPO,
       GPV.GPV_ID,
       EGA.DD_EGA_DESCRIPCION,
       NULL AS MOTIVO       
FROM REM01.H_ASPRO_10_CABECERA HIS, REM01.GPV_GASTOS_PROVEEDOR GPV, DD_EGA_ESTADOS_GASTO EGA
WHERE TO_NUMBER( HIS.NUFREM ) = GPV.GPV_NUM_GASTO_HAYA
AND EGA.DD_EGA_ID = GPV.DD_EGA_ID
AND HIS.COTIFA = ''R''
UNION
SELECT ''ASPRO'' AS DESTINO,
       GPV_NUM_GASTO_HAYA,
       PRG.PRG_NUM_PROVISION AS NUM_PROVISION_FONDOS,
       FECHA_ENVIO,
       ''PROVISION'' AS TIPO,
       GPV.GPV_ID,
       EGA.DD_EGA_DESCRIPCION,       
       NULL AS MOTIVO
FROM REM01.H_ASPRO_10_CABECERA HIS, REM01.GPV_GASTOS_PROVEEDOR GPV, REM01.PRG_PROVISION_GASTOS PRG, DD_EGA_ESTADOS_GASTO EGA
WHERE TO_NUMBER( HIS.NUFREM ) = PRG.PRG_NUM_PROVISION
AND PRG.PRG_ID = GPV.PRG_ID
AND EGA.DD_EGA_ID = GPV.DD_EGA_ID
AND HIS.COTIFA = ''A''
UNION
SELECT 
       CASE WHEN 0 < ( SELECT COUNT(1)
                       FROM REM01.GPV_ACT, REM01.ACT_ACTIVO ACT, REM01.DD_CRA_CARTERA CRA
                       WHERE GPV_ACT.ACT_ID = ACT.ACT_ID
                       AND GPV_ACT.GPV_ID = GPV.GPV_ID
                       AND ACT.DD_CRA_ID = CRA.DD_CRA_ID
                       AND CRA.DD_CRA_CODIGO = ''08''
                      ) THEN ''PRINEX''
       ELSE CASE WHEN DD_EGA_CODIGO IN ( ''04'', ''05'', ''06'' ) THEN '' ENVIADO SIN REGISTRO EN EL HISTÓRICO'' ELSE
       
       
           ''NO ENVIADO. DESTINO: '' || CASE WHEN 0 < ( SELECT COUNT(1)
                                                        FROM REM01.GPV_ACT, REM01.ACT_ACTIVO ACT, REM01.DD_CRA_CARTERA CRA
                                                        WHERE GPV_ACT.ACT_ID = ACT.ACT_ID
                                                        AND GPV_ACT.GPV_ID = GPV.GPV_ID
                                                        AND ACT.DD_CRA_ID = CRA.DD_CRA_ID
                                                        AND CRA.DD_CRA_CODIGO = ''03''
                                                       ) THEN ''UVEM'' ELSE ''ASPRO'' END      
        END                                               
       
       END AS DESTINO,
       GPV_NUM_GASTO_HAYA,
       NULL AS NUM_PROVISION_FONDOS,
       GGE.GGE_FECHA_ENVIO_PRPTRIO AS FECHA_ENVIO,
       CASE WHEN PVE_ID_GESTORIA IS NULL THEN ''INDIVIDUAL'' ELSE ''PROVISION'' END AS TIPO,
       GPV.GPV_ID,
       EGA.DD_EGA_DESCRIPCION,
       CASE WHEN DD_EGA_CODIGO NOT IN ( ''04'', ''05'', ''06'' ) THEN 
       
           CASE WHEN DD_EGA_CODIGO NOT IN ( ''03'' ) THEN ''ESTADO DEL GASTO DISTINTO A ''''Autorizado Administración'''' |'' END ||
           CASE WHEN GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL THEN ''FECHA ENVÍO PROPIETARIO INFORMADA: '' || GGE_FECHA_ENVIO_PRPTRIO || '' | '' END ||
           CASE WHEN PRG_ID IS NOT NULL THEN ''PROVISIÓN INFORMADA | '' END ||
           CASE WHEN ( ( SELECT DD_EAH_CODIGO FROM DD_EAH WHERE DD_EAH.GPV_ID = GPV.GPV_ID ) <> ''03'' OR ( SELECT DD_EAH_CODIGO FROM DD_EAH WHERE DD_EAH.GPV_ID = GPV.GPV_ID ) IS NULL ) THEN ''EL GASTO NO ESTÁ AUTORIZADO POR HAYA | '' END ||
           
            /* Es de Bankia ? */
            CASE WHEN 0 < ( SELECT COUNT(1)
                            FROM REM01.GPV_ACT, REM01.ACT_ACTIVO ACT, REM01.DD_CRA_CARTERA CRA
                            WHERE GPV_ACT.ACT_ID = ACT.ACT_ID
                            AND GPV_ACT.GPV_ID = GPV.GPV_ID
                            AND ACT.DD_CRA_ID = CRA.DD_CRA_ID
                            AND CRA.DD_CRA_CODIGO = ''03''
                           )  THEN

                                CASE WHEN PVE_ID_GESTORIA IS NOT NULL THEN 

                                    CASE WHEN GDE_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL AND GDE_IMP_IND_TIPO_IMPOSITIVO <> 0 THEN '' GASTO DE GESTORÍA PERO TIENE IVA INFORMADO '' || GDE_IMP_IND_TIPO_IMPOSITIVO || '' | '' END ||
                                    CASE WHEN GDE_IMP_IND_EXENTO = 1 THEN '' EL GASTO TIENE ACTIVO EL CHECK DE ''''Iva Exento'''' |'' END ||
                                    CASE WHEN COALESCE( GDE_PRINCIPAL_NO_SUJETO, 0 ) = 0 THEN ''EL IMPORTE DEL GASTO ES 0 |'' END                                   
                              /*  
                                ELSE
                                */

                                    /* PENDIENTE CASO REFACTURABLE */
				    CASE WHEN (     GDE.GDE_GASTO_REFACTURABLE = 1 
						AND GPV.DD_DEG_ID = ( SELECT DD_DEG_ID FROM REM01.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_ID=GPV.DD_DEG_ID AND DD_DEG_CODIGO = '02' ) 
					THEN ''GASTO REFACTURABLE Y CON DESTINATARIO ''''HAYA'''': NO SE ENVÍA A ''''UVEM''''  '' END	 

                                END



                              ELSE

                                CASE WHEN PVE_ID_GESTORIA IS NOT NULL THEN 

                                    CASE WHEN GDE_IMP_IND_TIPO_IMPOSITIVO IS NOT NULL AND GDE_IMP_IND_TIPO_IMPOSITIVO <> 0 THEN '' GASTO DE GESTORÍA PERO TIENE IVA INFORMADO '' || GDE_IMP_IND_TIPO_IMPOSITIVO || '' | '' END                                                                 

                                ELSE

                                    CASE WHEN GDE_IMP_IND_TIPO_IMPOSITIVO IS NULL AND COALESCE( GDE_IMP_IND_EXENTO, 0 ) = 0 THEN '' GASTO DE GESTORÍA NO TIENE IVA INFORMADO NI ESTÁ EXENTO  | '' END                                

                                END                              

            END

        ELSE ''''  

       END AS MOTIVO

FROM REM01.GPV_GASTOS_PROVEEDOR GPV, REM01.DD_EGA_ESTADOS_GASTO EGA, REM01.GGE_GASTOS_GESTION GGE, REM01.GDE_GASTOS_DETALLE_ECONOMICO GDE
WHERE PRG_ID IS NULL
AND EGA.DD_EGA_ID = GPV.DD_EGA_ID
AND GGE.GPV_ID = GPV.GPV_ID
AND GDE.GPV_ID = GPV.GPV_ID
AND NOT EXISTS ( SELECT 1 FROM REM01.H_ASPRO_10_CABECERA HIS
                 WHERE HIS.NUFREM = GPV.GPV_NUM_GASTO_HAYA )
AND NOT EXISTS ( SELECT 1 FROM REM01.H_APR_AUX_I_RU_LFACT_SIN_PROV HIS
                 WHERE FAC_ID_REM = GPV.GPV_NUM_GASTO_HAYA )

) TABLA
WHERE 1 = 1

';

  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[FIN] VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' CREADA');
  
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;        
	  
END;
/

EXIT;
