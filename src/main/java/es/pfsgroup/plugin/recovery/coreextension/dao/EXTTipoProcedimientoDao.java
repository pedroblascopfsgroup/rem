package es.pfsgroup.plugin.recovery.coreextension.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

public interface EXTTipoProcedimientoDao extends AbstractDao<TipoProcedimiento, Long> {

	public List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacion(String codigoActuacion);
}
