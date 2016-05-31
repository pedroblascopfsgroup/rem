--/*
--##########################################
--## AUTOR=CARLOS LOPEZ VIDAL
--## FECHA_CREACION=20160308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2727
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de paquete REG_EJECUCIONES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PACKAGE PAQ_REG_EJECUCION AS
 
  procedure inicio_ejecucion(pNombre_ejecutable IN VARCHAR2, pVersion_ejecutable IN varchar2);
  -- Genera un registro en REG_EJECUCION con el nombre y versión del ejecutable, fecha de inicio sysdate y estatus KO. (Ojo, posee Commit)
   
  procedure fin_ejecucion(pNombre_ejecutable IN VARCHAR2);
  -- Actualiza el último registro en REG_EJECUCION con el nombre del ejecutable con duración (sysdate - fecha de inicio) estatus OK. (Ojo, posee Commit)
   
  procedure estadisticas_ejecucion(pNombre_ejecutable IN VARCHAR2, pNumero_cambios IN NUMBER);
  --Actualiza el último registro en REG_EJECUCION con el número de cambios en la tabla principal (sin commit)
 
END PAQ_REG_EJECUCION;
/

-------------------------------------------------------------

create or replace PACKAGE BODY PAQ_REG_EJECUCION
AS

  --Declaración de variables privadas

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
    TABLA VARCHAR(30) :='REG_EJECUCIONES';
    ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
    err_num NUMBER;
    err_msg VARCHAR2(2048 CHAR); 
    V_MSQL VARCHAR2(8500 CHAR);
    V_EXISTE NUMBER (1);

  procedure inicio_ejecucion(pNombre_ejecutable IN VARCHAR2, 
                                            pVersion_ejecutable IN varchar2)
   AS
   -- Genera un registro en REG_EJECUCION con el nombre y versión del ejecutable, fecha de inicio sysdate y estatus KO. (Ojo, posee Commit)
   
    V_SQL VARCHAR2(4000);
  BEGIN
  
    Begin                     
      V_SQL := 'Insert Into '||V_ESQUEMA||'.REG_EJECUCIONES ' ||
                    ' (REG_FECHA_PROCESO	,
                       REG_NOM_PROCESO,
                       REG_VERSION,
                       REG_ESTATUS,
                       REG_NUM_CAMBIOS,
                       REG_FECHA_INI,
                       DURACION) '||   
        '          Values (trunc(sysdate),'''||
                          pNombre_ejecutable||''','''||
                          pVersion_ejecutable||''','||
                          '''KO'',
                          null,
                          sysdate,
                          null)';
      EXECUTE IMMEDIATE V_SQL;                      
                                       
    Exception
      When Dup_Val_On_Index then
        --para si en un futuro se añadiera una PK
        DBMS_OUTPUT.PUT_LINE ('WARNING: Clave duplicada. ' || pNombre_ejecutable || '.' || pVersion_ejecutable || '. ' || sqlcode || ' --- ' || sqlerrm);
    End;
    
    COMMIT;   
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR: PAQ_REG_EJECUCION.inicio_ejecucion ' || pNombre_ejecutable || '.' || pVersion_ejecutable || '. ' || sqlcode || ' --- ' || sqlerrm);
      ROLLBACK;
      RAISE;    
    
  END inicio_ejecucion;

  procedure fin_ejecucion(pNombre_ejecutable IN VARCHAR2)
   AS
   -- Actualiza el último registro en REG_EJECUCION con el nombre del ejecutable con duración (sysdate - fecha de inicio) estatus OK. (Ojo, posee Commit)
  
    V_SQL_CURSOR VARCHAR2(4000);
    V_SQL              VARCHAR2(4000);
    
    TYPE CUR_TYP IS REF CURSOR;
    CURSOR1 CUR_TYP;    
    
    TYPE REG_TYP IS RECORD (tREG_FECHA_INI REG_EJECUCIONES.REG_FECHA_INI%TYPE);
    REG REG_TYP;    
  
  BEGIN

    V_SQL_CURSOR := 'SELECT REG_FECHA_INI FROM ' || V_ESQUEMA || '.REG_EJECUCIONES WHERE  REG_FECHA_PROCESO = TRUNC(SYSDATE) AND REG_NOM_PROCESO = '''||pNombre_ejecutable || ''' ORDER BY 1 desc ';
    DBMS_OUTPUT.PUT_LINE (V_SQL_CURSOR);
    
    OPEN CURSOR1 FOR V_SQL_CURSOR;
  
       --LOOP
          FETCH CURSOR1 INTO REG;
          --EXIT WHEN CURSOR1%NOTFOUND;
          
          IF REG.tREG_FECHA_INI is not null then
             V_SQL :=  ' Update ' || V_ESQUEMA || '.REG_EJECUCIONES '||
                            '       set Duracion = TO_NUMBER(TO_CHAR(SYSDATE,''SS'') + TO_CHAR(SYSDATE,''MI'')*60 + TO_CHAR(SYSDATE,''HH24'')*60*60 + TO_CHAR(SYSDATE,''dd'')*24*60*60 )- '||
                            '                              TO_NUMBER(extract(second from Reg_fecha_Ini) +extract(minute from Reg_fecha_Ini) * 60 +extract(hour from Reg_fecha_Ini) * 60 * 60 +extract( day from Reg_fecha_Ini ) * 60 * 60 * 24) , '||
                           -- '       set Duracion = SYSDATE - Reg_fecha_Ini ,'||
                            '            Reg_estatus = ''OK'' '||
                            '  Where Reg_Nom_Proceso = ''' || pNombre_ejecutable ||'''' ||
                            '     And Reg_Fecha_Proceso = TRUNC(SYSDATE) '||
                            '     And Reg_fecha_Ini = '''|| REG.tREG_FECHA_INI ||'''' ;         
             
             EXECUTE IMMEDIATE V_SQL; 
          END IF;   
      -- END LOOP;
  
    CLOSE CURSOR1;
    
    COMMIT;   
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('ERROR: PAQ_REG_EJECUCION.fin_ejecucion ' || pNombre_ejecutable || '. ' || sqlcode || ' --- ' || sqlerrm);
      ROLLBACK;
      RAISE;    
    
  END fin_ejecucion;
  
  procedure estadisticas_ejecucion(pNombre_ejecutable IN VARCHAR2,
                                                     pNumero_cambios IN NUMBER)
   AS
   -- Actualiza el último registro en REG_EJECUCION con el número de cambios en la tabla principal (sin commit)
  
    V_SQL_CURSOR VARCHAR2(4000);
    V_SQL              VARCHAR2(4000);
    
    TYPE CUR_TYP IS REF CURSOR;
    CURSOR1 CUR_TYP;    
    
    TYPE REG_TYP IS RECORD (tREG_FECHA_INI REG_EJECUCIONES.REG_FECHA_INI%TYPE);
    REG REG_TYP;    
  
  BEGIN

    V_SQL_CURSOR := 'SELECT REG_FECHA_INI FROM ' || V_ESQUEMA || '.REG_EJECUCIONES WHERE  REG_FECHA_PROCESO = TRUNC(SYSDATE) AND REG_NOM_PROCESO = '''||pNombre_ejecutable || ''' ORDER BY 1 desc ';
    DBMS_OUTPUT.PUT_LINE (V_SQL_CURSOR);
    
    OPEN CURSOR1 FOR V_SQL_CURSOR;
  
       --LOOP
          FETCH CURSOR1 INTO REG;
          --EXIT WHEN CURSOR1%NOTFOUND;
          
          IF REG.tREG_FECHA_INI is not null then
             V_SQL :=  ' Update ' || V_ESQUEMA || '.REG_EJECUCIONES '||
                            '       set Reg_Num_Cambios = '||pNumero_cambios||
                            ' Where Reg_Nom_Proceso = ''' || pNombre_ejecutable ||'''' ||
                            '    And Reg_Fecha_Proceso = TRUNC(SYSDATE) '||
                            '    And Reg_fecha_Ini = '''|| REG.tREG_FECHA_INI ||'''' ;
             
             EXECUTE IMMEDIATE V_SQL; 
          END IF;   
      -- END LOOP;
  
    CLOSE CURSOR1;
    
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE ('ERROR: PAQ_REG_EJECUCION.estadisticas_ejecucion ' || pNombre_ejecutable || '.' || pNumero_cambios || '. ' || sqlcode || ' --- ' || sqlerrm);
    RAISE;     
    
  END estadisticas_ejecucion;  
END PAQ_REG_EJECUCION;
/
