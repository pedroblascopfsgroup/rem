package es.pfsgroup.plugin.precontencioso.documento.dao.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.precontencioso.documento.dao.SolicitudDocumentoPCODao;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.SolicitudDocumentoPCO;

@Repository("SolicitudDocumentoPCODao")
public class SolicitudDocumentoPCODaoImpl extends AbstractEntityDao<SolicitudDocumentoPCO, Long> implements SolicitudDocumentoPCODao {


	@Autowired
	GenericABMDao genericDao;
	
	 /**
     * Devuelve los tipos de gestor de relacionados con tipos de actor
     */
    @SuppressWarnings("unchecked")
    public List<EXTDDTipoGestor> getTiposGestorActores() {
       
    	String hql = "from EXTDDTipoGestor tg where tg.codigo IN (select ta.codigo from DDTipoActorPCO ta where ta.auditoria.borrado = 0)";
        List<EXTDDTipoGestor> documentosProc = getHibernateTemplate().find(hql);
        return documentosProc;
  
    	
//    	Order order = new Order(OrderType.ASC, "descripcion");
//		List<EXTDDTipoGestor> listado = genericDao.getListOrdered(EXTDDTipoGestor.class, order, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
//		return listado;
    }
}
