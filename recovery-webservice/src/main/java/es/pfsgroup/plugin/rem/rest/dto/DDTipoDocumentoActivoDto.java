package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

public class DDTipoDocumentoActivoDto implements Serializable{

	private static final long serialVersionUID = -2851105087335144514L;

	private Long id;
	private String codigo;
	private String descripcion;
	private String descripcionLarga;
	private String matricula;
	private Long version;
	private Auditoria auditoria;
	private List<String> tipoTrabajoCodigos = new ArrayList<String>();

	public DDTipoDocumentoActivoDto(DDTipoDocumentoActivo entity) {
		
		this.id = entity.getId();
		this.codigo = entity.getCodigo();
		this.descripcion = entity.getDescripcion();
		this.descripcionLarga = entity.getDescripcionLarga();
		this.matricula = entity.getMatricula();
		this.version = entity.getVersion();
		this.auditoria = entity.getAuditoria();

		for (DDTipoTrabajo ddTipoTrabajo : entity.getTiposTrabajo()) {
			tipoTrabajoCodigos.add(ddTipoTrabajo.getCodigo());
		}
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public List<String> getTipoTrabajoCodigos() {
		List<String> copy = new ArrayList<String>();
		copy.addAll(tipoTrabajoCodigos);
		return copy;
	}

	public void setTipoTrabajoCodigos(List<String> tipoTrabajoCodigos) {
		List<String> copy = new ArrayList<String>();
		copy.addAll(tipoTrabajoCodigos);
		this.tipoTrabajoCodigos = copy;
	}
}
