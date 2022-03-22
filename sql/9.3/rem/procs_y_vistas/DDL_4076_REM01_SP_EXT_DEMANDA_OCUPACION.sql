--/*
--#########################################
--## AUTOR=SANTI MONZÓ
--## FECHA_CREACION=20211011
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=HREOS-15477
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 CARLOS LÓPEZ HREOS-4530 Versión inicial
--##        0.2 NOELIA LAPERA HREOS-4790 Se update la tabla OKU_DEMANDA_OCUPACION_ILEGAL si los activos y los asuntos ya existen
--##        0.3 SANTI MONZÓ HREOS-15477 Añadir PRAGMA AUTONOMOUS_TRANSACTION;
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE SP_EXT_DEMANDA_OCUPACION (
	NUM_ACTIVO_HAYA IN #ESQUEMA#.ACT_ACTIVO.ACT_NUM_ACTIVO%TYPE,
  NUMERO_ASUNTO IN #ESQUEMA#.OKU_DEMANDA_OCUPACION_ILEGAL.OKU_NUM_ASUNTO%TYPE,
  FECHA_INI_ASUNTO IN VARCHAR2,
  FECHA_FIN_ASUNTO IN VARCHAR2,
  FECHA_LANZAMIENTO IN VARCHAR2,
	COD_TIPO_ASUNTO IN #ESQUEMA#.DD_TAO_OKU_TIPO_ASUNTO.DD_TAO_CODIGO%TYPE,
  COD_TIPO_ACTUACION IN #ESQUEMA#.DD_TCO_OKU_TIPO_ACTUACION.DD_TCO_CODIGO%TYPE,
	COD_RETORNO OUT NUMBER
)
AS

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 	-- 'REMMASTER'; -- Configuracion Esquema Master
	err_num NUMBER; 								-- Numero de errores
	err_msg VARCHAR2(2048);
	V_NUM NUMBER(16);
	V_COUNT NUMBER(16) := 0;
	V_SQL VARCHAR2(4000 CHAR);
	V_MSQL VARCHAR2(4000 CHAR);
  ErrorControlado VARCHAR2(2000);

	V_SEC VARCHAR2(30 CHAR) := '';
	V_NUM_TABLAS NUMBER(20);
	V_TABLA_HLP VARCHAR2(30 CHAR) := 'HLP_HISTORICO_LANZA_PERIODICO';
	V_TABLA_HLD VARCHAR2(30 CHAR) := 'HLD_HISTORICO_LANZA_PER_DETA';
	V_TABLA_OKU VARCHAR2(30 CHAR) := 'OKU_DEMANDA_OCUPACION_ILEGAL';
	V_TABLA_ACT VARCHAR2(30 CHAR) := 'ACT_ACTIVO';
  V_SP VARCHAR2(30 CHAR) := 'SP_EXT_DEMANDA_OCUPACION';
  
  
  nACT_ID    #ESQUEMA#.ACT_ACTIVO.ACT_ID%type;
  nDD_TAO_ID #ESQUEMA#.DD_TAO_OKU_TIPO_ASUNTO.DD_TAO_ID%type;
  nDD_TCO_ID #ESQUEMA#.DD_TCO_OKU_TIPO_ACTUACION.DD_TCO_ID %type; 
  nSeq       NUMBER;

  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
	--v0.1
	 DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
   DBMS_OUTPUT.PUT_LINE('FECHA_INI_ASUNTO (Se espera yyyyMMdd): '||FECHA_INI_ASUNTO);
   DBMS_OUTPUT.PUT_LINE('FECHA_FIN_ASUNTO (Se espera yyyyMMdd): '||FECHA_FIN_ASUNTO);
   DBMS_OUTPUT.PUT_LINE('FECHA_LANZAMIENTO (Se espera yyyyMMdd): '||FECHA_LANZAMIENTO);
            
   BEGIN
     SELECT ACT.ACT_ID
       INTO nACT_ID
       FROM #ESQUEMA#.ACT_ACTIVO ACT
      WHERE ACT.ACT_NUM_ACTIVO = NUM_ACTIVO_HAYA
        AND ACT.BORRADO = 0;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       nACT_ID := NULL;
       ErrorControlado := 'No existe el ACTIVO.';
   END;

   /*Tipos de asunto de ocupaciones*/
   BEGIN
     SELECT TAO.DD_TAO_ID
       INTO nDD_TAO_ID
       FROM #ESQUEMA#.DD_TAO_OKU_TIPO_ASUNTO TAO
      WHERE TAO.DD_TAO_CODIGO = COD_TIPO_ASUNTO
        AND TAO.BORRADO = 0;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       nDD_TAO_ID := NULL;
       ErrorControlado := ErrorControlado|| 'No existe el tipo de asunto.';
   END;
   
   /*Tipo actuación*/
   BEGIN
     SELECT TCO.DD_TCO_ID
       INTO nDD_TCO_ID
       FROM #ESQUEMA#.DD_TCO_OKU_TIPO_ACTUACION TCO
      WHERE TCO.DD_TCO_CODIGO = COD_TIPO_ACTUACION
        AND TCO.BORRADO = 0;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       nDD_TCO_ID := NULL;
       ErrorControlado := ErrorControlado|| 'No existe el tipo de actuación.';
   END;   

   IF nACT_ID IS NOT NULL AND nDD_TAO_ID IS NOT NULL AND nDD_TCO_ID IS NOT NULL THEN
      
      SELECT #ESQUEMA#.S_OKU_DEMANDA_OCUPACION_ILEGAL.NEXTVAL
        INTO nSeq
        FROM DUAL;
   
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLD||' (
        HLD_SP_CARGA,
        HLD_FECHA_EJEC,
        HLD_CODIGO_REG,
        HLD_TABLA_MODIFICAR,
        HLD_TABLA_MODIFICAR_CLAVE,
        HLD_TABLA_MODIFICAR_CLAVE_ID,
        HLD_CAMPO_MODIFICAR,
        HLD_VALOR_ORIGINAL,
        HLD_VALOR_ACTUALIZADO
       )VALUES(
       '''||V_SP||''',
       SYSDATE,
       '||nACT_ID||',
       '''||V_TABLA_OKU||''',
       ''OKU_ID'',
       '||nSeq||',
       ''OKU_NUM_ASUNTO'',
       '''||NUMERO_ASUNTO||''',
       NULL)
       ';
       EXECUTE IMMEDIATE V_MSQL;
       
	--Comprobar el dato a insertar.
       V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_OKU||' WHERE ACT_ID = '||nACT_ID||' AND OKU_NUM_ASUNTO ='''||NUMERO_ASUNTO||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
       
	IF V_NUM_TABLAS > 0 THEN				
          -- Si existe se modifica.
	V_MSQL := 'UPDATE '||V_ESQUEMA ||'.'||V_TABLA_OKU||' '||
                    'SET OKU_FECHA_INICIO_ASUNTO = to_date('''||FECHA_INI_ASUNTO||''',''yyyyMMdd'')  '|| 
					', OKU_FECHA_FIN_ASUNTO = to_date('''||FECHA_FIN_ASUNTO||''',''yyyyMMdd'')  '||
					', OKU_FECHA_LANZAMIENTO = to_date('''||FECHA_LANZAMIENTO||''',''yyyyMMdd'') '||
					', DD_TAO_ID = '||nDD_TAO_ID||''||
					', DD_TCO_ID = '||nDD_TCO_ID||''||
					', USUARIOMODIFICAR = '''||V_SP||''''||
					', FECHAMODIFICAR = SYSDATE '||
					'WHERE ACT_ID = '||nACT_ID||' AND OKU_NUM_ASUNTO ='''||NUMERO_ASUNTO||''' ';
	EXECUTE IMMEDIATE V_MSQL;

	-- Si no existe se inserta.
	 ELSE
       	
       	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_OKU||' OKU (OKU_ID
                                                                      ,ACT_ID
                                                                      ,OKU_NUM_ASUNTO
                                                                      ,OKU_FECHA_INICIO_ASUNTO
                                                                      ,OKU_FECHA_FIN_ASUNTO
                                                                      ,OKU_FECHA_LANZAMIENTO
                                                                      ,DD_TAO_ID
                                                                      ,DD_TCO_ID
                                                                      ,VERSION
                                                                      ,USUARIOCREAR
                                                                      ,FECHACREAR
                                                                      ,BORRADO)
          VALUES('||nSeq||'
                  ,'||nACT_ID||'
                  ,'''||NUMERO_ASUNTO||'''
                  ,to_date('''||FECHA_INI_ASUNTO||''',''yyyyMMdd'')
                  ,to_date('''||FECHA_FIN_ASUNTO||''',''yyyyMMdd'')
                  ,to_date('''||FECHA_LANZAMIENTO||''',''yyyyMMdd'')
                  ,'||nDD_TAO_ID||'
                  ,'||nDD_TCO_ID||'
                  ,0
                  ,'''||V_SP||'''
                  ,sysdate
                  ,0
                 
                )   
       ';
DBMS_OUTPUT.PUT(V_MSQL);
       EXECUTE IMMEDIATE V_MSQL;
  END IF;

       V_COUNT := SQL%ROWCOUNT;
  
       V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
                          HLP_SP_CARGA,
                          HLP_FECHA_EJEC,
                          HLP_RESULTADO_EJEC,
                          HLP_CODIGO_REG,
                          HLP_REGISTRO_EJEC)
              VALUES('''||V_SP||''',
                     SYSDATE,
                     0,
                     '''||NUM_ACTIVO_HAYA||''' || ''|'' || '''||NUMERO_ASUNTO||''',
                     '||to_char(V_COUNT)||')';
                       
    EXECUTE IMMEDIATE V_MSQL;
                   
    COD_RETORNO := 0;
  ELSE
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
        HLP_SP_CARGA,
        HLP_FECHA_EJEC,
        HLP_RESULTADO_EJEC,
        HLP_CODIGO_REG,
        HLP_REGISTRO_EJEC
      )VALUES(
      '''||V_SP||''',
       SYSDATE,
       1,
       ''Valores: ''||'''||NUM_ACTIVO_HAYA||''' || ''|'' || '''||NUMERO_ASUNTO||'''  || ''|'' || '''||nACT_ID||'''  || ''|'' || '''||nDD_TAO_ID||'''  || ''|'' || '''||nDD_TCO_ID||''' ,  
       '''||ErrorControlado||'''
       )';

        EXECUTE IMMEDIATE V_MSQL;  
        
      COD_RETORNO := 1;  
  END IF;
    
  DBMS_OUTPUT.put_line('COD_RETORNO= '||COD_RETORNO);
  
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    
    ROLLBACK;
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_HLP||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    IF V_COUNT > 0 THEN

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_HLP||' (
        HLP_SP_CARGA,
        HLP_FECHA_EJEC,
        HLP_RESULTADO_EJEC,
        HLP_CODIGO_REG,
        HLP_REGISTRO_EJEC
      )VALUES(
      '''||V_SP||''',
       SYSDATE,
       1,
       '''||NUM_ACTIVO_HAYA||''' || ''|'' || '''||NUMERO_ASUNTO||''',
       '''||SQLERRM||'''
       )';
        EXECUTE IMMEDIATE V_MSQL;
  
      COMMIT;
	  END IF;
    
    COD_RETORNO := 1;
    
    RAISE;

END SP_EXT_DEMANDA_OCUPACION;
/

EXIT
