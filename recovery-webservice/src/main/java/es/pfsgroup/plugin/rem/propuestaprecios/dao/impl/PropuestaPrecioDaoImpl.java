package es.pfsgroup.plugin.rem.propuestaprecios.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;

@Repository("PropuestaPrecioDao")
public class PropuestaPrecioDaoImpl extends AbstractEntityDao<PropuestaPrecio, Long> implements PropuestaPrecioDao{


    @Override
	public Page getListPropuestasPrecio(DtoPropuestaFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from PropuestaPrecio prp");
	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prp.cartera.codigo", dto.getEntidadPropietariaCodigo());
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    @Override
    public Long getNextNumPropuestaPrecio(){
		String sql = "SELECT S_PRP_NUM_PROPUESTA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
    }
    
    @Override
    public Page getListHistoricoPropuestasPrecios(DtoHistoricoPropuestaFilter dto) {
    	
    	HQLBuilder hb = new HQLBuilder(" from VBusquedaPropuestasPrecio prp");
    	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prp.numPropuesta", dto.getNumPropuesta());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "prp.nombrePropuesta", dto.getNombrePropuesta(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prp.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"prp.tipoPropuesta", dto.getTipoPropuesta());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"prp.numTramite", dto.getNumTramite());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"prp.numTrabajo", dto.getNumTrabajo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"prp.estadoCodigo", dto.getEstadoPropuesta());
   		HQLBuilder.addFiltroLikeSiNotNull(hb,"prp.gestor", dto.getGestorPrecios(),true);
   		
   		if(!Checks.esNulo(dto.getTipoDeFecha())) {
   			//No admite String en el switch
   			switch(Integer.parseInt(dto.getTipoDeFecha())) {
	   			case 1:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"prp.fechaEmision");	
	   				break;
	   			case 2:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"prp.fechaEnvio");	
	   				break;
	   			case 3:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"prp.fechaSancion");	
	   				break;
	   			case 4:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"prp.fechaCarga");	
	   				break;
   				default:
   					break;
   			}
   		}
   		
		return HibernateQueryUtils.page(this, hb, dto);
    }
    
    private void agregarFiltroFecha(HQLBuilder hb, String fechaD, String fechaH, String tipoFecha) {
    	try {
   			
			if (fechaD != null) {
				Date fechaDesde = DateFormat.toDate(fechaD);
				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, fechaDesde, null);
			}
			
			if (fechaH != null) {
				Date fechaHasta = DateFormat.toDate(fechaH);
		
				// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
				calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, null, calendar.getTime());
			}
			
   		} catch (ParseException e) {
			e.printStackTrace();
		}
    }
    
    @Override
	public boolean existePropuestaEnTrabajo(Long idTrabajo) {
    	
    	String sql = "select count(1) from PRP_PROPUESTAS_PRECIOS prp where prp.TBJ_ID = :idTrabajo";

    	return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).setParameter("idTrabajo", idTrabajo).uniqueResult()).longValue() == 1;

	}
    
    @Override
    @SuppressWarnings("unchecked")
	public List<BigDecimal> getActivosFromTrabajo(Long idTrabajo) {
    	String sql = "select prp.act_id from V_BUSQUEDA_ACTIVOS_TRABAJO prp ";
    	sql += " join V_BUSQUEDA_ACTIVOS_PRECIOS act on prp.ACT_ID = act.ACT_ID ";
    	sql += " where act.IN_PRP_TRAMITACION = 0 ";
    	sql += " and prp.TBJ_ID = :idTrabajo";
    	
    	return (List<BigDecimal>) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).setParameter("idTrabajo", idTrabajo).list();
    }
	
}
