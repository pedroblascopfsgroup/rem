package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.util.List;

/**
 * Es necesario implemnetar esta interfaz para proporcionar datos
 * {@link CambiosBDDao} sobre la BD
 * 
 * @author bruno
 *
 */
public interface InfoTablasBD {
	
	/**
	 * optimización para tablas con gran volumen
	 */

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

}
