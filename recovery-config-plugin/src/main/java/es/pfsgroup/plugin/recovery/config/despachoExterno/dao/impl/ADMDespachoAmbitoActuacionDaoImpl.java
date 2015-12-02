package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoAmbitoActuacionDao;

@Repository("ADMDespachoAmbitoActuacionDao")
public class ADMDespachoAmbitoActuacionDaoImpl extends
		AbstractEntityDao<DespachoAmbitoActuacion, Long> implements
		ADMDespachoAmbitoActuacionDao {

	@Override
	public List<DespachoAmbitoActuacion> getAmbitoGeograficoDespacho(Long idDespachoExterno) {
		Assertions.assertNotNull(idDespachoExterno, "idDespachoExterno: No puede ser NULL");
		HQLBuilder b = new HQLBuilder("from DespachoAmbitoActuacion d");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.despacho.id", idDespachoExterno);
		return HibernateQueryUtils.list(this, b);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<DespachoAmbitoActuacion> getAmbitosActuacionExcluidos(Long idDespacho, String listadoComunidades, String listadoProvincias) {
		
		DetachedCriteria crit = DetachedCriteria.forClass(DespachoAmbitoActuacion.class);
        crit.add(Restrictions.eq("despacho.id", idDespacho));
        crit.add(Restrictions.eq("auditoria.borrado", false));
        
		if(listadoComunidades != null && !listadoComunidades.equals("")) {
			crit.createCriteria("comunidad").add(Restrictions.not(Restrictions.in("codigo", StringUtils.split(listadoComunidades, ","))));
	    }
		else {
			crit.add(Restrictions.isNotNull("comunidad"));
		}
		
		List<DespachoAmbitoActuacion> listDespachoAmbitoActuacion = getHibernateTemplate().findByCriteria(crit); 
		
		crit = DetachedCriteria.forClass(DespachoAmbitoActuacion.class);
        crit.add(Restrictions.eq("despacho.id", idDespacho));
        crit.add(Restrictions.eq("auditoria.borrado", false));
		
		if(listadoProvincias != null && !listadoProvincias.equals("")) {
			crit.createCriteria("provincia").add(Restrictions.not(Restrictions.in("codigo", StringUtils.split(listadoComunidades, ","))));
        }
        else {
			crit.add(Restrictions.isNotNull("provincia"));
        }
        
		listDespachoAmbitoActuacion.addAll(getHibernateTemplate().findByCriteria(crit));
		
        return listDespachoAmbitoActuacion;		
	}

	@Override
	public DespachoAmbitoActuacion getByDespachoYComunidad(Long idDespacho,
			String codigoComunidad) {
		
		Assertions.assertNotNull(idDespacho, "idDespacho: No puede ser NULL");
		Assertions.assertNotNull(codigoComunidad, "codigoComunidad: No puede ser NULL");
		
		HQLBuilder b = new HQLBuilder("from DespachoAmbitoActuacion d");
		b.appendWhere("d.auditoria." + Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.despacho.id", idDespacho);
		HQLBuilder.addFiltroIgualQue(b, "d.comunidad.codigo", codigoComunidad);
		return HibernateQueryUtils.uniqueResult(this, b);
	}

	@Override
	public DespachoAmbitoActuacion getByDespachoYProvincia(Long idDespacho,
			String codigoProvincia) {
		
		Assertions.assertNotNull(idDespacho, "idDespacho: No puede ser NULL");
		Assertions.assertNotNull(codigoProvincia, "codigoProvincia: No puede ser NULL");
		
		HQLBuilder b = new HQLBuilder("from DespachoAmbitoActuacion d");
		b.appendWhere("d.auditoria." + Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.despacho.id", idDespacho);
		HQLBuilder.addFiltroIgualQue(b, "d.comunidad.codigo", codigoProvincia);
		return HibernateQueryUtils.uniqueResult(this, b);
	}    
}
