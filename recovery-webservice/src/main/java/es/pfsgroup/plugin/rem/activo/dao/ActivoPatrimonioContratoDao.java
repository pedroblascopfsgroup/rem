package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.VActivoPatrimonioContrato;

public interface ActivoPatrimonioContratoDao extends AbstractDao<ActivoPatrimonioContrato, Long>{
	
	/**
	 * Devuelve un objeto ActivoPatrimonio a partir del id de un activo
	 * @param idActivo
	 * @return ActivoPatrimonio
	 */
	public List<ActivoPatrimonioContrato> getActivoPatrimonioContratoByActivo(Long idActivo);
	
	public List<VActivoPatrimonioContrato> getActivosRelacionados(Long idActivo);

}
