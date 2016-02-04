package es.capgemini.pfs.dsm;

/**
 * Si ocurre cualquier problema de configuración para conectar con la BBDD
 * @author bruno
 *
 */
public class RecoveryDSMConfigurationException extends RuntimeException {

	public RecoveryDSMConfigurationException(String string) {
		super(string);
	}

}
