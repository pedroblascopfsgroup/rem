--/*
--##########################################
--## AUTOR=Alejandro Iñigo.
--## FECHA_CREACION=20160219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10
--## INCIDENCIA_LINK=BKREC-1718
--## PRODUCTO=NO
--## 
--## Finalidad: Carga ZONA_JERARQUIA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DATASTAGE#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='CARGAR_TABLA_PARAMETROS';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA||' (NOMBRE_TABLA_DESTINO, TIPO_CARGA,COLUMNAS,CLAUSULA_SELECT,CLAUSULA_FROM,CLAUSULA_WHERE,INDICE1,INDICE2,INDICE3,INDICE4,CLAUSULA_CREATE,ACTIVO,BLOQUE,ORDEN)
           VALUES (''ZONA_JERARQUIA'',
            1,
            ''NIVEL_0 ,NIVEL_1 ,NIVEL_2 ,NIVEL_3 ,NIVEL_4 ,NIVEL_5 ,NIVEL_6 ,NIVEL_7 ,NIVEL_8 ,NIVEL_9'',
            ''A.NIVEL_0 ,A.NIVEL_1 ,A.NIVEL_2 ,A.NIVEL_3 ,A.NIVEL_4 ,A.NIVEL_5 ,A.NIVEL_6 ,A.NIVEL_7 ,A.NIVEL_8 ,A.NIVEL_9'',
            ''BANK01.ZONA_JERARQUIA A'',
            '''',
            '''',
            '''',
            '''',
            '''',
            ''NIVEL_0 NUMBER(7), NIVEL_1 NUMBER(7), NIVEL_2 NUMBER(7), NIVEL_3 NUMBER(7), NIVEL_4 NUMBER(7), NIVEL_5 NUMBER(7), NIVEL_6 NUMBER(7), NIVEL_7 NUMBER(7), NIVEL_8 NUMBER(7), NIVEL_9 NUMBER(7)'',
            ''S'',
            1,
            182)';

EXECUTE IMMEDIATE V_MSQL;
COMMIT;
DBMS_OUTPUT.PUT_LINE('Insert en tabla '||TABLA||' correcto.');


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
