package es.pfsgroup.plugin.rem.gestorSustituto.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.gestorSustituto.dao.GestorSustitutoDao;
import es.pfsgroup.plugin.rem.model.DtoGestoresSustitutosFilter;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

@Repository("GestorSustitutoDao")
public class GestorSustitutoDaoImpl extends AbstractEntityDao<GestorSustituto, Long> implements GestorSustitutoDao {
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Autowired
	GestorEntidadDao gestorEntidadDao;
	
	@Override
	public Page getListGestoresSustitutos(DtoGestoresSustitutosFilter dto) {
		HQLBuilder hql = new HQLBuilder("select gs from VBusquedaGestoresSustitutos gs");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "gs.usernameOrigen", dto.getUsernameOrigen());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "gs.usernameSustituto", dto.getUsernameSustituto());
   		return HibernateQueryUtils.page(this, hql, dto);
	}

}
