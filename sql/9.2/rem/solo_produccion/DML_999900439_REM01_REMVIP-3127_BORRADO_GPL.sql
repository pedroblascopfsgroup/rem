--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20181220
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3127
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE



	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	


BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO ');
      
 
      V_SENTENCIA := '
       update rem01.GPL_GASTOS_PRINEX_LBK set 
        usuarioborrar = ''REMVIP3127'',
        BORRADO = 1,
        fechaborrar = SYSDATE
        WHERE gpl_id IN (
        select gpl_id from rem01.GPL_GASTOS_PRINEX_LBK where gpl_id in
        (13390,
        13397,
        13418,
        13422,
        13424,
        13428,
        13434,
        13776,
        13777,
        13778,
        13779,
        13780,
        13782,
        13795,
        13797,
        13801,
        13817,
        13820,
        13837,
        13796
        ))';


      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] CAMBIADAS  '||SQL%ROWCOUNT||' Filas.');
      
  
   
   COMMIT;
      
   
      
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
