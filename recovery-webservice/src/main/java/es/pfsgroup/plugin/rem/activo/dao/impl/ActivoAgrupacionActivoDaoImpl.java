package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Repository("ActivoAgrupacionActivoDao")
public class ActivoAgrupacionActivoDaoImpl extends AbstractEntityDao<ActivoAgrupacionActivo, Long> implements ActivoAgrupacionActivoDao{
	
	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivoHistorico aah");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aah.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aah.agrupacion.id", idAgrupacion);

		return HibernateQueryUtils.uniqueResult(this, hb);

	}  
	
	@Override
	public ActivoAgrupacionActivo getByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
		
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", idActivo);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.id", idAgrupacion);
   	    HQLBuilder.addFiltroIgualQue(hb, "aa.auditoria.borrado", false );
   	    HQLBuilder.addFiltroIgualQue(hb, "aa.agrupacion.auditoria.borrado", false );

		return HibernateQueryUtils.uniqueResult(this, hb);

	} 
	@Override
	public ActivoAgrupacionActivo getAgrupacionPAByIdAgrupacion(long idAgrupacion) {
		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.id", idAgrupacion);
   	    HQLBuilder.addFiltroIgualQue(hb, "aa.auditoria.borrado", false );
   	    HQLBuilder.addFiltroIgualQue(hb, "aa.agrupacion.auditoria.borrado", false );
   	    
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
   	    if(Checks.estaVacio(list)) {
   	    	return null;
   	    }
   	    return list.get(0);
	}
	

    @Override
	public void deleteById(Long id) {
		
		StringBuilder sb = new StringBuilder("delete from ActivoAgrupacionActivo aaa where aaa.id = "+id);		
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		
	}
    
    @Override
    public void deleteTramiteGencat(ComunicacionGencat comunicacionGencat, List<NotificacionGencat> notificacionesGencat, List<ReclamacionGencat> reclamacionesGencat, VisitaGencat visitaGencat) {
    	StringBuilder sb;
    	
    	sb = new StringBuilder("delete from AdecuacionGencat ag where ag.comunicacion.id = "+comunicacionGencat.getId());		
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
    	
		sb = new StringBuilder("delete from OfertaGencat og where og.comunicacion.id = "+comunicacionGencat.getId());		
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		
		if (!Checks.estaVacio(notificacionesGencat)) {
			sb = new StringBuilder("delete from NotificacionGencat ng where comunicacion.id = "+comunicacionGencat.getId());		
			this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		}
		if (!Checks.estaVacio(reclamacionesGencat)) {
			sb = new StringBuilder("delete from ReclamacionGencat rg where comunicacion.id = "+comunicacionGencat.getId());		
			this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		}
		if (!Checks.esNulo(visitaGencat)) {
			sb = new StringBuilder("delete from VisitaGencat vg where comunicacion.id = "+comunicacionGencat.getId());		
			this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		}
		
		sb = new StringBuilder("delete from ComunicacionGencat cg where cg.id = "+comunicacionGencat.getId());		
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		
	}

    
    @Override
    public int numActivosPorActivoAgrupacion(long idAgrupacion) {
    	
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.id", idAgrupacion);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
		
   	    return list.size();
    }
    
    @Override
    public ActivoAgrupacionActivo primerActivoPorActivoAgrupacion(long idAgrupacion) {
    	
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.id", idAgrupacion);
   	  	hb.orderBy("aa.id", HQLBuilder.ORDER_ASC);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
   	    
   	    if (list.size()==0) return null;
   	    ActivoAgrupacionActivo agrupacionActivo = list.get(0);
   	    return agrupacionActivo;
    }

	@Override
	public boolean isUniqueRestrictedActive(Activo activo) {
		
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", activo.getId());
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
   	    
		return (list.size()==0);
	}
	
	@Override
	public boolean isUniqueNewBuildingActive(Activo activo) {
		
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", activo.getId());
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
   	    
		return (list.size()==0);
	}
	
	@Override
	public boolean isUniqueAgrupacionActivo(Long idActivo, String codigoTipoAgrupacion, Long numAgrupacion) {
		
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
    	hb.appendWhere("aa.agrupacion.fechaBaja IS NULL");
    	hb.appendWhere("aa.agrupacion.numAgrupRem != " + numAgrupacion);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", idActivo);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", codigoTipoAgrupacion);
   	  	
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
   	    
		return (list.size()==0);
	}
	
	@Override
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo) {
		
		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	hb.appendWhere("aa.agrupacion.fechaBaja IS NOT NULL");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", activo.getId());
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);
		return (list.size()!=0);
	}
	
	@Override
	public List<ActivoAgrupacionActivo> getListActivosAgrupacion(DtoAgrupacionFilter dtoAgrupActivo){

		HQLBuilder hql = new HQLBuilder("from ActivoAgrupacionActivo aa");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.id", dtoAgrupActivo.getId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.activo.id", dtoAgrupActivo.getActId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.agrupacion.id", dtoAgrupActivo.getAgrId());
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.agrupacion.tipoAgrupacion.codigo", dtoAgrupActivo.getTipoAgrupacion());
		hql.appendWhere("aa.agrupacion.fechaBaja is null");
		hql.appendWhere("aa.auditoria.borrado = 0");
		
		return HibernateQueryUtils.list(this, hql);
	}

	@Override
	public List<ActivoAgrupacionActivo> getListActivoAgrupacionActivoByAgrupacionIDAndActivos(Long idAgrupacion,
			List<Long> activosID) {

		HQLBuilder hql = new HQLBuilder("from ActivoAgrupacionActivo aa");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.agrupacion.id", idAgrupacion);
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "aa.activo.id", activosID);
		
		return HibernateQueryUtils.list(this, hql);
	}
	
	@Override
	public List<ActivoAgrupacionActivo> getListActivoAgrupacionVentaByIdActivo(Long idActivo) {

		HQLBuilder hql = new HQLBuilder("from ActivoAgrupacionActivo aa");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.activo.id", idActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL_VENTA);
		hql.appendWhere("aa.agrupacion.fechaBaja is null");
		hql.appendWhere("aa.auditoria.borrado = 0");
		
		return HibernateQueryUtils.list(this, hql);
	}
	
	@Override
	public List<ActivoAgrupacionActivo> getListActivoAgrupacionActivoByAgrupacionID(Long idAgrupacion) {

		HQLBuilder hql = new HQLBuilder("from ActivoAgrupacionActivo aa");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "aa.agrupacion.id", idAgrupacion);
		
		return HibernateQueryUtils.list(this, hql);
	}

	@Override
	public boolean activoEnAgrupacionLoteComercial(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
		hb.appendWhere("aa.agrupacion.fechaBaja IS NULL");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", idActivo);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
   	  	
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}
	
	@Override
	public boolean activoEnAgrupacionLoteComercialAlquiler(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
		hb.appendWhere("aa.agrupacion.fechaBaja IS NULL");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", idActivo);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_COMERCIAL_ALQUILER);
   	  	
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}

	@Override
	public boolean algunActivoDeAgrRestringidaEnAgrLoteComercial(List<Long> activosID) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroWhereInSiNotNull(hb, "aa.activo.id", activosID);
   	  	HQLBuilder.addFiltroIsNull(hb, "aa.agrupacion.fechaBaja");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}
	
	@Override
	public Activo getActivoMatrizByIdAgrupacion(Long idAgrupacion){
		HQLBuilder hb = new HQLBuilder("select aga.activo from ActivoAgrupacionActivo aga where aga.agrupacion.id = "+idAgrupacion+ " and aga.principal = 1");
		try {
			return (Activo) getHibernateTemplate().find(hb.toString()).get(0);
		} catch(Exception e) {
			return null;
		}
	}
	
	@Override
	public List<Activo> getListUAsByIdAgrupacion(Long idAgrupacion) {
		HQLBuilder hb = new HQLBuilder("select aga.activo from ActivoAgrupacionActivo aga where aga.agrupacion.id = "+idAgrupacion+ " and aga.principal = 0");
		
		return (List<Activo>) getHibernateTemplate().find(hb.toString());
	}
	
	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoPrincipalByIdAgrupacion(long idAgrupacion) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aga");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.agrupacion.id", idAgrupacion);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.principal", 1);
		HQLBuilder.addFiltroIgualQue(hb, "aga.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQue(hb, "aga.agrupacion.auditoria.borrado", false);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}
	
	@Override
	public Activo getPisoPilotoByIdAgrupacion(long idAgrupacion) {
		
 		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aga ");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.agrupacion.id", idAgrupacion);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aga.pisoPiloto", true);
		HQLBuilder.addFiltroIgualQue(hb, "aga.auditoria.borrado", false);
		HQLBuilder.addFiltroIgualQue(hb, "aga.agrupacion.auditoria.borrado", false);
		
		ActivoAgrupacionActivo actAga = HibernateQueryUtils.uniqueResult(this, hb);
		if(!Checks.esNulo(actAga)) {
			return actAga.getActivo();
		}else {
			return null;
		}
	}
	@Override
	public boolean isTipoComercializacionesAgrupaciones(Long idAgrupacion) {
		
		String sql = " SELECT COUNT(1) FROM (SELECT Distinct(tco.dd_tco_id), aga.agr_id " + 
				"		FROM dd_tco_tipo_comercializacion tco " + 
				"		join act_apu_activo_publicacion apu on tco.dd_tco_id = apu.dd_tco_id " + 
				"		join act_activo act on apu.act_id = act.act_id " + 
				"		join act_aga_agrupacion_activo aga on act.act_id = aga.act_id " + 
				"		where aga.agr_id =" + idAgrupacion + " "+ 
				"		group by tco.dd_tco_id, aga.agr_id)";		
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() == 1;
		}
		return false;				
	}
	
	@Override
	public boolean algunActivoAlquilado(List<Long> activosID) {

		HQLBuilder hb = new HQLBuilder(" from Activo aa");
   	  	HQLBuilder.addFiltroWhereInSiNotNull(hb, "aa.id", activosID);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.situacionComercial.codigo", DDSituacionComercial.CODIGO_ALQUILADO);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}
	
	@Override
	public boolean algunActivoVendido(List<Long> activosID) {

		HQLBuilder hb = new HQLBuilder(" from Activo aa");
   	  	HQLBuilder.addFiltroWhereInSiNotNull(hb, "aa.id", activosID);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.situacionComercial.codigo", DDSituacionComercial.CODIGO_VENDIDO);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}
}