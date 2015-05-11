package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "DD_TFO_TIPO_FONDO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDTipoFondo implements  Serializable, Auditable {

	private static final long serialVersionUID = -4497097910086775262L;

	@Id
    @Column(name = "DD_TFO_ID")
    private Long id;

    @Column(name = "DD_TFO_CODIGO")
    private String codigo;   
    
    @Column(name = "DD_TFO_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_TFO_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_TFO_CODIGO_NAL")
    private String codigoNAL;
    
    @Column(name = "DD_TFO_CES_REM")
    private Boolean cesionRemate;
    
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

	public String getCodigoNAL() {
		return codigoNAL;
	}

	public void setCodigoNAL(String codigoNAL) {
		this.codigoNAL = codigoNAL;
	}

	public Boolean getCesionRemate() {
		return cesionRemate;
	}

	public void setCesionRemate(Boolean cesionRemate) {
		this.cesionRemate = cesionRemate;
	}
	
}
