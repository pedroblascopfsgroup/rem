package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "PCD_PROCESOS_CARGA_DOCS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class MSVProcesosCargaDocs implements Auditable, Serializable {

	private static final long serialVersionUID = 1991305075568850644L;
	
	@Id
    @Column(name = "PCD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVProcesosCargaDocsGenerator")
    @SequenceGenerator(name = "MSVProcesosCargaDocsGenerator", sequenceName = "S_PCD_PROCESOS_CARGA_DOCS")
    private Long id;

    @Column(name = "PCD_DESCRIPCION")
    private String descripcion;
      
    @ManyToOne
    @JoinColumn(name = "DD_EPF_ID")
    private MSVDDEstadoProceso estadoProceso;
    
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

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public MSVDDEstadoProceso getEstadoProceso() {
		return estadoProceso;
	}

	public void setEstadoProceso(MSVDDEstadoProceso estadoProceso) {
		this.estadoProceso = estadoProceso;
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
