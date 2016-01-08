package es.pfsgroup.plugin.recovery.plazasJuzgados.procedimiento.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;

public interface JUZProcedimientoDao extends AbstractDao<Procedimiento, Long> {

	List<Procedimiento> findPorJuzgado(Long id);

}
