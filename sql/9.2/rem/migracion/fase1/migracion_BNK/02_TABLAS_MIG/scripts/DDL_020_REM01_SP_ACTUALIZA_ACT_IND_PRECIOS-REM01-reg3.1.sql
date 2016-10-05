--/*
--##########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160907
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: ACTUALIZA_ACT_IND_PRECIOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

create or replace PROCEDURE ACTUALIZA_ACT_IND_PRECIOS (P_DD_CRA_ID IN REM01.ACT_ACTIVO.DD_CRA_ID%TYPE DEFAULT NULL
                                                                                                 ,P_ACT_ID IN REM01.ACT_ACTIVO.ACT_ID%TYPE DEFAULT NULL
                                                                                                 ,RESULT_EXE OUT VARCHAR2 ) AUTHID CURRENT_USER IS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'ESQUEMA_MASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REGS NUMBER(16);
    V_NUM_REGS2 NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
      
    TYPE carCurTyp IS REF CURSOR;
    v_car_cursor    carCurTyp;
    
    TYPE condCurTyp IS REF CURSOR;
    v_cond_cursor    condCurTyp;

    TYPE preCurTyp IS REF CURSOR;
    v_pre_cursor    preCurTyp;
    
    v_stmt_cond   VARCHAR2(4000 CHAR);
    v_stmt_car     VARCHAR2(4000 CHAR);
    v_stmt_pre     VARCHAR2(4000 CHAR);
    
    v_updt           VARCHAR2(4000 CHAR);

	V_USUARIO VARCHAR2(50 CHAR) := 'SP_ACT_IND_PRECIOS';
    V_FECHA    VARCHAR2(50 CHAR) := SYSDATE;
    
    dACT_FECHA_IND_PRECIAR       REM01.ACT_ACTIVO.ACT_FECHA_IND_PRECIAR%TYPE;
    dACT_FECHA_IND_REPRECIAR   REM01.ACT_ACTIVO.ACT_FECHA_IND_REPRECIAR%TYPE;
    dACT_FECHA_IND_DESCUENTO REM01.ACT_ACTIVO.ACT_FECHA_IND_DESCUENTO%TYPE;
    
    vDD_CIP_TEXTO                       REM01.DD_CIP_CONDIC_IND_PRECIOS.DD_CIP_TEXTO%TYPE;
    Aux_DD_CIP_TEXTO                 VARCHAR2(32000 CHAR);
    nDD_TPP_ID                             REM01.CCP_CARTERA_CONDIC_PRECIOS.DD_TPP_ID%TYPE;
    nDD_CRA_ID                            REM01.ACT_ACTIVO.DD_CRA_ID%TYPE;
    vDD_TPP_CODIGO                    REM01.DD_TPP_TIPO_PROP_PRECIO.DD_TPP_ID%TYPE; 
    vACT_FECHA_IND                     VARCHAR2(50 CHAR);
    vDD_CRA_DESCRIPCION            REM01.DD_CRA_CARTERA.DD_CRA_DESCRIPCION%TYPE;
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] ' );

    v_updt := ' UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ' ||
                   '        SET ACT_FECHA_IND_PRECIAR = NULL 
                                ,ACT_FECHA_IND_REPRECIAR = NULL
                               ,ACT_FECHA_IND_DESCUENTO = NULL 
                      WHERE BORRADO = 0 ' ;

    IF P_ACT_ID IS NOT NULL THEN
      v_updt := v_updt || ' AND ACT_ID = '|| P_ACT_ID;
    END IF;
  
    IF P_DD_CRA_ID IS NOT NULL THEN
      v_updt := v_updt || ' AND DD_CRA_ID = '|| P_DD_CRA_ID;
    END IF;
 
   execute immediate v_updt;

  --<Carteras
  v_stmt_Car := 'SELECT distinct ACT.DD_CRA_ID
                        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,  '||V_ESQUEMA||'.CCP_CARTERA_CONDIC_PRECIOS CCP
                     WHERE ACT.DD_CRA_ID = CCP.DD_CRA_ID
                         AND ACT.BORRADO = 0 
                         AND ACT.DD_CRA_ID is not null ';  
  --Fin carteras>

  --<Condiciones
  v_stmt_cond := '
      SELECT replace(replace(replace(DD_CIP.DD_CIP_TEXTO,'':mayor_que'',CCP.CCP_MAYOR_QUE),'':menor_que'',CCP.CCP_MENOR_QUE),'':igual_a'',CCP.CCP_IGUAL_A)
        FROM '||V_ESQUEMA||'.DD_CIP_CONDIC_IND_PRECIOS DD_CIP
       INNER JOIN '||V_ESQUEMA||'.CCP_CARTERA_CONDIC_PRECIOS CCP ON CCP.DD_CIP_ID = DD_CIP.DD_CIP_ID 
      WHERE CCP.BORRADO = 0
          AND DD_CIP.BORRADO = 0 
          AND DD_CIP.DD_CIP_TEXTO IS NOT NULL 
          AND CCP.DD_CRA_ID = :a
          AND CCP.DD_TPP_ID = :b ';
  --Fin condiciones>

  --<preciar/repreciar/dto
  v_stmt_pre := '
      SELECT DISTINCT CCP.DD_TPP_ID
        FROM '||V_ESQUEMA||'.DD_CIP_CONDIC_IND_PRECIOS DD_CIP
       INNER JOIN '||V_ESQUEMA||'.CCP_CARTERA_CONDIC_PRECIOS CCP ON CCP.DD_CIP_ID = DD_CIP.DD_CIP_ID 
      WHERE CCP.BORRADO = 0
          AND DD_CIP.BORRADO = 0 
          AND DD_CIP.DD_CIP_TEXTO IS NOT NULL 
          AND CCP.DD_CRA_ID = :a ';
  --Fin preciar/repreciar/dto>

  IF P_ACT_ID IS NOT NULL THEN
    v_stmt_car := v_stmt_car || ' AND ACT.ACT_ID = '|| P_ACT_ID;
  END IF;

  IF P_DD_CRA_ID IS NOT NULL THEN
    v_stmt_cond := v_stmt_cond || ' AND CCP.DD_CRA_ID = '|| P_DD_CRA_ID;
    v_stmt_car := v_stmt_car || ' AND ACT.DD_CRA_ID = '|| P_DD_CRA_ID;
  END IF;

     OPEN v_car_cursor FOR v_stmt_car;
      LOOP
        FETCH v_car_cursor INTO nDD_CRA_ID;
        EXIT WHEN v_car_cursor%NOTFOUND; 

         EXECUTE IMMEDIATE ' SELECT DD_CRA.DD_CRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_CRA_CARTERA DD_CRA WHERE DD_CRA.DD_CRA_ID = '|| nDD_CRA_ID INTO vDD_CRA_DESCRIPCION;

         OPEN v_pre_cursor FOR v_stmt_pre USING nDD_CRA_ID;
          LOOP
            FETCH v_pre_cursor INTO nDD_TPP_ID;
            EXIT WHEN v_pre_cursor%NOTFOUND;

		      Aux_DD_CIP_TEXTO := NULL;

              OPEN v_cond_cursor FOR v_stmt_cond USING nDD_CRA_ID, nDD_TPP_ID;
                LOOP
                  FETCH v_cond_cursor INTO vDD_CIP_TEXTO;
                  EXIT WHEN v_cond_cursor%NOTFOUND;
          
                  Aux_DD_CIP_TEXTO := Aux_DD_CIP_TEXTO ||' '||vDD_CIP_TEXTO;
   
              END LOOP;  
            CLOSE v_cond_cursor; 

            EXECUTE IMMEDIATE ' SELECT DD_TPP.DD_TPP_CODIGO FROM '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO DD_TPP WHERE DD_TPP.DD_TPP_ID = '||nDD_TPP_ID INTO vDD_TPP_CODIGO;

            IF vDD_TPP_CODIGO = '01' THEN /*Preciar*/
              vACT_FECHA_IND := 'ACT.ACT_FECHA_IND_PRECIAR ';
              RESULT_EXE := RESULT_EXE || ' Cartera: '||vDD_CRA_DESCRIPCION||' '||'Actualizados ACT_FECHA_IND_PRECIAR: ';
            ELSIF vDD_TPP_CODIGO = '02' THEN /*Repreciar*/
              vACT_FECHA_IND := 'ACT.ACT_FECHA_IND_REPRECIAR';
              RESULT_EXE := RESULT_EXE || ' Cartera: '||vDD_CRA_DESCRIPCION||' '||'Actualizados ACT_FECHA_IND_REPRECIAR: ';
            ELSIF vDD_TPP_CODIGO = '03' THEN /*De descuento*/
              vACT_FECHA_IND := 'ACT.ACT_FECHA_IND_DESCUENTO';
              RESULT_EXE := RESULT_EXE || ' Cartera: '||vDD_CRA_DESCRIPCION||' '||'Actualizados ACT_FECHA_IND_DESCUENTO:  ';
            END IF;
          
              EXECUTE IMMEDIATE '
                MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
                    (   SELECT DISTINCT ACT.ACT_ID  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT '||Aux_DD_CIP_TEXTO ||'  AND ACT.BORRADO = 0
                    ) aux
                      ON (ACT.ACT_ID = aux.ACT_ID AND ACT.DD_CRA_ID ='||nDD_CRA_ID||' AND ACT.BORRADO = 0)
                      WHEN MATCHED THEN
                        UPDATE SET '||
                          vACT_FECHA_IND ||' = ''' ||V_FECHA||'''
                          ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                          ,ACT.FECHAMODIFICAR = ''' ||V_FECHA||''' ';  
                       
              RESULT_EXE := RESULT_EXE ||TO_CHAR(SQL%ROWCOUNT) /*||chr(13)*/||chr(10);     
               
          END LOOP;  
        CLOSE v_pre_cursor;  
        
      END LOOP;  
    CLOSE v_car_cursor;           
  
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE(RESULT_EXE );
    
    RESULT_EXE := RESULT_EXE||'Finalizado correctamente';
  
    DBMS_OUTPUT.PUT_LINE('[FIN] ' );

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

EXIT
