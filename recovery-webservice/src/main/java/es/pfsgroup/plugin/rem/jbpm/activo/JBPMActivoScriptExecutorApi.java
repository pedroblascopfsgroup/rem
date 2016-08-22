package es.pfsgroup.plugin.rem.jbpm.activo;

import java.util.List;
import java.util.Map;

public interface JBPMActivoScriptExecutorApi {

	/**
	 * Devuelve el contexto crado de ejecución para un script groovy introduciendo variables, funciones y managers.
	 * @param idTramite
	 * @param idTareaExterna
	 * @param idTareaProcedimiento
	 * @return
	 * @throws ClassNotFoundException
	 */
	public abstract Map<String, Object> getContextoParaScript(
			Long idTramite, Long idTareaExterna, Long idTareaProcedimiento)
			throws ClassNotFoundException;

	/**
	 * Crea un contexto propio para la evaluación en relación con el procedimiento, la tarea externa y el contexto original
	 * y evalua el script que se le pasa como parámetro.
	 * @param idTramite ID del procedimiento para crear el contexto
	 * @param idTareaExterna ID de la tarea externa para crear el contexto
	 * @param idTareaProcedimiento ID de la tarea del procedimimento
	 * @param contextoOriginal Contexto Original para crear el contexto
	 * @param script Script que se evaluará
	 * @return Resultado de la evaluación en formato String
	 * @throws Exception Exception
	 */
	public abstract Object evaluaScript(Long idTramite,
			Long idTareaExterna, Long idTareaProcedimiento,
			Map<String, Object> contextoOriginal, String script)
			throws Exception;

	/**
	 * Evalua el script groovy, pero si se le pasa el contexto no lo crea.
	 * @param idTramite
	 * @param idTareaExterna
	 * @param idTareaProcedimiento
	 * @param contextoOriginal
	 * @param script
	 * @return
	 * @throws Exception
	 */
	public abstract Object evaluaScriptPorContexto(Long idTramite,
			Long idTareaExterna, Long idTareaProcedimiento,
			Map<String, Object> contextoOriginal, String script)
			throws Exception;

	/**
	 * settter.
	 * @param contextScript context
	 */
	public abstract void setContextScripts(List<String> contextScript);

	/**
	 * getter.
	 * @return context
	 */
	public abstract List<String> getContextScripts();


}