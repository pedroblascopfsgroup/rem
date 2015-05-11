package es.pfsgroup.recovery.recobroCommon.esquema.dao.api;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;

/**
 * Interfaz de acceso a base de datos para la clase RecobroSubCarteraAgencia
 * @author Carlos
 *
 */
public interface RecobroSubCarteraAgenciaDao extends AbstractDao<RecobroSubcarteraAgencia, Long>{
	
	
	/**
	 * A partir de una subcartera y una subcareteraAgencia, devuelve la subcarteraAgencia de la subcartera
	 * recibida que tiene la misma agencia que la subcarteraAgencia original
	 */
	RecobroSubcarteraAgencia getSubcarteraAgenciaPorAgenciaYSubCartera(RecobroSubCartera subCartera,
			RecobroSubcarteraAgencia subcarteraAgenciaOriginal);

}
