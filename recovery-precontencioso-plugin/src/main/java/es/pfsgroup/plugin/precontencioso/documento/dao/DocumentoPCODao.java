package es.pfsgroup.plugin.precontencioso.documento.dao;

import java.util.List;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;

public interface DocumentoPCODao extends AbstractDao<DocumentoPCO, Long> {

	public List<DocumentoPCO> getDocumentosProc(Long idProcPCO);
	public List<SolicitudDocumentoPCO> getSolicitudesDoc(Long idDocPCO);

	/**
	 * Obtener los documentos de un procedimientoPCO
	 * 
	 * @param idProcedimientoPCO
	 * @return lista documentos
	 */
	List<DocumentoPCO> getDocumentosPorIdProcedimientoPCO(Long idProcedimientoPCO);
	
	List<DocumentoPCO> getDocumentosPorIdProcedimientoPCONoDescartados(Long idProcedimientoPCO);
	
	List<Contrato> getContratosByIdsOrderByDesc(String ids);
	
	List<Persona> getPersonasByIdsOrderByDesc(String ids);
	
	List<NMBBienEntidad> getBienesByIdsOrderByDesc(String ids);
	
	/**
	 * Obtener los tipos de actores que tienen acceso a recovery
	 * 
	 * @return lista tiposGestores
	 */
	List<DDTipoActorPCO> getTipoActoresConAcceso();

}
