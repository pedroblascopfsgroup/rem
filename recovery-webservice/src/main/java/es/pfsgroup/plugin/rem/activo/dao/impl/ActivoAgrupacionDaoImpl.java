package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.VSubdivisionesAgrupacion;

@Repository("ActivoAgrupacionDao")
public class ActivoAgrupacionDaoImpl extends AbstractEntityDao<ActivoAgrupacion, Long> implements ActivoAgrupacionDao{

	@Resource
	private PaginationManager paginationManager;
	
	@Override
	public Page getListAgrupaciones(DtoAgrupacionFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaAgrupaciones agr");
		
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "agr.nombre", dto.getNombre(), true);
   		//HQLBuilder.addFiltroLikeSiNotNull(hb, "agr.publicado", dto.getPublicado(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.tipoAgrupacion.codigo", dto.getTipoAgrupacion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.numAgrupacionRem",dto.getNumAgrupacionRem());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.cartera", dto.getCodCartera());
   		
   		
   		if (dto.getAgrupacionId() != null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.id", Long.valueOf(dto.getAgrupacionId()));
   		}
		
   		try {
   			

			if (dto.getFechaCreacionDesde() != null) {
				Date fechaDesde = DateFormat.toDate(dto.getFechaCreacionDesde());
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaAlta", fechaDesde, null);
			}
			
			if (dto.getFechaCreacionHasta() != null) {
				Date fechaHasta = DateFormat.toDate(dto.getFechaCreacionHasta());
		
				// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, "agr.fechaAlta", null, calendar.getTime());
			}
			
   		} catch (ParseException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return HibernateQueryUtils.page(this, hb, dto);

	}
	
	@Override
	public Page getListActivosAgrupacionById(DtoAgrupacionFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VActivosAgrupacion agr");
		
   		if (dto.getAgrupacionId() != null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "agr.agrId", Long.valueOf(dto.getAgrupacionId()));
   		}
   		
   		if (dto.getSort() == null || dto.getSort().isEmpty()) {
   			hb.orderBy("activoPrincipal", HQLBuilder.ORDER_DESC);
   		}

		return HibernateQueryUtils.page(this, hb, dto);

	}  
	
    public Long getNextNumAgrupacionRemManual() {
		String sql = "SELECT S_AGR_NUM_AGRUP_REM.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

    @Override
    public Long getAgrupacionIdByNumAgrupRem(Long numAgrupRem){
    	try {
    		HQLBuilder hb = new HQLBuilder("select agr.id from ActivoAgrupacion agr where agr.numAgrupRem = " + numAgrupRem + " ");
    		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		return null;
    	}
    }
    
    @Override
   	public Long haveActivoPrincipal(Long id) {

    	try {
    		HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.id = " + id + " and act.principal = " + 1);
    		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		return null;
    	}

   	}
    
    @Override
	public Long haveActivoRestringidaAndObraNueva(Long id) {

    	try {

    		HQLBuilder hb = new HQLBuilder("select count( distinct act.agrupacion.tipoAgrupacion.id ) from ActivoAgrupacionActivo act where act.activo.id in "
    				+ " ( select distinct (agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = " + id + ")");
    		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));

    	} catch (Exception e) {
    		e.printStackTrace();
    		return null;
    	}

	}
    
   /* @Override
    public void deleteActivoPrincipalByIdActivoAgrupacionActivo(Long id) {

    	try {

    		HQLBuilder hb = new HQLBuilder("update ActivoAgrupacion set activoPrincipal = null where activoPrincipal = (select activo from ActivoAgrupacionActivo where id = " + id + ")");
    		
    		Query queryUpdate = this.getSession().createQuery(hb.toString());
            
            queryUpdate.executeUpdate();
    		//HQLBuilder hb = new HQLBuilder("update ActivoAgrupacion set activoPrincipal = null where activoPrincipal = (select activo from ActivoAgrupacionActivo where id = " + id + ")");
    		//return ((List<ActivoFoto>) getHibernateTemplate().find(hb.toString()));

    	} catch (Exception e) {
    		e.printStackTrace();
    		//return null;
    	}
    	
    	//update ACT_AGR_AGRUPACION AGR set AGR_ACT_PRINCIPAL = NULL WHERE AGR.AGR_ACT_PRINCIPAL = (SELECT ACT_ID FROM ACT_AGA_AGRUPACION_ACTIVO WHERE AGA_ID = 42)

    }*/	
    
    @Override
    public List<ActivoFoto> getFotosActivosAgrupacionById(Long id) {
    	
    	try {

    		HQLBuilder hb = new HQLBuilder("from ActivoFoto foto where foto.activo.id in "
    				+ " ( select distinct(agru.agrupacion.activoPrincipal) from ActivoAgrupacionActivo agru where agru.agrupacion.id = " + id + ") order by foto.activo.id desc ");
    		
    		List<ActivoFoto> listaPrincipal = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());
    		

    		HQLBuilder hbDos = new HQLBuilder("from ActivoFoto foto where foto.activo.id in "
			+ " ( select distinct(agru.activo.id) from ActivoAgrupacionActivo agru where agru.agrupacion.id = " + id + " and agru.agrupacion.activoPrincipal != foto.activo.id) order by foto.activo.id desc ");

    		List<ActivoFoto> listaResto = (List<ActivoFoto>) getHibernateTemplate().find(hbDos.toString());
    		
    		if (listaPrincipal != null && !listaPrincipal.isEmpty()) {
    			listaPrincipal.addAll(listaResto);
    			return listaPrincipal;
    		} else {
    			return listaResto;
    		}
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    		return null;
    	}
    	
    }
    
	@Override
	public Page getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter) {
		
		HQLBuilder hb = new HQLBuilder(" from VSubdivisionesAgrupacion subagr");		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subagr.agrupacionId", agrupacionFilter.getAgrId());  		

		return HibernateQueryUtils.page(this, hb, agrupacionFilter);
	}
	
	@Override
	public Page getListActivosSubdivisionById(DtoSubdivisiones subdivision) {
		
		HQLBuilder hb = new HQLBuilder(" from VActivosSubdivision actsub");	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "actsub.idSubdivision", subdivision.getId());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "actsub.agrupacionId", subdivision.getAgrId());	

		return HibernateQueryUtils.page(this, hb, subdivision);
	}

	@Override
	public List<ActivoFoto> getFotosSubdivision(DtoSubdivisiones subdivision) {
		
		List<ActivoFoto> lista = null;
		
		try {

    		HQLBuilder hb = new HQLBuilder("from ActivoFoto foto where foto.subdivision = "
    				+ subdivision.getId()
    				+ " and foto.agrupacion.id = "
    				+ subdivision.getAgrId()
    				+ " order by foto.orden");
    		
    		lista = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
		
		
		return lista;
		
		
	}

	@Override
	public List<ActivoFoto> getFotosAgrupacionById(Long id) {
		
		List<ActivoFoto> lista = null;
		
		try {

    		HQLBuilder hb = new HQLBuilder("from ActivoFoto foto where foto.agrupacion.id = " + id + " and foto.subdivision is null");
    		
    		lista = (List<ActivoFoto>) getHibernateTemplate().find(hb.toString());
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
		
		
		return lista;
	}

    


}
