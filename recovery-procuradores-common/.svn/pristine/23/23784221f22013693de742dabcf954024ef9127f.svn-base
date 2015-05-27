package es.pfsgroup.plugin.recovery.procuradores.procurador.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dao.ProcuradorDao;
import es.pfsgroup.plugin.recovery.procuradores.procurador.dto.ProcuradorDto;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;

@Repository("ProcuradorDao")
public class ProcuradorDaoImpl extends AbstractEntityDao<Procurador, Long> implements ProcuradorDao{

	
	@Override
	public Page getListadoProcuradores(ProcuradorDto dto){
		
		HQLBuilder hb = new HQLBuilder(" from Procurador proc ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "proc.nombre", dto.getNombre(), true);
		hb.orderBy("proc.nombre", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.page(this, hb, dto);
		
	}

	@Override
	public Procurador getProcurador(Long idProcurador) {
		
		HQLBuilder hb = new HQLBuilder(" from Procurador proc ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "proc.id", idProcurador);
//		HQLBuilder.addFiltroLikeSiNotNull(hb, "proc.id", idProcurador, true);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public List<Procurador> getListadoProcuradoresLista(ProcuradorDto dto) {
		HQLBuilder hb = new HQLBuilder(" from Procurador proc ");
		hb.orderBy("proc.nombre", HQLBuilder.ORDER_ASC);
		//HQLBuilder.addFiltroLikeSiNotNull(hb, "proc.nombre", dto.getNombre(), true);

		return HibernateQueryUtils.list(this, hb);
	}

	
}
