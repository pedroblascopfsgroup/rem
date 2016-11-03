--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Crear una procedure para procesar lo necesario despues de que una agrupación de tipo asistida finalice.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
  DBMS_OUTPUT.PUT_LINE('[INFO] Procedure PROCEDURE AGR_ASISTIDA_PROCESO_FIN: INICIANDO...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE PROCEDURE '||V_ESQUEMA||'.AGR_ASISTIDA_PROCESO_FIN IS

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

-- Cursor para agrupaciones:
    CURSOR AGRUPACION IS 
      SELECT AGR.AGR_ID
      FROM ACT_AGR_AGRUPACION AGR
      WHERE AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      AND AGR.AGR_FECHA_BAJA IS NULL -- Que no tenga asignada fecha de baja.
      ;
    FILA_AGR AGRUPACION%ROWTYPE; -- Registro para el loop.

-- Cursor para perimetros de activos:
    CURSOR PERIMETRO IS 
      SELECT PAC.PAC_ID
      FROM ACT_PAC_PERIMETRO_ACTIVO PAC, ACT_ACTIVO ACT, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA
      WHERE AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      AND ACT.BORRADO = 0 -- Que el activo no esté borrado.
      AND PAC.BORRADO = 0 -- Que el perímetro no esté borrado.
      AND AGR.AGR_ID = AGA.AGR_ID -- Que la agrupación se corresponda con la lista de activos por agrupación.
      AND AGA.ACT_ID = ACT.ACT_ID -- Que el activo se encuentre dentro de la lista de activos por agrupación.
      AND PAC.ACT_ID = ACT.ACT_ID -- Que el perímetro se corresponda con el activo.
	  AND PAC.PAC_INCLUIDO != 0 -- Que no este fuera de perimetro.
      ;
    FILA_PAC PERIMETRO%ROWTYPE; -- Registro para el loop.

-- Cursor para activos:
    CURSOR TRAMITE IS 
      SELECT TRA.TRA_ID
      FROM ACT_TRA_TRAMITE TRA, ACT_TBJ_TRABAJO TBJ, ACT_ACTIVO ACT, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA
      WHERE TRA.TBJ_ID = TBJ.TBJ_ID -- Que el trabajo asociado al trámite se corresponda.
      AND TBJ.ACT_ID = ACT.ACT_ID -- Que el activo asociado al trabajo se corresponda.
      AND AGR.AGR_ID = AGA.AGR_ID -- Que la agrupación se corresponda con la lista de activos por agrupación.
      AND AGA.ACT_ID = ACT.ACT_ID -- Que el activo se encuentre dentro de la lista de activos por agrupación.
      AND AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND TRA.DD_EPR_ID != (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE EPR.DD_EPR_CODIGO = ''05'') -- Que el trámite esté en estado cerrado.
      AND TRA.BORRADO = 0 -- Que el trámite no esté borrado.
      AND TBJ.BORRADO = 0 -- Que el trabajo no esté borrado.
      AND ACT.BORRADO = 0 -- Que el activo no esté borrado.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      ;
    FILA_TRA TRAMITE%ROWTYPE; -- Registro para el loop.

    CURSOR TAREA IS 
      SELECT TAR.TAR_ID
      FROM TAR_TAREAS_NOTIFICACIONES TAR, TAC_TAREAS_ACTIVOS TAC, ACT_TRA_TRAMITE TRA, ACT_TBJ_TRABAJO TBJ, ACT_ACTIVO ACT, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA
      WHERE TRA.TBJ_ID = TBJ.TBJ_ID -- Que el trabajo asociado al trámite se corresponda.
      AND TBJ.ACT_ID = ACT.ACT_ID -- Que el activo asociado al trabajo se corresponda.
      AND AGR.AGR_ID = AGA.AGR_ID -- Que la agrupación se corresponda con la lista de activos por agrupación.
      AND AGA.ACT_ID = ACT.ACT_ID -- Que el activo se encuentre dentro de la lista de activos por agrupación.
      AND TAC.TRA_ID = TRA.TRA_ID -- Que el trámite se encuentre en la lista de trámites tarea.
      AND TAC.TAR_ID = TAR.TAR_ID -- Que la tarea se encuentre asociada a la lista de trámites tarea. 
      AND AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND TAR.BORRADO = 0 -- Que la oferta no esté borrada.
      AND TRA.BORRADO = 0 -- Que el trámite no esté borrado.
      AND TBJ.BORRADO = 0 -- Que el trabajo no esté borrado.
      AND ACT.BORRADO = 0 -- Que el activo no esté borrado.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      ;
    FILA_TAR TAREA%ROWTYPE; -- Registro para el loop.
    
    CURSOR OFERTA IS 
      SELECT OFR.OFR_ID
      FROM OFR_OFERTAS OFR, ACT_OFR AFR, ACT_ACTIVO ACT, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA
      WHERE AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND OFR.DD_EOF_ID != (SELECT EOF.DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = ''02'') -- Que la oferta no se encuentre en estado rechazada.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      AND ACT.BORRADO = 0 -- Que el activo no esté borrado.
      and OFR.BORRADO = 0 -- Que la oferta no esté borrada.
      AND AGR.AGR_ID = AGA.AGR_ID -- Que la agrupación se corresponda con la lista de activos por agrupación.
      AND AGA.ACT_ID = ACT.ACT_ID -- Que el activo se encuentre dentro de la lista de activos por agrupación.
      AND ACT.ACT_ID = AFR.ACT_ID -- Que el activo se encuentre en la lista de activos ofertas.
      AND AFR.OFR_ID = OFR.OFR_ID -- Que la oferta se encuentre en la lista de activos oferta.
      ;
    FILA_OFR OFERTA%ROWTYPE; -- Registro para el loop.
    
    CURSOR EXPEDIENTE_COMERCIAL IS 
      SELECT ECO.ECO_ID
      FROM ECO_EXPEDIENTE_COMERCIAL ECO, OFR_OFERTAS OFR, ACT_OFR AFR, ACT_ACTIVO ACT, ACT_AGR_AGRUPACION AGR, ACT_AGA_AGRUPACION_ACTIVO AGA
      WHERE AGR.AGR_FIN_VIGENCIA <= SYSDATE -- Que la fecha de fin de vigencia sea hoy o anterior.
      AND AGR.DD_TAG_ID = (SELECT TAG.DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION TAG WHERE TAG.DD_TAG_CODIGO = ''13'') -- Que la agrupación sea de tipo asistida.
      AND ECO.DD_EEC_ID != (SELECT EEC.DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = ''12'') -- Que el expediente no se encuentre en estado denegado.
      AND AGR.BORRADO = 0 -- Que la agrupación no esté borrada.
      AND ACT.BORRADO = 0 -- Que el activo no esté borrado.
      AND OFR.BORRADO = 0 -- Que la oferta no esté borrada.
      AND ECO.BORRADO = 0 -- Que el expediente comercial no esté borrado.
      AND AGR.AGR_ID = AGA.AGR_ID -- Que la agrupación se corresponda con la lista de activos por agrupación.
      AND AGA.ACT_ID = ACT.ACT_ID -- Que el activo se encuentre dentro de la lista de activos por agrupación.
      AND ACT.ACT_ID = AFR.ACT_ID -- Que el activo se encuentre en la lista de activos ofertas.
      AND AFR.OFR_ID = OFR.OFR_ID -- Que la oferta se encuentre en la lista de activos oferta.
      AND ECO.OFR_ID = OFR.OFR_ID -- Que el expediente comercial tenga una oferta asociada.
      ;
    FILA_ECO EXPEDIENTE_COMERCIAL%ROWTYPE; -- Registro para el loop.

		BEGIN

	    DBMS_OUTPUT.PUT_LINE(''[INICIO]'');

-- Loop expedientes comerciales:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando expedientes comerciales:'');
	    IF (NOT EXPEDIENTE_COMERCIAL%ISOPEN) THEN
	        OPEN EXPEDIENTE_COMERCIAL;
	    END IF;

	    FETCH EXPEDIENTE_COMERCIAL INTO FILA_ECO;

	    WHILE (EXPEDIENTE_COMERCIAL%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar expediente comercial con ID: ''||FILA_ECO.ECO_ID||'' a estado denegado'');

          UPDATE ECO_EXPEDIENTE_COMERCIAL ECO SET
          ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = ''12''),
          ECO.fechamodificar = SYSDATE,
          ECO.usuariomodificar = ''REM''
          WHERE ECO.ECO_ID = FILA_ECO.ECO_ID;

	        FETCH EXPEDIENTE_COMERCIAL INTO FILA_ECO;
	
	    END LOOP;

