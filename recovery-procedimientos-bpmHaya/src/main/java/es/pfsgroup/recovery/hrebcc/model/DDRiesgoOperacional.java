package es.pfsgroup.recovery.hrebcc.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name="DD_RIO_RIESGO_OPERACIONAL", schema = "${entity.schema}")
public class DDRiesgoOperacional implements Auditable, Dictionary {

	/**
	 * 
	 */
	private static final long serialVersionUID = 900518608719237907L;

	@Id
	@Column(name="DD_RIO_ID")
	private Long id;
	
	@Column(name="DD_RIO_CODIGO")
	private String codigo;
	
	@Column(name="DD_RIO_DESCRIPCION")
	private String descripcion;
	
	@Column(name="DD_RIO_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Embedded
	private Auditoria auditoria;

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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
