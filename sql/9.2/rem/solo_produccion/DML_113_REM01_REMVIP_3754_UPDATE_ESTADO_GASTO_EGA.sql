

--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3754
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
set serveroutput on;
SET DEFINE OFF;

DECLARE

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_NUM_TABLAS NUMBER(16); -- Variable auxiliar
   USUARIO_CONSULTA_REM VARCHAR2(50 CHAR):= 'REM_QUERY';
   V_USUARIO_MODIFICAR VARCHAR2(50 CHAR):='REMVIP-3754';

BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');         


           V_SQL := 'MERGE INTO REM01.GGE_GASTOS_GESTION T1 USING
                                            (SELECT GPV_ID 
                                            FROM REM01.GPV_GASTOS_PROVEEDOR GPV 
                                            WHERE GPV_NUM_GASTO_HAYA IN ( 9425991, 9425993 )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EAP_ID = (SELECT DD_EAP_ID FROM DD_EAP_ESTADOS_AUTORIZ_PROP WHERE DD_EAP_CODIGO = ''07''),
                                                T1.GGE_FECHA_EAP = SYSDATE,
                                                T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                T1.FECHAMODIFICAR = SYSDATE';
            
            EXECUTE IMMEDIATE V_SQL;
                 
            
            V_SQL := 'MERGE INTO REM01.GPV_GASTOS_PROVEEDOR T1 USING
                                            (SELECT GPV_ID 
                                              FROM REM01.GPV_GASTOS_PROVEEDOR GPV 
                                              WHERE GPV_NUM_GASTO_HAYA IN ( 9425991, 9425993 )
                                            )T2 ON (
                                            T1.GPV_ID = T2.GPV_ID
                                    ) WHEN MATCHED THEN
                                            UPDATE
                                            SET T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''04''),
                                                T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                                                T1.FECHAMODIFICAR = SYSDATE';
                                                    
            EXECUTE IMMEDIATE V_SQL;
                        
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: GASTOS CAMBIADOS CORRECTAMENTE ');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '||ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT


