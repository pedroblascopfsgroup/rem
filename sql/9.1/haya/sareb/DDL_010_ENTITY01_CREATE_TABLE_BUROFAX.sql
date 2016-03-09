--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=20160309
--## ARTEFACTO=9.1
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-1447
--## PRODUCTO=NO
--## Finalidad: DDL creacion tablas TMP_PCO_GEN_BUROFAX y TMP_PCO_REC_BUROFAX y agregar campo PCO_BUR_MOTIVO_INCIDENCIA en PCO_BUR_ENVIO_INTEGRACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);



BEGIN
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: TMP_PCO_GEN_BUROFAX.');
    
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_PCO_GEN_BUROFAX'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN

    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_PCO_GEN_BUROFAX(
                    ID_ENVIO_BUROFAX	NUMBER (16) not null,
                    ID_BUROFAX	NUMBER (16) not null,
                    ID_PROCEDIMIENTO	NUMBER (16) not null,
                    CODIGO_PERSONA	NUMBER (16) ,
                    NIF_CIF_PASAP_NIE	VARCHAR2 (20),
                    NOM_COMPLETO	VARCHAR2 (300) ,
                    CODIGO_ENTIDAD	NUMBER (4) not null,
                    CODIGO_PROPIETARIO	NUMBER (5) not null,
                    TIPO_PRODUCTO	VARCHAR2 (5) not null,
                    NUMERO_CONTRATO	NUMBER (17) not null,
                    TIPO_INTERVENCION	VARCHAR2 (10 CHAR) not null,
                    DIRECCION	VARCHAR2 (200) not null,
                    TIPO_VIA	VARCHAR2 (100),
                    NOMBRE_VIA	VARCHAR2 (100),
                    NUM_DOMICILIO	VARCHAR2 (10),
                    PORTAL	VARCHAR2 (15),
                    PISO	VARCHAR2 (10),
                    ESCALERA	VARCHAR2 (10),
                    PUERTA	VARCHAR2 (10),
                    CODIGO_POSTAL	VARCHAR2 (10),
                    PROVINCIA	VARCHAR2 (100),
                    POBLACION	VARCHAR2 (100),
                    MUNICIPIO	VARCHAR2 (100),
                    PAIS	VARCHAR2 (100),
                    CODIGO_INE_PROVINCIA	NUMBER (10),
                    CODIGO_INE_POBLACION	NUMBER (10),
                    CODIGO_INE_MUNICIPIO	NUMBER (10),
                    CODIGO_INE_VIA	NUMBER (10),
                    TIPO_BUROFAX	VARCHAR2 (50) not null,
                    FECHA_SOLICITUD	VARCHAR2 (8) not null,
                    CONTENIDO_BUROFAX	VARCHAR2 (4000) not null,
                    CERTIFICADO_REQUERIDO	NUMBER (1) not null
                    )'
                    ;
EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('    [INFO] tabla creada.');	
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla ya existe');
END IF;
----------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[FIN]');
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: TMP_PCO_REC_BUROFAX.');
    
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_PCO_REC_BUROFAX'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_PCO_REC_BUROFAX(
    ID_ENVIO_BUROFAX	NUMBER (16) NOT NULL,
    ID_BUROFAX	NUMBER (16) NOT NULL,
    ID_PROCEDIMIENTO	NUMBER (16) NOT NULL,
    CODIGO_PERSONA	NUMBER (16) ,
    NIF_CIF_PASAP_NIE	VARCHAR2 (20),
    NOM_COMPLETO	VARCHAR2 (300) ,
    CODIGO_ENTIDAD	NUMBER (4) NOT NULL,
    CODIGO_PROPIETARIO	NUMBER (5) NOT NULL,
    TIPO_PRODUCTO	VARCHAR2 (5) NOT NULL,
    NUMERO_CONTRATO	NUMBER (17) NOT NULL,
    TIPO_INTERVENCION	VARCHAR2 (50 CHAR) NOT NULL,
    DIRECCION	VARCHAR2 (200) NOT NULL,
    TIPO_VIA	VARCHAR2 (100),
    NOMBRE_VIA	VARCHAR2 (100),
    NUM_DOMICILIO	VARCHAR2 (10),
    PORTAL	VARCHAR2 (15),
    PISO	VARCHAR2 (10),
    ESCALERA	VARCHAR2 (10),
    PUERTA	VARCHAR2 (10),
    CODIGO_POSTAL	VARCHAR2 (10),
    PROVINCIA	VARCHAR2 (100),
    POBLACION	VARCHAR2 (100),
    MUNICIPIO	VARCHAR2 (100),
    PAIS	VARCHAR2 (100),
    CODIGO_INE_PROVINCIA	NUMBER (10),
    CODIGO_INE_POBLACION	NUMBER (10),
    CODIGO_INE_MUNICIPIO	NUMBER (10),
    CODIGO_INE_VIA	NUMBER (10),
    TIPO_BUROFAX	VARCHAR2 (50) NOT NULL,
    FECHA_SOLICITUD	VARCHAR2(8 CHAR) NOT NULL,
    CONTENIDO_BUROFAX	VARCHAR2 (4000) NOT NULL,
    CERTIFICADO_REQUERIDO	NUMBER (1) NOT NULL,
    ESTADO_BUROFAX	VARCHAR2(20 CHAR)  NOT NULL,
    FECHA_ESTADO	TIMESTAMP(6),
    MOTIVO_INCIDENCIA	VARCHAR2(20 CHAR),
    ACUSE_RECIBO_PDF	VARCHAR2(50 CHAR),
    REFERENCIA_UNIPOST VARCHAR2(20 CHAR),
    ACUSE_RECIBO_TIF VARCHAR2(50 CHAR),
    ID_ADJ NUMBER(16,0)
    
)'
                    ;
EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('    [INFO] tabla creada.');		
ELSE
	DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla ya existe.');
END IF;

--------------------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[FIN]');
DBMS_OUTPUT.PUT_LINE(' ');
DBMS_OUTPUT.PUT_LINE('[INICIO] Añadir campo: PCO_BUR_MOTIVO_INCIDENCIA en PCO_BUR_ENVIO_INTEGRACION.');
    
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_BUR_ENVIO_INTEGRACION'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 1 THEN

    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''PCO_BUR_ENVIO_INTEGRACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''PCO_BUR_MOTIVO_INCIDENCIA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
      V_SQL := 'alter table  '||V_ESQUEMA||'.PCO_BUR_ENVIO_INTEGRACION add(
        PCO_BUR_MOTIVO_INCIDENCIA VARCHAR2(20 CHAR)
      )';
      EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('    [INFO] Campo agregado correctamente.'); 
    ELSE
      DBMS_OUTPUT.PUT_LINE('    [INFO] El campo ya existe.');
    END IF;
ELSE
    DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla PCO_BUR_ENVIO_INTEGRACION NO existe.');
END IF;
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;

/

EXIT
