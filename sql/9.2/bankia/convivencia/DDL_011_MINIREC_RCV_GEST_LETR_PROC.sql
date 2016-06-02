--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160530
--## ARTEFACTO=proc_salida_inform_gestion
--## VERSION_ARTEFACTO=2.28
--## INCIDENCIA_LINK=BKREC-2291
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla para informacion de salida a clientes, con datos de procuradores y letrados.
--## INSTRUCCIONES: Definir las variables de esquema antes de ejecutarlo.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
--## Configuraciones a rellenar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count_copy number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_column_count_fk number(3); -- Vble. para validar la existencia de las Columnas deFK.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
 
    -- Otras variables
	
BEGIN 
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.RCV_GEST_LETR_PROC... Crear tabla auxiliar.');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE table_name =''RCV_GEST_LETR_PROC''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF (table_count = 0) THEN
		-- Copiar los datos a una temporal
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.RCV_GEST_LETR_PROC
				( 
					FECHA_PROCESO	        DATE		          NOT NULL, 
					DES_ID		            NUMBER(16,0)	      NOT NULL,
					ANAGRAMA	            VARCHAR2(15 CHAR)	  ,
					NOMBRE		            VARCHAR2(60 CHAR)	  ,
					TIPO_AGENTE	          VARCHAR2(5 CHAR)	  ,	
					DIRECCION	            VARCHAR2(60 CHAR)	  ,
					LOCALIDAD	            VARCHAR2(30 CHAR)	  ,
					PROVINCIA	            VARCHAR2(20 CHAR)	  ,
					CODIGO_POSTAL	        NUMBER(5)	          ,
					TELEFONO1	            VARCHAR2(100 CHAR)	  ,
					TELEFONO2	            VARCHAR2(100 CHAR)	  ,
					FAX		                VARCHAR2(100 CHAR)	  ,	
					CODIGO_AGENTE	        NUMBER(3)	          ,	
					COD_EST_ASE	          VARCHAR2(1 CHAR)	  ,
					OFICINA_CONTACTO	    VARCHAR2(5 CHAR)	  ,
					ENTIDAD_CONTACTO	    VARCHAR2(5 CHAR)	  ,
					FECHA_ALTA		        DATE	              ,
					ENTIDAD_LIQUIDACION		VARCHAR2(4 CHAR)    ,
					OFICINA_LIQUIDACION		VARCHAR2(4 CHAR)	  ,
					DIGCON_LIQUIDACION		VARCHAR2(2 CHAR)    ,
					CUENTA_LIQUIDACION		VARCHAR2(10 CHAR)	  ,
					ENTIDAD_PROVISIONES		VARCHAR2(4 CHAR)	  ,
					OFICINA_PROVISIONES		VARCHAR2(4 CHAR)    ,
					DIGCON_PROVISIONES		VARCHAR2(2 CHAR)	  ,
					CUENTA_PROVISIONES		VARCHAR2(10 CHAR)	  ,
					ENTIDAD_ENTREGAS		  VARCHAR2(4 CHAR)	  ,
					OFICINA_ENTREGAS		  VARCHAR2(4 CHAR)	  ,
					DIGCON_ENTREGAS		    VARCHAR2(2 CHAR)	  ,
					CUENTA_ENTREGAS		    VARCHAR2(10 CHAR)	  ,
					CENTRO_RECUP		      VARCHAR2(60 CHAR)	  ,
					CORREO_ELECTRONICO	  VARCHAR2(100 CHAR)	  ,
					ACEPTACION_ACCESO	    VARCHAR2(1 CHAR)    ,
					TIPO_DOC	            VARCHAR2(1 CHAR)	  ,
					DOCUMENTO	            VARCHAR2(10 CHAR)	  ,
					ASESORIA		          CHAR(1)	            ,
					IVA_APL	              NUMBER(5,2)	        ,
					IVA_DES	            	VARCHAR2(4 CHAR)	  ,
					IRPF_APL	            NUMBER(5,2)	        ,
					TIPO_CONTRATO	        VARCHAR2(4 CHAR)	  ,
					SUPTIPO_CONTRATO	    VARCHAR2(4 CHAR)	  ,
					CONTRATO_VIGOR	      VARCHAR2(20 CHAR)	  ,
					SERV_INTEGRAL	        VARCHAR2(1)	        ,
					FECHA_SERV_INTEGRAL	  DATE	              ,
					AMBITO	              VARCHAR2(40 CHAR)	  ,
					CLASIFIC_CONCURSOS	  VARCHAR2(1)         ,
					CLASIFIC_PERFIL	      VARCHAR2(1)	        ,
					REL_BANKIA	          VARCHAR2(40 CHAR)	  ,
					DES_PERSONA_CONTACTO	VARCHAR2(100 CHAR)  ,
					USUARIOCREAR          VARCHAR2(50 CHAR)   ,
					FECHACREAR            TIMESTAMP(6)        ,
					USUARIOMODIFICAR      VARCHAR2(50 CHAR)   ,
					FECHAMODIFICAR        TIMESTAMP(6)        ,
					USUARIOBORRAR      VARCHAR2(50 CHAR)   ,
					FECHABORRAR           TIMESTAMP(6) , 
					CONSTRAINT PK_RCV_GEST_DESP_PROC PRIMARY KEY (FECHA_PROCESO,DES_ID)
				)
				'; 
		EXECUTE IMMEDIATE V_MSQL;
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.RCV_GEST_LETR_PROC... Se ha creado la tabla auxiliar.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.RCV_GEST_LETR_PROC... La tabla indicada ya existe.');	
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.RCV_GEST_LETR_PROC... Crear tabla auxiliar.');
	
		
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;	  
END;

/
 
EXIT;
