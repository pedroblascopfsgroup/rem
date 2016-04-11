package es.pfsgroup.procedimientos.acuerdos;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

public interface TramitesAcuerdosApi {
	
	public Boolean[] bpmGetValoresRamasDefinirDocumentacion(Procedimiento prc, TareaExterna tex);
	
}
