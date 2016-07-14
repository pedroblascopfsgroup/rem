create or replace PROCEDURE  CARGA_PRC_PROC_JERARQUIA IS 
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Abril 2015
-- Responsable ultima modificacion:
-- Fecha ultima modificacion: 29/04/2015
-- Motivos del cambio:
-- Cliente: Recovery BI Bankia
--
-- Descripcion: Procedimiento para cargar la tabla PRC_PROCEDIMIENTO_JERARQUIA
-- ===============================================================================================


  nCount NUMBER;
  V_ESQUEMA VARCHAR2(100);
  V_NOMBRE VARCHAR2(50) := 'PRC_PROCEDIMIENTOS_JERARQUIA';
  V_SQL VARCHAR2(500);
  V_FECHA date;
  
  Cursor C1 is select distinct(trunc(prc.FECHACREAR)) from BANK01.PRC_PROCEDIMIENTOS prc
                where trunc(prc.FECHACREAR) > (select NVL(max(trunc(FECHA_PROCEDIMIENTO)), TO_DATE('01/01/1900', 'dd/mm/yyyy')) from PRC_PROCEDIMIENTOS_JERARQUIA) and trunc(prc.FECHACREAR) <= trunc(sysdate)
                order by 1;

BEGIN                

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Empieza ' || V_NOMBRE, 3;  

  select valor into V_ESQUEMA from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

--"bucle de fechas, se repite el insert por cada una, previo truncate: (esquema DSTG)""

   OPEN C1;
    LOOP
      FETCH C1 INTO V_FECHA;
      EXIT WHEN C1%NOTFOUND;

      delete from PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO = V_FECHA;
      commit;
      
      insert into PRC_PROCEDIMIENTOS_JERARQUIA
        (
          FECHA_PROCEDIMIENTO,
          PJ_PADRE,
          PRC_ID,
          NIVEL,
          PATH_DERIVACION,
          CANCEL_PRC,
          PRC_TPO,
          ASU_ID
        )
        
      select 
          V_FECHA,
          connect_by_root PRC_ID PJ_PADRE,        
          PRC_ID,                          
          level NIVEL,        
          SYS_CONNECT_BY_PATH(PRC_ID, '/') PATH_DERIVACION,
          decode(DD_EPR_ID, 4, 1, 5, 1, 9, 1, 0) as CANCEL_PRC,
          PRC_TPO,
          ASU_ID   
      from 
          (
              select prc.PRC_ID, prc.FECHACREAR, prc.PRC_PRC_ID, DD_TPO.DD_TPO_CODIGO as PRC_TPO, prc.ASU_ID, prc.DD_EPR_ID, prc.BORRADO  
              from PRC_PROCEDIMIENTOS prc        
              inner join DD_TPO_TIPO_PROCEDIMIENTO DD_TPO ON DD_TPO.DD_TPO_ID = prc.DD_TPO_ID
              group by prc.PRC_ID, prc.PRC_PRC_ID, DD_TPO.DD_TPO_CODIGO, prc.ASU_ID, prc.DD_EPR_ID, prc.FECHACREAR, prc.BORRADO 
          )  
      where BORRADO = 0 and trunc(FECHACREAR) <= V_FECHA
      start with PRC_PRC_ID is null
      connect by  PRC_PRC_ID = prior PRC_ID;
      
      commit;
    
    END LOOP;  
    CLOSE C1;

  --Log_Cargar_Tabla
  execute immediate 'BEGIN INSERTAR_LOG_CARGAR_TABLA(:NOMBRE_TABLA, :NUM_BLOQUE, :NUM_ORDEN, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 0, 0, 'Termina ' || V_NOMBRE, 3;  
  
END;