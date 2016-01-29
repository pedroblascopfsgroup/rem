SET DEFINE OFF;
DECLARE
BEGIN
UPDATE CM01.TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_VALIDACION = 'comprobarMinimoBienLote() ? (comprobarExisteDocumentoESRAS() ? (comprobarProvLocFinBien() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de inmueble, provincia, localidad y número de finca.</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Es necesario adjuntar el documento "Diligencia de señalamiento Edicto de subasta".</div>'') : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Al menos un bien debe estar asignado a un lote</div>'''
WHERE TAP_CODIGO ='CJ004_SenyalamientoSubasta';
COMMIT;
END;
/