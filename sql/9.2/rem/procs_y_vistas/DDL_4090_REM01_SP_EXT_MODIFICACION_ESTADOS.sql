--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3906
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_MODIFICACION_ESTADOS
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190412)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       SP_EXT_MODIFICACION_ESTADOS (
         GPV_NUM_GASTO_HAYA IN  REM01.RSR_REGISTRO_SQLS.RSR_SALIDA_LOG%TYPE,
         V_USUARIO       VARCHAR2 DEFAULT 'SP_EXT_MODIFICACION_ESTADOS',
         DD_EGA_CODIGO VARCHAR2 DEFAULT NULL,
         DD_EAH_CODIGO VARCHAR2 DEFAULT NULL,
         DD_EAP_CODIGO VARCHAR2 DEFAULT NULL,    
         GGE_FECHA_EAH DATE DEFAULT NULL,
         GGE_FECHA_EAP DATE DEFAULT NULL,
         PRG_ID INTEGER DEFAULT NULL,
         GGE_FECHA_ENVIO_PRPTRIO DATE DEFAULT NULL,
         COD_RETORNO    OUT NUMBER
) AS

--

-- GPV_NUM_GASTO_HAYA se utiliza en una expresión de tipo 'IN' con lo que puede
-- ponerse 1 o múltiples identificadores separados por ',', con limite de 400
V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN


    COD_RETORNO := 0;

    --Actualiza GGE_GASTOS_GESTION :

	V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.GGE_GASTOS_GESTION T1 USING
    (
        SELECT GPV.GPV_ID
        FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
        JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
        WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )

    )T2 ON (T1.GPV_ID = T2.GPV_ID)
    WHEN MATCHED THEN
    UPDATE
    SET ' || CASE WHEN DD_EAH_CODIGO IS NOT NULL THEN ' T1.DD_EAH_ID = (SELECT DD_EAH_ID FROM  ' || V_ESQUEMA || '.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''' || DD_EAH_CODIGO || '''), ' END 
          || CASE WHEN GGE_FECHA_EAH IS NOT NULL THEN ' T1.GGE_FECHA_EAH = ''' || GGE_FECHA_EAH || ''', ' END
          || CASE WHEN DD_EAH_CODIGO IS NOT NULL THEN ' T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM  ' || V_ESQUEMA || '.DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''' || DD_EAH_CODIGO || '''), ' END
          || CASE WHEN GGE_FECHA_EAP IS NOT NULL THEN ' T1.GGE_FECHA_EAP = ''' || GGE_FECHA_EAP || ''',' END
          || CASE WHEN GGE_FECHA_ENVIO_PRPTRIO IS NOT NULL THEN ' T1.GGE_FECHA_ENVIO_PRPTRIO = ''' || GGE_FECHA_ENVIO_PRPTRIO || ''', ' END 
          || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
          || ' T1.FECHAMODIFICAR = SYSDATE ' ;  

        EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificados '||SQL%ROWCOUNT||' registro/s en la GGE_GASTOS_GESTION.');

    --Actualiza GPV_GASTOS_PROVEEDOR: 	

	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR T1 USING
    (
        SELECT GPV.GPV_ID
        FROM ' || V_ESQUEMA || '.GPV_GASTOS_PROVEEDOR GPV
        JOIN ' || V_ESQUEMA || '.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
        WHERE GPV.GPV_NUM_GASTO_HAYA IN (  ' || GPV_NUM_GASTO_HAYA || '  )

    )T2 ON (T1.GPV_ID = T2.GPV_ID) 
    WHEN MATCHED THEN
        UPDATE
        SET ' || CASE WHEN  DD_EGA_CODIGO IS NOT NULL THEN ' T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''' || DD_EGA_CODIGO || '''), ' END
              || CASE WHEN  PRG_ID IS NOT NULL THEN  'T1.PRG_ID = ' || PRG_ID || ', ' END
    	      || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
              || ' T1.FECHAMODIFICAR = SYSDATE' ; 

        EXECUTE IMMEDIATE V_SQL;


       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s '||SQL%ROWCOUNT||' registro/s en la GPV_GASTOS_PROVEEDOR.');

       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s ' ||SQL%ROWCOUNT||' gasto/s.');


   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_MODIFICACION_ESTADOS;
/
EXIT
