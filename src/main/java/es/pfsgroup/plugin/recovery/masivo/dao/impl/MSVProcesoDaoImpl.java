package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.masivo.controller.GridFilter;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesoDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoFiltroProcesos;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;

@Repository("MSVProcesoDao")
public class MSVProcesoDaoImpl extends AbstractEntityDao<MSVProcesoMasivo, Long> implements MSVProcesoDao{

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public MSVProcesoMasivo crearNuevoProceso() {
		return new MSVProcesoMasivo();
	}

	@Override
	@Deprecated
	public String eliminarProceso(long idProceso, MSVProcesoMasivo procesoMasivo) {
		genericDao.deleteById(MSVProcesoMasivo.class,idProceso);
		
		//TODO: Incorporar si hemos de controlar en el caso de que no se
		//pueda eliminar el proceso porque no esté, si la excepción la ha de recoger el controller
		MSVProcesoMasivo procesoEliminar =genericDao.get(MSVProcesoMasivo.class, genericDao.createFilter(FilterType.EQUALS, "id", procesoMasivo.getId()));
		
		
		if(procesoEliminar.getAuditoria().isBorrado()){
			return "ok";
		}else{
			return "ko";
		}
		
	}

	@Override
	public List<MSVProcesoMasivo> dameListaProcesos(String username) {
		
		return HibernateQueryUtils.list(this, this.getFiltroProcesos(username));
	}
	
	@Override
	public Page dameListaProcesos(MSVDtoFiltroProcesos dto) {
		
		return HibernateQueryUtils.page(this, this.getFiltroProcesos(dto), dto);

	}

	private HQLBuilder getFiltroProcesos(String username) {
		HQLBuilder hb = new HQLBuilder("from MSVProcesoMasivo proc");
		HQLBuilder.addFiltroIgualQue(hb, "proc.auditoria.usuarioCrear", username);
		return hb;
	}
	
	private HQLBuilder getFiltroProcesos(MSVDtoFiltroProcesos dto) {
		HQLBuilder hb = new HQLBuilder("from MSVProcesoMasivo proc");
		if(!dto.getEsSupervisor())
			HQLBuilder.addFiltroIgualQue(hb, "proc.auditoria.usuarioCrear", dto.getUsername());
		if (dto.getFiltros() != null && dto.getFiltros().size()>0)
			this.creaFiltrado(hb, dto.getFiltros());
		
		
		return hb;
	}

	private void creaFiltrado(HQLBuilder hb, List<GridFilter> filtros) {
		
		for (GridFilter gridFilter : filtros) {
			
			if ("usuario".equals(gridFilter.getCampoFiltrado())){
				HQLBuilder.addFiltroLikeSiNotNull(hb, "proc.auditoria.usuarioCrear", gridFilter.getValoresFiltrado().get(0), true);
			}
			if ("estado".equals(gridFilter.getCampoFiltrado())){
				hb.appendWhereIN("proc.estadoProceso.descripcion", gridFilter.getValoresFiltradoComas().toArray(new String[gridFilter.getValoresFiltrado().size()]));
			}
			if ("tipoOperacion".equals(gridFilter.getCampoFiltrado())){
				hb.appendWhereIN("proc.tipoOperacion.descripcion", gridFilter.getValoresFiltradoComas().toArray(new String[gridFilter.getValoresFiltrado().size()]));
			}	
			if ("fecha".equals(gridFilter.getCampoFiltrado())){
				String comparacion = gridFilter.getComparacion();
				if("eq".equals(comparacion)){
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "proc.auditoria.fechaCrear", this.parseDate(gridFilter.getValoresFiltrado().get(0) + " 00:00:00"), this.parseDate(gridFilter.getValoresFiltrado().get(0) + " 23:59:59"));
				}else if("gt".equals(comparacion)){
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "proc.auditoria.fechaCrear", this.parseDate(gridFilter.getValoresFiltrado().get(0) + " 00:00:00"), null);
				}else if("lt".equals(comparacion)){
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "proc.auditoria.fechaCrear", null, this.parseDate(gridFilter.getValoresFiltrado().get(0) + " 00:00:00"));
				}

			}
		}
		
	}
	
	private Date parseDate(String fecha) {
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy hh:mm:ss");
		try {
			return df.parse(fecha);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public MSVProcesoMasivo mergeAndGet(Long idProceso) {
		MSVProcesoMasivo proceso = super.get(idProceso);
		return HibernateUtils.merge(proceso);
	}

	@Override
	public void mergeAndUpdate(MSVProcesoMasivo proceso) {
		super.saveOrUpdate(HibernateUtils.merge(proceso));
	}

	@Override
	public MSVProcesoMasivo getByToken(Long tokenProceso) {
		return genericDao.get(MSVProcesoMasivo.class, genericDao.createFilter(FilterType.EQUALS, "token", tokenProceso));		
	}


}
