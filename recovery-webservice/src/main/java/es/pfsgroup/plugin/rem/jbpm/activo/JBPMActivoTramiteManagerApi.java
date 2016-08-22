package es.pfsgroup.plugin.rem.jbpm.activo;

import java.util.Map;

import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Trabajo;

public interface JBPMActivoTramiteManagerApi {
	
	public abstract Long lanzaBPMAsociadoATramite(Long idTramite);

	/**
	 * Crea un nuevo procedimiento derivado de otro procedimiento padre.
	 * @param tipoProcedimiento Tipo de procedimiento que se va a generar
	 * @param procPadre Procedimiento padre para copiar sus valores
	 * @return Devuelve el nuevo procedimiento creado
	 */
	public abstract ActivoTramite creaActivoTramiteHijo(TipoProcedimiento tipoProcedimiento, ActivoTramite procPadre);
	
	public ActivoTramite creaActivoTramite(TipoProcedimiento tipoProcedimiento, Activo activo);
	
	public ActivoTramite createActivoTramiteTrabajo(TipoProcedimiento tipoProcedimiento,/* Activo activo,*/ Trabajo trabajo);

	
	/**
	 * Lanza un BPM asociado a un procedimiento.
	 * @param idProcedimiento El id del procedimiento del cual se va a lanzar su BPM
	 * @param idTokenAviso Si es llamado desde otro BPM, el id del token al que debe avisar. (Este parámetro puede ser null)
	 * @return Devuelve el ID del process BPM que se ha creado
	 */
	public abstract Long lanzaBPMAsociadoATramite(Long idTramite, Long idTokenAviso);	
	
	/**
	 * Finaliza el procedimiento. Detiene el proceso BPM, finaliza las tareas activas y las decisiones.
	 * @param idProcedimiento id del proceso
	 * @throws Exception e
	 */
	public abstract void finalizarTramite(Long idTramite) throws Exception;
	
	/** Crea un Map de maps con los valores introducidos en las pantallas de las tareas de los procesos jbpm. Así podemos hacer referencia
	 * a un valor de un control en el script con la siguiente nomenclatura.
	 *
	 * valores['TramiteIntereses']['fecha']
	 *
	 * @param idTramite long
	 * @return map
	 */
	public Map<String, Map<String, String>> creaMapValores(Long idTramite);
	
	/**
	 * Paraliza las tareas de Checking de documentación admisión y checking documentación gestión.
	 * @param tramite
	 */
	public void paralizarTareasChecking(ActivoTramite tramite);
	

}