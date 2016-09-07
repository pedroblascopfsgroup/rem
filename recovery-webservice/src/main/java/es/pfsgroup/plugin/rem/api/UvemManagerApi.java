package es.pfsgroup.plugin.rem.api;

import com.gfi.webIntegrator.WIException;
import com.gfi.webIntegrator.WIMetaServiceException;

import es.cm.arq.tda.tiposdedatosbase.TipoDeDatoException;

/**
 * Interface operaciones UVEM
 * 
 * @author rllinares
 *
 */
public interface UvemManagerApi {

	/**
	 * Solicitar tasación de un bien
	 * 
	 * @param bienId
	 * @param nombreGestor
	 * @param gestion
	 * @return
	 * @throws WIMetaServiceException
	 * @throws WIException
	 * @throws TipoDeDatoException
	 */
	public Integer solicitarTasacion(Long bienId, String nombreGestor, String gestion)
			throws WIMetaServiceException, WIException, TipoDeDatoException;
}
