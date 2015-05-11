package es.capgemini.pfs.batch.recobro.simulacion.manager;

/**
 * Interface de generación de informes excel de simulacion
 * @author javier
 *
 */
public interface GeneracionInformesSimulacionManager {
	
	/**
	 * Método que genera el informe de resultados de la simulación
	 * @throws Throwable
	 */
	public void generarInformeResultadoSimulacion() throws Throwable;
}
