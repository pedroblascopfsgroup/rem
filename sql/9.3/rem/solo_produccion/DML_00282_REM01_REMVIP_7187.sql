--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200430
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7187
--## PRODUCTO=NO
--## 
--## Finalidad:
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
    V_JBV T_ARRAY_JBV := T_ARRAY_JBV( 
        -- ="T_JBV("&COLUMNA&"),"
        T_JBV(6848883),
        T_JBV(6848915),
        T_JBV(6850314),
        T_JBV(6848884),
        T_JBV(7030322),
        T_JBV(6874828),
        T_JBV(7072891),
        T_JBV(7071339),
        T_JBV(7068787),
        T_JBV(7068794),
        T_JBV(7068814),
        T_JBV(7068834),
        T_JBV(7068802),
        T_JBV(7030235),
        T_JBV(6874498),
        T_JBV(7068390),
        T_JBV(7293165),
        T_JBV(7072542),
        T_JBV(6875948),
        T_JBV(7068408),
        T_JBV(7072712),
        T_JBV(6849913),
        T_JBV(7072581),
        T_JBV(7072795),
        T_JBV(6966669),
        T_JBV(7030206),
        T_JBV(7072970),
        T_JBV(7072984),
        T_JBV(7072993),
        T_JBV(7072999),
        T_JBV(7073006),
        T_JBV(7073007),
        T_JBV(7073008),
        T_JBV(7073010),
        T_JBV(7073011),
        T_JBV(7073013),
        T_JBV(7073014),
        T_JBV(7073015),
        T_JBV(7073018),
        T_JBV(7073019),
        T_JBV(7073020),
        T_JBV(7073022),
        T_JBV(7073024),
        T_JBV(7073025),
        T_JBV(7073026),
        T_JBV(7073029),
        T_JBV(7073030),
        T_JBV(7073031),
        T_JBV(7073032),
        T_JBV(7073034),
        T_JBV(7073036),
        T_JBV(7073038),
        T_JBV(7073039),
        T_JBV(7073042),
        T_JBV(7073043),
        T_JBV(7073045),
        T_JBV(7073046),
        T_JBV(7073048),
        T_JBV(7073049),
        T_JBV(7073052),
        T_JBV(7073056),
        T_JBV(7073057),
        T_JBV(7073059),
        T_JBV(7073061),
        T_JBV(7073062),
        T_JBV(7073063),
        T_JBV(7073067),
        T_JBV(7073068),
        T_JBV(7073069),
        T_JBV(7073071),
        T_JBV(7073074),
        T_JBV(7073075),
        T_JBV(7073078),
        T_JBV(7073079),
        T_JBV(7073080),
        T_JBV(7073082),
        T_JBV(7073084),
        T_JBV(7073086),
        T_JBV(7073087),
        T_JBV(7073089),
        T_JBV(7073090),
        T_JBV(7073092),
        T_JBV(7073093),
        T_JBV(7073095),
        T_JBV(7073096),
        T_JBV(7073097),
        T_JBV(7073099),
        T_JBV(7073100),
        T_JBV(7073101),
        T_JBV(7073102),
        T_JBV(7073103),
        T_JBV(7073104),
        T_JBV(7073105),
        T_JBV(7073106),
        T_JBV(7073108),
        T_JBV(7073109),
        T_JBV(7073110),
        T_JBV(7073111),
        T_JBV(7073112),
        T_JBV(7073114),
        T_JBV(7073115),
        T_JBV(7073116),
        T_JBV(7073117),
        T_JBV(7073118),
        T_JBV(7073119),
        T_JBV(7073120),
        T_JBV(7073121),
        T_JBV(7073122),
        T_JBV(7073123),
        T_JBV(7073124),
        T_JBV(7073125),
        T_JBV(7073126),
        T_JBV(7073127),
        T_JBV(7073130),
        T_JBV(7073132),
        T_JBV(7073133),
        T_JBV(7073136),
        T_JBV(7073137),
        T_JBV(7073138),
        T_JBV(7073140),
        T_JBV(7073141),
        T_JBV(7073142),
        T_JBV(7073144),
        T_JBV(7073145),
        T_JBV(7073147),
        T_JBV(7073148),
        T_JBV(7073150),
        T_JBV(7073154),
        T_JBV(7073155),
        T_JBV(7073156),
        T_JBV(7073157),
        T_JBV(7073158),
        T_JBV(7073162)
	); 
	V_TMP_JBV T_JBV;

BEGIN

    DBMS_OUTPUT.put_line('[INICIO]');

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
    
	LOOP
 
        V_TMP_JBV := V_JBV(I);
        
        V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET 
                        SPS_OTRO = NULL,
                        USUARIOMODIFICAR = ''REMVIP-7187'',
                        FECHAMODIFICAR = SYSDATE
                    WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||TRIM(V_TMP_JBV(1))||')';
        
        EXECUTE IMMEDIATE V_SQL;
        
        V_COUNT := V_COUNT + SQL%ROWCOUNT;
	
	END LOOP;
    
    DBMS_OUTPUT.put_line('  [INFO] Se han eliminado '||V_COUNT||' descripciones de condicionantes.');
		
	COMMIT;
    
    DBMS_OUTPUT.put_line('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;