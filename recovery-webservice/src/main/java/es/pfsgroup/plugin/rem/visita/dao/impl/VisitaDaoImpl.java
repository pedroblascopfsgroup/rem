package es.pfsgroup.plugin.rem.visita.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.DtoVisitasFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaVisitasDetalle;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.rest.dto.VisitaDto;
import es.pfsgroup.plugin.rem.visita.dao.VisitaDao;

@Repository("VisitaDao")
public class VisitaDaoImpl extends AbstractEntityDao<Visita, Long> implements VisitaDao{
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListVisitas(DtoVisitasFilter dtoVisitasFilter) {
		HQLBuilder hb = new HQLBuilder(" from Visita vis");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vis.numVisitaRem", dtoVisitasFilter.getNumVisitaRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vis.activo.numActivo", dtoVisitasFilter.getNumActivo());

		if (dtoVisitasFilter.getSort() != null){
			if(dtoVisitasFilter.getSort().equals("nombre")) {
				dtoVisitasFilter.setSort("vis.cliente.nombre");
			} else if(dtoVisitasFilter.getSort().equals("numDocumento")) {
				dtoVisitasFilter.setSort("vis.cliente.documento");
			} else if(dtoVisitasFilter.getSort().equals("numActivo")) {
				dtoVisitasFilter.setSort("vis.activo.numActivo");
			}
		}

		//hb.orderBy("vis.numVisitaRem", HQLBuilder.ORDER_ASC);

		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoVisitasFilter);

		List<Visita> visitas = (List<Visita>) pageVisitas.getResults();
		List<DtoVisitasFilter> visitasFiltradas= new ArrayList<DtoVisitasFilter>();

		for(Visita v: visitas){
			DtoVisitasFilter dtoFilter= new DtoVisitasFilter();

			dtoFilter.setId(v.getId());
			dtoFilter.setNumActivo(v.getActivo().getNumActivo());
			dtoFilter.setNumVisitaRem((v.getNumVisitaRem()));
			dtoFilter.setNumActivoRem(v.getActivo().getNumActivoRem());
			dtoFilter.setFechaSolicitud(v.getFechaSolicitud());
			dtoFilter.setNombre(v.getCliente().getNombreCompleto());
			dtoFilter.setNumDocumento(v.getCliente().getDocumento());
			dtoFilter.setFechaVisita(v.getFechaVisita());
			if(!Checks.esNulo(v.getEstadoVisita())){
				dtoFilter.setEstadoVisita(v.getEstadoVisita().getDescripcion());
			}

			dtoFilter.setIdActivo(v.getActivo().getId());

			visitasFiltradas.add(dtoFilter);
		}

		return new DtoPage(visitasFiltradas, pageVisitas.getTotalCount());
	}

	@Override
	public Long getNextNumVisitaRem() {
		String sql = "SELECT S_VIS_NUM_VISITA.NEXTVAL FROM DUAL";

		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

	@Override
	public List<Visita> getListaVisitas(VisitaDto visitaDto) {
		HQLBuilder hql = new HQLBuilder("from Visita");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idVisitaWebcom", visitaDto.getIdVisitaWebcom());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numVisitaRem", visitaDto.getIdVisitaRem());

		return HibernateQueryUtils.list(this, hql);
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListVisitasDetalle(DtoVisitasFilter dtoVisitasFilter) {
		
		UsuarioCartera usuarioCartera = genericDao.get(UsuarioCartera.class,
				genericDao.createFilter(FilterType.EQUALS, "usuario.id", genericAdapter.getUsuarioLogado().getId()));
				
		HQLBuilder hb = new HQLBuilder(" from VBusquedaVisitasDetalle vvisita");
		
		if(!Checks.esNulo(usuarioCartera)) {
			HQLBuilder.addFiltroIgualQue(hb, "vvisita.idCartera", usuarioCartera.getCartera().getId().toString());
			if(!Checks.esNulo(usuarioCartera.getSubCartera())) {
				HQLBuilder.addFiltroIgualQue(hb, "vvisita.idSubcartera", usuarioCartera.getSubCartera().getId().toString());
			}
		}

		if(!Checks.esNulo(dtoVisitasFilter.getNumVisitaRem())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vvisita.numVisita", dtoVisitasFilter.getNumVisitaRem().toString());
		}

		if(!Checks.esNulo(dtoVisitasFilter.getNumActivo())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vvisita.numActivo", dtoVisitasFilter.getNumActivo().toString());
		}
		
		if(!Checks.esNulo(dtoVisitasFilter.getCarteraCodigo())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vvisita.carteraCodigo", dtoVisitasFilter.getCarteraCodigo());
		}

		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoVisitasFilter);

		List<VBusquedaVisitasDetalle> visitas = (List<VBusquedaVisitasDetalle>) pageVisitas.getResults();

		return new DtoPage(visitas, pageVisitas.getTotalCount());
	}
	
	
	
	@Override
	public List<Visita> getListaVisitasOrdenada(DtoVisitasFilter dtoVisitasFilter) {
		HQLBuilder hb = new HQLBuilder(" from Visita v");

		if(!Checks.esNulo(dtoVisitasFilter.getNumVisitaRem())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "v.numVisitaRem", dtoVisitasFilter.getNumVisitaRem());
		}

		if(!Checks.esNulo(dtoVisitasFilter.getNumActivo())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "v.activo.numActivo", dtoVisitasFilter.getNumActivo());
		}

		hb.orderBy("v.fechaSolicitud", HQLBuilder.ORDER_DESC);

	
		return HibernateQueryUtils.list(this, hb);
	}
	
	

	@SuppressWarnings("unchecked")
	@Override
	public VBusquedaVisitasDetalle getVisitaDetalle(DtoVisitasFilter dtoVisitasFilter) {
		HQLBuilder hb = new HQLBuilder(" from VBusquedaVisitasDetalle vvisita");

		// Filtrado por Num visita.
		if(!Checks.esNulo(dtoVisitasFilter.getNumVisitaRem())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vvisita.numVisita", dtoVisitasFilter.getNumVisitaRem().toString());
		}

		// Filtrado por ID visita.
		if(!Checks.esNulo(dtoVisitasFilter.getId())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vvisita.id", dtoVisitasFilter.getId().toString());
		}

		// Establecer los params para el objeto page.
		dtoVisitasFilter.setStart(0);
		dtoVisitasFilter.setLimit(1);

		Page pageVisitaDetalle = HibernateQueryUtils.page(this, hb, dtoVisitasFilter);

		List<VBusquedaVisitasDetalle> listaVisitasDetalle = (List<VBusquedaVisitasDetalle>) pageVisitaDetalle.getResults();
		
		if(!Checks.estaVacio(listaVisitasDetalle)) {
			return listaVisitasDetalle.get(0);
		}

		return null;
	}

	@Override
	public Visita getVisitaByIdwebcom(Long idWebcom) {
		Visita resultado = null;
		HQLBuilder hql = new HQLBuilder("from Visita");
		if(idWebcom != null){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idVisitaWebcom",idWebcom);
			
			try{
				resultado = HibernateQueryUtils.uniqueResult(this, hql);
			}catch(Exception e){
				logger.error("Error obteniendo visita por idwebcom");
			}
		}
		return resultado;
	}
}