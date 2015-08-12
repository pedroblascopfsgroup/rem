package es.pfsgroup.recovery.integration.jdbc.dao;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Property;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.Subqueries;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.integration.jdbc.model.MensajeIntegracion;

public class ColaDeMensajeriaDaoImpl extends AbstractEntityDao<MensajeIntegracion, Long> implements ColaDeMensajeriaDao {
	
	@Override
	public List<MensajeIntegracion> getPendientes(String direccion, int maxValues) {
		
        Criteria criteria = getSession().createCriteria(MensajeIntegracion.class, "cola");
		
        DetachedCriteria colaErroresCriteria = DetachedCriteria.forClass(MensajeIntegracion.class,"cola2");
		colaErroresCriteria.add(Property.forName("cola.guid").eqProperty("cola2.guid"));
		colaErroresCriteria.add(Restrictions.eq("estado", MensajeIntegracion.ESTADO_ERROR));
		colaErroresCriteria.add(Restrictions.eq("direccion", direccion));

        criteria.add(Restrictions.eq("estado", MensajeIntegracion.ESTADO_PENDIENTE));
        criteria.add(Subqueries.notExists(colaErroresCriteria.setProjection(Projections.property("cola2.id"))));
        criteria.add(Restrictions.eq("direccion", direccion));

        criteria.addOrder(Order.asc("fecha"));
        criteria.setMaxResults(maxValues);
        
        @SuppressWarnings("unchecked")
		List<MensajeIntegracion> list = criteria.list();
        
		return list;
	}

	@Override
	public boolean tieneAlgunError(String direccion, String guid) {
        Criteria criteria = getSession().createCriteria(MensajeIntegracion.class, "cola");
        criteria.add(Restrictions.eq("estado", MensajeIntegracion.ESTADO_ERROR));
        criteria.add(Restrictions.eq("guid", guid));
        criteria.setMaxResults(1);
        
        @SuppressWarnings("unchecked")
		List<MensajeIntegracion> list = criteria.list();
        
		return (list.size()>0);
	}
	
}
