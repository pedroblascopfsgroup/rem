package es.pfsgroup.plugin.precontencioso.documento.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.documento.dao.DocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.model.DDEstadoDocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;

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
        String hql = "from DocumentoPCO d where d.procedimientoPCO.procedimiento.id = ? and d.auditoria.borrado = 0 ";
        List<DocumentoPCO> documentosProc = getHibernateTemplate().find(hql, idProcedimientoPCO);
  
		return documentosProc;    	
    }
    
	/**
	 * Obtener los documentos de un procedimientoPCO No descartados
	 * 
	 * @param idProcedimientoPCO
	 * @return lista documentos
	 */
    @SuppressWarnings("unchecked")    
    public List<DocumentoPCO> getDocumentosPorIdProcedimientoPCONoDescartados(Long idProcedimientoPCO){
        String hql = "from DocumentoPCO d where d.procedimientoPCO.id = ? and d.auditoria.borrado = 0 and d.estadoDocumento.codigo != '" + DDEstadoDocumentoPCO.DESCARTADO + "'";
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
	
	public List<Contrato> getContratosByIdsOrderByDesc(String ids){
    	String hql = "from Contrato cnt where cnt.id in (" + ids + ") and cnt.auditoria.borrado = 0 order by cnt.nroContrato asc";
        List<Contrato> contratos = getHibernateTemplate().find(hql);
        return contratos;
    }
	
	public List<Persona> getPersonasByIdsOrderByDesc(String ids){
    	String hql = "from Persona per where per.id in (" + ids + ") and per.auditoria.borrado = 0 order by per.docId asc";
        List<Persona> personas = getHibernateTemplate().find(hql);
        return personas;
    }
	
	public List<NMBBienEntidad> getBienesByIdsOrderByDesc(String ids){
    	String hql = "from NMBBienEntidad bien where bien.id in (" + ids + ") and bien.auditoria.borrado = 0 order by bien.numFinca asc ";
        List<NMBBienEntidad> personas = getHibernateTemplate().find(hql);
        return personas;
    }	

    public List<DDTipoActorPCO> getTipoActoresConAcceso() {
    	Criteria query = getSession().createCriteria(DDTipoActorPCO.class);
    	query.add(Restrictions.eq("accesoRecovery", true));

    	List<DDTipoActorPCO> tipoActoresConAcceso = query.list(); 
		return tipoActoresConAcceso;
    }
}
