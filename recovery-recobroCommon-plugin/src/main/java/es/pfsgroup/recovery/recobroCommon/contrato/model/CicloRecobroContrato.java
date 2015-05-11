package es.pfsgroup.recovery.recobroCommon.contrato.model;

import java.io.Serializable;
import java.math.BigInteger;
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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.exceptuar.model.Exceptuacion;
import es.pfsgroup.recovery.recobroCommon.expediente.model.CicloRecobroExpediente;
import es.pfsgroup.recovery.recobroCommon.motivos.model.DDMotivoBaja;

/**
 * 
 * @author diana
 *
 */
@Entity
@Table(name = "CRC_CICLO_RECOBRO_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class CicloRecobroContrato  implements Serializable, Auditable{
	
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CRC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloRecobroContratoGenerator")
	@SequenceGenerator(name = "CicloRecobroContratoGenerator", sequenceName = "S_CRC_CICLO_RECOBRO_CNT")
	private Long id;
	
	@Column(name = "CRC_ID_ENVIO")
	private BigInteger idEnvio;
	
	@ManyToOne
    @JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@ManyToOne
    @JoinColumn(name = "CRE_ID")
	private CicloRecobroExpediente cicloRecobroExpediente;
	
	@ManyToOne
    @JoinColumn(name = "DD_MOB_ID")
	private DDMotivoBaja motivoBaja;
	
	@ManyToOne
	@JoinColumn(name="EXC_ID")
	private Exceptuacion exceptuacion;
	
	@Column(name = "CRC_FECHA_ALTA")
	private Date fechaAlta;

	@Column(name = "CRC_FECHA_BAJA")
	private Date fechaBaja;

	@Column(name = "CRC_POS_VIVA_NO_VENCIDA")
	private Float posVivaNoVencida;

	@Column(name = "CRC_POS_VIVA_VENCIDA")
	private Float posVivaVencida;

	@Column(name = "CRC_INT_ORDIN_DEVEN")
	private Float interesesOrdDeven;

	@Column(name = "CRC_INT_MORAT_DEVEN")
	private Float interesesMorDeven;

	@Column(name = "CRC_COMISIONES")
	private Float comisiones;

	@Column(name = "CRC_GASTOS")
	private Float gastos;

	@Column(name = "CRC_IMPUESTOS")
	private Float impuestos;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public BigInteger getIdEnvio() {
		return idEnvio;
	}

	public void setIdEnvio(BigInteger idEnvio) {
		this.idEnvio = idEnvio;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public CicloRecobroExpediente getCicloRecobroExpediente() {
		return cicloRecobroExpediente;
	}

	public void setCicloRecobroExpediente(
			CicloRecobroExpediente cicloRecobroExpediente) {
		this.cicloRecobroExpediente = cicloRecobroExpediente;
	}

	public DDMotivoBaja getMotivoBaja() {
		return motivoBaja;
	}

	public void setMotivoBaja(DDMotivoBaja motivoBaja) {
		this.motivoBaja = motivoBaja;
	}

	public Exceptuacion getExceptuacion() {
		return exceptuacion;
	}

	public void setExceptuacion(Exceptuacion exceptuacion) {
		this.exceptuacion = exceptuacion;
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
	

}
