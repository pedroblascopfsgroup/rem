package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;


/**
 * Factoría de ViewHandlers para los elementos del histórico del Asunto.
 * <p>
 * Estas factorías se encargan de generar los manejadores para abrir elementos del histórico del Asunto.
 * 
 * @author bruno
 *
 */
public interface HistoricoAsuntoAbrirDetalleFactory {

	/**
	 * Devuelve un manejador para abrir elementos del histórico del Asunto según el tipo de Traza
	 * 
	 * @param tipo de traza
	 * 
	 * @return
	 */
	HistoricoAsuntoAbrirDetalleHandler getForTipoTraza(String tipoTraza);

}
