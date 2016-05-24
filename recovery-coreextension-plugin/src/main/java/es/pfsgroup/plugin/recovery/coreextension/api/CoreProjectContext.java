package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Set;

/**
 * API con las operaciones de negocio para el coreextension.
 * @author carlos
 *
 */
public interface CoreProjectContext {
	
	public static final String CATEGORIA_SUBTAREA_TOMA_DECISION = "TOMA_DE_DECISION";	
	public static final String CATEGORIA_SUBTAREA_ABRIR_TAREA_PROCEDIMIENTO = "ABRIR_TAREA_PROCEDIMIENTO";
	public static final String CATEGORIA_SUBTAREA_ABRIR_EXP = "ABRIR_EXP";
	public static final String CATEGORIA_SUBTAREA_ABRIR_PER = "ABRIR_PER";
	public static final String CATEGORIA_SUBTAREA_ABRIR_ASUNTOS_COBRO_PAGO = "ABRIR_COBROS_PAGOS";
	public static final String ENTIDAD = "HAYA";
	public static final String TIPO_ASUNTO_LITIGIO = "01";
	public static final String TIPO_ASUNTO_CONSURSAL = "02";
	
	/**
	 * Devuelve los codigos (DD_STA_CODIGO) agrupadas por categorias (DECISION, ....)
	 * @return Set<String>
	 */
	public Map<String, Set<String>> getCategoriasSubTareas();	

	List<String> getTiposProcedimientosAdjudicados();
	
	Set<String> getTiposGestorGestoria();
	
	Set<String> getTiposGestorProcurador();
	
	Set<String> getEntidadesDesparalizacion();

	public List<String> getCodigosDocumentosConFechaCaducidad();
	
	public Set<String> getTipoGestorLetrado();
	
	public Map<String, String> getTipoSupervisorProrroga();
	
	Set<String> getTiposGestoresDeProcuradores();
	
	Set<String> getPerfilesConsulta();
	
	public HashMap<String, HashMap<String, Set<String>>> getTiposAsuntosTiposGestores();
	public HashMap<String, HashMap<String, Set<String>>> getPerfilesGestoresEspeciales();
	public HashMap<String, HashMap<String, Set<String>>> getSupervisorAsunto();
	public HashMap<String, HashMap<String, Set<String>>> getDespachoSupervisorAsunto();
	public HashMap<String, HashMap<String, Set<String>>> getTipoGestorSupervisorAsunto();
	
}
