package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.impl;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.ARQModeloArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ComparaPorPrioridad;

@Repository("ARQModeloArquetipoDao")
public class ARQModeloArquetipoDaoImpl extends AbstractEntityDao<ARQModeloArquetipo, Long> implements ARQModeloArquetipoDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<ARQModeloArquetipo> listaArquetiposModelo(Long idModelo) {
		HQLBuilder hb = new HQLBuilder("from ARQModeloArquetipo m");
		hb.appendWhere("m.auditoria.borrado = 0");
		HQLBuilder.addFiltroIgualQue(hb, "m.modelo.id", idModelo);
		List<ARQModeloArquetipo> l = HibernateQueryUtils.list(this, hb);
		
		Collections.sort(l,new ComparaPorPrioridad() );
		
		return l;
	}

	@Override
	public ARQModeloArquetipo createNewModeloArquetipo() {
		return new ARQModeloArquetipo();
	}
}
