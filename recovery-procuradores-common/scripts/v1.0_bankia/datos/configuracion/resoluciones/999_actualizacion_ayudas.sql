/*UPDATE DD_TR_TIPOS_RESOLUCION TIPO SET TIPO.DD_TR_AYUDA = ( 
    SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE 'titulo'
    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID
    )
WHERE (SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE 'titulo'
    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID ) IS NOT NULL
*/    
 
UPDATE DD_TR_TIPOS_RESOLUCION TIPO SET TIPO.DD_TR_AYUDA = ( 
    SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE 'titulo'
    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID AND ROWNUM <= 1
    )
WHERE (SELECT TFI.TFI_LABEL FROM DD_TR_TIPOS_RESOLUCION TIPOS
    JOIN BPM_DD_TIN_TIPO_INPUT TIN ON SUBSTR(TIPOS.DD_TR_CODIGO,2) = SUBSTR(TIN.BPM_DD_TIN_CODIGO,2)
    JOIN BPM_TPI_TIPO_PROC_INPUT TPI ON TIN.BPM_DD_TIN_ID = TPI.BPM_DD_TIN_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TPI.BPM_TPI_NODE_INC = TAP.TAP_CODIGO
    JOIN TFI_TAREAS_FORM_ITEMS TFI ON TAP.TAP_ID = TFI.TAP_ID AND TFI_NOMBRE LIKE 'titulo'
    WHERE TIPOS.DD_TR_ID = TIPO.DD_TR_ID AND ROWNUM <= 1) IS NOT NULL    