

--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1844
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
   V_USUARIO_MODIFICAR VARCHAR2(50 CHAR):='REMVIP-1844';

BEGIN   
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');              
                            
       V_SQL := 'MERGE INTO '||V_ESQUEMA||'.act_activo T1 USING
                    (Select ACT_ID from '||V_ESQUEMA||'.act_activo WHERE USUARIOCREAR LIKE ''%ALT_SAREB%'' AND DD_SCR_ID IS NULL AND BORRADO = 0
                    )T2 
                    ON (T1.ACT_ID = T2.ACT_ID) WHEN MATCHED THEN
                    UPDATE
                        SET T1.DD_SCR_ID = (SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''02''),
                            T1.USUARIOMODIFICAR = '''||V_USUARIO_MODIFICAR||''',
                            T1.FECHAMODIFICAR = SYSDATE';
        
        EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' SUBCARTERAS actualizadas en LA tabla act_activo.');
    
                        
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: GASTOS REENVIADOS CORRECTAMENTE ');

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


