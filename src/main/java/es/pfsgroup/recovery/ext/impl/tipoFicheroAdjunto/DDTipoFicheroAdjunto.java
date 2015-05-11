package es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


@Entity
@Table(name = "DD_TFA_FICHERO_ADJUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoFicheroAdjunto implements Dictionary, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4204095123956231985L;

	@Id
    @Column(name = "DD_TFA_ID")
    private Long id;

    @Column(name = "DD_TFA_CODIGO")
    private String codigo;

    @Column(name = "DD_TFA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TFA_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToOne
	@JoinColumn(name = "DD_TAC_ID", nullable = true)
	private DDTipoActuacion tipoActuacion;

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

	public void setTipoActuacion(DDTipoActuacion tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public DDTipoActuacion getTipoActuacion() {
		return tipoActuacion;
	}

}
