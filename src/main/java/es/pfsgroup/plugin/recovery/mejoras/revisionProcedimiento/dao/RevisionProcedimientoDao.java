package es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;

public interface RevisionProcedimientoDao extends AbstractDao<Procedimiento, Long>{

	public List<Procedimiento> getListaProcedimientosRevisar(Long idAsunto);
}
