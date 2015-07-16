package es.pfsgroup.plugin.precontencioso.documento.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.dto.DocumentoPCODto;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

@Repository("DocumentoPCODao")
public class DocumentoPCODaoImpl extends AbstractEntityDao<DocumentoPCO, Long> implements DocumentoPCODao {

	
	 /**
     * Devuelve los documentos de un proc de precontencioso
     */
    @SuppressWarnings("unchecked")
    public List<DocumentoPCO> getDocumentosProc(Long idProcPCO) {
        String hql = "from DocumentoPCO d where s.procedimientoPCO.id = ? and d.auditoria.borrado = 0";
        List<DocumentoPCO> documentosProc = getHibernateTemplate().find(hql, idProcPCO);
        return documentosProc;
    }
	 /**
     * Devuelve las solicitudes de un doc de precontencioso
     */
    @SuppressWarnings("unchecked")
    public List<SolicitudDocumentoPCO> getSolicitudesDoc(Long idDocPCO) {
        String hql = "from SolicitudDocumentoPCO s where s.documento.id = ? and s.auditoria.borrado = 0";
        List<SolicitudDocumentoPCO> solicitudesDoc = getHibernateTemplate().find(hql, idDocPCO);
        return solicitudesDoc;
    }
    
	/**
	 * Obtener los documentos de un procedimientoPCO
	 * 
	 * @param idProcedimientoPCO
	 * @return lista documentos
	 */
    @SuppressWarnings("unchecked")    
    public List<DocumentoPCO> getDocumentosPorIdProcedimientoPCO(Long idProcedimientoPCO){
        String hql = "from DocumentoPCO d where s.procedimientoPCO.id = ? and d.auditoria.borrado = 0";
        List<DocumentoPCO> documentosProc = getHibernateTemplate().find(hql, idProcedimientoPCO);
        
        return documentosProc;    	
    }
    
	/**
	 * Obtiene las solicitudes de un documentoPCO
	 * 
	 * @param idDocPCO
	 * @return
	 */
	public List<SolicitudDocumentoPCO> getSolicitudesPorIdDocumentoPCO(Long idDocumentoPCO){
		String hql = "from SolicitudDocumentoPCO s where s.documento.id = ? and s.auditoria.borrado = 0";
	    List<SolicitudDocumentoPCO> solicitudesDoc = getHibernateTemplate().find(hql, idDocumentoPCO);
	    
	        return solicitudesDoc;		
	}; 
	
	/**
	 * Obtiene el DTO de un documentoPCO
	 * 
	 * @param idDocPCO
	 * @return
	 */
	public DocumentoPCO getDocumentoPorIdDocumentoPCO(Long idDocumentoPCO){
		String hql = "from DocumentoPCO d where s.procedimientoPCO.id = ? and d.auditoria.borrado = 0";
	    DocumentoPCO documento = (DocumentoPCO)getHibernateTemplate().get(DocumentoPCO.class, idDocumentoPCO);
	    
	    return documento;
		
	};	
    
	
}
