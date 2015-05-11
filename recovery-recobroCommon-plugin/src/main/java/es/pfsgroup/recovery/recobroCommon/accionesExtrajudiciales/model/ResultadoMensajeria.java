package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * 
 * @author diana
 *
 */
@Entity
@Table(name = "RES_ACE_RESULTADOS_MENSAJERIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class ResultadoMensajeria implements Auditable, Serializable{
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = 6705958025894545075L;

	@Id
	 @Column(name = "RES_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "ResultadoMensajeriaGenerator")
	 @SequenceGenerator(name = "ResultadoMensajeriaGenerator", sequenceName = "S_RES_ACE_RESULTADOS_MENSAJERIA")
	 private Long id;
	 
	 @ManyToOne
	 @JoinColumn(name = "ACE_ID")
	 private RecobroAccionesExtrajudiciales accionRecobro;
	 
	 @ManyToOne
	 @JoinColumn(name = "RCF_AGE_ID")
	 private RecobroAgencia agencia;
	 
	 
	 @ManyToOne
	 @JoinColumn(name = "DD_RGM_ID")
	 private DDResultadoGestionMensajeria resultadoGestionMensajeria;
	 
	 @Column(name="RES_EXTRAFECHA1")
	 private Date fechaExtra1;
	 
	 @Column(name="RES_EXTRAFECHA2")
	 private Date fechaExtra2;
	 
	 @Column(name="RES_EXTRANUMERO1")
	 private Float numeroExtra1;
	 
	 @Column(name="RES_EXTRANUMERO2")
	 private Float numeroExtra2;
	 
	 @Column(name="RES_EXTRATEXTO1")
	 private String textoExtra1;
	 
	 @Column(name="RES_EXTRATEXTO2")
	 private String textoExtra2;
	 
	 @Column(name="RES_FECHA_EXTRACCION")
	 private Date fechaExtraccion;
	 
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

	public RecobroAccionesExtrajudiciales getAccionRecobro() {
		return accionRecobro;
	}

	public void setAccionRecobro(RecobroAccionesExtrajudiciales accionRecobro) {
		this.accionRecobro = accionRecobro;
	}

	public DDResultadoGestionMensajeria getResultadoGestionMensajeria() {
		return resultadoGestionMensajeria;
	}

	public void setResultadoGestionMensajeria(
			DDResultadoGestionMensajeria resultadoGestionMensajeria) {
		this.resultadoGestionMensajeria = resultadoGestionMensajeria;
	}

	public Date getFechaExtra1() {
		return fechaExtra1;
	}

	public void setFechaExtra1(Date fechaExtra1) {
		this.fechaExtra1 = fechaExtra1;
	}

	public Date getFechaExtra2() {
		return fechaExtra2;
	}

	public void setFechaExtra2(Date fechaExtra2) {
		this.fechaExtra2 = fechaExtra2;
	}

	public Float getNumeroExtra1() {
		return numeroExtra1;
	}

	public void setNumeroExtra1(Float numeroExtra1) {
		this.numeroExtra1 = numeroExtra1;
	}

	public Float getNumeroExtra2() {
		return numeroExtra2;
	}

	public void setNumeroExtra2(Float numeroExtra2) {
		this.numeroExtra2 = numeroExtra2;
	}

	public String getTextoExtra1() {
		return textoExtra1;
	}

	public void setTextoExtra1(String textoExtra1) {
		this.textoExtra1 = textoExtra1;
	}

	public String getTextoExtra2() {
		return textoExtra2;
	}

	public void setTextoExtra2(String textoExtra2) {
		this.textoExtra2 = textoExtra2;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
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

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}
	 
	 

}
