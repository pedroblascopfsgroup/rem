package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_TASAS_IMPUESTOS", schema = "${entity.schema}")
public class VTasasImpuestos implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID_VISTA")  
	private Long id;
	
	@Column(name = "SOCIEDAD")
	private String sociedad;
	
	@Column(name = "VISTA")
	private Long vista;
	
	@Column(name = "ORDEN")
	private Long orden;
	
	@Column(name = "CIF")
	private String cif;
	
	@Id
	@Column(name = "CODIGO")
	private String codigo;
	
	@Column(name = "NUM_FRA")
	private String numFra;
	
	@Column(name = "FECHA_FRA")
	private Date fechaFra;
	
	@Column(name = "FECHA_CONTABLE")
	private Date fechaContable;
	
	@Column(name = "DIARIO_CONTB")
	private String diarioContb;
	
	@Column(name = "IMP_BRUTO")
	private Double importeBruto;
	
	@Column(name = "TOTAL")
	private Double total;
	
	@Column(name = "OP_ALQ")
	private String opAlq;
	
	@Column(name = "D347")
	private String d347;
	
	@Column(name = "TIPO_FRA")
	private String tipoFra;
	
	@Column(name = "SUJ_RECC")
	private String sujRecc;
	
	@Column(name = "DELEGACION")
	private String delegacion;
	
	@Column(name = "BASE_RETENCION")
	private Double baseRetencion;
	
	@Column(name = "PORCENTAJE_RETENCION")
	private Double porcentajeRetencion;
	
	@Column(name = "IMPORTE_RETENCION")
	private Double importeRetencion;
	
	@Column(name = "APLICAR_RETENCION")
	private String aplicarRetencion;
	
	@Column(name = "BASE_IRPF")
	private Double baseIrpf;
	
	@Column(name = "PORCENTAJE_IRPF")
	private Double porcentajeIrpf;
	
	@Column(name = "IMPORTE_IRPF")
	private Double importeIrpf;
	
	@Column(name = "CLAVE_IRPF")
	private String claveIrpf;
	
	@Column(name = "SUBCLAVE_IRPF")
	private String subClaveIrpf;
	
	@Column(name = "CEUTA")
	private String ceuta;
	
	@Column(name = "CONCEPTO")
	private String concepto;
	
	@Column(name = "CTA_ACREEDORA")
	private Long ctaAcreedora;
	
	@Column(name = "SCTA_ACREEDORA")
	private String sctaAcreedora;
	
	@Column(name = "CTA_GARANTIA")
	private Long ctaGarantia;
	
	@Column(name = "SCTA_GARANTIA")
	private String sctaGarantia;
	
	@Column(name = "CTA_IRPF")
	private Long ctaIrpf;
	
	@Column(name = "SCTA_IRPF")
	private String sctaIrpf;
	
	@Column(name = "CTA_IVAD")
	private String ctaIvad;
	
	@Column(name = "SCTA_IVAD")
	private String sctaIvad;
	
	@Column(name = "CONDICIONES")
	private String condiciones;
	
	@Column(name = "PAGADA")
	private String pagada;
	
	@Column(name = "CTA_BANCO")
	private String ctaBanco;
	
	@Column(name = "SCTA_BANCO")
	private String sctaBanco;
	
	@Column(name = "CTA_EFECTOS")
	private String ctaEfectos;
	
	@Column(name = "SCTA_EFECTOS")
	private String sctaEfectos;
	
	@Column(name = "APUNTE")
	private String apunte;
	
	@Column(name = "CENTRODESTINO")
	private String centrodestino;
	
	@Column(name = "TIPO_FRA_SII")
	private String tipoFraSii;
	
	@Column(name = "CLAVE_RE")
	private String claveRe;
	
	@Column(name = "CLAVE_RE_AD1")
	private String claveReAd1;
	
	@Column(name = "CLAVE_RE_AD2")
	private String claveReAd2;
	
	@Column(name = "TIPO_OP_INTRA")
	private String tipoOpIntra;
	
	@Column(name = "DESC_BIENES")
	private String descBienes;
	
	@Column(name = "DESCRIPCION_OP")
	private String descripcionOp;
	
	@Column(name = "SIMPLIFICADA")
	private String simplificada;
	
	@Column(name = "FRA_SIMPLI_IDEN")
	private String fraSImpliIden;
	
	@Column(name = "DIARIO1")
	private String diario1;
	
	@Column(name = "BASE1")
	private Double base1;
	
	@Column(name = "IVA1")
	private Double iva1;
	
	@Column(name = "CUOTA1")
	private Double cuota1;
	
	@Column(name = "DIARIO2")
	private String diario2;
	
	@Column(name = "BASE2")
	private Double base2;
	
	@Column(name = "IVA2")
	private Double iva2;
	
	@Column(name = "CUOTA2")
	private Double cuota2;
	
	@Column(name = "DIARIO3")
	private Double diario3;
	
	@Column(name = "BASE3")
	private Double base3;
	
	@Column(name = "IVA3")
	private Double iva3;
	
	@Column(name = "CUOTA3")
	private Double cuota3;
	
	@Column(name = "DIARIO4")
	private Double diario4;
	
	@Column(name = "BASE4")
	private Double base4;
	
	@Column(name = "IVA4")
	private Double iva4;
	
	@Column(name = "CUOTA4")
	private Double cuota4;
	
	@Column(name = "DIARIO5")
	private Double diario5;
	
	@Column(name = "BASE5")
	private Double base5;
	
	@Column(name = "IVA5")
	private Double iva5;
	
	@Column(name = "CUOTA5")
	private Double cuota5;
	
	@Column(name = "PROYECTO")
	private Long proyecto;
	
	@Column(name = "TIPO_INMUEBLE")
	private String tipoInmueble;
	
	@Column(name = "CLAVE1")
	private String clave1;
	
	@Column(name = "CLAVE2")
	private String clave2;
	
	@Column(name = "CLAVE3")
	private String clave3;
	
	@Column(name = "CLAVE4")
	private String clave4;
	
	@Column(name = "ID_ACTIVO")
	private Long idActivo;
	
	@Column(name = "IMPORTE_GASTO")
	private Double importeGasto;
	
	@Column(name = "TIPO_PARTIDA")
	private String tipoPartida;
	
	@Column(name = "APARTADO")
	private String apartado;
	
	@Column(name = "CAPITULO")
	private String capitulo;
	
	@Column(name = "PARTIDA")
	private String partida;
	
	@Column(name = "CTA_GASTO")
	private String ctaGasto;
	
	@Column(name = "SCTA_GASTO")
	private String sctaGasto;
	
	@Column(name = "REPERCUTIR")
	private String repercutir;
	
	@Column(name = "CONCEPTO_FAC")
	private String conceptoFac;
	
	@Column(name = "FECHA_FAC")
	private Date fechaFac;
	
	@Column(name = "COD_COEF")
	private String codCoef;
	
	@Column(name = "CODI_DIAR_IVA_V")
	private String codiDiarIvaV;
	
	@Column(name = "PCTJE_IVA_V")
	private Double pctjeIvaV;
	
	@Column(name = "NOMBRE")
	private String nombre;
	
	@Column(name = "CARACTERISTICA")
	private String caracteristica;

	public String getSociedad() {
		return sociedad;
	}

	public void setSociedad(String sociedad) {
		this.sociedad = sociedad;
	}

	public Long getVista() {
		return vista;
	}

	public void setVista(Long vista) {
		this.vista = vista;
	}

	public Long getOrden() {
		return orden;
	}

	public void setOrden(Long orden) {
		this.orden = orden;
	}

	public String getCif() {
		return cif;
	}

	public void setCif(String cif) {
		this.cif = cif;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getNumFra() {
		return numFra;
	}

	public void setNumFra(String numFra) {
		this.numFra = numFra;
	}

	public Date getFechaFra() {
		return fechaFra;
	}

	public void setFechaFra(Date fechaFra) {
		this.fechaFra = fechaFra;
	}

	public Date getFechaContable() {
		return fechaContable;
	}

	public void setFechaContable(Date fechaContable) {
		this.fechaContable = fechaContable;
	}

	public String getDiarioContb() {
		return diarioContb;
	}

	public void setDiarioContb(String diarioContb) {
		this.diarioContb = diarioContb;
	}

	public Double getImporteBruto() {
		return importeBruto;
	}

	public void setImporteBruto(Double importeBruto) {
		this.importeBruto = importeBruto;
	}

	public Double getTotal() {
		return total;
	}

	public void setTotal(Double total) {
		this.total = total;
	}

	public String getOpAlq() {
		return opAlq;
	}

	public void setOpAlq(String opAlq) {
		this.opAlq = opAlq;
	}

	public String getD347() {
		return d347;
	}

	public void setD347(String d347) {
		this.d347 = d347;
	}

	public String getTipoFra() {
		return tipoFra;
	}

	public void setTipoFra(String tipoFra) {
		this.tipoFra = tipoFra;
	}

	public String getSujRecc() {
		return sujRecc;
	}

	public void setSujRecc(String sujRecc) {
		this.sujRecc = sujRecc;
	}

	public String getDelegacion() {
		return delegacion;
	}

	public void setDelegacion(String delegacion) {
		this.delegacion = delegacion;
	}

	public Double getBaseRetencion() {
		return baseRetencion;
	}

	public void setBaseRetencion(Double baseRetencion) {
		this.baseRetencion = baseRetencion;
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

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public Long getCtaAcreedora() {
		return ctaAcreedora;
	}

	public void setCtaAcreedora(Long ctaAcreedora) {
		this.ctaAcreedora = ctaAcreedora;
	}

	public String getSctaAcreedora() {
		return sctaAcreedora;
	}

	public void setSctaAcreedora(String sctaAcreedora) {
		this.sctaAcreedora = sctaAcreedora;
	}

	public Long getCtaGarantia() {
		return ctaGarantia;
	}

	public void setCtaGarantia(Long ctaGarantia) {
		this.ctaGarantia = ctaGarantia;
	}

	public String getSctaGarantia() {
		return sctaGarantia;
	}

	public void setSctaGarantia(String sctaGarantia) {
		this.sctaGarantia = sctaGarantia;
	}

	public Long getCtaIrpf() {
		return ctaIrpf;
	}

	public void setCtaIrpf(Long ctaIrpf) {
		this.ctaIrpf = ctaIrpf;
	}

	public String getSctaIrpf() {
		return sctaIrpf;
	}

	public void setSctaIrpf(String sctaIrpf) {
		this.sctaIrpf = sctaIrpf;
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

	public String getPagada() {
		return pagada;
	}

	public void setPagada(String pagada) {
		this.pagada = pagada;
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

	public String getCentrodestino() {
		return centrodestino;
	}

	public void setCentrodestino(String centrodestino) {
		this.centrodestino = centrodestino;
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

	public String getFraSImpliIden() {
		return fraSImpliIden;
	}

	public void setFraSImpliIden(String fraSImpliIden) {
		this.fraSImpliIden = fraSImpliIden;
	}

	public String getDiario1() {
		return diario1;
	}

	public void setDiario1(String diario1) {
		this.diario1 = diario1;
	}

	public Double getBase1() {
		return base1;
	}

	public void setBase1(Double base1) {
		this.base1 = base1;
	}

	public Double getIva1() {
		return iva1;
	}

	public void setIva1(Double iva1) {
		this.iva1 = iva1;
	}

	public Double getCuota1() {
		return cuota1;
	}

	public void setCuota1(Double cuota1) {
		this.cuota1 = cuota1;
	}

	public String getDiario2() {
		return diario2;
	}

	public void setDiario2(String diario2) {
		this.diario2 = diario2;
	}

	public Double getBase2() {
		return base2;
	}

	public void setBase2(Double base2) {
		this.base2 = base2;
	}

	public Double getIva2() {
		return iva2;
	}

	public void setIva2(Double iva2) {
		this.iva2 = iva2;
	}

	public Double getCuota2() {
		return cuota2;
	}

	public void setCuota2(Double cuota2) {
		this.cuota2 = cuota2;
	}

	public Long getProyecto() {
		return proyecto;
	}

	public void setProyecto(Long proyecto) {
		this.proyecto = proyecto;
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

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Double getImporteGasto() {
		return importeGasto;
	}

	public void setImporteGasto(Double importeGasto) {
		this.importeGasto = importeGasto;
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

	public Double getDiario3() {
		return diario3;
	}

	public void setDiario3(Double diario3) {
		this.diario3 = diario3;
	}

	public Double getBase3() {
		return base3;
	}

	public void setBase3(Double base3) {
		this.base3 = base3;
	}

	public Double getIva3() {
		return iva3;
	}

	public void setIva3(Double iva3) {
		this.iva3 = iva3;
	}

	public Double getCuota3() {
		return cuota3;
	}

	public void setCuota3(Double cuota3) {
		this.cuota3 = cuota3;
	}

	public Double getDiario4() {
		return diario4;
	}

	public void setDiario4(Double diario4) {
		this.diario4 = diario4;
	}

	public Double getBase4() {
		return base4;
	}

	public void setBase4(Double base4) {
		this.base4 = base4;
	}

	public Double getIva4() {
		return iva4;
	}

	public void setIva4(Double iva4) {
		this.iva4 = iva4;
	}

	public Double getCuota4() {
		return cuota4;
	}

	public void setCuota4(Double cuota4) {
		this.cuota4 = cuota4;
	}

	public Double getDiario5() {
		return diario5;
	}

	public void setDiario5(Double diario5) {
		this.diario5 = diario5;
	}

	public Double getBase5() {
		return base5;
	}

	public void setBase5(Double base5) {
		this.base5 = base5;
	}

	public Double getIva5() {
		return iva5;
	}

	public void setIva5(Double iva5) {
		this.iva5 = iva5;
	}

	public Double getCuota5() {
		return cuota5;
	}

	public void setCuota5(Double cuota5) {
		this.cuota5 = cuota5;
	}
}

