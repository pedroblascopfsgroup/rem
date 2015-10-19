package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.List;

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
		
		String hqlAmbitosExcluidos = 
				"select distinct daa from DespachoAmbitoActuacion daa where daa.despacho.id=" + idDespacho + " and daa.auditoria.borrado = false";
		
		if(listadoComunidades != null && !listadoComunidades.equals("")) {
			hqlAmbitosExcluidos += " and daa.comunidad.codigo NOT IN (" + listadoComunidades + ") ";
	    }
		else {
			hqlAmbitosExcluidos += " and daa.comunidad IS NOT NULL";
		}
		
		List<DespachoAmbitoActuacion> listDespachoAmbitoActuacion = getHibernateTemplate().find(hqlAmbitosExcluidos); 
		
		hqlAmbitosExcluidos = "select distinct daa from DespachoAmbitoActuacion daa where daa.despacho.id=" + idDespacho + " and daa.auditoria.borrado = false";
		
		if(listadoProvincias != null && !listadoProvincias.equals("")) {
			hqlAmbitosExcluidos += " and daa.provincia.codigo NOT IN (" + listadoProvincias + ")";
        }
        else {
        	hqlAmbitosExcluidos += " and daa.provincia IS NOT NULL";
        }
        
		listDespachoAmbitoActuacion.addAll(getHibernateTemplate().find(hqlAmbitosExcluidos));
		
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
