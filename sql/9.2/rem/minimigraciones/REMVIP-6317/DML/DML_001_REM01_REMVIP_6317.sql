--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200131
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6317
--## PRODUCTO=SI
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
DECLARE
    V_SQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    V_ACT_NUM_ACTIVO NUMBER(16,0);
    V_NUM_BAN NUMBER(2,0);
    V_NUM_DOR NUMBER(2,0);		
    V_NUM NUMBER(16);    
    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------


BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

-----------------------------------------------------------------------------------------------------------------
--Paso 3: Se recorre la tabla temporal

	DBMS_OUTPUT.PUT_LINE('[INICIO] Recorriendo activos para insertar dormitorio/baño ');
     
     	-- Busca los activos/gestores
    	V_SQL := ' SELECT ACT_NUM_ACTIVO, NUM_DOR, NUM_BAN
		   FROM REM01.AUX_REMVIP_6317
		 ' ;

	OPEN v_cursor FOR V_SQL;
   
   	V_NUM := 0;
   
   	LOOP
       		FETCH v_cursor INTO V_ACT_NUM_ACTIVO, V_NUM_DOR, V_NUM_BAN;
       		EXIT WHEN v_cursor%NOTFOUND;
       	
		-- Es Dormitorio ?
		IF V_NUM_DOR > 0 THEN

			V_SQL := ' INSERT INTO REM01.ACT_DIS_DISTRIBUCION 
				   ( DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, ICO_ID,
				     VERSION, BORRADO, USUARIOCREAR, FECHACREAR )
				   VALUES
				   (
				     REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
				     1,
				     ( SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''01'' ),
				     ' || V_NUM_DOR || ',
				     ( SELECT ICO_ID FROM REM01.ACT_ICO_INFO_COMERCIAL ICO, REM01.ACT_ACTIVO ACT
				       WHERE ACT.ACT_ID = ICO.ACT_ID
		 		       AND ACT.ACT_NUM_ACTIVO = ''' || V_ACT_NUM_ACTIVO || ''' ),
				     0,
				     0,
				     ''REMVIP-6317'',
				     SYSDATE
				    ) ';						

			EXECUTE IMMEDIATE V_SQL;       		

		END IF;

		-- Es Baño ?
		IF V_NUM_BAN > 0 THEN

			V_SQL := ' INSERT INTO REM01.ACT_DIS_DISTRIBUCION 
				   ( DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD, ICO_ID,
				     VERSION, BORRADO, USUARIOCREAR, FECHACREAR )
				   VALUES
				   (
				     REM01.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
				     1,
				     ( SELECT DD_TPH_ID FROM REM01.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = ''02'' ),
				     ' || V_NUM_BAN || ',
				     ( SELECT ICO_ID FROM REM01.ACT_ICO_INFO_COMERCIAL ICO, REM01.ACT_ACTIVO ACT
				       WHERE ACT.ACT_ID = ICO.ACT_ID
		 		       AND ACT.ACT_NUM_ACTIVO = ''' || V_ACT_NUM_ACTIVO || ''' ),
				     0,
				     0,
				     ''REMVIP-6317'',
				     SYSDATE
				    ) ';						

			EXECUTE IMMEDIATE V_SQL;       		

		END IF;  


           
       		V_NUM := V_NUM + 1;

   	END LOOP;

	CLOSE v_cursor;    
	DBMS_OUTPUT.PUT_LINE(' [INFO] Se han modificado '||V_NUM||' activos ');

-----------------------------------------------------------------------------------------------------------------

   
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
