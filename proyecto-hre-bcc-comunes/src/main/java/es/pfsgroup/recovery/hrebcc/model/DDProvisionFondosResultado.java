package es.pfsgroup.recovery.hrebcc.model;

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
@Table(name = "DD_PFR_PROV_FONDOS_RESULTADO", schema = "${entity.schema}")
public class DDProvisionFondosResultado implements Auditable, Dictionary{
    
	public static final String ACEPTAR = "APR";
	public static final String RECHAZAR = "REC";
	public static final String SUBSANAR = "SUB";
	
	/**
	 *  
	 */
	private static final long serialVersionUID = 6488409119873054777L;

	@Id
    @Column(name = "DD_PFR_ID")
    private Long id;

    @Column(name = "DD_PFR_CODIGO")
    private String codigo;

    @Column(name = "DD_PFR_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_PFR_DESCRIPCION_LARGA")
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
