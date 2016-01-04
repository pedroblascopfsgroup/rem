package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;

@Repository("MSVResolucionDao")
public class MSVResolucionDaoImpl extends AbstractEntityDao<MSVResolucion, Long> implements MSVResolucionDao{

	@Override
	public MSVResolucion crearNuevoProceso() {
		return new MSVResolucion();
	}

	@Override
	public List<MSVResolucion> dameListaProcesos(String username) {
		
		return HibernateQueryUtils.list(this, this.getFilter(username));
	}
	
	@Override
	public Page dameListaProcesos(MSVDtoFiltroProcesos dto) {
		
		return HibernateQueryUtils.page(this, this.getFilter(dto.getUsername()), dto);
	}

	@Override
	public MSVResolucion mergeAndGet(Long idResolucion) {
		MSVResolucion resolucion = super.get(idResolucion);
		return HibernateUtils.merge(resolucion);
	}

	@Override
	public void mergeAndUpdate(MSVResolucion resolucion) {
		super.saveOrUpdate(HibernateUtils.merge(resolucion));
	}

	@Override
	public List<MSVResolucion> dameResolucionByTarea(Long idTareaExterna) {

		return HibernateQueryUtils.list(this, this.getFilterTareaExterna(idTareaExterna));
	}
	
	@Override
	public MSVResolucion getResolucionByTareaNotificacion(Long idTareaNotificacion) {
		
		HQLBuilder hb = new HQLBuilder("from MSVResolucion res");
		hb.appendWhere("res.auditoria.borrado=0");
		HQLBuilder.addFiltroIgualQue(hb, "res.tareaNotificacion.id", idTareaNotificacion);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	private HQLBuilder getFilter(String username) {
		HQLBuilder hb = new HQLBuilder("from MSVResolucion res");
		HQLBuilder.addFiltroIgualQue(hb, "res.auditoria.usuarioCrear", username);
		return hb;
	}
	
	private HQLBuilder getFilterTareaExterna(Long idTareaExterna) {
		HQLBuilder hb = new HQLBuilder("from MSVResolucion res");
		hb.appendWhere("res.auditoria.borrado=0 AND (res.estadoResolucion.codigo LIKE '"+MSVDDEstadoProceso.CODIGO_PTE_VALIDAR+"' OR res.estadoResolucion.codigo LIKE '"+MSVDDEstadoProceso.CODIGO_PAUSADO+"')");
		HQLBuilder.addFiltroIgualQue(hb, "res.tarea.id", idTareaExterna);
		//HQLBuilder.addFiltroIgualQue(hb, "res.estadoResolucion.codigo", MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
		return hb;
	}

	@Override
	public List<MSVResolucion> getResolucionesPendientesValidar(Long idTarea, List<String> tipoResolucionAccionBaned) {
		
		HQLBuilder hb = new HQLBuilder("from MSVResolucion res");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "res.tarea.id", idTarea);
		HQLBuilder.addFiltroIgualQue(hb, "res.auditoria.borrado", false);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "res.estadoResolucion.codigo", MSVDDEstadoProceso.CODIGO_PTE_VALIDAR);
		
		for(String trab :  tipoResolucionAccionBaned){
			hb.appendWhere(" res.tipoResolucion.tipoAccion.codigo != '"+trab+"' ");
		}
		
		return HibernateQueryUtils.list(this,hb);
	}

	
}
