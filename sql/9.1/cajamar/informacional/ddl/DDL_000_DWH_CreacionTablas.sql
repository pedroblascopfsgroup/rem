--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3318 FECHA_SENYAL_LANZAMIENTO
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de tabla D_BIE_GARANTIA_NUM_OPER_BIE_AGR , D_BIE_GARANTIA_NUM_OPER_BIE , D_PRC_GESTOR_HAYA , D_PRC_DESPACHO_GESTOR_HAYA y D_PRC_CON_POSTORES 
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 TABLA VARCHAR(30) :='D_F_SENYAL_LANZA_ANIO2';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  V_MSQL := 'SELECT COUNT(1) 
			FROM ALL_TABLES
			WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
  
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
            (ANIO_SENYAL_LANZA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla
TABLA := 'D_F_SENYAL_LANZA_DIA_SEMANA2';
--Validamos si la tabla existe antes de crearla

  V_EXISTE := 0;

  V_MSQL := 'SELECT COUNT(1) 
			FROM ALL_TABLES
			WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
             (DIA_SEMANA_SENYAL_LANZA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla

TABLA := 'D_F_SENYAL_LANZA_MES2';
--Validamos si la tabla existe antes de crearla

  V_EXISTE := 0;

  V_MSQL := 'SELECT COUNT(1) 
			FROM ALL_TABLES
			WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
             (MES_SENYAL_LANZA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SENYAL_LANZA_ID INTEGER,
                            TRIMESTRE_SENYAL_LANZA_ID INTEGER,
                            ANIO_SENYAL_LANZA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla

TABLA := 'D_F_SENYAL_LANZA_MES_ANIO2';
--Validamos si la tabla existe antes de crearla

  V_EXISTE := 0;

  V_MSQL := 'SELECT COUNT(1) 
			FROM ALL_TABLES
			WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
             (MES_ANIO_SENYAL_LANZA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla

TABLA := 'D_F_SENYAL_LANZA_TRIMESTRE2';
--Validamos si la tabla existe antes de crearla

  V_EXISTE := 0;

  V_MSQL := 'SELECT COUNT(1) 
			FROM ALL_TABLES
			WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
             (TRIMESTRE_SENYAL_LANZA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SENYAL_LANZA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla

TABLA := 'D_F_SENYAL_LANZA_DIA2';
--Validamos si la tabla existe antes de crearla

  V_EXISTE := 0;

  V_MSQL := 'SELECT COUNT(1) 
      FROM ALL_TABLES
      WHERE TABLE_NAME = '''||TABLA||'''';

  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
             (DIA_SENYAL_LANZA_ID DATE NOT NULL,
                            DIA_SEMANA_SENYAL_LANZA_ID INTEGER,
                            MES_SENYAL_LANZA_ID INTEGER,
                            TRIMESTRE_SENYAL_LANZA_ID INTEGER,
                            ANIO_SENYAL_LANZA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SENYAL_LANZA_ID))';
 
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');  
    
  END IF;   

--Fin crear tabla
--Excepciones
          

EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT
