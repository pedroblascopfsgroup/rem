--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190607
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4444
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_MODIFICACION_ESTADOS_PF
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Oscar Diestre-Versión inicial (20190607)
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE       SP_EXT_MODIFICACION_ESTADOS_PF (
         PRG_NUM_PROVISION IN  REM01.RSR_REGISTRO_SQLS.RSR_SALIDA_LOG%TYPE,
         V_USUARIO       VARCHAR2 DEFAULT 'SP_EXT_MODIFICACION_ESTADOS_PF',

         DD_EPR_CODIGO VARCHAR2 DEFAULT NULL,
	 UPDATE_DD_EPR INTEGER DEFAULT 0,

         PVE_ID_GESTORIA VARCHAR2 DEFAULT NULL,
	 UPDATE_PVE_ID_GESTORIA INTEGER DEFAULT 0,

         COD_RETORNO    OUT NUMBER
) AS

--

-- PRG_NUM_PROVISION se utiliza en una expresión de tipo 'IN' con lo que puede
-- ponerse 1 o múltiples identificadores separados por ',', con limite de 400
V_SQL VARCHAR2(32000 CHAR); 											-- Sentencia a ejecutar.
V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 								-- Configuracion Esquema.
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    COD_RETORNO := 0;

	V_SQL := '
	MERGE INTO ' || V_ESQUEMA || '.PRG_PROVISION_GASTOS T1 USING
    (
        SELECT PRG.PRG_ID
        FROM ' || V_ESQUEMA || '.PRG_PROVISION_GASTOS PRG
        WHERE PRG.PRG_NUM_PROVISION IN (  ' || PRG_NUM_PROVISION || '  )

    )T2 ON (T1.PRG_ID = T2.PRG_ID) 
    WHEN MATCHED THEN
        UPDATE
        SET ' || CASE WHEN ( ( DD_EPR_CODIGO IS NOT NULL ) AND ( UPDATE_DD_EPR = 1 ) ) THEN ' T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM ' || V_ESQUEMA || '.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''' || DD_EPR_CODIGO || '''), ' END
	      || CASE WHEN ( ( DD_EPR_CODIGO IS NULL ) AND ( UPDATE_DD_EPR = 1 ) ) THEN ' T1.DD_EPR_ID = NULL, ' END

              || CASE WHEN ( ( PVE_ID_GESTORIA IS NOT NULL ) AND ( UPDATE_PVE_ID_GESTORIA = 1 ) ) THEN  'T1.PVE_ID_GESTORIA = ' || PVE_ID_GESTORIA || ', ' END
              || CASE WHEN ( ( PVE_ID_GESTORIA IS NULL     ) AND ( UPDATE_PVE_ID_GESTORIA = 1 ) ) THEN  'T1.PVE_ID_GESTORIA = NULL, ' END

    	      || ' T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', '
              || ' T1.FECHAMODIFICAR = SYSDATE' ; 

        EXECUTE IMMEDIATE V_SQL;


       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s '||SQL%ROWCOUNT||' registro/s en la PRG_PROVISION_GASTOS.');

       DBMS_OUTPUT.PUT_LINE('[INFO] - Modificado/s ' ||SQL%ROWCOUNT||' provision/es.');


   COMMIT;

       COD_RETORNO := 1;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_EXT_MODIFICACION_ESTADOS_PF;
/
EXIT
