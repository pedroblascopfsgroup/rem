package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao;

import java.io.Serializable;

import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author pedro
 *
 */
public interface GestorTareasDao extends AbstractDao<Serializable,Long> {

	/**
	 * Obtener el Token ID de BPM a partir del id de Proceso BPM
	 * @param idProcessBPM
	 * @return id de token
	 */
	public Long getTokenId(Long idProcessBPM);
	
	/**
	 * Evalúa si el procedimiento especificado por idProc cumple la condición especificada
	 * @param idProc
	 * @param sql
	 * @return boolean
	 */
	public boolean evaluaCondicion(Long idProc, String condicion);

	String obtenerSubtipoTarea(String codigoTarea);
	
	/**
	 * Obtiene el id NODE a partir del codigo TAP y el id TOKEN 
	 * @param codTAP
	 * @param idToken
	 */
	public Long getNodeByCodTapAndIdProcesDefinition(Long idProcesDefinition, String codTap);
	
	/**
	 * Actualiza el node de un token
	 * @param idToken
	 * @param idNode
	 */
	public void updateNodeToken(Long idToken, Long idNode);
	
	public Long getProcesDefinition(Long processinstance);
}
