package es.pfsgroup.plugin.rem.proveedores.mediadores.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvalua;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.VListMediadoresEvaluar;
import es.pfsgroup.plugin.rem.model.VStatsCarteraMediadores;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.proveedores.mediadores.dao.MediadoresEvaluarDao;

@Repository("MediadoresEvaluarDao")
public class MediadoresEvaluarDaoImpl extends AbstractEntityDao<VListMediadoresEvaluar, Long> implements MediadoresEvaluarDao {
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Override
	public Page getListMediadoresEvaluar(DtoMediadorEvaluaFilter dtoFilter){
		DtoMediadorEvalua dto = new DtoMediadorEvalua();
		try {
			beanUtilNotNull.copyProperties(dto, dtoFilter);
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HQLBuilder hb = new HQLBuilder(" FROM VListMediadoresEvaluar mev ");
		
		if(!Checks.esNulo(dto.getCodCalificacion()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "codCalificacion", dto.getCodCalificacion());
		
		if(!Checks.esNulo(dto.getCodCartera()))
			HQLBuilder.addFiltroIgualQue(hb, "codCartera", dto.getCodCartera());
		
		if(!Checks.esNulo(dto.getCodEstadoProveedor()))
			HQLBuilder.addFiltroIgualQue(hb, "codEstadoProveedor", dto.getCodEstadoProveedor());

		if(!Checks.esNulo(dto.getCodigoRem()))
			HQLBuilder.addFiltroIgualQue(hb, "codigoRem", dto.getCodigoRem());
		
		if(!Checks.esNulo(dto.getCodLocalidad()))
			HQLBuilder.addFiltroIgualQue(hb, "codLocalidad", dto.getCodLocalidad());
		
		if(!Checks.esNulo(dto.getCodProvincia()))
			HQLBuilder.addFiltroIgualQue(hb, "codProvincia", dto.getCodProvincia());
		
		if(!Checks.esNulo(dto.getEsCustodio()))
			HQLBuilder.addFiltroIgualQue(hb, "esCustodio", dto.getEsCustodio());
		
		if(!Checks.esNulo(dto.getEsHomologado())){
			if(dto.getEsHomologado() == 1)
				HQLBuilder.addFiltroIgualQue(hb, "esHomologado", dto.getEsHomologado());
		}
		
		if(!Checks.esNulo(dto.getEsTop())){
			if(dto.getEsTop() == 1)
				HQLBuilder.addFiltroIgualQue(hb, "esTop", dto.getEsTop());
		}

		if(!Checks.esNulo(dto.getNombreApellidos()))
			HQLBuilder.addFiltroLikeSiNotNull(hb, "nombreApellidos", dto.getNombreApellidos());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	@Transactional(readOnly = false)
	public Boolean evaluarMediadoresConPropuestas(){

		// Procesa primero los datos para retirar calificaciones
		StringBuilder updateHQLRetireCal = new StringBuilder("update ActivoProveedor pve ");
		updateHQLRetireCal.append(" set pve.calificacionProveedor = null ");
		updateHQLRetireCal.append(" where pve.calificacionProveedorPropuesta = ");
		updateHQLRetireCal.append(" (select cpr1.id from DDCalificacionProveedorRetirar cpr1 where cpr1.codigo = :codigoRetirar ) ");
		
        Query queryUpdateRetireCal = this.getSession().createQuery(updateHQLRetireCal.toString());
        queryUpdateRetireCal.setParameter("codigoRetirar", DDCalificacionProveedorRetirar.CPR_CODIGO_RETIRAR);
        queryUpdateRetireCal.executeUpdate();
        
        // Elimina las calificaciones propuestas del tipo retirar para que no interfieran en el proceso de calificar
		StringBuilder updateHQLRemoveRetire = new StringBuilder("update ActivoProveedor pve ");
		updateHQLRemoveRetire.append(" set pve.calificacionProveedorPropuesta = null ");
		updateHQLRemoveRetire.append(" where pve.calificacionProveedorPropuesta = ");
		updateHQLRemoveRetire.append(" (select cpr1.id from DDCalificacionProveedorRetirar cpr1 where cpr1.codigo = :codigoRetirar) ");
		
        Query queryUpdateRemoveRetire = this.getSession().createQuery(updateHQLRemoveRetire.toString());
        queryUpdateRemoveRetire.setParameter("codigoRetirar", DDCalificacionProveedorRetirar.CPR_CODIGO_RETIRAR);
        queryUpdateRemoveRetire.executeUpdate();
        
		// Actualiza las calificaciones vigentes copiando los datos de propuestas
		StringBuilder updateHQLCal = new StringBuilder("update ActivoProveedor pve ");
		updateHQLCal.append(" set pve.calificacionProveedor = pve.calificacionProveedorPropuesta ");
		updateHQLCal.append(" where pve.calificacionProveedorPropuesta is not null ");
		
        Query queryUpdateCal = this.getSession().createQuery(updateHQLCal.toString());
        queryUpdateCal.executeUpdate();
        
        // Actualiza Top vigentes copiando los datos de propuestos
		StringBuilder updateHQLTop = new StringBuilder("update ActivoProveedor pve ");
		updateHQLTop.append(" set pve.top = pve.topPropuesto ");
		updateHQLTop.append(" where pve.topPropuesto is not null ");
		
        Query queryUpdateTop = this.getSession().createQuery(updateHQLTop.toString());
        queryUpdateTop.executeUpdate();
        

        // Vacia los datos de propuestos de calificaciones y Top
		StringBuilder updateHQLKiller = new StringBuilder("update ActivoProveedor pve ");
		updateHQLKiller.append(" set pve.calificacionProveedorPropuesta = null ");
		updateHQLKiller.append("   , pve.topPropuesto = null ");
		
        Query queryUpdateKiller = this.getSession().createQuery(updateHQLKiller.toString());
        queryUpdateKiller.executeUpdate();
        
        return true;
	}

}
