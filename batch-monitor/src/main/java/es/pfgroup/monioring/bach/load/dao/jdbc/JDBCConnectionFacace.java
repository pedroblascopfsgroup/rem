package es.pfgroup.monioring.bach.load.dao.jdbc;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Interfaz para abstraer las facades connections. Estas fachadas son para
 * encapsular toda la funcionalidad de abrir conexión a BBDD y otras cosas
 * aburridas.
 * 
 * @author bruno
 * 
 */
public interface JDBCConnectionFacace {

	/**
	 * Método que simplemente lanza una SQL y devuelve el resultado. Oculta
	 * todas esas cosas farragosas como abrir sesión y tal. No obstante es
	 * necesario usar el método close() cuando terminemos de trabajar con la
	 * fachada.
	 * 
	 * @param query
	 * @return
	 */
	ResultSet connectAndExecute(final String query) throws SQLException;

	/**
	 * Este método se usa para terminar la interacción con la fachada. Este
	 * método se encarga de ocultar todas esas cosas aburridas que hay que hacer
	 * con la BBDD.
	 * 
	 * @throws SQLException
	 */
	void close() throws SQLException;

}