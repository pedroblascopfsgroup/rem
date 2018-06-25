package es.pfsgroup.framework.paradise.bulkUpload.model;

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
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "PRM_PROCESO_MASIVO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class MSVProcesoMasivo implements Auditable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7654671614284636108L;
	
	@Id
    @Column(name = "PRM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVProcesoMasivoGenerator")
    @SequenceGenerator(name = "MSVProcesoMasivoGenerator", sequenceName = "S_PRM_PROCESO_MASIVO")
    private Long id;

    @Column(name = "PRM_DESCRIPCION")
    private String descripcion;
    
    @ManyToOne
    @Fetch(FetchMode.JOIN)
    @JoinColumn(name = "DD_OPM_ID")
    private MSVDDOperacionMasiva tipoOperacion;
    
    @ManyToOne
    @Fetch(FetchMode.JOIN)
    @JoinColumn(name = "DD_EPF_ID")
    private MSVDDEstadoProceso estadoProceso;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Column(name = "PRM_PROCESO_TOKEN")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVProcesoMasivoGenerator")
    @SequenceGenerator(name = "MSVProcesoMasivoGenerator", sequenceName = "S_BPM_PROCESO_TOKEN")
    private Long token;
    
    @Column(name = "PRM_TOTAL_FILAS")
    private Long totalFilas;
    
    @Column(name = "PRM_TOTAL_FILAS_KO")
    private Long totalFilasKo;
    
    @Column(name = "PRM_TOTAL_FILAS_OK")
    private Long totalFilasOk;

    
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

	public MSVDDOperacionMasiva getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(MSVDDOperacionMasiva tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
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

	public Long getToken() {
		return token;
	}

	public void setToken(Long token) {
		this.token = token;
	}

	public Long getTotalFilas() {
		return totalFilas;
	}

	public void setTotalFilas(Long totalFilas) {
		this.totalFilas = totalFilas;
	}

	public Long getTotalFilasOk() {
		return totalFilasOk;
	}

	public void setTotalFilasOk(Long totalFilasOk) {
		this.totalFilasOk = totalFilasOk;
	}

	public Long getTotalFilasKo() {
		return totalFilasKo;
	}

	public void setTotalFilasKo(Long totalFilasKo) {
		this.totalFilasKo = totalFilasKo;
	}
	
}
