package es.pfsgroup.procedimientos.subastaElectronica;

import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public interface TramitesElectronicosApi {
	
	public Boolean[] bpmGetValoresRamasRevisarDocumentacion(Procedimiento prc, TareaExterna tex, List<EXTTareaExternaValor> listado);
	
}
