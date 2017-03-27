package es.pfsgroup.plugin.rem.resolucionComite.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;

@Repository("ResolucionComiteDao")
public  class ResolucionComiteDaoImpl extends AbstractEntityDao<ResolucionComiteBankia, Long> implements ResolucionComiteDao {

	
	
	@Override
	public List<ResolucionComiteBankia> getListaResolucionComite(ResolucionComiteBankiaDto resolDto) throws Exception {

		HQLBuilder hql = new HQLBuilder("from ResolucionComiteBankia res");
		if(!Checks.esNulo(resolDto.getExpediente())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.expediente.id", resolDto.getExpediente().getId());
		}
		if(!Checks.esNulo(resolDto.getTipoResolucion())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.tipoResolucion.codigo", resolDto.getTipoResolucion().getCodigo());
		}
		if(!Checks.esNulo(resolDto.getComite())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.comite.codigo", resolDto.getComite().getCodigo());
		}
		if(!Checks.esNulo(resolDto.getEstadoResolucion())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.estadoResolucion.codigo", resolDto.getEstadoResolucion().getCodigo());
		}
		if(!Checks.esNulo(resolDto.getFechaAnulacion())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.fechaAnulacion", resolDto.getFechaAnulacion());
		}
		if(!Checks.esNulo(resolDto.getMotivoDenegacion())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.motivoDenegacion.codigo", resolDto.getMotivoDenegacion().getCodigo());
		}
		if(!Checks.esNulo(resolDto.getImporteContraoferta())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "res.importeContraoferta", resolDto.getImporteContraoferta());
		}
		
		return HibernateQueryUtils.list(this, hql);
	}




}