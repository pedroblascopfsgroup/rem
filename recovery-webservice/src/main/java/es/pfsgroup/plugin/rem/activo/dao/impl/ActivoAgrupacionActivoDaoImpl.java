package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
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
	public void deleteById(Long id) {
		
		StringBuilder sb = new StringBuilder("delete from ActivoAgrupacionActivo aaa where aaa.id = "+id);		
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
	public boolean isUniqueAgrupacionActivo(Long idActivo, String codigoTipoAgrupacion) {
		
    	HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
    	hb.appendWhere("aa.agrupacion.fechaBaja IS NULL");
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
	public boolean activoEnAgrupacionLoteComercial(Long idActivo) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
		hb.appendWhere("aa.agrupacion.fechaBaja IS NULL");
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.activo.id", idActivo);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
   	  	
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}

	@Override
	public boolean algunActivoDeAgrRestringidaEnAgrLoteComercial(List<Long> activosID) {

		HQLBuilder hb = new HQLBuilder(" from ActivoAgrupacionActivo aa");
   	  	HQLBuilder.addFiltroWhereInSiNotNull(hb, "aa.activo.id", activosID);
   	  	HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aa.agrupacion.tipoAgrupacion.codigo", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
   	    List<ActivoAgrupacionActivo> list = HibernateQueryUtils.list(this, hb);

		return (list.size() > 0);
	}
}