package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONObject;

/**
 * Es necesario implemnetar esta interfaz para proporcionar datos
 * {@link CambiosBDDao} sobre la BD
 * 
 * @author bruno
 *
 */
public interface InfoTablasBD {
	
	

	/**
	 * Es necesario implementar este método para indicar el nombre de la vistas
	 * auxiliares que necesita la vista principal
	 * 
	 * @return
	 */
	List<String> vistasAuxiliares();

	/**
	 * Es necesario implementar este método para indicar el nombre de la vista
	 * que nos devuelve los datos actuales.
	 * 
	 * @return
	 */
	String nombreVistaDatosActuales();

	/**
	 * Es necesario implmentar este método para indicar el nombre de la tabla
	 * que contiene los datos históricos.
	 * 
	 * @return
	 */
	String nombreTablaDatosHistoricos();

	/**
	 * Es necesario implmentar este método para indicar el nombre del campo que
	 * representa la clave primaria tanto en la tabla de histórico como en la
	 * vista de datos actuales.
	 * 
	 * @return
	 */
	String clavePrimaria();

	/**
	 * Registro identificador unico en el json
	 * 
	 * @return
	 */
	String clavePrimariaJson();
	
	/**
	 * Solo proceara los registros que esten marcados como modificados
	 * 
	 * @return
	 */
	Boolean procesarSoloCambiosMarcados();
	
	/**
	 * Para forzar a trabajar en modo optimizado
	 * @return
	 */
	public void setSoloCambiosMarcados(Boolean procesar);
	
	/**
	 * Borra de la tabla de modificaciones aquellas que se han enviado
	 * @param listPendientes
	 */
	public void marcarComoEnviadosMarcadosEspecifico(Date fechaEjecucion) throws Exception;
	
	/**
	 * Procesa el JSON rerultado devuelto por la contraparte
	 * @param resultado
	 */
	public void procesaResultado(JSONObject resultado);

}
