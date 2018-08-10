package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "GPL_GASTOS_PRINEX_LBK", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GastoPrinex implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5657034208602725667L;

	@Id
    @Column(name = "GPL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoPrinexGenerator")
	@SequenceGenerator(name = "GastoPrinexGenerator", sequenceName = "S_GPL_GASTOS_PRINEX_LBK")
    private Long id;
	
	@Column(name = "GPV_ID")
	private Long idGasto;
	
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "GPL_PROYECTO")
	private Long promocion;
	
	@Column(name = "GPL_TIPO_INMUEBLE")
	private String tipoInmueble;
	
	@Column(name = "GPL_CLAVE_1")
	private String clave1;
	
	@Column(name = "GPL_CLAVE_2")
	private String clave2;
	
	@Column(name = "GPL_CLAVE_3")
	private String clave3;
	
	@Column(name = "GPL_CLAVE_4")
	private String clave4;
	
	@Column(name = "GPL_IMPORTE_GASTO")
	private Double importeGasto;
	
	@Column(name = "GPL_FECHA_CONTABLE")
    private Date fechaContable;
	
	@Column(name = "GPL_DIARIO_CONTB")
	private String diarioContable;
	
	@Column(name = "GPL_D347")
	private String d347;
	
	@Column(name = "GPL_DELEGACION")
	private String delegacion;
	
	@Column(name = "GPL_BASE_RETENCION")
    private Double retencionBase;
	
	@Column(name = "GPL_PROCENTAJE_RETEN")
    private Double porcentajeRetencion;
	
	@Column(name = "GPL_IMPORTE_RENTE")
    private Double importeRetencion;
	
	@Column(name = "GPL_APLICAR_RETENCION")
	private String aplicarRetencion;
	
	@Column(name = "GPL_BASE_IRPF")
    private Double baseIrpf;
	
	@Column(name = "GPL_PROCENTAJE_IRPF")
    private Double porcentajeIrpf;
	
	@Column(name = "GPL_IMPORTE_IRPF")
    private Double importeIrpf;
	
	@Column(name = "GPL_CLAVE_IRPF")
	private String claveIrpf;
	
	@Column(name = "GPL_SUBCLAVE_IRPF")
	private String subClaveIrpf;
	
	@Column(name = "GPL_CEUTA")
	private String ceuta;
	
	@Column(name = "GPL_CTA_IVAD")
	private String ctaIvad;

	@Column(name = "GPL_SCTA_IVAD")
	private String sctaIvad;
	
	@Column(name = "GPL_CONDICIONES")
	private String condiciones;
	
	@Column(name = "GPL_CTA_BANCO")
	private String ctaBanco;
	
	@Column(name = "GPL_SCTA_BANCO")
	private String sctaBanco;
	
	@Column(name = "GPL_CTA_EFECTOS")
	private String ctaEfectos;
	
	@Column(name = "GPL_SCTA_EFECTOS")
	private String sctaEfectos;
	
	@Column(name = "GPL_APUNTE")
	private String apunte;
	
	@Column(name = "GPL_CENTRODESTINO")
	private String centroDestino;
	
	@Column(name = "GPL_TIPO_FRA_SII")
	private String tipoFraSii;
	
	@Column(name = "GPL_CLAVE_RE")
	private String claveRe;
	
	@Column(name = "GPL_CLAVE_RE_AD1")
	private String claveReAd1;
	
	@Column(name = "GPL_CLAVE_RE_AD2")
	private String claveReAd2;
	
	@Column(name = "GPL_TIPO_OP_INTRA")
	private String tipoOpIntra;
	
	@Column(name = "GPL_DESC_BIENES")
	private String descBienes;
	
	@Column(name = "GPL_DESCRIPCION_OP")
	private String descripcionOp;
	
	@Column(name = "GPL_SIMPLIFICADA")
	private String simplificada;
	
	@Column(name = "GPL_FRA_SIMPLI_IDEN")
	private String fraSimpliIden;
	
	@Column(name = "GPL_DIARIO1")
	private String diario1;
	
	@Column(name = "GPL_DIARIO2")
	private String diario2;
	
	@Column(name = "GPL_TIPO_PARTIDA")
	private String tipoPartida;
	
	@Column(name = "GPL_APARTADO")
	private String apartado;
	
	@Column(name = "GPL_CAPITULO")
	private String capitulo;
	
	@Column(name = "GPL_PARTIDA")
	private String partida;
	
	@Column(name = "GPL_CTA_GASTO")
	private String ctaGasto;
	
	@Column(name = "GPL_SCTA_GASTO")
	private String sctaGasto;
	
	@Column(name = "GPL_REPERCUTIR")
	private String repercutir;
	
	@Column(name = "GPL_CONCEPTO_FAC")
	private String conceptoFac;
	
	@Column(name = "GPL_FECHA_FAC")
    private Date fechaFac;
	
	@Column(name = "GPL_COD_COEF")
	private String codCoef;
	
	@Column(name = "GPL_CODI_DIAR_IVA_V")
	private String codiDiarIvaV;
	
	@Column(name = "GPL_PCTJE_IVA_V")
    private Double pctjeIvaV;
	
	@Column(name = "GPL_NOMBRE")
	private String nombre;
	
	@Column(name = "GPL_CARACTERISTICA")
	private String caracteristica;
	
	@Column(name = "GPL_DIARIO1_BASE")
	private Long diario1Base;
	
	@Column(name = "GPL_DIARIO1_TIPO")
	private Long diario1Tipo;
	
	@Column(name = "GPL_DIARIO1_CUOTA")
	private Long diario1Cuota;
	
	@Column(name = "GPL_DIARIO2_BASE")
	private Long diario2Base;
	
	@Column(name = "GPL_DIARIO2_TIPO")
	private Long diario2Tipo;
	
	@Column(name = "GPL_DIARIO2_CUOTA")
	private Long diario2Cuota;
	
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getPromocion() {
		return promocion;
	}

	public void setPromocion(Long promocion) {
		this.promocion = promocion;
	}

	public String getTipoInmueble() {
		return tipoInmueble;
	}

	public void setTipoInmueble(String tipoInmueble) {
		this.tipoInmueble = tipoInmueble;
	}

	public String getClave1() {
		return clave1;
	}

	public void setClave1(String clave1) {
		this.clave1 = clave1;
	}

	public String getClave2() {
		return clave2;
	}

	public void setClave2(String clave2) {
		this.clave2 = clave2;
	}

	public String getClave3() {
		return clave3;
	}

	public void setClave3(String clave3) {
		this.clave3 = clave3;
	}

	public String getClave4() {
		return clave4;
	}

	public void setClave4(String clave4) {
		this.clave4 = clave4;
	}

	public Double getImporteGasto() {
		return importeGasto;
	}

	public void setImporteGasto(Double importeGasto) {
		this.importeGasto = importeGasto;
	}

	public Date getFechaContable() {
		return fechaContable;
	}

	public void setFechaContable(Date fechaContable) {
		this.fechaContable = fechaContable;
	}

	public String getDiarioContable() {
		return diarioContable;
	}

	public void setDiarioContable(String diarioContable) {
		this.diarioContable = diarioContable;
	}

	public String getD347() {
		return d347;
	}

	public void setD347(String d347) {
		this.d347 = d347;
	}

	public String getDelegacion() {
		return delegacion;
	}

	public void setDelegacion(String delegacion) {
		this.delegacion = delegacion;
	}

	public Double getRetencionBase() {
		return retencionBase;
	}

	public void setRetencionBase(Double retencionBase) {
		this.retencionBase = retencionBase;
	}

	public Double getPorcentajeRetencion() {
		return porcentajeRetencion;
	}

	public void setPorcentajeRetencion(Double porcentajeRetencion) {
		this.porcentajeRetencion = porcentajeRetencion;
	}

	public Double getImporteRetencion() {
		return importeRetencion;
	}

	public void setImporteRetencion(Double importeRetencion) {
		this.importeRetencion = importeRetencion;
	}

	public String getAplicarRetencion() {
		return aplicarRetencion;
	}

	public void setAplicarRetencion(String aplicarRetencion) {
		this.aplicarRetencion = aplicarRetencion;
	}

	public Double getBaseIrpf() {
		return baseIrpf;
	}

	public void setBaseIrpf(Double baseIrpf) {
		this.baseIrpf = baseIrpf;
	}

	public Double getPorcentajeIrpf() {
		return porcentajeIrpf;
	}

	public void setPorcentajeIrpf(Double porcentajeIrpf) {
		this.porcentajeIrpf = porcentajeIrpf;
	}

	public Double getImporteIrpf() {
		return importeIrpf;
	}

	public void setImporteIrpf(Double importeIrpf) {
		this.importeIrpf = importeIrpf;
	}

	public String getClaveIrpf() {
		return claveIrpf;
	}

	public void setClaveIrpf(String claveIrpf) {
		this.claveIrpf = claveIrpf;
	}

	public String getSubClaveIrpf() {
		return subClaveIrpf;
	}

	public void setSubClaveIrpf(String subClaveIrpf) {
		this.subClaveIrpf = subClaveIrpf;
	}

	public String getCeuta() {
		return ceuta;
	}

	public void setCeuta(String ceuta) {
		this.ceuta = ceuta;
	}

	public String getCtaIvad() {
		return ctaIvad;
	}

	public void setCtaIvad(String ctaIvad) {
		this.ctaIvad = ctaIvad;
	}

	public String getSctaIvad() {
		return sctaIvad;
	}

	public void setSctaIvad(String sctaIvad) {
		this.sctaIvad = sctaIvad;
	}

	public String getCondiciones() {
		return condiciones;
	}

	public void setCondiciones(String condiciones) {
		this.condiciones = condiciones;
	}

	public String getCtaBanco() {
		return ctaBanco;
	}

	public void setCtaBanco(String ctaBanco) {
		this.ctaBanco = ctaBanco;
	}

	public String getSctaBanco() {
		return sctaBanco;
	}

	public void setSctaBanco(String sctaBanco) {
		this.sctaBanco = sctaBanco;
	}

	public String getCtaEfectos() {
		return ctaEfectos;
	}

	public void setCtaEfectos(String ctaEfectos) {
		this.ctaEfectos = ctaEfectos;
	}

	public String getSctaEfectos() {
		return sctaEfectos;
	}

	public void setSctaEfectos(String sctaEfectos) {
		this.sctaEfectos = sctaEfectos;
	}

	public String getApunte() {
		return apunte;
	}

	public void setApunte(String apunte) {
		this.apunte = apunte;
	}

	public String getCentroDestino() {
		return centroDestino;
	}

	public void setCentroDestino(String centroDestino) {
		this.centroDestino = centroDestino;
	}

	public String getTipoFraSii() {
		return tipoFraSii;
	}

	public void setTipoFraSii(String tipoFraSii) {
		this.tipoFraSii = tipoFraSii;
	}

	public String getClaveRe() {
		return claveRe;
	}

	public void setClaveRe(String claveRe) {
		this.claveRe = claveRe;
	}

	public String getClaveReAd1() {
		return claveReAd1;
	}

	public void setClaveReAd1(String claveReAd1) {
		this.claveReAd1 = claveReAd1;
	}

	public String getClaveReAd2() {
		return claveReAd2;
	}

	public void setClaveReAd2(String claveReAd2) {
		this.claveReAd2 = claveReAd2;
	}

	public String getTipoOpIntra() {
		return tipoOpIntra;
	}

	public void setTipoOpIntra(String tipoOpIntra) {
		this.tipoOpIntra = tipoOpIntra;
	}

	public String getDescBienes() {
		return descBienes;
	}

	public void setDescBienes(String descBienes) {
		this.descBienes = descBienes;
	}

	public String getDescripcionOp() {
		return descripcionOp;
	}

	public void setDescripcionOp(String descripcionOp) {
		this.descripcionOp = descripcionOp;
	}

	public String getSimplificada() {
		return simplificada;
	}

	public void setSimplificada(String simplificada) {
		this.simplificada = simplificada;
	}

	public String getFraSimpliIden() {
		return fraSimpliIden;
	}

	public void setFraSimpliIden(String fraSimpliIden) {
		this.fraSimpliIden = fraSimpliIden;
	}

	public String getDiario1() {
		return diario1;
	}

	public void setDiario1(String diario1) {
		this.diario1 = diario1;
	}

	public String getDiario2() {
		return diario2;
	}

	public void setDiario2(String diario2) {
		this.diario2 = diario2;
	}

	public String getTipoPartida() {
		return tipoPartida;
	}

	public void setTipoPartida(String tipoPartida) {
		this.tipoPartida = tipoPartida;
	}

	public String getApartado() {
		return apartado;
	}

	public void setApartado(String apartado) {
		this.apartado = apartado;
	}

	public String getCapitulo() {
		return capitulo;
	}

	public void setCapitulo(String capitulo) {
		this.capitulo = capitulo;
	}

	public String getPartida() {
		return partida;
	}

	public void setPartida(String partida) {
		this.partida = partida;
	}

	public String getCtaGasto() {
		return ctaGasto;
	}

	public void setCtaGasto(String ctaGasto) {
		this.ctaGasto = ctaGasto;
	}

	public String getSctaGasto() {
		return sctaGasto;
	}

	public void setSctaGasto(String sctaGasto) {
		this.sctaGasto = sctaGasto;
	}

	public String getRepercutir() {
		return repercutir;
	}

	public void setRepercutir(String repercutir) {
		this.repercutir = repercutir;
	}

	public String getConceptoFac() {
		return conceptoFac;
	}

	public void setConceptoFac(String conceptoFac) {
		this.conceptoFac = conceptoFac;
	}

	public Date getFechaFac() {
		return fechaFac;
	}

	public void setFechaFac(Date fechaFac) {
		this.fechaFac = fechaFac;
	}

	public String getCodCoef() {
		return codCoef;
	}

	public void setCodCoef(String codCoef) {
		this.codCoef = codCoef;
	}

	public String getCodiDiarIvaV() {
		return codiDiarIvaV;
	}

	public void setCodiDiarIvaV(String codiDiarIvaV) {
		this.codiDiarIvaV = codiDiarIvaV;
	}

	public Double getPctjeIvaV() {
		return pctjeIvaV;
	}

	public void setPctjeIvaV(Double pctjeIvaV) {
		this.pctjeIvaV = pctjeIvaV;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCaracteristica() {
		return caracteristica;
	}

	public void setCaracteristica(String caracteristica) {
		this.caracteristica = caracteristica;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getDiario1Base() {
		return diario1Base;
	}

	public void setDiario1Base(Long diario1Base) {
		this.diario1Base = diario1Base;
	}

	public Long getDiario1Tipo() {
		return diario1Tipo;
	}

	public void setDiario1Tipo(Long diario1Tipo) {
		this.diario1Tipo = diario1Tipo;
	}

	public Long getDiario1Cuota() {
		return diario1Cuota;
	}

	public void setDiario1Cuota(Long diario1Cuota) {
		this.diario1Cuota = diario1Cuota;
	}

	public Long getDiario2Base() {
		return diario2Base;
	}

	public void setDiario2Base(Long diario2Base) {
		this.diario2Base = diario2Base;
	}

	public Long getDiario2Tipo() {
		return diario2Tipo;
	}

	public void setDiario2Tipo(Long diario2Tipo) {
		this.diario2Tipo = diario2Tipo;
	}

	public Long getDiario2Cuota() {
		return diario2Cuota;
	}

	public void setDiario2Cuota(Long diario2Cuota) {
		this.diario2Cuota = diario2Cuota;
	}
	
}
