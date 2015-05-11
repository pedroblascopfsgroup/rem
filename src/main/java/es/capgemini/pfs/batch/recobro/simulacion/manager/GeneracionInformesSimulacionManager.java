package es.capgemini.pfs.batch.recobro.simulacion.manager;

/**
 * Interface de generaci�n de informes excel de simulacion
 * @author javier
 *
 */
public interface GeneracionInformesSimulacionManager {
	
	/**
	 * M�todo que genera el informe de resultados de la simulaci�n
	 * @throws Throwable
	 */
	public void generarInformeResultadoSimulacion() throws Throwable;
}
