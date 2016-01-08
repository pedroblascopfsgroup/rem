--==============================================================*/					    
--Crear nuevas columnas en la tabla DD_PTP_PLAZOS_TAREAS_PLAZAS	*/
--																*/														
--==============================================================*/


ALTER TABLE DD_PTP_PLAZOS_TAREAS_PLAZAS ADD DD_PTP_ABSOLUTO  NUMBER(1) DEFAULT 0;
ALTER TABLE DD_PTP_PLAZOS_TAREAS_PLAZAS ADD DD_PTP_OBSERVACIONES VARCHAR2(250 CHAR) ;

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_ABSOLUTO=1 WHERE length(DD_PTP_PLAZO_SCRIPT)<25 ;


