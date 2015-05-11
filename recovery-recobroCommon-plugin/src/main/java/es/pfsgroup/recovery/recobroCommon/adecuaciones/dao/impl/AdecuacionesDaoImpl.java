package es.pfsgroup.recovery.recobroCommon.adecuaciones.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dao.api.AdecuacionesDaoApi;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.dto.AdecuacionesDto;
import es.pfsgroup.recovery.recobroCommon.adecuaciones.model.Adecuaciones;


/**
 * Implementación de métodos para la persistencia de datos de las adecuaciones
 *
 */
@Repository("Adecuaciones")
public class AdecuacionesDaoImpl extends AbstractEntityDao<Adecuaciones, Long> 
	implements	AdecuacionesDaoApi {

	@Autowired
	GenericABMDao genericDao;

	@Override
	public List<Adecuaciones> getListadoAdecuaciones(Long cntId) {
		
		StringBuilder sb = new StringBuilder("from Adecuaciones ade where ade.auditoria.borrado=0");

		Query query = getSession().createQuery(sb.toString());

		return query.list();
		
	}

	@Override
	public Adecuaciones getAdecuacionById(Long id) {

		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "adecuaciones.id", id);

		return genericDao.get(Adecuaciones.class, f1);
	}

	@Override
	public Page getListadoAdecuaciones(AdecuacionesDto dto) {

		HQLBuilder hb = new HQLBuilder("select ade from Adecuaciones ade ");
		hb.appendWhere(" ade.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ade.contrato.id", dto.getIdContrato() );

		return HibernateQueryUtils.page(this, hb, dto);
	}

	
}
