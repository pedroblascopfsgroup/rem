package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.impl;



import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto.ARQDtoBusquedaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;

@Repository("ARQArquetipoDao")
public class ARQArquetipoDaoImpl extends AbstractEntityDao<ARQListaArquetipo, Long> implements ARQArquetipoDao{

	
	public Page findArquetipo(ARQDtoBusquedaArquetipo dto) {
		HQLBuilder b;
		if (dto.getModelo()== null && dto.getEstado()== null) {
			b = new HQLBuilder("from ARQListaArquetipo a");
			
		}else{
			b=new HQLBuilder("select distinct a from ARQModeloArquetipo ma join ma.arquetipo a ");
		}
		
		b.appendWhere("a.auditoria.borrado = 0");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(b, "a.rule.id", dto.getRule());
		
		HQLBuilder.addFiltroLikeSiNotNull(b, "a.nombre", dto.
				getNombre(),true);
		
		HQLBuilder.addFiltroIgualQueSiNotNull(b, "ma.modelo.id", dto.getModelo());
		
		
		HQLBuilder.addFiltroIgualQueSiNotNull(b, "ma.modelo.estado.id", dto.getEstado());
		
		return HibernateQueryUtils.page(this, b, dto);
	}

	public ARQListaArquetipo createNewArquetipo() {
		return new ARQListaArquetipo();
	}

	

}