-- Loop ofertas:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando ofertas:'');
	    IF (NOT OFERTA%ISOPEN) THEN
	        OPEN OFERTA;
	    END IF;

	    FETCH OFERTA INTO FILA_OFR;

	    WHILE (OFERTA%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar oferta con ID: ''||FILA_OFR.OFR_ID||'' a estado rechazada'');

          UPDATE OFR_OFERTAS OFR SET
          OFR.DD_EOF_ID = (SELECT EOF.DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA EOF WHERE EOF.DD_EOF_CODIGO = ''02''),
          OFR.fechamodificar = SYSDATE,
          OFR.usuariomodificar = ''REM''
          WHERE OFR.OFR_ID = FILA_OFR.OFR_ID;

	        FETCH OFERTA INTO FILA_OFR;
	
	    END LOOP;

-- Loop Tareas:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando tareas:'');
	    IF (NOT TAREA%ISOPEN) THEN
	        OPEN TAREA;
	    END IF;

	    FETCH TAREA INTO FILA_TAR;

	    WHILE (TAREA%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar tarea con ID: ''||FILA_TAR.TAR_ID||'' a borrada'');

          UPDATE TAR_TAREAS_NOTIFICACIONES TAR SET
          TAR.borrado = 1,
          TAR.fechaborrar = SYSDATE,
          TAR.usuarioborrar = ''REM''
          WHERE TAR.TAR_ID = FILA_TAR.TAR_ID;

		  UPDATE TAC_TAREAS_ACTIVOS TAC SET
		  TAC.BORRADO = 1,
		  TAC.fechaborrar = SYSDATE,
          TAC.usuarioborrar = ''REM''
		  WHERE TAC.TAR_ID = FILA_TAR.TAR_ID;

	        FETCH TAREA INTO FILA_TAR;
	
	    END LOOP;

