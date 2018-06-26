package es.pfsgroup.plugin.rem.tareasactivo.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.model.DtoTareaGestorSustitutoFilter;
import es.pfsgroup.plugin.rem.model.VTramitesGestorSustituto;
import es.pfsgroup.plugin.rem.tareasactivo.dao.VTareasGestorSustitutoDao;

@Repository("VTareasGestorSustitutoDao")
public class VTareasGestorSustitutoDaoImpl extends AbstractEntityDao<VTramitesGestorSustituto, Long> implements VTareasGestorSustitutoDao{

    @Autowired
    private ApiProxyFactory proxyFactory;
	
	@Override
	public Page getListTareasGS(DtoTareaGestorSustitutoFilter dto) {
		HQLBuilder hb = new HQLBuilder("from VTramitesGestorSustituto");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "idGestorSustituto", proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado().getId());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

}
