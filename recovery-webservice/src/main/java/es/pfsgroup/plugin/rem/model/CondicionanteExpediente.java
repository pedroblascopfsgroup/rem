package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadesAvalistas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDGrupoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDMetodoActualizacionRenta;
import es.pfsgroup.plugin.rem.model.dd.DDRangoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenFianzaCCAA;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;


/**
 * Modelo que gestiona la informacion de condicionantes de un expediente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "COE_CONDICIONANTES_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class CondicionanteExpediente implements Serializable, Auditable {

	private static final long serialVersionUID = -2333323398245528237L;


	@Id
    @Column(name = "COE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CondicionantesExpedienteGenerator")
    @SequenceGenerator(name = "CondicionantesExpedienteGenerator", sequenceName = "S_COE_CONDICIONANTES_EXP")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@Column(name="COE_SOLICITA_FINANCIACION")
	private Integer solicitaFinanciacion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ESF_ID")
	private DDEstadoFinanciacion estadoFinanciacion;
		
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCC_ID")
	private DDTipoCalculo tipoCalculoReserva;
    
    @Column(name="COE_PORCENTAJE_RESERVA")
    private Double porcentajeReserva;
    
    @Column(name="COE_IMPORTE_RESERVA")
    private Double importeReserva;
    
	@Column(name="COE_DEPOSITO_RESERVA")
    private Double depositoReserva;
    
    @Column(name="COE_PLAZO_FIRMA_RESERVA")
    private Integer plazoFirmaReserva;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TIT_ID")
	private DDTiposImpuesto tipoImpuesto;
    
    @Column(name="COE_TIPO_APLICABLE")
    private Double tipoAplicable;

    @Column(name="COE_RENUNCIA_EXENCION")
    private Boolean renunciaExencion;

    @Column(name="COE_RESERVA_CON_IMPUESTO")
    private Integer reservaConImpuesto;

    @Column(name="COE_GASTOS_PLUSVALIA")
    private Double gastosPlusvalia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_PLUSVALIA")
	private DDTiposPorCuenta tipoPorCuentaPlusvalia;
    
    @Column(name="COE_GASTOS_NOTARIA")
    private Double gastosNotaria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_NOTARIA")
	private DDTiposPorCuenta tipoPorCuentaNotaria;
    
    @Column(name="COE_GASTOS_OTROS")
    private Double gastosOtros;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_GASTOS_OTROS")
	private DDTiposPorCuenta tipoPorCuentaGastosOtros;
    
    @Column(name="COE_CARGAS_IMPUESTOS")
    private Double cargasImpuestos;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_IMPUESTOS")
	private DDTiposPorCuenta tipoPorCuentaImpuestos;
    
    @Column(name="COE_CARGAS_COMUNIDAD")
    private Double cargasComunidad;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_COMUNIDAD")
	private DDTiposPorCuenta tipoPorCuentaComunidad;
    
    @Column(name="COE_CARGAS_OTROS")
    private Double cargasOtros;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_CARGAS_OTROS")
	private DDTiposPorCuenta tipoPorCuentaCargasOtros;
    
    @Column(name="COE_SUJETO_TANTEO_RETRACTO")
    private Integer sujetoTanteoRetracto;
    
    @Column(name="COE_RENUNCIA_SNMTO_EVICCION")
    private Integer renunciaSaneamientoEviccion;
    
    @Column(name="COE_RENUNCIA_SNMTO_VICIOS")
    private Integer renunciaSaneamientoVicios;
    
    @Column(name="COE_VPO")
    private Integer vpo;
    
    @Column(name="COE_LICENCIA")
    private String licencia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_LICENCIA")
	private DDTiposPorCuenta tipoPorCuentaLicencia;
    
    @Column(name="COE_PROCEDE_DESCALIFICACION")
    private Integer procedeDescalificacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_DESCALIFICACION")
	private DDTiposPorCuenta tipoPorCuentaDescalificacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIP_ID")
	private DDSituacionesPosesoria situacionPosesoria;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ETI_ID")
	private DDEstadoTitulo estadoTitulo;
    
    @Column(name="COE_ESTADO_TRAMITE")
    private String estadoTramite;
    
    @Column(name="COE_ENTIDAD_FINANCIACION_AJENA")
    private String entidadFinanciacion;
    
    @Column(name="COE_POSESION_INICIAL")
    private Integer posesionInicial;
    
	@Column(name = "COE_INICIO_EXPEDIENTE")
	private Date fechaInicioExpediente;
	
	@Column(name = "COE_INICIO_FINANCIACION")
	private Date fechaInicioFinanciacion;
	
	@Column(name = "COE_FIN_FINANCIACION")
	private Date fechaFinFinanciacion;
	
    @Column(name="COE_GASTOS_IBI")
    private Double gastosIbi;
    
    @Column(name="COE_GASTOS_COMUNIDAD")
    private Double gastosComunidad;
    
    @Column(name="COE_GASTOS_SUMINISTROS")
    private Double gastosSuministros;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_IBI")
	private DDTiposPorCuenta tipoPorCuentaIbi;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_COMUNIDAD_ALQUILER")
	private DDTiposPorCuenta tipoPorCuentaComunidadAlquiler;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPC_ID_SUMINISTROS")
	private DDTiposPorCuenta tipoPorCuentaSuministros;
    
    @Column(name="COE_SOLICITA_RESERVA")
    private Integer solicitaReserva;

    @Column(name="COE_OPERACION_EXENTA")
    private Boolean operacionExenta;

    @Column(name="COE_INVERSION_SUJETO_PASIVO")
    private Boolean inversionDeSujetoPasivo;
    
	@Column(name="ALQ_FIANZA_MESES")
    private Integer mesesFianza;
    
    @Column(name="ALQ_FIANZA_IMPORTE")
    private Double importeFianza;
    
    @Column(name="ALQ_FIANZA_ACTUALIZABLE")
    private Boolean fianzaActualizable;
    
    @Column(name="ALQ_DEPOSITO_MESES")
    private Integer mesesDeposito;
    
    @Column(name="ALQ_DEPOSITO_IMPORTE")
    private Double importeDeposito;
    
    @Column(name="ALQ_DEPOSITO_ACTUALIZABLE")
    private Boolean depositoActualizable;
    
    @Column(name="ALQ_AVALISTA")
    private String avalista;
    
    @Column(name="ALQ_FIADOR_DOCUMENTO")
    private String documentoFiador;
        
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ALQ_FIADOR_ENTIDAD_BANCARIA")
	private DDEntidadesAvalistas entidadBancariaFiador;
    
    @Column(name="ALQ_IMPORTE_AVAL")
    private Double importeAval;
    
    @Column(name="ALQ_NUMERO_AVAL")
    private Integer numeroAval;
    
    @Column(name="ALQ_RENUNCIA_TANTEO")
    private Boolean renunciaTanteo;
    
    @Column(name="ALQ_CARENCIA")
    private Boolean carencia;
    
    @Column(name="ALQ_CARENCIA_MESES")
    private Integer mesesCarencia;
    
    @Column(name="ALQ_CARENCIA_IMPORTE")
    private Double importeCarencia;
    
    @Column(name="ALQ_BONIFICACION")
    private Boolean bonificacion;
    
    @Column(name="ALQ_BONIFICACION_MESES")
    private Integer mesesBonificacion;
    
    @Column(name="ALQ_BONIFICACION_IMPORTE")
    private Double importeBonificacion;
    
    @Column(name="ALQ_BONIFICACION_DURACION")
    private Integer duracionBonificacion;
    
    @Column(name="ALQ_GASTOS_REPERCUTIBLES")
    private Boolean gastosRepercutibles;
    
    @Column(name="ALQ_REPERCUTIBLES_COMMENTS")
    private String repercutiblesComments;
    
    @Column(name="ALQ_ENTIDAD_COMMENTS")
    private String entidadComments;
    
    @Column(name="ALQ_FECHA_FIRMA") 
    private Date fechaFirma;
    
    @Column(name="ALQ_RENTA_FIJO")
    private Boolean checkFijo;
    
    @Column(name="ALQ_FECHA_FIJO")
    private Date fechaFijo;
    
    @Column(name="ALQ_FECHA_INC_RENTA")
    private Double incrementoRentaFijo;
    
    @Column(name="ALQ_RENTA_PORCENTUAL")
    private Boolean checkPorcentual;
    
    @Column(name="ALQ_RENTA_IPC")
    private Boolean checkIPC;

    @Column(name="ALQ_RENTA_PORC_IMPUESTOS")
    private Integer porcentaje;
    
    @Column(name="ALQ_RENTA_REVISION_MERCADO")
    private Boolean checkRevisionMercado;
	
	@Column(name = "ALQ_RENTA_MERCADO_FECHA")
	private Date revisionMercadoFecha;
	
    @Column(name="ALQ_RENTA_MERCADO_CADA")
    private Integer revisionMercadoMeses;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ETF_ID")
	private DDEntidadFinanciera entidadFinanciera;
    
    @Column(name="COE_TRIBUTOS_PROPIEDAD")
    private Boolean tributosSobrePropiedad;
    
    @OneToMany(mappedBy = "condicionante", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "COE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<HistoricoCondicionanteExpediente> listHistoricoCondiciones;
    
    @Column(name="COE_OTRA_ENT_FINANCIERA")
    private String otraEntidadFinaciera;
    
    @Column(name="COE_FIANZA_EXONERADA")
    private Boolean fianzaExonerada;
    
    @Column(name="COE_OBLIGADO_CUMPLIMIENTO")
    private Double obligadoCumplimiento;
    
    @Column(name="COE_VENCIMIENTO_AVAL")
    private Date fechaVencimientoAval;
    
    @Column(name="COE_ADECUACIONES")
    private Boolean adecuaciones;
    
    @Column(name="COE_CERTIFICACIONES")
    private Boolean certificaciones;
    
    @Column(name="COE_DER_CESION_ARREND")
    private Boolean derechoCesionSubarriendo;
    
    @Column(name="COE_FECHA_PREAVISO_VENC_CONT")
    private Date fechaPreavisoVencimientoCnt;
    
    @Column(name="COE_FECHA_INGR_ARREND")
    private Date fechaIngresoFianzaArrendatario;
    
    @Column(name="COE_ANT_DEUDOR_LOCALIZABLE")
    private Boolean antiguoDeudorLocalizable;
    
    @Column(name="COE_CNT_SUSCR_POST_ADJ")
    private Boolean cntSuscritoPosteridadAdj;
    
    @Column(name="COE_OFR_NUEVAS_CONDICIONES")
    private Boolean ofrNuevasCondiciones;
    
    @Column(name="COE_ENTREGAS_CUENTA")
    private Boolean entregasCuenta;
    
    @Column(name="COE_IMPORTE_ENTREGAS_CUENTA")
    private Double importeEntregasCuenta;
    
    @Column(name="COE_RENTAS_CUENTA")
    private Boolean rentasCuenta;
    
    @Column(name="COE_FIANZAS_CNT_SUBROGADOS")
    private Boolean fianzaContratosSubrogados;
    
    @Column(name="COE_VULNERABILIDAD_DETECTADA")
    private Boolean vulnerabilidadDetectada;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RFC_ID")
	private DDRegimenFianzaCCAA regimenFianzaCCAA;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MTA_ID")
	private DDMetodoActualizacionRenta metodoActualizacionRenta;
    
    @Column(name="COE_CHECK_IGC")
    private Boolean checkIGC;
    
    @Column(name="COE_PERIODICIDAD")
    private Long periodicidadMeses;
    
    @Column(name="COE_FECHA_ACTU")
    private Date fechaActualizacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RGI_ID")
	private DDRangoImpuesto rangoImpuesto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_GRI_ID")
	private DDGrupoImpuesto tipoGrupoImpuesto;
    
    
    @Column(name="COE_SCORING_BC")
    private Boolean scoringBc;
    
    @Column(name="COE_AVAL_BC")
    private Boolean avalBc;
    
    @Column(name="COE_SEG_RENTAS_BC")
    private Boolean seguroRentasBc;
    
    @Column(name="ALQ_FECHA_VENC_AVAL")
    private Date fechaVencimientoAvalBc;
    
	@Column(name="ALQ_MESES_AVAL")
    private Integer mesesAval;
	
	@Column(name="ALQ_DURACION_MESES")
    private Integer mesesDuracion;
	
	@Column(name="COE_CHECK_DEPOSITO")
	private Boolean checkDeposito;
    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Double getDepositoReserva() {
		return depositoReserva;
	}

	public void setDepositoReserva(Double depositoReserva) {
		this.depositoReserva = depositoReserva;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public Integer getSolicitaFinanciacion() {
		return solicitaFinanciacion;
	}

	public void setSolicitaFinanciacion(Integer solicitaFinanciacion) {
		this.solicitaFinanciacion = solicitaFinanciacion;
	}

	public DDTipoCalculo getTipoCalculoReserva() {
		return tipoCalculoReserva;
	}

	public void setTipoCalculoReserva(DDTipoCalculo tipoCalculoReserva) {
		this.tipoCalculoReserva = tipoCalculoReserva;
	}

	public Double getImporteReserva() {
		return importeReserva;
	}

	public void setImporteReserva(Double importeReserva) {
		this.importeReserva = importeReserva;
	}

	public Double getPorcentajeReserva() {
		return porcentajeReserva;
	}

	public void setPorcentajeReserva(Double porcentajeReserva) {
		this.porcentajeReserva = porcentajeReserva;
	}

	public Integer getPlazoFirmaReserva() {
		return plazoFirmaReserva;
	}

	public void setPlazoFirmaReserva(Integer plazoFirmaReserva) {
		this.plazoFirmaReserva = plazoFirmaReserva;
	}

	public DDTiposImpuesto getTipoImpuesto() {
		return tipoImpuesto;
	}

	public void setTipoImpuesto(DDTiposImpuesto tipoImpuesto) {
		this.tipoImpuesto = tipoImpuesto;
	}

	public Double getTipoAplicable() {
		return tipoAplicable;
	}

	public void setTipoAplicable(Double tipoAplicable) {
		this.tipoAplicable = tipoAplicable;
	}

	public Boolean getRenunciaExencion() {
		return renunciaExencion;
	}

	public void setRenunciaExencion(Boolean renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}

	public Integer getReservaConImpuesto() {
		return reservaConImpuesto;
	}

	public void setReservaConImpuesto(Integer reservaConImpuesto) {
		this.reservaConImpuesto = reservaConImpuesto;
	}

	public Double getGastosPlusvalia() {
		return gastosPlusvalia;
	}

	public void setGastosPlusvalia(Double gastosPlusvalia) {
		this.gastosPlusvalia = gastosPlusvalia;
	}

	public DDTiposPorCuenta getTipoPorCuentaPlusvalia() {
		return tipoPorCuentaPlusvalia;
	}

	public void setTipoPorCuentaPlusvalia(DDTiposPorCuenta tipoPorCuentaPlusvalia) {
		this.tipoPorCuentaPlusvalia = tipoPorCuentaPlusvalia;
	}

	public Double getGastosNotaria() {
		return gastosNotaria;
	}

	public void setGastosNotaria(Double gastosNotaria) {
		this.gastosNotaria = gastosNotaria;
	}

	public DDTiposPorCuenta getTipoPorCuentaNotaria() {
		return tipoPorCuentaNotaria;
	}

	public void setTipoPorCuentaNotaria(DDTiposPorCuenta tipoPorCuentaNotaria) {
		this.tipoPorCuentaNotaria = tipoPorCuentaNotaria;
	}

	public Double getGastosOtros() {
		return gastosOtros;
	}

	public void setGastosOtros(Double gastosOtros) {
		this.gastosOtros = gastosOtros;
	}

	public DDTiposPorCuenta getTipoPorCuentaGastosOtros() {
		return tipoPorCuentaGastosOtros;
	}

	public void setTipoPorCuentaGastosOtros(
			DDTiposPorCuenta tipoPorCuentaGastosOtros) {
		this.tipoPorCuentaGastosOtros = tipoPorCuentaGastosOtros;
	}

	public Double getCargasImpuestos() {
		return cargasImpuestos;
	}

	public void setCargasImpuestos(Double cargasImpuestos) {
		this.cargasImpuestos = cargasImpuestos;
	}

	public DDTiposPorCuenta getTipoPorCuentaImpuestos() {
		return tipoPorCuentaImpuestos;
	}

	public void setTipoPorCuentaImpuestos(DDTiposPorCuenta tipoPorCuentaImpuestos) {
		this.tipoPorCuentaImpuestos = tipoPorCuentaImpuestos;
	}

	public Double getCargasComunidad() {
		return cargasComunidad;
	}

	public void setCargasComunidad(Double cargasComunidad) {
		this.cargasComunidad = cargasComunidad;
	}

	public DDTiposPorCuenta getTipoPorCuentaComunidad() {
		return tipoPorCuentaComunidad;
	}

	public void setTipoPorCuentaComunidad(DDTiposPorCuenta tipoPorCuentaComunidad) {
		this.tipoPorCuentaComunidad = tipoPorCuentaComunidad;
	}

	public Double getCargasOtros() {
		return cargasOtros;
	}

	public void setCargasOtros(Double cargasOtros) {
		this.cargasOtros = cargasOtros;
	}

	public DDTiposPorCuenta getTipoPorCuentaCargasOtros() {
		return tipoPorCuentaCargasOtros;
	}

	public void setTipoPorCuentaCargasOtros(
			DDTiposPorCuenta tipoPorCuentaCargasOtros) {
		this.tipoPorCuentaCargasOtros = tipoPorCuentaCargasOtros;
	}

	public Integer getSujetoTanteoRetracto() {
		return sujetoTanteoRetracto;
	}

	public void setSujetoTanteoRetracto(Integer sujetoTanteoRetracto) {
		this.sujetoTanteoRetracto = sujetoTanteoRetracto;
	}

	public Integer getRenunciaSaneamientoEviccion() {
		return renunciaSaneamientoEviccion;
	}

	public void setRenunciaSaneamientoEviccion(Integer renunciaSaneamientoEviccion) {
		this.renunciaSaneamientoEviccion = renunciaSaneamientoEviccion;
	}

	public Integer getRenunciaSaneamientoVicios() {
		return renunciaSaneamientoVicios;
	}

	public void setRenunciaSaneamientoVicios(Integer renunciaSaneamientoVicios) {
		this.renunciaSaneamientoVicios = renunciaSaneamientoVicios;
	}

	public Integer getVpo() {
		return vpo;
	}

	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}

	public String getLicencia() {
		return licencia;
	}

	public void setLicencia(String licencia) {
		this.licencia = licencia;
	}

	public DDTiposPorCuenta getTipoPorCuentaLicencia() {
		return tipoPorCuentaLicencia;
	}

	public void setTipoPorCuentaLicencia(DDTiposPorCuenta tipoPorCuentaLicencia) {
		this.tipoPorCuentaLicencia = tipoPorCuentaLicencia;
	}

	public Integer getProcedeDescalificacion() {
		return procedeDescalificacion;
	}

	public void setProcedeDescalificacion(Integer procedeDescalificacion) {
		this.procedeDescalificacion = procedeDescalificacion;
	}

	public DDTiposPorCuenta getTipoPorCuentaDescalificacion() {
		return tipoPorCuentaDescalificacion;
	}

	public void setTipoPorCuentaDescalificacion(
			DDTiposPorCuenta tipoPorCuentaDescalificacion) {
		this.tipoPorCuentaDescalificacion = tipoPorCuentaDescalificacion;
	}

	public DDEstadoFinanciacion getEstadoFinanciacion() {
		return estadoFinanciacion;
	}

	public void setEstadoFinanciacion(DDEstadoFinanciacion estadoFinanciacion) {
		this.estadoFinanciacion = estadoFinanciacion;
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

	public DDSituacionesPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(DDSituacionesPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public DDEstadoTitulo getEstadoTitulo() {
		return estadoTitulo;
	}

	public void setEstadoTitulo(DDEstadoTitulo estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}

	public String getEstadoTramite() {
		return estadoTramite;
	}

	public void setEstadoTramite(String estadoTramite) {
		this.estadoTramite = estadoTramite;
	}

	public String getEntidadFinanciacion() {
		return entidadFinanciacion;
	}

	public void setEntidadFinanciacion(String entidadFinanciacion) {
		this.entidadFinanciacion = entidadFinanciacion;
	}

	public Integer getPosesionInicial() {
		return posesionInicial;
	}

	public void setPosesionInicial(Integer posesionInicial) {
		this.posesionInicial = posesionInicial;
	}

	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}

	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}

	public Date getFechaInicioFinanciacion() {
		return fechaInicioFinanciacion;
	}

	public void setFechaInicioFinanciacion(Date fechaInicioFinanciacion) {
		this.fechaInicioFinanciacion = fechaInicioFinanciacion;
	}

	public Date getFechaFinFinanciacion() {
		return fechaFinFinanciacion;
	}

	public void setFechaFinFinanciacion(Date fechaFinFinanciacion) {
		this.fechaFinFinanciacion = fechaFinFinanciacion;
	}

	public Double getGastosIbi() {
		return gastosIbi;
	}

	public void setGastosIbi(Double gastosIbi) {
		this.gastosIbi = gastosIbi;
	}

	public Double getGastosComunidad() {
		return gastosComunidad;
	}

	public void setGastosComunidad(Double gastosComunidad) {
		this.gastosComunidad = gastosComunidad;
	}

	public Double getGastosSuministros() {
		return gastosSuministros;
	}

	public void setGastosSuministros(Double gastosSuministros) {
		this.gastosSuministros = gastosSuministros;
	}

	public DDTiposPorCuenta getTipoPorCuentaIbi() {
		return tipoPorCuentaIbi;
	}

	public void setTipoPorCuentaIbi(DDTiposPorCuenta tipoPorCuentaIbi) {
		this.tipoPorCuentaIbi = tipoPorCuentaIbi;
	}

	public DDTiposPorCuenta getTipoPorCuentaComunidadAlquiler() {
		return tipoPorCuentaComunidadAlquiler;
	}

	public void setTipoPorCuentaComunidadAlquiler(
			DDTiposPorCuenta tipoPorCuentaComunidadAlquiler) {
		this.tipoPorCuentaComunidadAlquiler = tipoPorCuentaComunidadAlquiler;
	}

	public DDTiposPorCuenta getTipoPorCuentaSuministros() {
		return tipoPorCuentaSuministros;
	}

	public void setTipoPorCuentaSuministros(
			DDTiposPorCuenta tipoPorCuentaSuministros) {
		this.tipoPorCuentaSuministros = tipoPorCuentaSuministros;
	}

	public Integer getSolicitaReserva() {
		return solicitaReserva;
	}

	public void setSolicitaReserva(Integer solicitaReserva) {
		this.solicitaReserva = solicitaReserva;
	}

	public Boolean getOperacionExenta() {
		return operacionExenta;
	}

	public void setOperacionExenta(Boolean operacionExenta) {
		this.operacionExenta = operacionExenta;
	}

	public Boolean getInversionDeSujetoPasivo() {
		return inversionDeSujetoPasivo;
	}

	public void setInversionDeSujetoPasivo(Boolean inversionDeSujetoPasivo) {
		this.inversionDeSujetoPasivo = inversionDeSujetoPasivo;
	}
	
	public Integer getMesesFianza() {
		return mesesFianza;
	}

	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}

	public Double getImporteFianza() {
		return importeFianza;
	}

	public void setImporteFianza(Double importeFianza) {
		this.importeFianza = importeFianza;
	}

	public Boolean getFianzaActualizable() {
		return fianzaActualizable;
	}

	public void setFianzaActualizable(Boolean fianzaActualizable) {
		this.fianzaActualizable = fianzaActualizable;
	}

	public Integer getMesesDeposito() {
		return mesesDeposito;
	}

	public void setMesesDeposito(Integer mesesDeposito) {
		this.mesesDeposito = mesesDeposito;
	}

	public Double getImporteDeposito() {
		return importeDeposito;
	}

	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}

	public Boolean getDepositoActualizable() {
		return depositoActualizable;
	}

	public void setDepositoActualizable(Boolean depositoActualizable) {
		this.depositoActualizable = depositoActualizable;
	}

	public String getAvalista() {
		return avalista;
	}

	public void setAvalista(String avalista) {
		this.avalista = avalista;
	}

	public String getDocumentoFiador() {
		return documentoFiador;
	}

	public void setDocumentoFiador(String documentoFiador) {
		this.documentoFiador = documentoFiador;
	}

	public DDEntidadesAvalistas getEntidadBancariaFiador() {
		return entidadBancariaFiador;
	}

	public void setEntidadBancariaFiador(DDEntidadesAvalistas entidadBancariaFiador) {
		this.entidadBancariaFiador = entidadBancariaFiador;
	}

	public Double getImporteAval() {
		return importeAval;
	}

	public void setImporteAval(Double importeAval) {
		this.importeAval = importeAval;
	}

	public Integer getNumeroAval() {
		return numeroAval;
	}

	public void setNumeroAval(Integer numeroAval) {
		this.numeroAval = numeroAval;
	}

	public Boolean getRenunciaTanteo() {
		return renunciaTanteo;
	}

	public void setRenunciaTanteo(Boolean renunciaTanteo) {
		this.renunciaTanteo = renunciaTanteo;
	}

	public Boolean getCarencia() {
		return carencia;
	}

	public void setCarencia(Boolean carencia) {
		this.carencia = carencia;
	}

	public Boolean getBonificacion() {
		return bonificacion;
	}

	public void setBonificacion(Boolean bonificacion) {
		this.bonificacion = bonificacion;
	}

	public Boolean getGastosRepercutibles() {
		return gastosRepercutibles;
	}

	public void setGastosRepercutibles(Boolean gastosRepercutibles) {
		this.gastosRepercutibles = gastosRepercutibles;
	}

	public Integer getMesesCarencia() {
		return mesesCarencia;
	}

	public void setMesesCarencia(Integer mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}

	public Double getImporteCarencia() {
		return importeCarencia;
	}

	public void setImporteCarencia(Double importeCarencia) {
		this.importeCarencia = importeCarencia;
	}

	public Integer getMesesBonificacion() {
		return mesesBonificacion;
	}

	public void setMesesBonificacion(Integer mesesBonificacion) {
		this.mesesBonificacion = mesesBonificacion;
	}

	public Double getImporteBonificacion() {
		return importeBonificacion;
	}

	public void setImporteBonificacion(Double importeBonificacion) {
		this.importeBonificacion = importeBonificacion;
	}

	public Integer getDuracionBonificacion() {
		return duracionBonificacion;
	}

	public void setDuracionBonificacion(Integer duracionBonificacion) {
		this.duracionBonificacion = duracionBonificacion;
	}

	public String getRepercutiblesComments() {
		return repercutiblesComments;
	}

	public void setRepercutiblesComments(String repercutiblesComments) {
		this.repercutiblesComments = repercutiblesComments;
	}

	public String getEntidadComments() {
		return entidadComments;
	}

	public void setEntidadComments(String entidadComments) {
		this.entidadComments = entidadComments;
	}
	
	 public Date getFechaFirma() {
		return fechaFirma;
	}

	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	} 

	public Boolean getCheckFijo() {
		return checkFijo;
	}

	public void setCheckFijo(Boolean checkFijo) {
		this.checkFijo = checkFijo;
	}
	

	public Date getFechaFijo() {
		return fechaFijo;
	}

	public void setFechaFijo(Date fechaFijo) {
		this.fechaFijo = fechaFijo;
	}

	public Double getIncrementoRentaFijo() {
		return incrementoRentaFijo;
	}

	public void setIncrementoRentaFijo(Double incrementoRentaFijo) {
		this.incrementoRentaFijo = incrementoRentaFijo;
	}

	public Boolean getCheckPorcentual() {
		return checkPorcentual;
	}

	public void setCheckPorcentual(Boolean checkPorcentual) {
		this.checkPorcentual = checkPorcentual;
	}

	public Boolean getCheckIPC() {
		return checkIPC;
	}

	public void setCheckIPC(Boolean checkIPC) {
		this.checkIPC = checkIPC;
	}

	public Integer getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Integer porcentaje) {
		this.porcentaje = porcentaje;
	}

	public Boolean getCheckRevisionMercado() {
		return checkRevisionMercado;
	}

	public void setCheckRevisionMercado(Boolean checkRevisionMercado) {
		this.checkRevisionMercado = checkRevisionMercado;
	}

	public Date getRevisionMercadoFecha() {
		return revisionMercadoFecha;
	}

	public void setRevisionMercadoFecha(Date revisionMercadoFecha) {
		this.revisionMercadoFecha = revisionMercadoFecha;
	}

	public Integer getRevisionMercadoMeses() {
		return revisionMercadoMeses;
	}

	public void setRevisionMercadoMeses(Integer revisionMercadoMeses) {
		this.revisionMercadoMeses = revisionMercadoMeses;
	}

	public List<HistoricoCondicionanteExpediente> getListHistoricoCondiciones() {
		return listHistoricoCondiciones;
	}

	public void setListHistoricoCondiciones(List<HistoricoCondicionanteExpediente> listHistoricoCondiciones) {
		this.listHistoricoCondiciones = listHistoricoCondiciones;
	}
	
	
	public DDEntidadFinanciera getEntidadFinanciera() {
		return entidadFinanciera;
	}

	public void setEntidadFinanciera(DDEntidadFinanciera entidadFinanciera) {
		this.entidadFinanciera = entidadFinanciera;
	}

	public Boolean getTributosSobrePropiedad() {
		return tributosSobrePropiedad;
	}

	public void setTributosSobrePropiedad(Boolean tributosSobrePropiedad) {
		this.tributosSobrePropiedad = tributosSobrePropiedad;
	}

	public String getOtraEntidadFinaciera() {
		return otraEntidadFinaciera;
	}

	public void setOtraEntidadFinaciera(String otraEntidadFinaciera) {
		this.otraEntidadFinaciera = otraEntidadFinaciera;
	}

	public Boolean getFianzaExonerada() {
		return fianzaExonerada;
	}

	public void setFianzaExonerada(Boolean fianzaExonerada) {
		this.fianzaExonerada = fianzaExonerada;
	}

	public Double getObligadoCumplimiento() {
		return obligadoCumplimiento;
	}

	public void setObligadoCumplimiento(Double obligadoCumplimiento) {
		this.obligadoCumplimiento = obligadoCumplimiento;
	}

	public Date getFechaVencimientoAval() {
		return fechaVencimientoAval;
	}

	public void setFechaVencimientoAval(Date fechaVencimientoAval) {
		this.fechaVencimientoAval = fechaVencimientoAval;
	}

	public Boolean getAdecuaciones() {
		return adecuaciones;
	}

	public void setAdecuaciones(Boolean adecuaciones) {
		this.adecuaciones = adecuaciones;
	}

	public Boolean getCertificaciones() {
		return certificaciones;
	}

	public void setCertificaciones(Boolean certificaciones) {
		this.certificaciones = certificaciones;
	}

	public Boolean getDerechoCesionSubarriendo() {
		return derechoCesionSubarriendo;
	}

	public void setDerechoCesionSubarriendo(Boolean derechoCesionSubarriendo) {
		this.derechoCesionSubarriendo = derechoCesionSubarriendo;
	}

	public Date getFechaPreavisoVencimientoCnt() {
		return fechaPreavisoVencimientoCnt;
	}

	public void setFechaPreavisoVencimientoCnt(Date fechaPreavisoVencimientoCnt) {
		this.fechaPreavisoVencimientoCnt = fechaPreavisoVencimientoCnt;
	}

	public Date getFechaIngresoFianzaArrendatario() {
		return fechaIngresoFianzaArrendatario;
	}

	public void setFechaIngresoFianzaArrendatario(Date fechaIngresoFianzaArrendatario) {
		this.fechaIngresoFianzaArrendatario = fechaIngresoFianzaArrendatario;
	}

	public Boolean getAntiguoDeudorLocalizable() {
		return antiguoDeudorLocalizable;
	}

	public void setAntiguoDeudorLocalizable(Boolean antiguoDeudorLocalizable) {
		this.antiguoDeudorLocalizable = antiguoDeudorLocalizable;
	}

	public Boolean getCntSuscritoPosteridadAdj() {
		return cntSuscritoPosteridadAdj;
	}

	public void setCntSuscritoPosteridadAdj(Boolean cntSuscritoPosteridadAdj) {
		this.cntSuscritoPosteridadAdj = cntSuscritoPosteridadAdj;
	}

	public Boolean getOfrNuevasCondiciones() {
		return ofrNuevasCondiciones;
	}

	public void setOfrNuevasCondiciones(Boolean ofrNuevasCondiciones) {
		this.ofrNuevasCondiciones = ofrNuevasCondiciones;
	}

	public Boolean getEntregasCuenta() {
		return entregasCuenta;
	}

	public void setEntregasCuenta(Boolean entregasCuenta) {
		this.entregasCuenta = entregasCuenta;
	}

	public Double getImporteEntregasCuenta() {
		return importeEntregasCuenta;
	}

	public void setImporteEntregasCuenta(Double importeEntregasCuenta) {
		this.importeEntregasCuenta = importeEntregasCuenta;
	}

	public Boolean getRentasCuenta() {
		return rentasCuenta;
	}

	public void setRentasCuenta(Boolean rentasCuenta) {
		this.rentasCuenta = rentasCuenta;
	}

	public Boolean getFianzaContratosSubrogados() {
		return fianzaContratosSubrogados;
	}

	public void setFianzaContratosSubrogados(Boolean fianzaContratosSubrogados) {
		this.fianzaContratosSubrogados = fianzaContratosSubrogados;
	}

	public Boolean getVulnerabilidadDetectada() {
		return vulnerabilidadDetectada;
	}

	public void setVulnerabilidadDetectada(Boolean vulnerabilidadDetectada) {
		this.vulnerabilidadDetectada = vulnerabilidadDetectada;
	}

	public DDRegimenFianzaCCAA getRegimenFianzaCCAA() {
		return regimenFianzaCCAA;
	}

	public void setRegimenFianzaCCAA(DDRegimenFianzaCCAA regimenFianzaCCAA) {
		this.regimenFianzaCCAA = regimenFianzaCCAA;
	}

	public DDMetodoActualizacionRenta getMetodoActualizacionRenta() {
		return metodoActualizacionRenta;
	}

	public void setMetodoActualizacionRenta(DDMetodoActualizacionRenta metodoActualizacionRenta) {
		this.metodoActualizacionRenta = metodoActualizacionRenta;
	}

	public Boolean getCheckIGC() {
		return checkIGC;
	}

	public void setCheckIGC(Boolean checkIGC) {
		this.checkIGC = checkIGC;
	}

	public Long getPeriodicidadMeses() {
		return periodicidadMeses;
	}

	public void setPeriodicidadMeses(Long periodicidadMeses) {
		this.periodicidadMeses = periodicidadMeses;
	}

	public Date getFechaActualizacion() {
		return fechaActualizacion;
	}

	public void setFechaActualizacion(Date fechaActualizacion) {
		this.fechaActualizacion = fechaActualizacion;
	}

	public DDRangoImpuesto getRangoImpuesto() {
		return rangoImpuesto;
	}

	public void setRangoImpuesto(DDRangoImpuesto rangoImpuesto) {
		this.rangoImpuesto = rangoImpuesto;
	}

	public DDGrupoImpuesto getTipoGrupoImpuesto() {
		return tipoGrupoImpuesto;
	}

	public void setTipoGrupoImpuesto(DDGrupoImpuesto tipoGrupoImpuesto) {
		this.tipoGrupoImpuesto = tipoGrupoImpuesto;
	}

	public Boolean getScoringBc() {
		return scoringBc;
	}

	public void setScoringBc(Boolean scoringBc) {
		this.scoringBc = scoringBc;
	}

	public Boolean getAvalBc() {
		return avalBc;
	}

	public void setAvalBc(Boolean avalBc) {
		this.avalBc = avalBc;
	}

	public Boolean getSeguroRentasBc() {
		return seguroRentasBc;
	}

	public void setSeguroRentasBc(Boolean seguroRentasBc) {
		this.seguroRentasBc = seguroRentasBc;
	}

	public Date getFechaVencimientoAvalBc() {
		return fechaVencimientoAvalBc;
	}

	public void setFechaVencimientoAvalBc(Date fechaVencimientoAvalBc) {
		this.fechaVencimientoAvalBc = fechaVencimientoAvalBc;
	}

	public Integer getMesesAval() {
		return mesesAval;
	}

	public void setMesesAval(Integer mesesAval) {
		this.mesesAval = mesesAval;
	}

	public Integer getMesesDuracion() {
		return mesesDuracion;
	}

	public void setMesesDuracion(Integer mesesDuracion) {
		this.mesesDuracion = mesesDuracion;
	}

	public Boolean getCheckDeposito() {
		return checkDeposito;
	}

	public void setCheckDeposito(Boolean checkDeposito) {
		this.checkDeposito = checkDeposito;
	}

}
