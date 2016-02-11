package es.capgemini.pfs;

/**
 * En esta classe enumeramos las propiedades que tenemos en devon.properties
 * @author bruno
 *
 */
public class DevonPropertiesConstants {
	
	/**
	 * Properties relativas a la configuración de la Base de Datos
	 * @author bruno
	 *
	 */
	public static class DatabaseConfig {
		/**
		 * Define el nombre del master schema
		 */
		public static final String MASTER_SCHEMA_KEY = "master.schema";
		
		/**
		 * Define si usamos usuarios transaccionales o no.
		 * <p> Posibles valores
		 * <dl>
		 * 		<dt>yes</dt><dd>Sí usamos usuarios transaccionales</dd>
		 * 		<dt>no | undefined</dt><dd>No usamos usuarios transaccionales (por defecto)</dd>
		 * </dl>
		 * </p>
		 */
		public static final String USE_TRANSACTIONAL_USERS_KEY = "dsm.use.transactonal.users";
		public static final String USE_TRANSACTIONAL_USERS_VALUE_YES = "yes";
		public static final String USE_TRANSACTIONAL_USERS_VALUE_NO = "no";
		
		/**
		 * Define el mapeo para los distintos usuarios transaccionales. 
		 * <p>
		 * El los mapeos se definen del siguiente modo:
		 * <code>
		 * 	schema_id_1-> user_1; schema_id_2 -> user_2; schema_id_3 -> user_3
		 * </code>
		 * </p>
		 */
		public static final String TRANSACTIONAL_USER_MAPPING_KEY = "dsm.transactional.users.mapping";
		
		/**
		 * Definie si queremos usar passwords encriptados para conectarnos a la BBDD
		 * <p> Posibles valores
		 * <dl>
		 * 		<dt>SI</dt><dd>Sí usamos passwords encriptados</dd>
		 * 		<dt>NO | undefined</dt><dd>No usamos passwords encriptados(por defecto)</dd>
		 * </dl>
		 * </p>
		 */
		public static final String ENABLE_PASSWORD_ENCRYPT_KEY = "dsm.prot.cnts";
		public static final String ENABLE_PASSWORD_ENCRYPT_VALUE_NO = "NO";
		public static final String ENABLE_PASSWORD_ENCRYPT_VALUE_SI = "SI";		
		
	}	
	
	

}
