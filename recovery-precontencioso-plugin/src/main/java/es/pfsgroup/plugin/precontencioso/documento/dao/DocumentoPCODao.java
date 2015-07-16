package es.pfsgroup.plugin.precontencioso.documento.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

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
	
}
