package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

/**
 * Es necesario implemnetar esta interfaz para proporcionar datos
 * {@link CambiosBDDao} sobre la BD
 * 
 * @author bruno
 *
 */
public interface InfoTablasBD {

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

}
