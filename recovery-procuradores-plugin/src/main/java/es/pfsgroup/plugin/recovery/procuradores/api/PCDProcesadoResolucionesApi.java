package es.pfsgroup.plugin.recovery.procuradores.api;

import java.text.ParseException;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResolucionesDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.recovery.ext.api.tareas.EXTCrearTareaException;

public interface PCDProcesadoResolucionesApi {

	public static final String PCD_BO_GENERAR_AUTOPRORROGA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarAutoprorroga";
	public static final String PCD_BO_GENERAR_COMUNICACION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarComunicacion";
	public static final String PCD_BO_GENERAR_TAREA = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarTarea";
	public static final String PCD_BO_GENERAR_COMUNICACION_SUBIDA_FICHERO = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.generarComunicacionsubidaDeFichero";
	public static final String PCD_BO_PROCESAR_RESOLUCION = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.procesar";
	public static final String PCD_BO_HISTORICO_DESPACHO_INTEGRAL = "es.pfsgroup.plugin.recovery.procuradores.procesado.api.hayDespachoIntegral";
	
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
	
	/**
	 * Comprueba si el asunto del procedimiento, ha tenido asociado algun despacho integral
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(PCD_BO_HISTORICO_DESPACHO_INTEGRAL)
	public boolean hayDespachoIntegral(Long idProcedimiento);
	

}
