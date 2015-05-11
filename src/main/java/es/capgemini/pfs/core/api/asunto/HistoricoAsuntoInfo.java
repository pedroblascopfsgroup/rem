package es.capgemini.pfs.core.api.asunto;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;

public interface HistoricoAsuntoInfo {
	
	String getTipoRegistro();
	
	String getSubtipoTarea();
	
	Long getIdTarea();
	
	Long getIdTraza();
	
	String getTipoTraza();
	
	String getTipoActuacion();
	
	HistoricoProcedimiento getTarea();
	
	Procedimiento getProcedimiento();
	
	String getGroup();
	
	Date getFechaVencReal();
	
	String getDestinatarioTarea();
	
	String getDescripcionTarea();
	
	void setProcedimiento(Procedimiento procedimiento);
	
	void setGroup(String group);
	
	String getFechasTarea();
	
}
