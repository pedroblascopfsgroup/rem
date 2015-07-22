package es.pfsgroup.plugin.precontencioso.documento.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

public interface SolicitudDocumentoPCODao extends AbstractDao<SolicitudDocumentoPCO, Long> {
	
	
	/**
	 * Obtener los tipos de gestores que estan en tipo actores
	 * 
	 * @return lista tiposGestores
	 */
	List<EXTDDTipoGestor> getTiposGestorActores();
	
}
