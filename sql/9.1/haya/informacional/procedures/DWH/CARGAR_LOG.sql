create or replace PROCEDURE CARGAR_LOG (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Diego Pérez, PFS Group
-- Fecha creacion: Febrero 2015
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 13/05/2015
-- Motivos del cambio: Corrección para COMPILAR_SP
-- Cliente: Recovery BI Haya
--
-- Descripcion: Procedimiento almancenado que carga las tablas relacionadas con los LOG's
-- ===============================================================================================


BEGIN
  declare
    nCount NUMBER;
  
  BEGIN  
    --------------------------
    ---LOG_GENERAL_PARAMETROS
    --------------------------    
    insert into LOG_GENERAL_PARAMETROS values ('ASIGNAR_GRANTS', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', -2);
    insert into LOG_GENERAL_PARAMETROS values ('CREAR_INDICES_DATASTAGE', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'N', -1);
    insert into LOG_GENERAL_PARAMETROS values ('COMPILAR_SP', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 0);
    
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_ASUNTO', 'ERROR', '', '', 'ERROR', 0, '', 'S', 1);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_CONTRATO', 'ERROR', '', '', 'ERROR', 0, '', 'S', 2);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_EXPEDIENTE', 'ERROR', '', '', 'ERROR', 0, '', 'S', 3);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_FECHA', 'ERROR', '', '', 'ERROR', 0, '', 'N', 4);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_FECHA_OTRAS', 'ERROR', '', '', 'ERROR', 0, '', 'S', 5);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_PERSONA', 'ERROR', '', '', 'ERROR', 0, '', 'S', 6);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_PROCEDIMIENTO', 'ERROR', '', '', 'ERROR', 0, '', 'S', 7);
    insert into LOG_GENERAL_PARAMETROS values ('TRUNCAR_DIM_TAREA', 'ERROR', '', '', 'ERROR', 0, '', 'S', 8);
    
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_ASUNTO', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 101);
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_CONTRATO', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 102);
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_EXPEDIENTE', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 103);
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_FECHA', 'p_ANIO_ENTRADA, p_NUM_ANIOS', '', '', '', 2, '1980, 50', 'N', 104);
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_FECHA_OTRAS', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 105);    
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_PERSONA', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 106); 
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_PROCEDIMIENTO', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 107);
    insert into LOG_GENERAL_PARAMETROS values ('CARGAR_DIM_TAREA', 'O_ERROR_STATUS', '', '', 'O_ERROR_STATUS', 0, '', 'S', 108);

	Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_EXPEDIENTE','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',109);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PROCEDIMIENTO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',110);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PROCEDIMIENTO_ESPEC','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',111);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRECONTENCIOSO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',112);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRE_DET_LIQ','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',113);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRE_DET_DOC','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',114);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRE_DET_BURO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',115);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_CONTRATO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',116);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_TAREA','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',117);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRC_DET_ACUERDO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',118);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_SUBASTA','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',119);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_BIEN','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',120);
    Insert into LOG_GENERAL_PARAMETROS values ('CARGAR_H_PRC_DET_COBRO','DATE_START, DATE_END, O_ERROR_STATUS','DATE_START','DATE_END','O_ERROR_STATUS',0,'','S',121);
	
    commit;
    
    
    --------------------------
    ---LOG_GENERAL
    --------------------------

    --------------------------
    ---LOG_PROCESO
    --------------------------

    
  End;  
END;