package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.util.Date;

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
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBContratoBienInfo;

@Entity
@Table(name = "BIE_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBContratoBien implements  Serializable, Auditable, NMBContratoBienInfo{

	private static final long serialVersionUID = -4497097910086775262L;

	@Id
    @Column(name = "BIE_CNT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBContratoBienGenerator")
    @SequenceGenerator(name = "NMBContratoBienGenerator", sequenceName = "S_BIE_CNT")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private NMBBien bien;
	
	@ManyToOne
    @JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@ManyToOne
    @JoinColumn(name = "DD_TBC_ID")
	private NMBDDTipoBienContrato Tipo;
	
	@ManyToOne
    @JoinColumn(name = "DD_EBC_ID")
	private NMBDDEstadoBienContrato estado;	
	
	@Column(name = "BIE_CNT_IMPORTE_GARANTIZADO")
    private Float importeGarantizado;
	
	@Column(name = "BIE_CNT_IMPORTE_GARAN_APROV")
    private Float importeGarantizadoAprov;
	
	@Column(name = "BIE_CNT_FECHA_INICIO")
    private Date fechaInicio;
	
	@Column(name = "BIE_CNT_FECHA_CIERRE")
    private Date fechaCierre;
	
	@Transient
	@Column(name = "NUM_EXTRA1")
    private Float secuenciaGarantia;
	
	@Embedded
    private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public NMBDDTipoBienContrato getTipo() {
		return Tipo;
	}

	public void setTipo(NMBDDTipoBienContrato nmbddTipoBienContrato) {
		this.Tipo = nmbddTipoBienContrato;
	}

	public NMBDDEstadoBienContrato getEstado() {
		return estado;
	}

	public void setEstado(
			NMBDDEstadoBienContrato nmbddEstadoBienContrato) {
		this.estado = nmbddEstadoBienContrato;
	}

	public Float getImporteGarantizado() {
		return importeGarantizado;
	}

	public void setImporteGarantizado(Float importeGarantizado) {
		this.importeGarantizado = importeGarantizado;
	}
	
	public Float getImporteGarantizadoAprov() {
		return importeGarantizadoAprov;
	}

	public void setImporteGarantizadoAprov(Float importeGarantizadoAprov) {
		this.importeGarantizadoAprov = importeGarantizadoAprov;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the secuenciaGarantia
	 */
	public Float getSecuenciaGarantia() {
		return secuenciaGarantia;
	}

	/**
	 * @param secuenciaGarantia the secuenciaGarantia to set
	 */
	public void setSecuenciaGarantia(Float secuenciaGarantia) {
		this.secuenciaGarantia = secuenciaGarantia;
	}
}
