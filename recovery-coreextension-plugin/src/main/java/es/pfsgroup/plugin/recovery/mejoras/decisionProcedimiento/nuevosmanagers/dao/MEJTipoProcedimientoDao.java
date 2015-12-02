package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

public interface MEJTipoProcedimientoDao extends AbstractDao<TipoProcedimiento, Long>{

	TipoProcedimiento getByCodigo(String codigo);

}
