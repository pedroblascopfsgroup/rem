package es.pfsgroup.recovery.integration.bpm;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class UsuarioPayload {
	
	private final static String KEY = "@usu";

	private static final String CAMPO_NOMBRE_USUARIO = String.format("%s.nombre", KEY);

	private final DataContainerPayload data;

	public UsuarioPayload(String tipo, Auditable auditable) {
		this(new DataContainerPayload(null, null), auditable);
	}
	
	public UsuarioPayload(DataContainerPayload data, Auditable auditable) {
		this.data = data;
		build(auditable);
	}
	
	public UsuarioPayload(DataContainerPayload data) {
		this.data = data;
	}

	public String getNombre() {
		return data.getCodigo(CAMPO_NOMBRE_USUARIO);
	}
	
	private void setNombre(String nombre) {
		data.addCodigo(CAMPO_NOMBRE_USUARIO, nombre);
	}
	
	public void build(Auditable auditable) {
		Auditoria auditoria = auditable.getAuditoria();
		if (auditoria!=null) {
			setNombre("HY-" + auditoria.getUsuarioCrear());
		}
	}
	
}
