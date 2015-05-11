package es.pfsgroup.procedimientos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_MOS_MOTIVO_SUSPENSION", schema = "${master.schema}")
public class DDMotivoSuspension implements Auditable, Dictionary{

    public static final String INSTRUCCIONES = "1";
    public static final String FALTA = "2";
    public static final String OTROS = "3";
    
	@Id
    @Column(name = "DD_MOS_ID")
    private Long id;

    @Column(name = "DD_MOS_CODIGO")
    private String codigo;

    @Column(name = "DD_MOS_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_MOS_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
}
