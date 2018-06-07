package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;



/**
 * Modelo que gestiona el plan dinamico de ventas de un activo
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_ADN_ADJNOJUDICIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAdjudicacionNoJudicial implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ADN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ACTAdjudicacionNoJudicialGenerator")
    @SequenceGenerator(name = "ACTAdjudicacionNoJudicialGenerator", sequenceName = "S_ACT_ADN_ADJNOJUDICIAL")
    private Long id;
    
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEJ_ID")
    private DDEntidadEjecutante entidadEjecutante;
	
	@Column(name = "ADN_FECHA_TITULO")
	private Date fechaTitulo;
	
	@Column(name = "ADN_FECHA_FIRMA_TITULO")
	private Date fechaFirmaTitulo;
	
	@Column(name = "ADN_VALOR_ADQUISICION")
	private Double valorAdquisicion;
	
	@Column(name = "ADN_TRAMITADOR_TITULO")
	private String tramitadorTitulo;

	@Column(name = "ADN_NUM_REFERENCIA")
	private String numReferencia;

	@Column(name = "ADN_EXP_DEF_TESTI")
	private String defectosTestimonio;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDEntidadEjecutante getEntidadEjecutante() {
		return entidadEjecutante;
	}

	public void setEntidadEjecutante(DDEntidadEjecutante entidadEjecutante) {
		this.entidadEjecutante = entidadEjecutante;
	}

	public Date getFechaTitulo() {
		return fechaTitulo;
	}

	public void setFechaTitulo(Date fechaTitulo) {
		this.fechaTitulo = fechaTitulo;
	}

	public Date getFechaFirmaTitulo() {
		return fechaFirmaTitulo;
	}

	public void setFechaFirmaTitulo(Date fechaFirmaTitulo) {
		this.fechaFirmaTitulo = fechaFirmaTitulo;
	}

	public Double getValorAdquisicion() {
		return valorAdquisicion;
	}

	public void setValorAdquisicion(Double valorAdquisicion) {
		this.valorAdquisicion = valorAdquisicion;
	}

	public String getTramitadorTitulo() {
		return tramitadorTitulo;
	}

	public void setTramitadorTitulo(String tramitadorTitulo) {
		this.tramitadorTitulo = tramitadorTitulo;
	}

	public String getNumReferencia() {
		return numReferencia;
	}

	public void setNumReferencia(String numReferencia) {
		this.numReferencia = numReferencia;
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

	public String getDefectosTestimonio() {
		return defectosTestimonio;
	}

	public void setDefectosTestimonio(String defectosTestimonio) {
		this.defectosTestimonio = defectosTestimonio;
	}

}
