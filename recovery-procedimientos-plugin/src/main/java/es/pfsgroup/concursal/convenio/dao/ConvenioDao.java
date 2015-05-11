package es.pfsgroup.concursal.convenio.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.concursal.convenio.model.Convenio;

public interface ConvenioDao extends AbstractDao<Convenio, Long>{

	/**
	 * Devuelve los convenios asociados a un asunto / procedimiento
	 * @param idProcedimiento Tenemos que pasar el id del procedimiento
	 * @return lista de convenios
	 */
	public List<Convenio> findByProcedimiento(Long idProcedimiento);
	
	/**
	 * Devuelve los convenios asociados a un asunto / numero de auto
	 * @param numero de auto 
	 * @return lista de convenios
	 */
	public List<Convenio> findByNumAuto(String numAuto);

}
