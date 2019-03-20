--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190315
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3608
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

        MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 USING
        (
            SELECT GPV.GPV_ID
            FROM rem01.GPV_GASTOS_PROVEEDOR GPV
            JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
            WHERE GPV.GPV_NUM_GASTO_HAYA IN  (
10286563,
10286565,
10286567,
10286573

    )             
        )T2 ON (T1.GPV_ID = T2.GPV_ID) 
        WHEN MATCHED THEN
                UPDATE
                SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM  REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01''),
                    T1.PRG_ID = NULL,
                    T1.USUARIOMODIFICAR = ''REMVIP-3608'',
                    T1.FECHAMODIFICAR = SYSDATE
            


        ';


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
