package es.pfsgroup.plugin.rem.historicotarifaplana.dao;

import java.util.Date;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.HistoricoTarifaPlana;

public interface HistoricoTarifaPlanaDao extends AbstractDao<HistoricoTarifaPlana, Long>{

	/**
	 * Devuelve un objeto Boolean, true si el subtipo de trabajo tiene tarifa plana vigente
	 * @param codigoSubtipoTrabajo
	 * @param date 
	 * @return 
	 */
	public Boolean subtipoTrabajoTieneTarifaPlanaVigente(Long idCarteraActivo, Long idSubtipoTrabajo, Date date);
}
