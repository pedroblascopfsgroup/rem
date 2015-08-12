package es.pfsgroup.recovery.integration.jdbc.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.Subqueries;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

@Repository
public class ColaDeMensajeriaDaoImpl extends AbstractEntityDao<MensajeIntegracion, Long> implements ColaDeMensajeriaDao {
	
	@Override
	public List<MensajeIntegracion> getPendientes(String cola, int maxValues) {
        Criteria criteria = getSession().createCriteria(MensajeIntegracion.class, "msq");
		
        DetachedCriteria colaErroresCriteria = DetachedCriteria.forClass(MensajeIntegracion.class,"msq2");
		colaErroresCriteria.add(Property.forName("msq.guidGrp").eqProperty("msq2.guidGrp"));
		colaErroresCriteria.add(Restrictions.eq("msq2.estado", MensajeIntegracion.ESTADO_ERROR));
		colaErroresCriteria.add(Restrictions.eq("msq2.auditoria.borrado", false));
		colaErroresCriteria.add(Restrictions.eq("msq2.cola", cola));

        criteria.add(Restrictions.eq("msq.estado", MensajeIntegracion.ESTADO_PENDIENTE));
        criteria.add(Restrictions.eq("msq.cola", cola));	
        criteria.add(Restrictions.eq("msq.auditoria.borrado", false));
        criteria.add(Subqueries.notExists(colaErroresCriteria.setProjection(Projections.property("msq2.id"))));

        criteria.addOrder(Order.asc("msq.auditoria.fechaCrear"));
        criteria.setMaxResults(maxValues);
        
        @SuppressWarnings("unchecked")
		List<MensajeIntegracion> list = criteria.list();
        
		return list;
	}

	@Override
	public boolean tieneAlgunError(String direccion, String guid) {
        Criteria criteria = getSession().createCriteria(MensajeIntegracion.class, "msq");
        criteria.add(Restrictions.eq("msq.estado", MensajeIntegracion.ESTADO_ERROR));
        criteria.add(Restrictions.eq("msq.guidGrp", guid));
        criteria.add(Restrictions.eq("msq.auditoria.borrado", false));
        criteria.setMaxResults(1);
        
        @SuppressWarnings("unchecked")
		List<MensajeIntegracion> list = criteria.list();
        
		return (list.size()>0);
	}
	
}
