package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

public interface ARQModeloArquetipoDao extends AbstractDao<ARQModeloArquetipo, Long> {

	/**
	 * 
	 * @param idModelo
	 * @return devuelve una lista de objetos ARQModeloArquetipo cuyo
	 * modelo coincide con el id que se le pasa como entrada. Es decir
	 * devuelve los arquetipos que tiene asociado un determinado modelo
	 */
	public List<ARQModeloArquetipo> listaArquetiposModelo(Long idModelo);

	/**
	 * Nos crea una nueva instancia de ModeloArquetipo
	 * @return
	 */
	public ARQModeloArquetipo createNewModeloArquetipo();
	
}
