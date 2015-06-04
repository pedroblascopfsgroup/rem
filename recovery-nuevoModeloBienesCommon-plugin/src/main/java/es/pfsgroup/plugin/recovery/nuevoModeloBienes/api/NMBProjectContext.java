package es.pfsgroup.plugin.recovery.nuevoModeloBienes.api;

import java.util.List;
import java.util.Map;
import java.util.Set;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoLoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

/**
 * API con las operaciones de negocio para Editar Bienes.
 * @author bruno
 *
 */
public interface NMBProjectContext {

	/**
	 * Devuelve las tareas Stop para validar Lotes de Subasta
	 * 
	 * @return Listado de tareas
	 */
	Set<String> getTareasStopValidarLotesSubasta();
	
	/**
	 * Completa el Dto como si se hubiera completado la tarea Validar Propuesta según el BPM de subastas como se hubiera realizado desde el formulario.
	 *  
	 * @param subasta
	 * @param dtoForm
	 * @param tareaExterna
	 * @param estado
	 * @param codMotivoSuspSubasta
	 * @param observaciones
	 */
	String[] valoresTareaValidarPropuestaDesdeCambioMasivoLotes(Subasta subasta, String[] nombresItems, TareaExterna tareaExterna, DDEstadoLoteSubasta estado, String codMotivoSuspSubasta, String observaciones);
	
	/**
	 * Actualiza el lote según la información de la tarea y la decisión que se ha tomado.
	 * 
	 * @param lote
	 * @param listadoTareaValor
	 * @param decision
	 */
	void actualizaLoteSubastaSegunInformacionTarea(LoteSubasta lote, List<EXTTareaExternaValor> listadoTareaValor, String decision);
	
	/**
	 * Id del nivel del centro gestor a partir del cual consideramos padres de una oficina para pintar en informe.
	 * 
	 * @return
	 */
	Long getNivelZonaOficinaGestoraEnInformes();
	
	List<String> getTiposProcedimientosAdjudicados();
	
	//void setTiposProcedimientosAdjudicados(List<String> tiposPrcAdjudicados);
	
	Map<String, String> getMapaTiposPrc();

	Map<String, String> getTareasCierreDeuda();
	
	//void setMapaTiposPrc(Map<String, String> mapaTiposPrc);
	
}
