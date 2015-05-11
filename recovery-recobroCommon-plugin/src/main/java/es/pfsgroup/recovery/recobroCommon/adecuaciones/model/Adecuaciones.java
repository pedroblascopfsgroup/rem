package es.pfsgroup.recovery.recobroCommon.adecuaciones.model;

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
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * 
 * @author dgg
 *
 */
@Entity
@Table(name = "ADC_ADECUACIONES_CNT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Adecuaciones implements Auditable, Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6705958025894545075L;

	@Id
	@Column(name = "ADC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AdecuacionesGenerator")
	@SequenceGenerator(name = "AdecuacionesGenerator", sequenceName = "S_ADC_ADECUACIONES_CNT")
	private Long id;

	@Column(name="ADC_FECHA_EXTRACCION" ) //DATE NOT NULL ENABLE, 
	private Date fechaExtraccion;

	@Column(name="ADC_FECHA_DATO" ) //DATE NOT NULL ENABLE, 
	private Date fechaDato;

	@Column(name="ADC_CODIGO_ENTIDAD" ) //NUMBER(4,0) NOT NULL ENABLE,
	private Integer codigoEntidad;

	@Column(name="ADC_CNT_CONTRATO") // VARCHAR2(50 CHAR) NOT NULL ENABLE,
	private String  cntContrato;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato; 

	@Column(name="ADC_FECHA_CARGA" ) //DATE NOT NULL ENABLE, 
	private Date fechaCarga;

	@Column(name="DD_CODIGO_RECOMENDACION") // VARCHAR2(3 CHAR) NOT NULL ENABLE, 
	private String  codigoRecomendacion;

	@Column(name="ADC_IMPORTE_FINANCIAR") // FLOAT(126),
	private Float importeFinanciar;

	@Column(name="ADC_GASTOS_INCLUIDOS") // FLOAT(126),
	private Float gastosIncluidos;

	@Column(name="ADC_TIPO") // VARCHAR2(5 CHAR), 
	private String  tipo;

	@Column(name="ADC_DIFERENCIAL") // VARCHAR2(5 CHAR), 
	private String  diferencial;

	@Column(name="ADC_PLAZO") // VARCHAR2(3 CHAR), 
	private String  plazo;

	@Column(name="ADC_CUOTA") // FLOAT(126),
	private Float cuota;

	@Column(name="ADC_CUOTA_TRAS_CARENCIA") // FLOAT(126), 
	private Float cuotaTrasCarencia;

	@Column(name="ADC_SISTEMA_AMORTIZACION") // VARCHAR2(250 CHAR), 
	private String  sistemaAmortizacion;

	@Column(name="ADC_RAZON_PROGRESION") // VARCHAR2(5 CHAR), 
	private String  razonProgresion;

	@Column(name="ADC_PERIODICIDAD_RECIBOS" ) //NUMBER(*,0),
	private Long periodicidadRecibos;

	@Column(name="ADC_PERIODICIDAD_TIPO" ) //NUMBER(*,0), 
	private Long periodicidadTipo;

	@Column(name="ADC_PROXIMA_REVISION" ) 
	private Date proximaRevision;

	@Column(name="ADC_REVISION_CUOTA") // VARCHAR2(5 CHAR), 
	private String  revisionCuota;

	@Column(name="ADC_LCHAR_EXTRA") // VARCHAR2(250 CHAR),
	private String  charExtra;

	@Column(name="ADC_CHAR_EXTRA1") // VARCHAR2(50 CHAR), 
	private String  charExtra1;

	@Column(name="ADC_CHAR_EXTRA2") // VARCHAR2(50 CHAR),
	private String  charExtra2;

	@Column(name="ADC_CHAR_EXTRA3") // VARCHAR2(50 CHAR),
	private String  charExtra3;

	@Column(name="ADC_CHAR_EXTRA4") // VARCHAR2(50 CHAR),
	private String  charExtra4;

	@Column(name="ADC_CHAR_EXTRA5") // VARCHAR2(50 CHAR),
	private String  charExtra5;

	@Column(name="ADC_FLAG_EXTRA1") // VARCHAR2(1 BYTE),
	private String  flagExtra1;

	@Column(name="ADC_FLAG_EXTRA2") // VARCHAR2(1 BYTE), 
	private String  flagExtra2;

	@Column(name="ADC_FLAG_EXTRA3") // VARCHAR2(1 BYTE),
	private String  flagExtra3;

	@Column(name="ADC_FLAG_EXTRA4") // VARCHAR2(1 BYTE),
	private String  flagExtra4;

	@Column(name="ADC_FLAG_EXTRA5") // VARCHAR2(1 BYTE),
	private String  flagExtra5;

	@Column(name="ADC_FLAG_EXTRA6") // VARCHAR2(1 BYTE),
	private String  flagExtra6;

	@Column(name="ADC_FLAG_EXTRA7") // VARCHAR2(1 BYTE),
	private String  flagExtra7;

	@Column(name="ADC_FLAG_EXTRA8") // VARCHAR2(1 BYTE),
	private String  flagExtra8;

	@Column(name="ADC_FLAG_EXTRA9") // VARCHAR2(1 BYTE),
	private String  flagExtra9;

	@Column(name="ADC_FLAG_EXTRA10") // VARCHAR2(1 BYTE),
	private String  flagExtra10;

	@Column(name="ADC_DATE_EXTRA1")
	private Date dateExtra1;

	@Column(name="ADC_DATE_EXTRA2") 
	private Date dateExtra2;

	@Column(name="ADC_DATE_EXTRA3") 
	private Date dateExtra3;

	@Column(name="ADC_DATE_EXTRA4") 
	private Date dateExtra4;

	@Column(name="ADC_DATE_EXTRA5") 
	private Date dateExtra5;

	@Column(name="ADC_DATE_EXTRA6") 
	private Date dateExtra6;

	@Column(name="ADC_DATE_EXTRA7") 
	private Date dateExtra7;

	@Column(name="ADC_DATE_EXTRA8") 
	private Date dateExtra8;

	@Column(name="ADC_DATE_EXTRA9") 
	private Date dateExtra9;

	@Column(name="ADC_DATE_EXTRA10")
	private Date dateExtra10;

	@Column(name="ADC_NUM_EXTRA1" ) //NUMBER(16,2),
	private Float numExtra1;

	@Column(name="ADC_NUM_EXTRA2" ) //NUMBER(16,2), 
	private Float numExtra2;

	@Column(name="ADC_NUM_EXTRA3" ) //NUMBER(16,2), 
	private Float numExtra3;

	@Column(name="ADC_NUM_EXTRA4" ) //NUMBER(16,2),
	private Float numExtra4;

	@Column(name="ADC_NUM_EXTRA5" ) //NUMBER(16,2),
	private Float numExtra5;

	@Column(name="ADC_NUM_EXTRA6" ) //NUMBER(16,2),
	private Float numExtra6;

	@Column(name="ADC_NUM_EXTRA7" ) //NUMBER(16,2),
	private Float numExtra7;

	@Column(name="ADC_NUM_EXTRA8" ) //NUMBER(16,2),
	private Float numExtra8;

	@Column(name="ADC_NUM_EXTRA9" ) //NUMBER(16,2),
	private Float numExtra9;

	@Column(name="ADC_NUM_EXTRA10" ) //NUMBER(16,2),
	private Float numExtra10;

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

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public Integer getCodigoEntidad() {
		return codigoEntidad;
	}

	public void setCodigoEntidad(Integer codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	public String getCntContrato() {
		return cntContrato;
	}

	public void setCntContrato(String cntContrato) {
		this.cntContrato = cntContrato;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getcodigoRecomendacion() {
		return codigoRecomendacion;
	}

	public void setcodigoRecomendacion(String codigoRecomendacion) {
		this.codigoRecomendacion = codigoRecomendacion;
	}

	public Float getImporteFinanciar() {
		return importeFinanciar;
	}

	public void setImporteFinanciar(Float importeFinanciar) {
		this.importeFinanciar = importeFinanciar;
	}

	public Float getGastosIncluidos() {
		return gastosIncluidos;
	}

	public void setGastosIncluidos(Float gastosIncluidos) {
		this.gastosIncluidos = gastosIncluidos;
	}

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getDiferencial() {
		return diferencial;
	}

	public void setDiferencial(String diferencial) {
		this.diferencial = diferencial;
	}

	public String getPlazo() {
		return plazo;
	}

	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}

	public Float getCuota() {
		return cuota;
	}

	public void setCuota(Float cuota) {
		this.cuota = cuota;
	}

	public Float getCuotaTrasCarencia() {
		return cuotaTrasCarencia;
	}

	public void setCuotaTrasCarencia(Float cuotaTrasCarencia) {
		this.cuotaTrasCarencia = cuotaTrasCarencia;
	}

	public String getSistemaAmortizacion() {
		return sistemaAmortizacion;
	}

	public void setSistemaAmortizacion(String sistemaAmortizacion) {
		this.sistemaAmortizacion = sistemaAmortizacion;
	}

	public String getRazonProgresion() {
		return razonProgresion;
	}

	public void setRazonProgresion(String razonProgresion) {
		this.razonProgresion = razonProgresion;
	}

	public Long getPeriodicidadRecibos() {
		return periodicidadRecibos;
	}

	public void setPeriodicidadRecibos(Long periodicidadRecibos) {
		this.periodicidadRecibos = periodicidadRecibos;
	}

	public Long getPeriodicidadTipo() {
		return periodicidadTipo;
	}

	public void setPeriodicidadTipo(Long periodicidadTipo) {
		this.periodicidadTipo = periodicidadTipo;
	}

	public Date getProximaRevision() {
		return proximaRevision;
	}

	public void setProximaRevision(Date proximaRevision) {
		this.proximaRevision = proximaRevision;
	}

	public String getRevisionCuota() {
		return revisionCuota;
	}

	public void setRevisionCuota(String revisionCuota) {
		this.revisionCuota = revisionCuota;
	}

	public String getCharExtra() {
		return charExtra;
	}

	public void setCharExtra(String charExtra) {
		this.charExtra = charExtra;
	}

	public String getCharExtra1() {
		return charExtra1;
	}

	public void setCharExtra1(String charExtra1) {
		this.charExtra1 = charExtra1;
	}

	public String getCharExtra2() {
		return charExtra2;
	}

	public void setCharExtra2(String charExtra2) {
		this.charExtra2 = charExtra2;
	}

	public String getCharExtra3() {
		return charExtra3;
	}

	public void setCharExtra3(String charExtra3) {
		this.charExtra3 = charExtra3;
	}

	public String getCharExtra4() {
		return charExtra4;
	}

	public void setCharExtra4(String charExtra4) {
		this.charExtra4 = charExtra4;
	}

	public String getCharExtra5() {
		return charExtra5;
	}

	public void setCharExtra5(String charExtra5) {
		this.charExtra5 = charExtra5;
	}

	public String getFlagExtra1() {
		return flagExtra1;
	}

	public void setFlagExtra1(String flagExtra1) {
		this.flagExtra1 = flagExtra1;
	}

	public String getFlagExtra2() {
		return flagExtra2;
	}

	public void setFlagExtra2(String flagExtra2) {
		this.flagExtra2 = flagExtra2;
	}

	public String getFlagExtra3() {
		return flagExtra3;
	}

	public void setFlagExtra3(String flagExtra3) {
		this.flagExtra3 = flagExtra3;
	}

	public String getFlagExtra4() {
		return flagExtra4;
	}

	public void setFlagExtra4(String flagExtra4) {
		this.flagExtra4 = flagExtra4;
	}

	public String getFlagExtra5() {
		return flagExtra5;
	}

	public void setFlagExtra5(String flagExtra5) {
		this.flagExtra5 = flagExtra5;
	}

	public String getFlagExtra6() {
		return flagExtra6;
	}

	public void setFlagExtra6(String flagExtra6) {
		this.flagExtra6 = flagExtra6;
	}

	public String getFlagExtra7() {
		return flagExtra7;
	}

	public void setFlagExtra7(String flagExtra7) {
		this.flagExtra7 = flagExtra7;
	}

	public String getFlagExtra8() {
		return flagExtra8;
	}

	public void setFlagExtra8(String flagExtra8) {
		this.flagExtra8 = flagExtra8;
	}

	public String getFlagExtra9() {
		return flagExtra9;
	}

	public void setFlagExtra9(String flagExtra9) {
		this.flagExtra9 = flagExtra9;
	}

	public String getFlagExtra10() {
		return flagExtra10;
	}

	public void setFlagExtra10(String flagExtra10) {
		this.flagExtra10 = flagExtra10;
	}

	public Date getDateExtra1() {
		return dateExtra1;
	}

	public void setDateExtra1(Date dateExtra1) {
		this.dateExtra1 = dateExtra1;
	}

	public Date getDateExtra2() {
		return dateExtra2;
	}

	public void setDateExtra2(Date dateExtra2) {
		this.dateExtra2 = dateExtra2;
	}

	public Date getDateExtra3() {
		return dateExtra3;
	}

	public void setDateExtra3(Date dateExtra3) {
		this.dateExtra3 = dateExtra3;
	}

	public Date getDateExtra4() {
		return dateExtra4;
	}

	public void setDateExtra4(Date dateExtra4) {
		this.dateExtra4 = dateExtra4;
	}

	public Date getDateExtra5() {
		return dateExtra5;
	}

	public void setDateExtra5(Date dateExtra5) {
		this.dateExtra5 = dateExtra5;
	}

	public Date getDateExtra6() {
		return dateExtra6;
	}

	public void setDateExtra6(Date dateExtra6) {
		this.dateExtra6 = dateExtra6;
	}

	public Date getDateExtra7() {
		return dateExtra7;
	}

	public void setDateExtra7(Date dateExtra7) {
		this.dateExtra7 = dateExtra7;
	}

	public Date getDateExtra8() {
		return dateExtra8;
	}

	public void setDateExtra8(Date dateExtra8) {
		this.dateExtra8 = dateExtra8;
	}

	public Date getDateExtra9() {
		return dateExtra9;
	}

	public void setDateExtra9(Date dateExtra9) {
		this.dateExtra9 = dateExtra9;
	}

	public Date getDateExtra10() {
		return dateExtra10;
	}

	public void setDateExtra10(Date dateExtra10) {
		this.dateExtra10 = dateExtra10;
	}

	public Float getNumExtra1() {
		return numExtra1;
	}

	public void setNumExtra1(Float numExtra1) {
		this.numExtra1 = numExtra1;
	}

	public Float getNumExtra2() {
		return numExtra2;
	}

	public void setNumExtra2(Float numExtra2) {
		this.numExtra2 = numExtra2;
	}

	public Float getNumExtra3() {
		return numExtra3;
	}

	public void setNumExtra3(Float numExtra3) {
		this.numExtra3 = numExtra3;
	}

	public Float getNumExtra4() {
		return numExtra4;
	}

	public void setNumExtra4(Float numExtra4) {
		this.numExtra4 = numExtra4;
	}

	public Float getNumExtra5() {
		return numExtra5;
	}

	public void setNumExtra5(Float numExtra5) {
		this.numExtra5 = numExtra5;
	}

	public Float getNumExtra6() {
		return numExtra6;
	}

	public void setNumExtra6(Float numExtra6) {
		this.numExtra6 = numExtra6;
	}

	public Float getNumExtra7() {
		return numExtra7;
	}

	public void setNumExtra7(Float numExtra7) {
		this.numExtra7 = numExtra7;
	}

	public Float getNumExtra8() {
		return numExtra8;
	}

	public void setNumExtra8(Float numExtra8) {
		this.numExtra8 = numExtra8;
	}

	public Float getNumExtra9() {
		return numExtra9;
	}

	public void setNumExtra9(Float numExtra9) {
		this.numExtra9 = numExtra9;
	}

	public Float getNumExtra10() {
		return numExtra10;
	}

	public void setNumExtra10(Float numExtra10) {
		this.numExtra10 = numExtra10;
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
