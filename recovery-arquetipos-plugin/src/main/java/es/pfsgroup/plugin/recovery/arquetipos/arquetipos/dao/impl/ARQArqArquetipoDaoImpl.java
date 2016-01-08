package es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArqArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQArquetipo;

@Repository("ARQArqArquetipoDao")
public class ARQArqArquetipoDaoImpl extends AbstractEntityDao<ARQArquetipo, Long> implements ARQArqArquetipoDao {

	@Override
	public void deleteByMraId(Long mraId) {
		// TODO Auto-generated method stub
		//Obtenemos el arq_arquetipo por MRA_ID
		
		HQLBuilder b=new HQLBuilder("from ARQArquetipo arq");
		b.appendWhere("arq.auditoria.borrado = 0");
		HQLBuilder.addFiltroIgualQue(b, "arq.modeloArquetipo.id", mraId);
		
		
		ARQArquetipo arq = HibernateQueryUtils.uniqueResult(this, b);
		if (arq!=null)
			this.deleteById(arq.getId());
	}
	
}
