--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20170728
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.6
--## INCIDENCIA_LINK=HREOS-2568
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

TABLE_COUNT NUMBER(1,0)         :=  0;
V_ESQUEMA_1 VARCHAR2(20 CHAR)   :=  'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR)   :=  'REMMASTER';         --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA     VARCHAR2(40 CHAR)   :=  'MIG2_TMP_ULT_HIST_PUBLI';
--V_SEC       VARCHAR2(40 CHAR)   :=  'S_'||V_TABLA;

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||' 
           (    
                HEP_ACT_NUMERO_ACTIVO      NUMBER(16,0) NOT NULL,     
                HEP_FECHA_DESDE            DATE,
                HEP_FECHA_HASTA            DATE,
                HEP_COD_PORTAL             VARCHAR2(20 CHAR),
                HEP_COD_TIPO_PUBLICACION   VARCHAR2(20 CHAR),
                HEP_COD_ESTADO_PUBLI       VARCHAR2(20 CHAR),
                HEP_MOTIVO                 VARCHAR2(100 CHAR),
                RN NUMBER(1)
           ) 
        '
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

        /*SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''||V_SEC||'' AND SEQUENCE_OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT = 1 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] SECUENCIA '||V_ESQUEMA_1||'.'||V_SEC||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
                EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA_1||'.'||V_SEC||'';
        END IF;

        EXECUTE IMMEDIATE 'CREATE SEQUENCE  '||V_ESQUEMA_1||'.'||V_SEC||' MINVALUE 0 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 0 CACHE 20 NOORDER  NOCYCLE';

        DBMS_OUTPUT.PUT_LINE('[INFO] SECUENCIA '||V_ESQUEMA_1||'.'||V_SEC||' CREADA');*/

        IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN
            EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
            DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||'');
            --EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_SEC||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
            --DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA SECUENCIA '||V_ESQUEMA_1||'.'||V_SEC||' OTORGADOS A '||V_ESQUEMA_2||'');
        END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT;
