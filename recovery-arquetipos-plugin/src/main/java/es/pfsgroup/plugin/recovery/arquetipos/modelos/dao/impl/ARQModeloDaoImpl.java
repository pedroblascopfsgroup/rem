package es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.impl;



import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoBusquedaModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;

@Repository("ARQModeloDao")
public class ARQModeloDaoImpl extends AbstractEntityDao<ARQModelo, Long> implements ARQModeloDao{

	@Override
	public ARQModelo createNewModelo() {
		return new ARQModelo();
	}

	@Override
	public Page findModelos(ARQDtoBusquedaModelo dto) {
		HQLBuilder b=new HQLBuilder("from ARQModelo mod");
		b.appendWhere("mod.auditoria.borrado = 0");
		
		HQLBuilder.addFiltroLikeSiNotNull(b, "mod.nombre", dto.getNombre(), true);
		HQLBuilder.addFiltroLikeSiNotNull(b, "mod.descripcion", dto.getDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(b, "mod.estado.codigo", dto.getEstadoModelo());
		if(!Checks.esNulo(dto.getListaArquetipos())){
			b.appendWhere("mod in (select modArq.modelo from ARQModeloArquetipo modArq where modArq.arquetipo.id in ("+dto.getListaArquetipos()+"))");
		}
		if(!Checks.esNulo(dto.getFechaInicioVigencia())&& !Checks.esNulo(dto.getFechaFinVigencia())){
			b.appendWhere("not((mod.fechaInicioVigencia > :p_ffv) OR (mod.fechaFinVigencia < :p_fiv))");
			b.getParameters().put("p_ffv", dto.getFechaFinVigencia());
			b.getParameters().put("p_fiv", dto.getFechaInicioVigencia());
		}	
		
		
		//HQLBuilder.addFiltroBetweenSiNotNull(b, "mod.fechaInicioVigencia", dto.getFechaInicioVigencia(), dto.getFechaFinVigencia());
		
		return HibernateQueryUtils.page(this, b, dto);
	
	}
}

