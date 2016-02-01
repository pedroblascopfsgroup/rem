package es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model;

import java.io.Serializable;

import es.capgemini.pfs.auditoria.Auditable;

public interface DICDiccionarioEditableInterface extends Serializable, Auditable {

	public String getNombreTabla();
}
