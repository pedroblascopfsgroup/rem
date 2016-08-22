package es.pfsgroup.plugin.rem.clienteComercial.dao.impl;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.ClienteDto;

@Repository("ClienteComercialDao")
public class ClienteComercialDaoImpl extends AbstractEntityDao<ClienteComercial, Long> implements ClienteComercialDao{
		
	
	@Override
	public Long getNextClienteRemId() {
		String sql = "SELECT S_CLC_REM_ID.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
	
	
	@Override
	public List<ClienteComercial> getListaClientes(ClienteDto clienteDto) {
		
		HQLBuilder hql = new HQLBuilder("from ClienteComercial");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "id", clienteDto.getIdClienteRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idClienteWebcom", clienteDto.getIdClienteWebcom());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idClienteRem", clienteDto.getIdClienteRem());
		
		
		return HibernateQueryUtils.list(this, hql);
	}
	
}
