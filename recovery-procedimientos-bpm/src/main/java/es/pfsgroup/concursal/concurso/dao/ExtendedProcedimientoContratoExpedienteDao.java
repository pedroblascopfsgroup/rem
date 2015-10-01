package es.pfsgroup.concursal.concurso.dao;

import es.capgemini.pfs.asunto.model.ProcedimientoContratoExpediente;
import es.capgemini.pfs.dao.AbstractDao;

public interface ExtendedProcedimientoContratoExpedienteDao extends AbstractDao<ProcedimientoContratoExpediente, Long>{
	
	public ProcedimientoContratoExpediente buscar(Long idProcedimiento, Long idContratoExpediente);

}
