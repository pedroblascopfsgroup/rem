package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.expediente.model.Expediente;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Clase donde se guardan los cobros pagos de recobro
 * 
 * @author javier
 * 
 * @since 1.9.0
 *
 *        Esta clase se ha movido al plugin de recobro, originalmente estaba en
 *        el rec-batch con el nombre
 *        es.capgemini.pfs.batch.recobro.facturacion.model.RecobroCobrosPagos
 *
 */
@Entity
@Table(name = "CPR_COBROS_PAGOS_RECOBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
// @Where(clause=Auditoria.UNDELETED_RESTICTION)
public class RecobroCobroPreprocesado implements Serializable {
	/**
	 * SERIALUID
	 */
	private static final long serialVersionUID = -8777862184694126435L;

	@Id
	@Column(name = "CPR_ID")
	private Long recobroCobroPago;

	@OneToOne
	@JoinColumn(name = "CPA_ID")
	private EXTRecobroCobroPago cobroPago;

	@Column(name = "CPA_FECHA")
	private Date fecha;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private EXTContrato contrato;

	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;

	@OneToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;

	@OneToOne
	@JoinColumn(name = "RCF_SCA_ID", nullable = false)
	private RecobroSubCartera subCartera;
	
	@Column(name = "FECHA_POS_VENCIDA")
	private Date fechaPosicionVencida;
	
	@Column(name = "FECHA_INI_IRREGU")
	private Date fechaInicioEpisodioIrregular;

	public Long getRecobroCobroPago() {
		return recobroCobroPago;
	}

	public void setRecobroCobroPago(Long recobroCobroPago) {
		this.recobroCobroPago = recobroCobroPago;
	}

	public EXTRecobroCobroPago getCobroPago() {
		return cobroPago;
	}

	public void setCobroPago(EXTRecobroCobroPago cobroPago) {
		this.cobroPago = cobroPago;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public EXTContrato getContrato() {
		return contrato;
	}

	public void setContrato(EXTContrato contrato) {
		this.contrato = contrato;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public RecobroSubCartera getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(RecobroSubCartera subCartera) {
		this.subCartera = subCartera;
	}

	public Date getFechaPosicionVencida() {
		return fechaPosicionVencida;
	}

	public void setFechaPosicionVencida(Date fechaPosicionVencida) {
		this.fechaPosicionVencida = fechaPosicionVencida;
	}

	public Date getFechaInicioEpisodioIrregular() {
		return fechaInicioEpisodioIrregular;
	}

	public void setFechaInicioEpisodioIrregular(Date fechaInicioEpisodioIrregular) {
		this.fechaInicioEpisodioIrregular = fechaInicioEpisodioIrregular;
	}
}