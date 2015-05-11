package es.capgemini.pfs.procedimiento.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;

public interface EXTProcedimientoDao extends AbstractDao<Procedimiento, Long>{

	public List<Procedimiento> getProcedimientosOrigenOrdenados(Long idAsunto);

	public List<Procedimiento> buscaHijosProcedimiento(Long idProcedimiento);

}
