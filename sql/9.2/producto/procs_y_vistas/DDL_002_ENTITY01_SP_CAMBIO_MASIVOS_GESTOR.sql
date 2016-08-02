--/*
--##########################################
--## AUTOR=Miguel Ángel Sánchez
--## FECHA_CREACION=20160622
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2105
--## PRODUCTO=SI
--## 
--## Finalidad: Cambio Gestor Masivo
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE CAMBIO_MASIVOS_GESTOR  (RESULT_EXE OUT VARCHAR2 ) AUTHID CURRENT_USER IS

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_NO_REASIGNADO NUMBER(1,0) := 0;
	V_REASIGNADO NUMBER(1,0) := 1;

	V_SQL_GAA VARCHAR2(4000 CHAR)  := 'UPDATE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO SET USD_ID=:1, USUARIOMODIFICAR=:2, FECHAMODIFICAR=SYSDATE WHERE GAA_ID=:3';
	V_SQL_GAH1 VARCHAR2(4000 CHAR) := 'UPDATE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO SET GAH_FECHA_HASTA=SYSDATE, USUARIOMODIFICAR=:1, FECHAMODIFICAR=SYSDATE  ' ||
		'WHERE GAH_ASU_ID=:2 AND GAH_TIPO_GESTOR_ID=:3 AND GAH_GESTOR_ID=:4 AND GAH_FECHA_HASTA IS NULL';
	V_SQL_GAH2 VARCHAR2(4000 CHAR) := 'INSERT INTO  '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO ' ||
		'(GAH_ID, GAH_GESTOR_ID, GAH_ASU_ID, GAH_TIPO_GESTOR_ID, GAH_FECHA_DESDE, USUARIOCREAR, FECHACREAR) VALUES ' ||
		'('||V_ESQUEMA||'.S_GAH_GESTOR_ADIC_HISTORICO.NEXTVAL, :1, :2, :3, SYSDATE, :4, SYSDATE)';
	V_SQL_CMA VARCHAR2(4000 CHAR)  := 'UPDATE '||V_ESQUEMA||'.CMA_CAMBIOS_MASIVOS_ASUNTOS SET REASIGNADO=:1, USUARIOMODIFICAR=:2, FECHAMODIFICAR=SYSDATE WHERE CMA_ID=:3';

	V_SQL_TRAZA1 VARCHAR2(4000 CHAR)  := 'SELECT '||V_ESQUEMA||'.S_MEJ_REG_REGISTRO.NEXTVAL FROM DUAL';
	V_SQL_TRAZA2 VARCHAR2(4000 CHAR)  := 'SELECT DD_TRG_ID FROM '||V_ESQUEMA||'.MEJ_DD_TRG_TIPO_REGISTRO WHERE DD_TRG_CODIGO=''CAMBIO_MASIVO''';
	V_SQL_TRAZA3 VARCHAR2(4000 CHAR)  := 'INSERT INTO '||V_ESQUEMA||'.MEJ_REG_REGISTRO (CMA_ID, REG_ID, DD_TRG_ID, TRG_EIN_CODIGO, TRG_EIN_ID, USU_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
		' VALUES (:1, :2, :3, 3, :4, :5, 0, :6, SYSDATE, 0)';
	V_SQL_TRAZA4 VARCHAR2(4000 CHAR)  := 'SELECT USU_ID FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS WHERE USD_ID=:1';
	V_SQL_TRAZA5 VARCHAR2(4000 CHAR)  := 'SELECT TRIM(USU_NOMBRE||'' ''||USU_APELLIDO1||'' ''||USU_APELLIDO2) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_ID=:1';
	V_SQL_TRAZA6 VARCHAR2(4000 CHAR)  := 'INSERT INTO '||V_ESQUEMA||'.MEJ_IRG_INFO_REGISTRO (IRG_ID, REG_ID, IRG_CLAVE, IRG_VALOR, VERSION, USUARIOCREAR,FECHACREAR, BORRADO) ' ||
		' VALUES ('||V_ESQUEMA||'.S_MEJ_IRG_INFO_REGISTRO.NEXTVAL, :1, :2, :3, 0, :4, sysdate, 0)';

	CURSOR C_SUSTITUCIONES IS
		SELECT CMA.CMA_ID CMA_ID, GAA.GAA_ID GAA_ID, GAA.ASU_ID ASU_ID, GAA.DD_TGE_ID DD_TGE_ID, GAA.USD_ID VIEJO ,
			CMA.USD_ID_NUEVO NUEVO, CMA.FECHA_INICIO FECHA_INICIO, CMA.FECHA_FIN FECHA_FIN, CMA.USUARIOCREAR USUARIOCREAR,
			CMA.SOL_ID SOL_ID, TGE.DD_TGE_DESCRIPCION TIPOGESTOR
		FROM #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO GAA
		JOIN #ESQUEMA#.CMA_CAMBIOS_MASIVOS_ASUNTOS CMA
		ON GAA.ASU_ID = CMA.ASU_ID AND GAA.DD_TGE_ID = CMA.DD_TGE_ID AND GAA.USD_ID = CMA.USD_ID_ORIGINAL
		JOIN #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR  TGE ON GAA.DD_TGE_ID = TGE.DD_TGE_ID
		WHERE CMA.BORRADO = 0 AND CMA.REASIGNADO = 0
				AND TRUNC(SYSDATE) >= TRUNC (CMA.FECHA_INICIO) and TRUNC(SYSDATE) <= TRUNC (CMA.FECHA_Fin);
	V_SUST C_SUSTITUCIONES%ROWTYPE;

	CURSOR C_RESTITUCIONES IS
		SELECT CMA.CMA_ID CMA_ID, GAA.GAA_ID GAA_ID, GAA.ASU_ID ASU_ID, GAA.DD_TGE_ID DD_TGE_ID, GAA.USD_ID NUEVO ,
			CMA.USD_ID_ORIGINAL VIEJO, CMA.FECHA_INICIO FECHA_INICIO, CMA.FECHA_FIN FECHA_FIN, CMA.USUARIOCREAR USUARIOCREAR,
			CMA.SOL_ID SOL_ID
		FROM #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO GAA
		JOIN #ESQUEMA#.CMA_CAMBIOS_MASIVOS_ASUNTOS CMA
		ON GAA.ASU_ID = CMA.ASU_ID AND GAA.DD_TGE_ID = CMA.DD_TGE_ID AND GAA.USD_ID = CMA.USD_ID_NUEVO
		WHERE CMA.BORRADO = 0 AND CMA.REASIGNADO = 1
		AND TRUNC(SYSDATE) >= TRUNC (CMA.FECHA_FIN);
	V_REST C_RESTITUCIONES%ROWTYPE;

	PROCEDURE ACTUALIZAR_GAA(GAA_ID IN NUMBER, USD_ID_NUEVO IN NUMBER, USUARIOMODIFICAR IN VARCHAR2) IS
	BEGIN
		DBMS_OUTPUT.PUT('[ACTUALIZAR_GAA] '|| GAA_ID || '-' || USD_ID_NUEVO || '-' || USUARIOMODIFICAR);
		EXECUTE IMMEDIATE V_SQL_GAA USING USD_ID_NUEVO, USUARIOMODIFICAR, GAA_ID;
        DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);
	END;

	PROCEDURE ACTUALIZAR_GAH(ASU_ID IN NUMBER, GAH_TIPO_GESTOR_ID IN NUMBER, USD_ID_ANTERIOR IN NUMBER, USD_ID_NUEVO IN NUMBER, USUARIOMODIFICAR IN VARCHAR2) IS
	BEGIN
		DBMS_OUTPUT.PUT('[ACTUALIZAR_GAH] '|| USUARIOMODIFICAR || '-' || ASU_ID || '-' || GAH_TIPO_GESTOR_ID || '-' || USUARIOMODIFICAR );
		EXECUTE IMMEDIATE V_SQL_GAH1 USING USUARIOMODIFICAR, ASU_ID, GAH_TIPO_GESTOR_ID, USD_ID_ANTERIOR;
		DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);
		DBMS_OUTPUT.PUT('[INSERTAR_GAH] ' || USD_ID_NUEVO || '-' || ASU_ID || '-' || GAH_TIPO_GESTOR_ID || '-' || USUARIOMODIFICAR );
		EXECUTE IMMEDIATE V_SQL_GAH2 USING USD_ID_NUEVO, ASU_ID, GAH_TIPO_GESTOR_ID, USUARIOMODIFICAR;
		DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);
	END;

	PROCEDURE GUARDAR_TRAZA (ASU_ID IN NUMBER, SOL_ID IN NUMBER, CMA_ID IN NUMBER,
				VIEJO IN NUMBER, NUEVO IN NUMBER, FECHA_INICIO IN VARCHAR2, FECHA_FIN IN VARCHAR2, USUARIOCREAR IN VARCHAR2,TIPOGESTOR IN VARCHAR2) IS
		V_MEJ_ID NUMBER(16);
		V_DD_TRG_ID NUMBER(16);
		V_USU_ID_OLD NUMBER(16);
		V_USU_NOM_OLD VARCHAR2(250 CHAR);
		V_USU_ID_NEW NUMBER(16);
		V_USU_NOM_NEW VARCHAR2(250 CHAR);
	BEGIN
		DBMS_OUTPUT.PUT_LINE('[GUARDAR_TRAZA] ' || ASU_ID || '-' ||  SOL_ID || '-' ||  CMA_ID || '-' ||  SOL_ID || '-' ||
		VIEJO || '-' ||  NUEVO || '-' ||  FECHA_INICIO || '-' || FECHA_FIN);

		DBMS_OUTPUT.PUT_LINE(V_SQL_TRAZA1);
		EXECUTE IMMEDIATE V_SQL_TRAZA1 INTO V_MEJ_ID;
		DBMS_OUTPUT.PUT('[GUARDAR_TRAZA] V_MEJ_ID=' || V_MEJ_ID);

		EXECUTE IMMEDIATE V_SQL_TRAZA2 INTO V_DD_TRG_ID;
		DBMS_OUTPUT.PUT('--- V_DD_TRG_ID=' || V_DD_TRG_ID);

		EXECUTE IMMEDIATE V_SQL_TRAZA3 USING CMA_ID, V_MEJ_ID, V_DD_TRG_ID, ASU_ID, SOL_ID, USUARIOCREAR;
		DBMS_OUTPUT.PUT('--- INSERCION EN MEJ_REG_REGISTRO...' || sql%rowcount);

		EXECUTE IMMEDIATE V_SQL_TRAZA4 INTO V_USU_ID_OLD USING VIEJO;
		DBMS_OUTPUT.PUT('--- V_USU_ID_OLD=' || V_USU_ID_OLD);

		EXECUTE IMMEDIATE V_SQL_TRAZA5 INTO V_USU_NOM_OLD USING V_USU_ID_OLD;
		DBMS_OUTPUT.PUT('--- V_USU_NOM_OLD=' || V_USU_NOM_OLD);

		EXECUTE IMMEDIATE V_SQL_TRAZA4 INTO V_USU_ID_NEW USING NUEVO;
		DBMS_OUTPUT.PUT('--- V_USU_ID_NEW=' || V_USU_ID_NEW);

		EXECUTE IMMEDIATE V_SQL_TRAZA5 INTO V_USU_NOM_NEW USING V_USU_ID_NEW;
		DBMS_OUTPUT.PUT_LINE('--- V_USU_NOM_NEW=' || V_USU_NOM_NEW);

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'idUserOld', V_USU_ID_OLD, USUARIOCREAR;
		DBMS_OUTPUT.PUT('---MEJ_IRG_INFO_REGISTRO=idUserOld-');

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'userOld', V_USU_NOM_OLD, USUARIOCREAR;
		DBMS_OUTPUT.PUT('userOld-');

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'idUserNew', V_USU_ID_NEW, USUARIOCREAR;
		DBMS_OUTPUT.PUT('idUserNew-');

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'userNew', V_USU_NOM_NEW, USUARIOCREAR;
		DBMS_OUTPUT.PUT('userNew-');

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'dateBegin', FECHA_INICIO, USUARIOCREAR;
		DBMS_OUTPUT.PUT('dateBegin-');

		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'dateEnd', FECHA_FIN, USUARIOCREAR;
		DBMS_OUTPUT.PUT_LINE('dateEnd');
		
		EXECUTE IMMEDIATE V_SQL_TRAZA6 USING V_MEJ_ID, 'tipoGestor', TIPOGESTOR, USUARIOCREAR;
		DBMS_OUTPUT.PUT_LINE('tipoGestor');
	END;

	PROCEDURE ACTUALIZAR_CMA(CMA_ID IN NUMBER, REASIGNADO IN NUMBER, USUARIOMODIFICAR IN VARCHAR2) IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE('[ACTUALIZAR_CMA] '|| REASIGNADO || '-' || USUARIOMODIFICAR || '-' || CMA_ID );
		EXECUTE IMMEDIATE V_SQL_CMA USING REASIGNADO, USUARIOMODIFICAR, CMA_ID;
		DBMS_OUTPUT.PUT_LINE('... registros afectados: ' || sql%rowcount);
	END;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||' -----.... ' );

   -- Cambio de gestores que entran como sustitutos
   OPEN C_SUSTITUCIONES;
   LOOP
    	FETCH C_SUSTITUCIONES INTO V_SUST;
		EXIT WHEN C_SUSTITUCIONES%NOTFOUND;
    	IF V_SUST.VIEJO=V_SUST.NUEVO THEN
    		DBMS_OUTPUT.PUT_LINE('No se cambia la petición ' || V_SUST.CMA_ID || ' porque sustituto y titular son el mismo usuario.' );
    	ELSE
		 	DBMS_OUTPUT.PUT_LINE('SUSTITUCIÓN nº ' || V_SUST.CMA_ID || '-----------------------------------------------------------');
	    	ACTUALIZAR_GAA(V_SUST.GAA_ID, V_SUST.NUEVO, V_SUST.USUARIOCREAR);
	    	ACTUALIZAR_GAH(V_SUST.ASU_ID, V_SUST.DD_TGE_ID, V_SUST.VIEJO, V_SUST.NUEVO, V_SUST.USUARIOCREAR);
	    	GUARDAR_TRAZA(V_SUST.ASU_ID, V_SUST.SOL_ID, V_SUST.CMA_ID, V_SUST.VIEJO, V_SUST.NUEVO, to_char(V_SUST.FECHA_INICIO, 'dd/mm/rrrr'), to_char(V_SUST.FECHA_FIN, 'dd/mm/rrrr'), V_SUST.USUARIOCREAR,V_SUST.TIPOGESTOR);
	END IF;
	ACTUALIZAR_CMA(V_SUST.CMA_ID, V_REASIGNADO, V_SUST.USUARIOCREAR);
    END LOOP;
    RESULT_EXE := 'Cambio de gestores que entran como sustitutos, realizado';

   DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------------');

   -- Cambio de gestores que eran titulares y vuelven
   OPEN C_RESTITUCIONES;
   LOOP
    	FETCH C_RESTITUCIONES INTO V_REST;
		EXIT WHEN C_RESTITUCIONES%NOTFOUND;
    	IF V_REST.VIEJO=V_REST.NUEVO THEN
    		DBMS_OUTPUT.PUT_LINE('No se cambia la petición ' || V_REST.CMA_ID || ' porque sustituto y titular son el mismo usuario.' );
    	ELSE
		DBMS_OUTPUT.PUT_LINE('RESTITUCIÓN nº ' || V_REST.CMA_ID || '-----------------------------------------------------------');
		ACTUALIZAR_GAA(V_REST.GAA_ID, V_REST.VIEJO, V_REST.USUARIOCREAR);
		ACTUALIZAR_GAH(V_REST.ASU_ID, V_REST.DD_TGE_ID, V_REST.NUEVO, V_REST.VIEJO, V_REST.USUARIOCREAR);
	END IF;
    	-- NO VOLVEMOS A PONER EL VALOR REASIGNADO A CERO, PORQUE SI NO APARECERÍA EN EL GRID COMO CAMBIO PENDIENTE
    	-- ACTUALIZAR_CMA(V_REST.CMA_ID, V_NO_REASIGNADO, V_REST.USUARIOCREAR);
    END LOOP;
    RESULT_EXE := RESULT_EXE||'| Cambio de gestores que eran titulares y vuelven, realizado';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||' -----.... ' );

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
	  RESULT_EXE := 'Error:'||TO_CHAR(ERR_NUM)||'['||ERR_MSG||']';
          ROLLBACK;
          RAISE;
END;
/

EXIT;


