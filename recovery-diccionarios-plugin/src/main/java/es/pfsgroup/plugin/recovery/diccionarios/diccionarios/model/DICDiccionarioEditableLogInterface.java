package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model;

import java.io.Serializable;
import java.util.Date;

import es.capgemini.pfs.auditoria.Auditable;

public interface DICDiccionarioEditableLogInterface <D extends DICDiccionarioEditableInterface> extends Serializable, Auditable{

	public void setUsuario(String u);
	
	public void setDiccionario(D u);
	
	public void setFecha(Date u);
	
	public void setAccion(String u);
	
	public void setValorAnterior(String u);
	
	public void setValorNuevo(String u);
}