-- Loop tramites:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando tramites:'');
	    IF (NOT TRAMITE%ISOPEN) THEN
	        OPEN TRAMITE;
	    END IF;

	    FETCH TRAMITE INTO FILA_TRA;

	    WHILE (TRAMITE%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar tramite con ID: ''||FILA_TRA.TRA_ID||'' a estado cerrado'');

          UPDATE ACT_TRA_TRAMITE TRA SET
          TRA.DD_EPR_ID = (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE EPR.DD_EPR_CODIGO = ''05''),
          TRA.fechamodificar = SYSDATE,
          TRA.usuariomodificar = ''REM''
          WHERE TRA.TRA_ID = FILA_TRA.TRA_ID;

	        FETCH TRAMITE INTO FILA_TRA;
	
	    END LOOP;

-- Loop perímetros:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando perimetros:'');
	    IF (NOT PERIMETRO%ISOPEN) THEN
	        OPEN PERIMETRO;
	    END IF;

	    FETCH PERIMETRO INTO FILA_PAC;

	    WHILE (PERIMETRO%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar perímetro con ID: ''||FILA_PAC.PAC_ID||'' estado incluido en perimetro a 0'');

          UPDATE ACT_PAC_PERIMETRO_ACTIVO PAC SET
          PAC.PAC_INCLUIDO = 0,
		  PAC.PAC_CHECK_TRA_ADMISION = 0,
		  PAC.PAC_CHECK_GESTIONAR = 0,
		  PAC.PAC_CHECK_ASIGNAR_MEDIADOR = 0,
		  PAC.PAC_CHECK_COMERCIALIZAR = 0,
		  PAC.PAC_CHECK_FORMALIZAR = 0,
          PAC.fechamodificar = SYSDATE,
          PAC.usuariomodificar = ''REM''
          WHERE PAC.PAC_ID = FILA_PAC.PAC_ID;

	        FETCH PERIMETRO INTO FILA_PAC;
	
	    END LOOP;

-- Loop agrupaciones:
      DBMS_OUTPUT.PUT_LINE(''[INFO] Procesando agrupaciones:'');
	    IF (NOT AGRUPACION%ISOPEN) THEN
	        OPEN AGRUPACION;
	    END IF;

	    FETCH AGRUPACION INTO FILA_AGR;

	    WHILE (AGRUPACION%FOUND) LOOP
         DBMS_OUTPUT.PUT_LINE(''[INFO] actualizar agrupación con ID: ''||FILA_AGR.AGR_ID||'' fecha baja a hoy'');

          UPDATE ACT_AGR_AGRUPACION AGR SET
          AGR.AGR_FECHA_BAJA = SYSDATE,
          AGR.fechamodificar = SYSDATE,
          AGR.usuariomodificar = ''REM''
          WHERE AGR.AGR_ID = FILA_AGR.AGR_ID;

	        FETCH AGRUPACION INTO FILA_AGR;
	
	    END LOOP;


	    DBMS_OUTPUT.PUT_LINE(''[FIN]'');
	
	    CLOSE EXPEDIENTE_COMERCIAL;
      CLOSE OFERTA;
      CLOSE TAREA;
      CLOSE TRAMITE;
      CLOSE PERIMETRO;
      CLOSE AGRUPACION;
	    
	    COMMIT;
	
	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecución:''||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line(''-----------------------------------------------------------''); 
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

		END AGR_ASISTIDA_PROCESO_FIN;
		';
  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Procedure creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT