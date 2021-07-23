package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoVListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk;
import es.pfsgroup.plugin.rem.oferta.dao.VListadoOfertasAgrupadasLbkDao;

@Repository("VListadoOfertasAgrupadasLbkDao")
public class VListadoOfertasAgrupadasLbkDaoImpl extends AbstractEntityDao<VListadoOfertasAgrupadasLbk, Long> implements VListadoOfertasAgrupadasLbkDao{

	@Override
	public DtoPage getListOfertasAgrupadasLbk(
			DtoVListadoOfertasAgrupadasLbk dtoListadoOfertasAgrupadas) {
		
		HQLBuilder hb = null;
		
		String from = "SELECT new es.pfsgroup.plugin.rem.model.VListadoOfertasAgrupadasLbk("+
				"vofertaagrupadas.numOfertaPrincipal,vofertaagrupadas.numOfertaDependiente,vofertaagrupadas.importeOfertaDependiente"+
				") FROM VListadoOfertasAgrupadasLbk vofertaagrupadas ";
					
		hb = new HQLBuilder(from);
		HQLBuilder.addFiltroIgualQue(hb, "vofertaagrupadas.numOfertaPrincipal", dtoListadoOfertasAgrupadas.getNumOfertaPrincipal());
		hb.addGroupBy("vofertaagrupadas.numOfertaPrincipal,vofertaagrupadas.numOfertaDependiente,vofertaagrupadas.importeOfertaDependiente");
		
		Page page = HibernateQueryUtils.page(this, hb, dtoListadoOfertasAgrupadas);
		List<VListadoOfertasAgrupadasLbk> ofertas;
		if(!Checks.estaVacio(page.getResults())) {
			ofertas = (List<VListadoOfertasAgrupadasLbk>) page.getResults();
			return new DtoPage(ofertas, page.getTotalCount());
		}
		return new DtoPage(new ArrayList<VListadoOfertasAgrupadasLbk>(),0);
	}

	@Override
	public DtoPage getListActivosOfertasAgrupadasLbk(DtoVListadoOfertasAgrupadasLbk dtoListadoOfertasAgrupadas) {
HQLBuilder hb = null;
		
		String from = "SELECT vofertaagrupadas FROM VListadoOfertasAgrupadasLbk vofertaagrupadas ";
					
		hb = new HQLBuilder(from);
		HQLBuilder.addFiltroIgualQue(hb, "vofertaagrupadas.numOfertaPrincipal", dtoListadoOfertasAgrupadas.getNumOfertaPrincipal());
		
		Page page = HibernateQueryUtils.page(this, hb, dtoListadoOfertasAgrupadas);
		List<VListadoOfertasAgrupadasLbk> ofertas;
		if(!Checks.estaVacio(page.getResults())) {
			ofertas = (List<VListadoOfertasAgrupadasLbk>) page.getResults();
			return new DtoPage(ofertas, page.getTotalCount());
		}
		return new DtoPage(new ArrayList<VListadoOfertasAgrupadasLbk>(),0);
	}
	
}
