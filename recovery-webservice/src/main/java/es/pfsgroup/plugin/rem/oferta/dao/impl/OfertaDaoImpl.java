package es.pfsgroup.plugin.rem.oferta.dao.impl;


import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao{
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {
		
		HQLBuilder hb = new HQLBuilder(" from VOfertasActivosAgrupacion voferta");
		
		if(!Checks.esNulo(dtoOfertasFilter.getNumOferta())){
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numOferta", dtoOfertasFilter.getNumOferta().toString());
		}
		
		if(!Checks.esNulo(dtoOfertasFilter.getNumAgrupacion())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoAgrupacion", dtoOfertasFilter.getNumAgrupacion().toString());
		}
		if(!Checks.esNulo(dtoOfertasFilter.getNumActivo())){
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.activos", dtoOfertasFilter.getNumActivo().toString());
		}
		
		try {
			Date fechaAltaDesde = DateFormat.toDate(dtoOfertasFilter.getFechaAltaDesde());
			Date fechaAltaHasta = DateFormat.toDate(dtoOfertasFilter.getFechaAltaHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "voferta.fechaCreacion", fechaAltaDesde, fechaAltaHasta);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoEstadoOferta", dtoOfertasFilter.getEstadoOferta());
		
		//hb.orderBy("voferta.numOferta", HQLBuilder.ORDER_ASC);
		//Faltan los dos combos

	
		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoOfertasFilter);
		
		List<VOfertasActivosAgrupacion> ofertas = (List<VOfertasActivosAgrupacion>) pageVisitas.getResults();
		
		return new DtoPage(ofertas, pageVisitas.getTotalCount());
		
	}


	@Override
	public Page getListTextosOfertaById(DtoTextosOferta dto, Long id) {
		
		HQLBuilder hb = new HQLBuilder(" from TextosOferta txo");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "txo.oferta.id", id);
		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
	
	
	@Override
	public Long getNextNumOfertaRem() {
		String sql = "SELECT S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
	
	
	@Override
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto){

		HQLBuilder hql = new HQLBuilder("from Oferta ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idWebCom", ofertaDto.getIdOfertaWebcom());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numOferta", ofertaDto.getIdOfertaRem());
		
		
		return HibernateQueryUtils.list(this, hql);
	}
	


}
