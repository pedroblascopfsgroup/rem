--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190724
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4540
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-4540'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_NUM NUMBER(25);	
        
    TYPE T_GPV_TBJ IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_GPV_TBJ IS TABLE OF T_GPV_TBJ; 

	V_GPV_TBJ T_ARRAY_GPV_TBJ := T_ARRAY_GPV_TBJ(
							T_GPV_TBJ(9000123711, 10278518),
							T_GPV_TBJ(9000124371, 10355443),
							T_GPV_TBJ(9000136494, 10278518)
				); 
	V_TMP_GPV_TBJ T_GPV_TBJ;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado relación gastos - trabajos');
	V_NUM := 0;
	
	FOR I IN V_GPV_TBJ.FIRST .. V_GPV_TBJ.LAST
	
	LOOP
 
	V_TMP_GPV_TBJ := V_GPV_TBJ(I);	

	DBMS_OUTPUT.PUT_LINE('[INICIO] Se trata el caso trabajo = ' ||  V_TMP_GPV_TBJ(1) || ' y gasto = ' ||  V_TMP_GPV_TBJ(2)  );
	
	V_SQL := ' UPDATE '||V_ESQUEMA||'.GPV_TBJ
		    SET BORRADO = 1,
		    	USUARIOBORRAR = ''' || V_USUARIO || ''',
		     	FECHABORRAR = SYSDATE
		    WHERE 1 = 1
		    AND GPV_ID = ( SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''' || V_TMP_GPV_TBJ(2) || ''' )
		    AND TBJ_ID = ( SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = ''' || V_TMP_GPV_TBJ(1) || ''' )
		' ;	
		
	EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Borrado '||SQL%ROWCOUNT||' registro '); 
    
	V_NUM := V_NUM + 1;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Borradas '||V_NUM||' relaciones entre gastos y trabajos');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	COMMIT;
	
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
