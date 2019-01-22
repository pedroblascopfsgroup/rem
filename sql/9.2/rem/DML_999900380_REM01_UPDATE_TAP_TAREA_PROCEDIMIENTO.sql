/*
--##########################################
--## AUTOR=Rasul Akhmeddiribov
--## FECHA_CREACION=20190122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5273
--## PRODUCTO=NO
--##
--## Finalidad: Updatear registros TAP_TAREA_PROCEDIMIENTO
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'ESQUEMA_MASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla
    VAR_TAP_CODIGO VARCHAR2(50 CHAR); -- Columna auxiliar TAP_CODIGO
    VAR_TAP_SCRIPT_VALIDACION VARCHAR2(50 CHAR); -- Columna auxiliar TAP_SCRIPT_VALIDACION
    VAR_VALIDACION_ACTUAL VARCHAR(2048 CHAR); -- Variable para guardar el valor de la validación actual de la tabla.
    VAR_SIMPLE_QUOTES VARCHAR(10 CHAR):= ''''''''''; -- Simple quotes
    VAR_DOUBLE_QUOTES VARCHAR(10 CHAR):= ''''''''''''''; -- Double quotes
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    V_NUM_SEQUENCE NUMBER(16); --Vble. que recoge el valor autoincremental.
    V_NUM_MAXID NUMBER(16); --Vble. que recoge el valor máximo de id.


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		 
		     --TAP_CODIGO			--TAP_SCRIPT_VALIDACION-1			--TAP_SCRIPT_VALIDACION-2
	 T_TIPO_TAP('T013_InformeJuridico'		, '!tieneTramiteGENCATVigenteByIdActivo() ? '	, ' : ''''El activo tiene un trámite GENCAT en curso.'''' ')	
	,T_TIPO_TAP('T013_ResultadoPBC'			, '!tieneTramiteGENCATVigenteByIdActivo() ? '	, ' : ''''El activo tiene un trámite GENCAT en curso.'''' ')	
	,T_TIPO_TAP('T013_ObtencionContratoReserva' 	, '!tieneTramiteGENCATVigenteByIdActivo() ? '	, ' : ''''El activo tiene un trámite GENCAT en curso.'''' ')
	,T_TIPO_TAP('T013_InstruccionesReserva'		, '!tieneTramiteGENCATVigenteByIdActivo() ? '	, ' : ''''El activo tiene un trámite GENCAT en curso.'''' ')
	,T_TIPO_TAP('T013_PosicionamientoYFirma'	, '!tieneTramiteGENCATVigenteByIdActivo() ? '	, ' : ''''El activo tiene un trámite GENCAT en curso.'''' ')

    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    
BEGIN	
	
    
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Proceso iniciado.');

    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Se va a comprobar si ya existe la validación. '|| TRIM(V_TMP_TIPO_TAP(2)) ||'');

	-- SELECT para comprobar que si ya existe la validación en la TAP_CODIGO
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||'
		  WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''' 
		  AND TAP_SCRIPT_VALIDACION LIKE '''||TRIM(V_TMP_TIPO_TAP(2))||'%''';
	
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a proceder a hacer los cambios.');

		DBMS_OUTPUT.PUT_LINE('[INFO] Se van a cambiar las comillas simples por dobles simples.');

		-- UPDATE para cambiar las comillas simples por dobles simples para que luego no de problemas al concatenar los textos
		V_SQL := 'UPDATE rem01.TAP_TAREA_PROCEDIMIENTO
		SET TAP_SCRIPT_VALIDACION = REPLACE(TAP_SCRIPT_VALIDACION, '||VAR_SIMPLE_QUOTES||', '||VAR_DOUBLE_QUOTES||')
		WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''' ';

		EXECUTE IMMEDIATE V_SQL;


		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a recoger el valor actual de la validación.');

		-- SELECT para recoger el script de validacion que hay actualmente y asi contanerale la nueva validacion
		V_SQL := 'SELECT TAP_SCRIPT_VALIDACION 
		 	  FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' 
		 	  WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''' ';

		EXECUTE IMMEDIATE V_SQL INTO VAR_VALIDACION_ACTUAL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a actualizar el registro.');
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET 
		 	  TAP_SCRIPT_VALIDACION = '''||TRIM(V_TMP_TIPO_TAP(2))||' '||VAR_VALIDACION_ACTUAL||' '||TRIM(V_TMP_TIPO_TAP(3))||''',
			  USUARIOMODIFICAR	= ''HREOS-5273'',
			  FECHAMODIFICAR 	= SYSDATE
			  WHERE TAP_CODIGO 	= '''||TRIM(V_TMP_TIPO_TAP(1))||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	    	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado el TAP_CODIGO '||TRIM(V_TMP_TIPO_TAP(1))||'.');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] La validación '|| TRIM(V_TMP_TIPO_TAP(2)) ||' ya existe.');

	END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME|| '... Proceso finalizado.');
    
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
