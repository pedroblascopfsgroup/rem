package es.pfsgroup.plugin.recovery.config.despachoExterno.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;

@Repository("ADMTipoDespachoExternoDao")
public class ADMTipoDespachoExternoDaoImpl extends AbstractEntityDao<DDTipoDespachoExterno, Long> implements ADMTipoDespachoExternoDao{
	
	@Autowired
	private GenericABMDao genericDao;
	
	public List<DDTipoDespachoExterno> getListTipoDespachoByEntidad() {
		String queryString = "SELECT distinct tde.* FROM ${master.schema}.dd_tde_tipo_despacho tde "
				+ " inner join tgp_tipo_gestor_propiedad tgp on  tgp.tgp_valor like '%' || tde.dd_tde_codigo || '%'"
				+ " inner join ${master.schema}.dd_tge_tipo_gestor tge on tge.dd_tge_id = tgp.dd_tge_id"
				+ " where tde.borrado=0 and tgp.borrado=0 and tge.borrado=0 "
				+ " order by tde.DD_TDE_DESCRIPCION";
		
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);
		
		//sqlQuery.setResultTransformer(Transformers.aliasToBean(DDTipoDespachoExterno.class));
		List<DDTipoDespachoExterno> lista = new ArrayList<DDTipoDespachoExterno>();
		
		for (Object item : sqlQuery.list()) {
			Object[] partes = (Object[])item;
			
			Long tipoDespachoId = Long.parseLong(partes[0].toString());
			
			lista.add(genericDao.get(DDTipoDespachoExterno.class, genericDao.createFilter(FilterType.EQUALS, "id",  tipoDespachoId)));
		}
		return lista;
	}

}
