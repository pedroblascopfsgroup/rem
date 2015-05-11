package es.pfsgroup.recovery.ext.impl.procedimiento.dao;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractDao;

public interface EXTProcedimientoDao extends AbstractDao<Procedimiento, Long>{

	List<? extends Procedimiento> buscaProcedimientoConContrato(
			Long idContrato, String[] estados);
	
	Procedimiento getPersonaProcedimiento(Long idPrc, Long idPersona);

}
