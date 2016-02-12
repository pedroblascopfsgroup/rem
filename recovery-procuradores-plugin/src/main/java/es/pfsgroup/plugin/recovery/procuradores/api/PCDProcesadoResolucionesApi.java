package es.pfsgroup.plugin.recovery.procuradores.api;

import java.text.ParseException;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;

public interface PCDProcesadoResolucionesApi {

	public static final String PCD_BO_GENERAR_AUTOPRORROGA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarAutoprorroga";
	public static final String PCD_BO_GENERAR_COMUNICACION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarComunicacion";
	public static final String PCD_BO_GENERAR_TAREA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarTarea";
	public static final String PCD_BO_GENERAR_COMUNICACION_SUBIDA_FICHERO = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarComunicacionsubidaDeFichero";
	public static final String PCD_BO_PROCESAR_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.procesar";;
	
	@BusinessOperationDefinition(PCD_BO_GENERAR_AUTOPRORROGA)
	public void generarAutoprorroga(MSVResolucionesDto dtoResolucion) throws ParseException;
	
	@BusinessOperationDefinition(PCD_BO_GENERAR_COMUNICACION)
	public void generarComunicacion(MSVResolucionesDto dtoResolucion) throws ParseException;

	@BusinessOperationDefinition(PCD_BO_GENERAR_TAREA)
	public void generarTarea(MSVResolucionesDto dtoResolucion) throws EXTCrearTareaException, ParseException, Exception;
	
	@BusinessOperationDefinition(PCD_BO_GENERAR_COMUNICACION_SUBIDA_FICHERO)
	public void generarComunicacionSubidaFichero(MSVResolucionesDto dtoResolucion) throws ParseException;

	@BusinessOperationDefinition(PCD_BO_PROCESAR_RESOLUCION)
	public void procesar(MSVResolucionesDto dtoResolucion) throws Exception;
	

}
