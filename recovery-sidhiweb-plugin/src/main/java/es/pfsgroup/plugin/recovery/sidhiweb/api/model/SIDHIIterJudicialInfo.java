package es.pfsgroup.plugin.recovery.sidhiweb.api.model;

import java.io.Serializable;
import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.users.domain.Usuario;

public interface SIDHIIterJudicialInfo extends Serializable{
	
	List<? extends SIDHIAccionJudicialInfo> getAccionesJudiciales();

	Procedimiento getProcedimiento();
	
	String getIdExpedienteExterno();
	
	Usuario getProcurador();
	
	String getUsernameProcurador();
	
	String getPlaza();
	
	String getJuzgado();
	
	TipoJuzgado getTipoJuzgado();
	
	String getNumeroAutos();

}
