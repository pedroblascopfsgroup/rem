--/*
--##########################################
--## AUTOR=Gonzalo Estellés
--## FECHA_CREACION=20150803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--##
--## Finalidad: Crear multientidad en HRE
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	/*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     
    V_SQL VARCHAR2(4000 CHAR);                          -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16);                            -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    ENTIDAD_ID NUMBER(16,0);
    ENTIDADCONFIG_ID NUMBER(16,0);
    CUENTA NUMBER(16,0);

    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      	T_TIPO_TPO('workingCode','2039')
		,T_TIPO_TPO('jndiName','jdbc/haya02_Oracle9iDialect')
		,T_TIPO_TPO('driverClassName','oracle.jdbc.driver.OracleDriver')
		,T_TIPO_TPO('url','jdbc:oracle:thin:haya02/admin@//localhost:1521/ibd011')
		,T_TIPO_TPO('username','haya02')
		,T_TIPO_TPO('password','admin')
		,T_TIPO_TPO('initialId','1')
		,T_TIPO_TPO('theme','slateGreen')
		,T_TIPO_TPO('logo','logo-haya-recovery.jpg')
		,T_TIPO_TPO('schema','haya02')
		,T_TIPO_TPO('connectionInfo','haya02/admin@//localhost:1521/ibd011')
		,T_TIPO_TPO('pathToSqlLoader','/opt/app/oracle/product/11.2.0/dbhome_1/bin/sqlldr')
		,T_TIPO_TPO('sqlLoaderParameters','direct=true bindsize=512000 rows=10000 ERRORS=100000')
		,T_TIPO_TPO('PeriodoVigenciaPassword','91')
		,T_TIPO_TPO('cronExpressionAnalisisExterna','15 6 5 * * ?')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;
    
BEGIN

	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA_M||'.ENTIDAD WHERE DESCRIPCION=''CAJAMAR''' INTO CUENTA;
	
	IF (CUENTA=0) THEN
		
	    DBMS_OUTPUT.PUT_LINE('[CREANDO ENTIDAD]...............................................');
		EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA_M||'.S_ENTIDAD.NEXTVAL FROM DUAL' INTO ENTIDAD_ID;
	    V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.ENTIDAD (ID,DESCRIPCION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) '||
		 ' VALUES ('||ENTIDAD_ID||',''CAJAMAR'',''DD'',sysdate,null,null,null,null,0)';
    	DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL; 

	    DBMS_OUTPUT.PUT_LINE('[CONFIGURANDO ENTIDAD]...............................................');
	    DBMS_OUTPUT.PUT('    [INSERT] '||V_ESQUEMA_M||'.ENTIDADCONFIG......');
	    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
	      LOOP
	        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
	        
	        --EXISTENCIA DE REGISTROS: Mediante consulta a la tabla, se verifica si existen ya los registros a insertar mas adelante,
	        -- si ya existían los registros en la tabla, se informa de q existen y no se hace nada
	        -----------------------------------------------------------------------------------------------------------
	        DBMS_OUTPUT.PUT_LINE('[INFO] Array codigo '''||V_TMP_TIPO_TPO(1)||''' = '''||V_TMP_TIPO_TPO(2)||'''---------------------------------'); 
	        DBMS_OUTPUT.PUT('[INFO] Verificando existencia de REGISTROS de la tabla ENTIDADCONFIG, con codigo '''||V_TMP_TIPO_TPO(1)||'''...'); 
	
	        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.ENTIDADCONFIG WHERE ENTIDAD_ID='||ENTIDAD_ID||' AND DATAKEY = '''|| V_TMP_TIPO_TPO(1) ||'''';
	        --DBMS_OUTPUT.PUT_LINE(V_SQL);
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	        IF V_NUM_TABLAS > 0 THEN
	            DBMS_OUTPUT.PUT_LINE('OK - YA existe');
	            DBMS_OUTPUT.PUT_LINE('[INFO] NO se inserta el registro del array porque ya existe en ENTIDADCONFIG');
	        ELSE
	            DBMS_OUTPUT.PUT_LINE('OK - NO existe');
          		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.ENTIDADCONFIG (ID,ENTIDAD_ID,DATAKEY,DATAVALUE) values ('||V_ESQUEMA_M||'.S_ENTIDADCONFIG.NEXTVAL,'||ENTIDAD_ID||', ' ||
					'''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',' ||
					'''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''')';
	                DBMS_OUTPUT.PUT_LINE(V_MSQL);
	                --DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
	                EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('OK - Insertado!');
	        END IF;
	    END LOOP;

	ELSE  
	
		DBMS_OUTPUT.PUT_LINE('[ENTIDAD EXISTENTE]...............................................');
	
	END IF;
	
   	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
	
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/ 
EXIT;