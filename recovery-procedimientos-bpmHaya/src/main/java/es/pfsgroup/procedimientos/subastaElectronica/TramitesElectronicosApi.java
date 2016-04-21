package es.pfsgroup.procedimientos.subastaElectronica;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramitesElectronicosApi {
	
	public Boolean[] bpmGetValoresRamasRevisarDocumentacion(Procedimiento prc, TareaExterna tex);
	
}
