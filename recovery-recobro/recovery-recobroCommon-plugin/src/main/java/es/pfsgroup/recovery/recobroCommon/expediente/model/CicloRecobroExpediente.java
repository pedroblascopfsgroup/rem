package es.pfsgroup.recovery.recobroCommon.expediente.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.contrato.model.CicloRecobroContrato;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoGestionCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.motivos.model.DDMotivoBaja;
import es.pfsgroup.recovery.recobroCommon.persona.model.CicloRecobroPersona;

@Entity
@Table(name = "CRE_CICLO_RECOBRO_EXP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CicloRecobroExpediente implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloGenerator")
	@SequenceGenerator(name = "CicloGenerator", sequenceName = "S_CRE_CICLO_RECOBRO_EXP")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;

	@Column(name = "CRE_FECHA_ALTA")
	private Date fechaAlta;

	@Column(name = "CRE_FECHA_BAJA")
	private Date fechaBaja;

	@Column(name = "CRE_POS_VIVA_NO_VENCIDA")
	private Float posVivaNoVencida;

	@Column(name = "CRE_POS_VIVA_VENCIDA")
	private Float posVivaVencida;

	@Column(name = "CRE_INT_ORDIN_DEVEN")
	private Float interesesOrdDeven;

	@Column(name = "CRE_INT_MORAT_DEVEN")
	private Float interesesMorDeven;

	@Column(name = "CRE_COMISIONES")
	private Float comisiones;

	@Column(name = "CRE_GASTOS")
	private Float gastos;

	@Column(name = "CRE_IMPUESTOS")
	private Float impuestos;

	@Column(name = "CRE_MARCADO_BPM")
	private Boolean marcadoBpm;

	@Column(name = "CRE_MARCADO_BPM_FECHA")
	private Date marcadoBpmFecha;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "RCF_ESQ_ID")
	private RecobroEsquema esquema;

	@ManyToOne
	@JoinColumn(name = "RCF_ESC_ID")
	private RecobroCarteraEsquema carteraEsquema;

	@ManyToOne
	@JoinColumn(name = "RCF_SCA_ID")
	private RecobroSubCartera subcartera;

	@ManyToOne
	@JoinColumn(name = "RCF_SUA_ID")
	private RecobroSubcarteraAgencia subCarteraAgencia;

	@ManyToOne
	@JoinColumn(name = "RCF_MFA_ID")
	private RecobroModeloFacturacion modeloFacturacion;

	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID")
	private RecobroAgencia agencia;

	@OneToMany(cascade = CascadeType.ALL,fetch=FetchType.LAZY)
	@JoinColumn(name = "CRE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<CicloRecobroContrato> ciclosRecobroContrato;

	@OneToMany(cascade = CascadeType.ALL,fetch=FetchType.LAZY)
	@JoinColumn(name = "CRE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<CicloRecobroPersona> ciclosRecobroPersona;

	@ManyToOne
	@JoinColumn(name = "DD_MOB_ID")
	private DDMotivoBaja motivoBaja;

	@Column(name = "CRE_PROCESS_BPM")
	private Long processBPM;

	 @ManyToOne
	 @JoinColumn(name = "DD_TGC_ID", nullable = true)
	 private RecobroDDTipoGestionCartera tipoGestionCartera;

	@OneToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "CRE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<CicloRecobroExpedienteTareaNotificacion> ciclosRecobroExpedienteTareaNotificaciones;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	
	public String getDescripcion(){
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		StringBuilder desc = new StringBuilder();
		if (this.agencia != null && this.agencia.getNombre() != null){
			desc.append(this.agencia.getNombre());
		}else{
			desc.append("--");
		}
		if (this.fechaAlta != null){
			desc.append(" - Del ");
			desc.append(df.format(this.fechaAlta));
		}
		if (this.fechaBaja != null){
			desc.append(" al ");
			desc.append(df.format(this.fechaBaja));
		}

		return desc.toString();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public Float getPosVivaNoVencida() {
		return posVivaNoVencida;
	}

	public void setPosVivaNoVencida(Float posVivaNoVencida) {
		this.posVivaNoVencida = posVivaNoVencida;
	}

	public Float getPosVivaVencida() {
		return posVivaVencida;
	}

	public void setPosVivaVencida(Float posVivaVencida) {
		this.posVivaVencida = posVivaVencida;
	}

	public Float getInteresesOrdDeven() {
		return interesesOrdDeven;
	}

	public void setInteresesOrdDeven(Float interesesOrdDeven) {
		this.interesesOrdDeven = interesesOrdDeven;
	}

	public Float getInteresesMorDeven() {
		return interesesMorDeven;
	}

	public void setInteresesMorDeven(Float interesesMorDeven) {
		this.interesesMorDeven = interesesMorDeven;
	}

	public Float getComisiones() {
		return comisiones;
	}

	public void setComisiones(Float comisiones) {
		this.comisiones = comisiones;
	}

	public Float getGastos() {
		return gastos;
	}

	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}

	public Float getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}

	public Boolean getMarcadoBpm() {
		return marcadoBpm;
	}

	public void setMarcadoBpm(Boolean marcadoBpm) {
		this.marcadoBpm = marcadoBpm;
	}

	public Date getMarcadoBpmFecha() {
		return marcadoBpmFecha;
	}

	public void setMarcadoBpmFecha(Date marcadoBpmFecha) {
		this.marcadoBpmFecha = marcadoBpmFecha;
	}

	/**
	 * Retorna el atributo auditoria.
	 * 
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * Setea el atributo auditoria.
	 * 
	 * @param auditoria
	 *            Auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * Retorna el atributo version.
	 * 
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * Setea el atributo version.
	 * 
	 * @param version
	 *            Integer
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	public RecobroEsquema getEsquema() {
		return esquema;
	}

	public void setEsquema(RecobroEsquema esquema) {
		this.esquema = esquema;
	}

	public RecobroCarteraEsquema getCarteraEsquema() {
		return carteraEsquema;
	}

	public void setCarteraEsquema(RecobroCarteraEsquema carteraEsquema) {
		this.carteraEsquema = carteraEsquema;
	}

	public RecobroSubCartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(RecobroSubCartera subcartera) {
		this.subcartera = subcartera;
	}

	public RecobroSubcarteraAgencia getSubCarteraAgencia() {
		return subCarteraAgencia;
	}

	public void setSubCarteraAgencia(RecobroSubcarteraAgencia subCarteraAgencia) {
		this.subCarteraAgencia = subCarteraAgencia;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public List<CicloRecobroContrato> getCiclosRecobroContrato() {
		return ciclosRecobroContrato;
	}

	public void setCiclosRecobroContrato(List<CicloRecobroContrato> ciclosRecobroContrato) {
		this.ciclosRecobroContrato = ciclosRecobroContrato;
	}

	public List<CicloRecobroPersona> getCiclosRecobroPersona() {
		return ciclosRecobroPersona;
	}

	public void setCiclosRecobroPersona(List<CicloRecobroPersona> ciclosRecobroPersona) {
		this.ciclosRecobroPersona = ciclosRecobroPersona;
	}

	public DDMotivoBaja getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(DDMotivoBaja motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public Long getProcessBPM() {
		return processBPM;
	}

	public void setProcessBPM(Long processBPM) {
		this.processBPM = processBPM;
	}

	public RecobroModeloFacturacion getModeloFacturacion() {
		return modeloFacturacion;
	}

	public void setModeloFacturacion(RecobroModeloFacturacion modeloFacturacion) {
		this.modeloFacturacion = modeloFacturacion;
	}

	public List<CicloRecobroExpedienteTareaNotificacion> getCiclosRecobroExpedienteTareaNotificaciones() {
		return ciclosRecobroExpedienteTareaNotificaciones;
	}

	public void setCiclosRecobroExpedienteTareaNotificaciones(List<CicloRecobroExpedienteTareaNotificacion> ciclosRecobroExpedienteTareaNotificaciones) {
		this.ciclosRecobroExpedienteTareaNotificaciones = ciclosRecobroExpedienteTareaNotificaciones;
	}
	public RecobroDDTipoGestionCartera getTipoGestionCartera() {
		return tipoGestionCartera;
	}

	public void setTipoGestionCartera(
			RecobroDDTipoGestionCartera tipoGestionCartera) {
		this.tipoGestionCartera = tipoGestionCartera;
	}

}
