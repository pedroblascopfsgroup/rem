package es.pfsgroup.plugin.recovery.mejoras.tareaProcedimiento.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

public interface MEJTareaProcedimientoDao extends AbstractDao<TareaProcedimiento, Long>{

	public List<TareaProcedimiento> getListaTareaProcedimientos(Long idTipoPro);
}
