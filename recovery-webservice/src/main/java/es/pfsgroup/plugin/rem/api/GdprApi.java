package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;

public interface GdprApi {
	
	/**
	 * Dado un documento obtiene el id del inteviniente haya
	 * @param numDcoumento
	 * @return
	 * @throws Exception
	 */
	public String obtenerIdPersonaHaya(String docCliente) throws Exception;
	
	/**
	 * Borra un adjunto de una persona
	 * @param adjuntoComprador
	 * @return
	 * @throws Exception
	 */
	public boolean deleteAdjuntoPersona(AdjuntoComprador adjuntoComprado,String docCliente) throws Exception;
	
	/**
	 * Obtnener gdpr por numero documento
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<ClienteGDPR> obtnenerClientesGdprNyNumDoc(String docCliente) throws Exception;
	
	
	/**
	 * Borra un cliente temporal
	 * @param docCliente
	 * @throws Exception
	 */
	public void deleteTmpClienteByDocumento(String docCliente) throws Exception;
	
	
	/**
	 * Obtiene el adjunto de un comprador
	 * @return
	 * @throws Exception
	 */
	public AdjuntoComprador obtenerAdjuntoComprador(String docCliente, Long idAdjunto) throws Exception;

}
