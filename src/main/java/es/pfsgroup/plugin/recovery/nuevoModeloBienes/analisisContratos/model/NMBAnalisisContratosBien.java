package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

@Entity
@Table(name = "BIE_ANC_ANALISIS_CONTRATOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBAnalisisContratosBien implements Serializable, Auditable{


	/**
	 * 
	 */
	private static final long serialVersionUID = -754595098172565299L;

	@Id
    @Column(name = "BIE_ANC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBAnalisisContratosBienGenerator")
    @SequenceGenerator(name = "NMBAnalisisContratosBienGenerator", sequenceName = "S_BIE_ANC_ANALISIS_CONTRATOS")
    private Long id;
	 
	@OneToOne
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "BIE_ID")
	private NMBBien bien;

	@OneToOne
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "ANC_ID")
	private AnalisisContratos analisisContrato;
	
	@Column(name = "BIE_ANC_SOLICITAR_NO_AFE")
	private Boolean solicitarNoAfeccion;
	
	@Column(name = "BIE_ANC_F_SOLICITAR_NO_AFE")
	private Date fechaSolicitarNoAfeccion;
	
	@Column(name = "BIE_ANC_RESOLUCION")
	private Boolean resolucion;
	
	@Column(name = "BIE_ANC_F_RESOLUCION") 
	private Date fechaResolucion;
	

	@Embedded
	private Auditoria auditoria;


	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

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

	public AnalisisContratos getAnalisisContrato() {
		return analisisContrato;
	}

	public void setAnalisisContrato(AnalisisContratos analisisContrato) {
		this.analisisContrato = analisisContrato;
	}

	public Boolean getSolicitarNoAfeccion() {
		return solicitarNoAfeccion;
	}

	public void setSolicitarNoAfeccion(Boolean solicitarNoAfeccion) {
		this.solicitarNoAfeccion = solicitarNoAfeccion;
	}

	public Date getFechaSolicitarNoAfeccion() {
		return fechaSolicitarNoAfeccion;
	}

	public void setFechaSolicitarNoAfeccion(Date fechaSolicitarNoAfeccion) {
		this.fechaSolicitarNoAfeccion = fechaSolicitarNoAfeccion;
	}
	
	public Boolean getResolucion() {
		return resolucion;
	}

	public void setResolucion(Boolean resolucion) {
		this.resolucion = resolucion;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

}
