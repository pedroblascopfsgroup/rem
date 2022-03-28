package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.*;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDClaseContratoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacionContratoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadFinanciera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoJustificacionOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableDocumentacionCliente;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDRiesgoOperacion;
import es.pfsgroup.plugin.rem.model.dd.DDSistemaOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSnsSiNoNosabe;
import es.pfsgroup.plugin.rem.model.dd.DDTfnTipoFinanciacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;


/**
 * Modelo que gestiona la informacion de una oferta
 *
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "OFR_OFERTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Oferta implements Serializable, Auditable {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "OFR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaGenerator")
    @SequenceGenerator(name = "OfertaGenerator", sequenceName = "S_OFR_OFERTAS")
    private Long id;

    @Column(name = "OFR_WEBCOM_ID")
    private Long idWebCom;

    @Column(name = "OFR_NUM_OFERTA")
    private Long numOferta;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;

	@Column(name="OFR_IMPORTE")
	private Double importeOferta;

	@Column(name="OFR_IMPORTE_CONTRAOFERTA")
	private Double importeContraOferta;

	@Column(name="OFR_FECHA_CONTRAOFERTA")
	private Date fechaContraoferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EOF_ID")
	private DDEstadoOferta estadoOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MRO_ID")
	private DDMotivoRechazoOferta motivoRechazo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EVO_ID")
	private DDEstadosVisitaOferta estadoVisitaOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TOF_ID")
	private DDTipoOferta tipoOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CLC_ID")
    private ClienteComercial cliente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "VIS_ID")
    private Visita visita;

    @Column(name = "OFR_FECHA_ACCION")
    private Date fechaAccion;

    @Column(name = "OFR_USUARIO_BAJA")
    private String usuarioBaja;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuarioAccion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_PRESCRIPTOR")
	private ActivoProveedor prescriptor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_API_RESPONSABLE")
	private ActivoProveedor apiResponsable;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_CUSTODIO")
	private ActivoProveedor custodio;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_FDV")
	private ActivoProveedor fdv;

    @OneToOne(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ExpedienteComercial expedienteComercial;
    
    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TitularesAdicionalesOferta> titularesAdicionales;

    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TextosOferta> textos;

    @OneToMany(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private List<ActivoOferta> activosOferta;

    @OneToMany(mappedBy = "ofertaPrincipal", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    //@JoinColumn(name = "OFR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<OfertasAgrupadasLbk> ofertasAgrupadas;

    @OneToOne(mappedBy = "ofertaDependiente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private OfertasAgrupadasLbk ofertaDependiente;   

	@Column(name="OFR_FECHA_RESPUESTA_OFERTANTE_CES")
   	private Date fechaRespuestaCES;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ORIGEN")
	private DDSistemaOrigen origen;

    @Column(name = "OFR_FECHA_ALTA")
    private Date fechaAlta;

    @Column(name = "OFR_FECHA_NOTIFICACION")
    private Date fechaNotificacion;

	@Column(name="OFR_IMPORTE_APROBADO")
	private Double importeOfertaAprobado;

	@Column(name="OFR_IND_LOTE_RESTRINGIDO")
	private Integer indicadorLoteRestringido;

	@Column(name="OFR_FECHA_RECHAZO")
	private Date fechaRechazoOferta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAP_ID")
	private DDCanalPrescripcion canalPrescripcion;

    // Datos de Tanteo y Retracto ----- TR
	@Column(name="OFR_DESDE_TANTEO")
	private Boolean desdeTanteo;

	@Column(name="OFR_CONDICIONES_TX")
	private String condicionesTransmision;

	@Column(name="OFR_FECHA_COMUNIC_REG")
	private Date fechaComunicacionReg;

	@Column(name="OFR_FECHA_CONTESTACION")
	private Date fechaContestacion;

	@Column(name="OFR_FECHA_SOLICITUD_VISITA")
	private Date fechaSolicitudVisita;

	@Column(name="OFR_FECHA_REALIZACION_VISITA")
	private Date fechaRealizacionVisita;

	@Column(name="OFR_FECHA_HASTA_TANTEO")
	private Date fechaFinTanteo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_DRT_ID")
	private DDResultadoTanteo resultadoTanteo;

	@Column(name="OFR_INTENCION_FINANCIAR")
	private Integer intencionFinanciar;

	@Column(name="OFR_FECHA_MAX_FORMALIZACION")
	private Date plazoMaxFormalizacion;
	//----- TR

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID_SUCURSAL")
	private ActivoProveedor sucursal;

    @Column(name="OFR_OFERTA_EXPRESS")
	private Boolean ofertaExpress;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="OFR_NECESITA_FINANCIACION")
	private DDSnsSiNoNosabe necesitaFinanciar;

    @Column(name="OFR_OBSERVACIONES")
	private String observaciones;

    @Column(name = "OFR_UVEM_ID")
    private Long idUvem;

    @Column(name = "OFR_VENTA_DIRECTA")
    private Boolean ventaDirecta = false;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
	private DDTipoAlquiler tipoAlquiler;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPI_ID")
	private DDTipoInquilino tipoInquilino;

	@Column(name="OFR_CONTRATO_PRINEX")
	private String numContratoPrinex;

	@Column(name="OFR_REF_CIRCUITO_CLIENTE")
	private String refCircuitoCliente;

	@Column(name="OFR_IMP_CONTRAOFERTA_PM")
	private Double importeContraofertaPM;

	@Column(name="OFR_FECHA_RESPUESTA_PM")
	private Date fechaRespuestaPM;

	@Column(name="OFR_FECHA_RESPUESTA_OFERTANTE_PM")
	private Date fechaRespuestaOfertantePM;

	@Column(name="OFR_IMP_CONTRAOFERTA_CES")
	private Double importeContraofertaCES;

	@Column(name="OFR_FECHA_RESOLUCION_CES")
	private Date fechaResolucionCES;

   	@Column(name="OFR_FECHA_RESPUESTA")
   	private Date fechaRespuesta;

   	@Column(name="OFR_FECHA_APROBACION_PRO_MANZANA")
   	private Date fechaAprobacionProManzana;	

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CLO_ID")
	private DDClaseOferta claseOferta;  

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ORC_ID")
	private DDOrigenComprador origenComprador;

	@ManyToOne
	@JoinColumn(name = "OFR_GES_COM_PRES")
	private Usuario gestorComercialPrescriptor;
	
	@Column(name = "OFR_CONTRAOFERTA_OFERTANTE_CES")
	private Double importeContraofertaOfertanteCES;
	
	@Column(name="OFR_OFERTA_SINGULAR")
	private Boolean ofertaSingular;
	
	@Column(name="OFR_FECHA_ORI_LEAD")
	private Date fechaOrigenLead;
	
	@Column(name="OFR_COD_TIPO_PROV_ORI_LEAD")
	private String codTipoProveedorOrigenCliente;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="OFR_ID_PRES_ORI_LEAD")
	private ActivoProveedor proveedorPrescriptorRemOrigenLead;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="OFR_ID_REALIZA_ORI_LEAD")
	private ActivoProveedor proveedorRealizadorRemOrigenLead;
	
	@Column(name = "OFR_OFERTA_ESPECIAL")
    private Boolean ofertaEspecial;
	
	@Column(name = "OFR_VENTA_CARTERA")
    private Boolean ventaCartera;
    
	@Column(name = "OFR_VENTA_SOBRE_PLANO")
    private Boolean ventaSobrePlano;
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_ROP_ID")
    private DDRiesgoOperacion riesgoOperacion;
	
	@Column(name = "ID_OFERTA_ORIGEN")
    private Long idOfertaOrigen;
	
	@Column(name = "OFR_RECOMENDACION_RC")
    private String ofrRecomendacionRc;
	
	@Column(name = "OFR_FECHA_RECOMENDACION_RC")
    private Date ofrFechaRecomendacionRc;
	
	@Column(name = "OFR_RECOMENDACION_DC")
    private String ofrRecomendacionDc;
	
	@Column(name = "OFR_FECHA_RECOMENDACION_DC")
    private Date ofrFechaRecomendacionDc;
	
	@Column(name="OFR_FECHA_CREACION_OP_SF")
	private Date fechaCreacionOpSf;

	@Column(name = "FECHA_ENT_CRM_SF")
    private Date fechaEntradaCRMSF;	

	@Column(name = "OFR_DOC_RESP_PRESCRIPTOR")
    private Boolean ofrDocRespPrescriptor;
	@Column(name = "OFR_SOSPECHOSA")
    private Boolean ofertaSospechosa;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RDC_ID")
    private DDResponsableDocumentacionCliente respDocCliente;
	
	@Column(name = "OFR_HAYA_HOME_ID")
    private Long idOfertaHayaHome;
	
	@Column(name = "OFR_ORIGEN_OFERTA")
    private String codOrigenOferta;
	
	@Column(name = "OFR_MESES_CARENCIA")
    private Double mesesCarencia;
	
	@Column(name = "OFR_CONTRATO_RESERVA")
    private Boolean tieneContratoReserva;
	
	@Column(name = "OFR_MOTIVO_CONGELACION")
    private String motivoCongelacion;
	
	@Column(name = "OFR_IBI")
    private Boolean tieneIBI;
	
	@Column(name = "OFR_IMPORTE_IBI")
    private Double importeIBI;
	
	@Column(name = "OFR_OTRAS_TASAS")
    private Boolean tieneOtrasTasas;
	
	@Column(name = "OFR_IMPORTE_OTRAS_TASAS")
    private Double importeOtrasTasas;
	
	@Column(name = "OFR_CCPP")
    private Boolean tieneCCPP;
	
	@Column(name = "OFR_IMPORTE_CCPP")
    private Double importeCCPP;
	
	@Column(name = "OFR_PORCENTAJE_1_ANYO")
    private Double bonificacionAnyo1;
	
	@Column(name = "OFR_PORCENTAJE_2_ANYO")
    private Double bonificacionAnyo2;
	
	@Column(name = "OFR_PORCENTAJE_3_ANYO")
    private Double bonificacionAnyo3;
	
	@Column(name = "OFR_PORCENTAJE_4_ANYO")
    private Double bonificacionAnyo4;
	
	@Column(name = "OFR_MESES_CARENCIA_CTRAOFR")
    private Double mesesCarenciaContraoferta;

	@Column(name = "OFR_PORCENTAJE_1_ANYO_CTRAOFR")
    private Double bonificacionAnyo1Contraoferta;
	
	@Column(name = "OFR_PORCENTAJE_2_ANYO_CTRAOFR")
    private Double bonificacionAnyo2Contraoferta;
	
	@Column(name = "OFR_PORCENTAJE_3_ANYO_CTRAOFR")
    private Double bonificacionAnyo3Contraoferta;
	
	@Column(name = "OFR_PORCENTAJE_4_ANYO_CTRAOFR")
    private Double bonificacionAnyo4Contraoferta;
	
	@Column(name = "OFR_SALESFORCE_COD")
    private String codOfertaSalesforce;
	
	@Column(name = "OFR_SALESFORCE_ID")
	private String idOfertaSalesforce;
	
	@Column(name = "OFR_FECHA_APR_GARANTIAS_APORTADAS")
    private Date fechaAprobacionGarantiasAportadas;
	
	@Column(name = "OFR_FECHA_PRIMER_VENCIMIENTO")
    private Date fechaPrimerVencimiento;

	@Column(name = "OFR_FECHA_INICIO_CONTRATO")
    private Date fechaInicioContrato;
	
	@Column(name = "OFR_FECHA_FIN_CONTRATO")
    private Date fechaFinContrato;
	
	@Column(name = "OFR_ALQUILER_OPCION_COMPRA")
    private Boolean opcionACompra;
	
	@Column(name = "OFR_VALOR_OPCION_COMPRA")
    private Double valorCompra;
	
	@Column(name = "OFR_FECHA_VENC_OPCION_COMPRA")
    private Date fechaVencimientoOpcionCompra;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CCA_ID")
	private DDClaseContratoAlquiler claseContratoAlquiler;  
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAL_ID")
	private DDClasificacionContratoAlquiler clasificacion;  
	
	@Column(name = "OFR_CHECK_DOCUMENTACION")
    private Boolean checkDocumentacion;
	
	@Column(name = "OFR_FECHA_ALTA_WEBCOM")
	private Date fechaAltaWebcom;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TOA_ID")
	private DDTipoOfertaAlquiler tipoOfertaAlquiler;

	@Column(name="OFR_FECHA_OFERTA_PENDIENTE")
	private Date fechaOfertaPendiente;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_TFN_ID")
	private DDTfnTipoFinanciacion tipologiaFinanciacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_ETF_ID")
	private DDEntidadFinanciera entidadFinanciera;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MJO_ID")
	private DDMotivoJustificacionOferta motivoJustificacionOferta;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_TITULARES_CONFIRMADOS")
    private DDSinSiNo titularesConfirmadosSINo;

    @OneToOne(mappedBy = "oferta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private OfertaCaixa ofertaCaixa;

	@Transient
	private Boolean replicateBC;


	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdWebCom() {
		return idWebCom;
	}

	public void setIdWebCom(Long idWebCom) {
		this.idWebCom = idWebCom;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public DDEstadoOferta getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(DDEstadoOferta estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public DDMotivoRechazoOferta getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(DDMotivoRechazoOferta motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public DDEstadosVisitaOferta getEstadoVisitaOferta() {
		return estadoVisitaOferta;
	}

	public void setEstadoVisitaOferta(DDEstadosVisitaOferta estadoVisitaOferta) {
		this.estadoVisitaOferta = estadoVisitaOferta;
	}

	public DDTipoOferta getTipoOferta() {
		return tipoOferta;
	}

	public void setTipoOferta(DDTipoOferta tipoOferta) {
		this.tipoOferta = tipoOferta;
	}

	public ClienteComercial getCliente() {
		return cliente;
	}

	public void setCliente(ClienteComercial cliente) {
		this.cliente = cliente;
	}

	public Visita getVisita() {
		return visita;
	}

	public void setVisita(Visita visita) {
		this.visita = visita;
	}

	public Date getFechaAccion() {
		return fechaAccion;
	}

	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}

	public Usuario getUsuarioAccion() {
		return usuarioAccion;
	}

	public void setUsuarioAccion(Usuario usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}

	public ActivoProveedor getPrescriptor() {
		return prescriptor;
	}

	public void setPrescriptor(ActivoProveedor prescriptor) {
		this.prescriptor = prescriptor;
	}

	public List<TitularesAdicionalesOferta> getTitularesAdicionales() {
		return titularesAdicionales;
	}

	public void setTitularesAdicionales(
			List<TitularesAdicionalesOferta> titularesAdicionales) {
		this.titularesAdicionales = titularesAdicionales;
	}

	public List<TextosOferta> getTextos() {
		return textos;
	}

	public void setTextos(List<TextosOferta> textos) {
		this.textos = textos;
	}

	public List<ActivoOferta> getActivosOferta() {

		if(activosOferta == null) activosOferta = new ArrayList<ActivoOferta>();

		return activosOferta;
	}

	public void setActivosOferta(List<ActivoOferta> activosOferta) {
		this.activosOferta = activosOferta;
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

	/**
	 * Devuelve un activo. El activo principal si es una agrupación,
	 * el primer y único activo relacionado con la oferta si no es agrupación.
	 * @return Activo activo
	 */
	public Activo getActivoPrincipal() {

		Activo activo = null;

		if(!Checks.esNulo(this.getAgrupacion())) {
			activo = this.getAgrupacion().getActivoPrincipal();
			if(Checks.esNulo(activo)) {
				List<ActivoAgrupacionActivo> listaActivosAgrupacion = this.getAgrupacion().getActivos();
				if(!Checks.estaVacio(listaActivosAgrupacion)){
					activo = listaActivosAgrupacion.get(0).getActivo();
				} else {
					activo = this.getActivosOferta().get(0).getPrimaryKey().getActivo();
				}
			}
		}else if(!Checks.esNulo(this.getActivosOferta()) && !this.getActivosOferta().isEmpty()) {
			activo = this.getActivosOferta().get(0).getPrimaryKey().getActivo();
		}
		return activo;

	}

	public Double getImporteContraOferta() {
		return importeContraOferta;
	}

	public void setImporteContraOferta(Double importeContraOferta) {
		this.importeContraOferta = importeContraOferta;
	}

	public Date getFechaContraoferta() {
		return fechaContraoferta;
	}

	public void setFechaContraoferta(Date fechaContraoferta) {
		this.fechaContraoferta = fechaContraoferta;
	}

	public ActivoProveedor getApiResponsable() {
		return apiResponsable;
	}

	public void setApiResponsable(ActivoProveedor apiResponsable) {
		this.apiResponsable = apiResponsable;
	}

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public ActivoProveedor getCustodio() {
		return custodio;
	}

	public void setCustodio(ActivoProveedor custodio) {
		this.custodio = custodio;
	}

	public ActivoProveedor getFdv() {
		return fdv;
	}

	public void setFdv(ActivoProveedor fdv) {
		this.fdv = fdv;
	}

	public Double getImporteOfertaAprobado() {
		return importeOfertaAprobado;
	}

	public void setImporteOfertaAprobado(Double importeOfertaAprobado) {
		this.importeOfertaAprobado = importeOfertaAprobado;
	}

	public Integer getIndicadorLoteRestringido() {
		return indicadorLoteRestringido;
	}

	public void setIndicadorLoteRestringido(Integer indicadorLoteRestringido) {
		this.indicadorLoteRestringido = indicadorLoteRestringido;
	}

	public Date getFechaRechazoOferta() {
		return fechaRechazoOferta;
	}

	public void setFechaRechazoOferta(Date fechaRechazoOferta) {
		this.fechaRechazoOferta = fechaRechazoOferta;
	}

	public DDCanalPrescripcion getCanalPrescripcion() {
		return canalPrescripcion;
	}

	public void setCanalPrescripcion(DDCanalPrescripcion canalPrescripcion) {
		this.canalPrescripcion = canalPrescripcion;
	}

	public String getCondicionesTransmision() {
		return condicionesTransmision;
	}

	public void setCondicionesTransmision(String condicionesTransmision) {
		this.condicionesTransmision = condicionesTransmision;
	}

	public Date getFechaComunicacionReg() {
		return fechaComunicacionReg;
	}

	public void setFechaComunicacionReg(Date fechaComunicacionReg) {
		this.fechaComunicacionReg = fechaComunicacionReg;
	}

	public Date getFechaContestacion() {
		return fechaContestacion;
	}

	public void setFechaContestacion(Date fechaContestacion) {
		this.fechaContestacion = fechaContestacion;
	}

	public Date getFechaSolicitudVisita() {
		return fechaSolicitudVisita;
	}

	public void setFechaSolicitudVisita(Date fechaSolicitudVisita) {
		this.fechaSolicitudVisita = fechaSolicitudVisita;
	}

	public Date getFechaRealizacionVisita() {
		return fechaRealizacionVisita;
	}

	public void setFechaRealizacionVisita(Date fechaRealizacionVisita) {
		this.fechaRealizacionVisita = fechaRealizacionVisita;
	}

	public Date getFechaFinTanteo() {
		return fechaFinTanteo;
	}

	public void setFechaFinTanteo(Date fechaFinTanteo) {
		this.fechaFinTanteo = fechaFinTanteo;
	}

	public DDResultadoTanteo getResultadoTanteo() {
		return resultadoTanteo;
	}

	public void setResultadoTanteo(DDResultadoTanteo resultadoTanteo) {
		this.resultadoTanteo = resultadoTanteo;
	}

	public Date getPlazoMaxFormalizacion() {
		return plazoMaxFormalizacion;
	}

	public void setPlazoMaxFormalizacion(Date plazoMaxFormalizacion) {
		this.plazoMaxFormalizacion = plazoMaxFormalizacion;
	}

	public Boolean getDesdeTanteo() {
		return desdeTanteo;
	}

	public void setDesdeTanteo(Boolean desdeTanteo) {
		this.desdeTanteo = desdeTanteo;
	}

	public Integer getIntencionFinanciar() {
		return intencionFinanciar;
	}

	public void setIntencionFinanciar(Integer intencionFinanciar) {
		this.intencionFinanciar = intencionFinanciar;
	}

	public ActivoProveedor getSucursal() {
		return sucursal;
	}

	public void setSucursal(ActivoProveedor sucursal) {
		this.sucursal = sucursal;
	}

	public String getUsuarioBaja() {
		return usuarioBaja;
	}

	public void setUsuarioBaja(String usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
	}

	public DDSistemaOrigen getOrigen() {
		return origen;
	}

	public void setOrigen(DDSistemaOrigen origen) {
		this.origen = origen;
	}

	public Boolean getOfertaExpress() {
		return ofertaExpress == null ? false : ofertaExpress;
	}

	public void setOfertaExpress(Boolean ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public DDSnsSiNoNosabe getNecesitaFinanciar() {
		return necesitaFinanciar;
	}

	public void setNecesitaFinanciar(DDSnsSiNoNosabe necesitaFinanciacion) {
		this.necesitaFinanciar = necesitaFinanciacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getIdUvem() {
		return idUvem;
	}

	public void setIdUvem(Long idUvem) {
		this.idUvem = idUvem;
	}

	public Boolean getVentaDirecta() {
		if(ventaDirecta == null){
			return false;
		}else{
			return ventaDirecta;
		}

	}

	public void setVentaDirecta(Boolean ventaDirecta) {
		this.ventaDirecta = ventaDirecta;
	}

	public DDTipoAlquiler getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(DDTipoAlquiler tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}

	public DDTipoInquilino getTipoInquilino() {
		return tipoInquilino;
	}

	public void setTipoInquilino(DDTipoInquilino tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}

	public String getNumContratoPrinex() {
		return numContratoPrinex;
	}

	public void setNumContratoPrinex(String numContratoPrinex) {
		this.numContratoPrinex = numContratoPrinex;
	}

	public String getRefCircuitoCliente() {
		return refCircuitoCliente;
	}

	public void setRefCircuitoCliente(String refCircuitoCliente) {
		this.refCircuitoCliente = refCircuitoCliente;
	}


	public Usuario getGestorComercialPrescriptor() {
		return gestorComercialPrescriptor;
	}

	public void setGestorComercialPrescriptor(Usuario gestorComercialPrescriptor) {
		this.gestorComercialPrescriptor = gestorComercialPrescriptor;
	}

	public Double getImporteContraofertaPM() {
		return importeContraofertaPM;
	}

	public void setImporteContraofertaPM(Double importeContraofertaPM) {
		this.importeContraofertaPM = importeContraofertaPM;
	}

	public Date getFechaRespuestaPM() {
		return fechaRespuestaPM;
	}

	public void setFechaRespuestaPM(Date fechaRespuestaPM) {
		this.fechaRespuestaPM = fechaRespuestaPM;
	}

	public Date getFechaRespuestaOfertantePM() {
		return fechaRespuestaOfertantePM;
	}

	public void setFechaRespuestaOfertantePM(Date fechaRespuestaOfertantePM) {
		this.fechaRespuestaOfertantePM = fechaRespuestaOfertantePM;
	}

	public Double getImporteContraofertaCES() {
		return importeContraofertaCES;
	}

	public void setImporteContraofertaCES(Double importeContraofertaCES) {
		this.importeContraofertaCES = importeContraofertaCES;
	}

	public Date getFechaResolucionCES() {
		return fechaResolucionCES;
	}

	public void setFechaResolucionCES(Date fechaResolucionCES) {
		this.fechaResolucionCES = fechaResolucionCES;
	}

	public Date getFechaRespuestaCES() {
			return fechaRespuestaCES;
	}
	public void setFechaRespuestaCES(Date fechaRespuestaCES) {
		this.fechaRespuestaCES = fechaRespuestaCES;
	}

	public Date getFechaRespuesta() {
		return fechaRespuesta;
	}

	public void setFechaRespuesta(Date fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
	}

	public Date getFechaAprobacionProManzana() {
		return fechaAprobacionProManzana;
	}

	public void setFechaAprobacionProManzana(Date fechaAprobacionProManzana) {
		this.fechaAprobacionProManzana = fechaAprobacionProManzana;
	}
	public DDClaseOferta getClaseOferta() {
		return claseOferta;
	}

	public void setClaseOferta(DDClaseOferta claseOferta) {
		this.claseOferta = claseOferta;
	}

	public List<OfertasAgrupadasLbk> getOfertasAgrupadas() {
		if(ofertasAgrupadas == null) ofertasAgrupadas = new ArrayList<OfertasAgrupadasLbk>(); 
		return ofertasAgrupadas;
	}

	public void setOfertasAgrupadas(List<OfertasAgrupadasLbk> ofertasAgrupadas) {
		this.ofertasAgrupadas = ofertasAgrupadas;
	}

	public OfertasAgrupadasLbk getOfertaDependiente() {
		return ofertaDependiente;
	}

	public void setOfertaDependiente(OfertasAgrupadasLbk ofertaDependiente) {
		this.ofertaDependiente = ofertaDependiente;
	}	

	public DDOrigenComprador getOrigenComprador() {
		return origenComprador;
	}

	public void setOrigenComprador(DDOrigenComprador origenComprador) {
		this.origenComprador = origenComprador;
	}

	public Double getImporteContraofertaOfertanteCES() {
		return importeContraofertaOfertanteCES;
	}

	public void setImporteContraofertaOfertanteCES(Double importeContraofertaOfertanteCES) {
		this.importeContraofertaOfertanteCES = importeContraofertaOfertanteCES;
	}
	
	public Boolean getOfertaSingular() {
		return ofertaSingular;
	}

	public void setOfertaSingular(Boolean ofertaSingular) {
		this.ofertaSingular = ofertaSingular;
	}

	public Date getFechaOrigenLead() {
		return fechaOrigenLead;
	}

	public void setFechaOrigenLead(Date fechaOrigenLead) {
		this.fechaOrigenLead = fechaOrigenLead;
	}

	public String getCodTipoProveedorOrigenCliente() {
		return codTipoProveedorOrigenCliente;
	}

	public void setCodTipoProveedorOrigenCliente(String codTipoProveedorOrigenCliente) {
		this.codTipoProveedorOrigenCliente = codTipoProveedorOrigenCliente;
	}

	public ActivoProveedor getProveedorPrescriptorRemOrigenLead() {
		return proveedorPrescriptorRemOrigenLead;
	}

	public void setProveedorPrescriptorRemOrigenLead(ActivoProveedor proveedorPrescriptorRemOrigenLead) {
		this.proveedorPrescriptorRemOrigenLead = proveedorPrescriptorRemOrigenLead;
	}

	public ActivoProveedor getProveedorRealizadorRemOrigenLead() {
		return proveedorRealizadorRemOrigenLead;
	}

	public void setProveedorRealizadorRemOrigenLead(ActivoProveedor proveedorRealizadorRemOrigenLead) {
		this.proveedorRealizadorRemOrigenLead = proveedorRealizadorRemOrigenLead;
	}
	
	public Boolean getOfertaEspecial() {
		return ofertaEspecial;
	}

	public void setOfertaEspecial(Boolean ofertaEspecial) {
		this.ofertaEspecial = ofertaEspecial;
	}
	
	public Long getIdOfertaOrigen() {
		return this.idOfertaOrigen;
	}
	
	public void setIdOfertaOrigen(Long idOfertaOrigen) {
		this.idOfertaOrigen = idOfertaOrigen;
	}
	
	public String getOfrRecomendacionRc() {
		return this.ofrRecomendacionRc;
	}
	
	public void setOfrRecomendacionRc(String ofrRecomendacionRc) {
		this.ofrRecomendacionRc = ofrRecomendacionRc;
	}
	
	public Date getOfrFechaRecomendacionRc() {
		return this.ofrFechaRecomendacionRc;
	}
	
	public void setOfrFechaRecomendacionRc(Date ofrFechaRecomendacionRc) {
		this.ofrFechaRecomendacionRc = ofrFechaRecomendacionRc;
	}
	
	public String getOfrRecomendacionDc() {
		return this.ofrRecomendacionDc;
	}
	
	public void setOfrRecomendacionDc(String ofrRecomendacionDc) {
		this.ofrRecomendacionDc = ofrRecomendacionDc;
	}
	
	public Date getOfrFechaRecomendacionDc() {
		return this.ofrFechaRecomendacionDc;
	}
	
	public void setOfrFechaRecomendacionDc(Date ofrFechaRecomendacionDc) {
		this.ofrFechaRecomendacionDc = ofrFechaRecomendacionDc;
	}

	public Date getFechaCreacionOpSf() {
		return fechaCreacionOpSf;
	}

	public void setFechaCreacionOpSf(Date fechaCreacionOpSf) {
		this.fechaCreacionOpSf = fechaCreacionOpSf;
	}
		
	public Date getFechaEntradaCRMSF() {
		return fechaEntradaCRMSF;
	}

	public void setFechaEntradaCRMSF(Date fechaEntradaCRMSF) {
		this.fechaEntradaCRMSF = fechaEntradaCRMSF;
	}
	
	public Boolean getOfrDocRespPrescriptor() {
		return ofrDocRespPrescriptor;
	}

	public void setOfrDocRespPrescriptor(Boolean ofrDocRespPrescriptor) {
		this.ofrDocRespPrescriptor = ofrDocRespPrescriptor;
	}

	public Boolean getOfertaSospechosa() {
		return ofertaSospechosa;
	}

	public void setOfertaSospechosa(Boolean ofertaSospechosa) {
		this.ofertaSospechosa = ofertaSospechosa;
	}

	public Boolean getVentaCartera() {
		return ventaCartera;
	}

	public void setVentaCartera(Boolean ventaCartera) {
		this.ventaCartera = ventaCartera;
	}

	public DDRiesgoOperacion getRiesgoOperacion() {
		return riesgoOperacion;
	}

	public void setRiesgoOperacion(DDRiesgoOperacion riesgoOperacion) {
		this.riesgoOperacion = riesgoOperacion;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Boolean getVentaSobrePlano() {
		return ventaSobrePlano;
	}

	public void setVentaSobrePlano(Boolean ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}
	public DDResponsableDocumentacionCliente getRespDocCliente() {
		return respDocCliente;
	}

	public void setRespDocCliente(DDResponsableDocumentacionCliente respDocCliente) {
		this.respDocCliente = respDocCliente;
	}

	public OfertaCaixa getOfertaCaixa() {
		return ofertaCaixa;
	}

	public void setOfertaCaixa(OfertaCaixa ofertaCaixa) {
		this.ofertaCaixa = ofertaCaixa;
	}
	
	public Date getFechaOfertaPendiente() {
		return fechaOfertaPendiente;
	}

	public void setFechaOfertaPendiente(Date fechaOfertaPendiente) {
		this.fechaOfertaPendiente = fechaOfertaPendiente;
	}
	
	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}

	public Date getFechaAprobacionGarantiasAportadas() {
		return fechaAprobacionGarantiasAportadas;
	}

	public void setFechaAprobacionGarantiasAportadas(Date fechaAprobacionGarantiasAportadas) {
		this.fechaAprobacionGarantiasAportadas = fechaAprobacionGarantiasAportadas;
	}

	public Date getFechaPrimerVencimiento() {
		return fechaPrimerVencimiento;
	}

	public void setFechaPrimerVencimiento(Date fechaPrimerVencimiento) {
		this.fechaPrimerVencimiento = fechaPrimerVencimiento;
	}

	public Date getFechaInicioContrato() {
		return fechaInicioContrato;
	}

	public void setFechaInicioContrato(Date fechaInicioContrato) {
		this.fechaInicioContrato = fechaInicioContrato;
	}

	public Date getFechaFinContrato() {
		return fechaFinContrato;
	}

	public void setFechaFinContrato(Date fechaFinContrato) {
		this.fechaFinContrato = fechaFinContrato;
	}

	public Boolean getOpcionACompra() {
		return opcionACompra;
	}

	public void setOpcionACompra(Boolean opcionACompra) {
		this.opcionACompra = opcionACompra;
	}

	public Double getValorCompra() {
		return valorCompra;
	}

	public void setValorCompra(Double valorCompra) {
		this.valorCompra = valorCompra;
	}

	public Date getFechaVencimientoOpcionCompra() {
		return fechaVencimientoOpcionCompra;
	}

	public void setFechaVencimientoOpcionCompra(Date fechaVencimientoOpcionCompra) {
		this.fechaVencimientoOpcionCompra = fechaVencimientoOpcionCompra;
	}

	public DDClaseContratoAlquiler getClaseContratoAlquiler() {
		return claseContratoAlquiler;
	}

	public void setClaseContratoAlquiler(DDClaseContratoAlquiler claseContratoAlquiler) {
		this.claseContratoAlquiler = claseContratoAlquiler;
	}

	public DDClasificacionContratoAlquiler getClasificacion() {
		return clasificacion;
	}

	public void setClasificacion(DDClasificacionContratoAlquiler clasificacion) {
		this.clasificacion = clasificacion;
	}

	public Boolean getCheckDocumentacion() {
		return checkDocumentacion;
	}

	public void setCheckDocumentacion(Boolean checkDocumentacion) {
		this.checkDocumentacion = checkDocumentacion;
	}

	public Date getFechaAltaWebcom() {
		return fechaAltaWebcom;
	}

	public void setFechaAltaWebcom(Date fechaAltaWebcom) {
		this.fechaAltaWebcom = fechaAltaWebcom;
	}

	public DDTipoOfertaAlquiler getTipoOfertaAlquiler() {
		return tipoOfertaAlquiler;
	}

	public void setTipoOfertaAlquiler(DDTipoOfertaAlquiler tipoOfertaAlquiler) {
		this.tipoOfertaAlquiler = tipoOfertaAlquiler;
	}
	
	public DDTfnTipoFinanciacion getTipologiaFinanciacion() {
		return tipologiaFinanciacion;
	}

	public void setTipologiaFinanciacion(DDTfnTipoFinanciacion tipoFinanciacion) {
		this.tipologiaFinanciacion = tipoFinanciacion;
	}

	public DDEntidadFinanciera getEntidadFinanciera() {
		return entidadFinanciera;
	}

	public void setEntidadFinanciera(DDEntidadFinanciera entidadFinanciera) {
		this.entidadFinanciera = entidadFinanciera;
	}
	
	public DDMotivoJustificacionOferta getMotivoJustificacionOferta() {
		return motivoJustificacionOferta;
	}

	public void setMotivoJustificacionOferta(DDMotivoJustificacionOferta motivoJustificacionOferta) {
		this.motivoJustificacionOferta = motivoJustificacionOferta;
	}
	
	public DDSinSiNo getTitularesConfirmadosSINo() {
		return titularesConfirmadosSINo;
	}

	public void setTitularesConfirmadosSINo(DDSinSiNo titularesConfirmados) {
		this.titularesConfirmadosSINo = titularesConfirmados;
	}
	
	public Long getIdOfertaHayaHome() {
		return idOfertaHayaHome;
	}

	public void setIdOfertaHayaHome(Long idOfertaHayaHome) {
		this.idOfertaHayaHome = idOfertaHayaHome;
	}

	public String getCodOrigenOferta() {
		return codOrigenOferta;
	}

	public void setCodOrigenOferta(String codOrigenOferta) {
		this.codOrigenOferta = codOrigenOferta;
	}

	public Double getMesesCarencia() {
		return mesesCarencia;
	}

	public void setMesesCarencia(Double mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}

	public Boolean getTieneContratoReserva() {
		return tieneContratoReserva;
	}

	public void setTieneContratoReserva(Boolean tieneContratoReserva) {
		this.tieneContratoReserva = tieneContratoReserva;
	}

	public String getMotivoCongelacion() {
		return motivoCongelacion;
	}

	public void setMotivoCongelacion(String motivoCongelacion) {
		this.motivoCongelacion = motivoCongelacion;
	}

	public Boolean getTieneIBI() {
		return tieneIBI;
	}

	public void setTieneIBI(Boolean tieneIBI) {
		this.tieneIBI = tieneIBI;
	}

	public Double getImporteIBI() {
		return importeIBI;
	}

	public void setImporteIBI(Double importeIBI) {
		this.importeIBI = importeIBI;
	}

	public Boolean getTieneOtrasTasas() {
		return tieneOtrasTasas;
	}

	public void setTieneOtrasTasas(Boolean tieneOtrasTasas) {
		this.tieneOtrasTasas = tieneOtrasTasas;
	}

	public Double getImporteOtrasTasas() {
		return importeOtrasTasas;
	}

	public void setImporteOtrasTasas(Double importeOtrasTasas) {
		this.importeOtrasTasas = importeOtrasTasas;
	}

	public Boolean getTieneCCPP() {
		return tieneCCPP;
	}

	public void setTieneCCPP(Boolean tieneCCPP) {
		this.tieneCCPP = tieneCCPP;
	}

	public Double getImporteCCPP() {
		return importeCCPP;
	}

	public void setImporteCCPP(Double importeCCPP) {
		this.importeCCPP = importeCCPP;
	}

	public Double getBonificacionAnyo1() {
		return bonificacionAnyo1;
	}

	public void setBonificacionAnyo1(Double bonificacionAnyo1) {
		this.bonificacionAnyo1 = bonificacionAnyo1;
	}

	public Double getBonificacionAnyo2() {
		return bonificacionAnyo2;
	}

	public void setBonificacionAnyo2(Double bonificacionAnyo2) {
		this.bonificacionAnyo2 = bonificacionAnyo2;
	}

	public Double getBonificacionAnyo3() {
		return bonificacionAnyo3;
	}

	public void setBonificacionAnyo3(Double bonificacionAnyo3) {
		this.bonificacionAnyo3 = bonificacionAnyo3;
	}

	public Double getBonificacionAnyo4() {
		return bonificacionAnyo4;
	}

	public void setBonificacionAnyo4(Double bonificacionAnyo4) {
		this.bonificacionAnyo4 = bonificacionAnyo4;
	}

	public Double getMesesCarenciaContraoferta() {
		return mesesCarenciaContraoferta;
	}

	public void setMesesCarenciaContraoferta(Double mesesCarenciaContraoferta) {
		this.mesesCarenciaContraoferta = mesesCarenciaContraoferta;
	}

	public Double getBonificacionAnyo1Contraoferta() {
		return bonificacionAnyo1Contraoferta;
	}

	public void setBonificacionAnyo1Contraoferta(Double bonificacionAnyo1Contraoferta) {
		this.bonificacionAnyo1Contraoferta = bonificacionAnyo1Contraoferta;
	}

	public Double getBonificacionAnyo2Contraoferta() {
		return bonificacionAnyo2Contraoferta;
	}

	public void setBonificacionAnyo2Contraoferta(Double bonificacionAnyo2Contraoferta) {
		this.bonificacionAnyo2Contraoferta = bonificacionAnyo2Contraoferta;
	}

	public Double getBonificacionAnyo3Contraoferta() {
		return bonificacionAnyo3Contraoferta;
	}

	public void setBonificacionAnyo3Contraoferta(Double bonificacionAnyo3Contraoferta) {
		this.bonificacionAnyo3Contraoferta = bonificacionAnyo3Contraoferta;
	}

	public Double getBonificacionAnyo4Contraoferta() {
		return bonificacionAnyo4Contraoferta;
	}

	public void setBonificacionAnyo4Contraoferta(Double bonificacionAnyo4Contraoferta) {
		this.bonificacionAnyo4Contraoferta = bonificacionAnyo4Contraoferta;
	}
	
	public String getCodOfertaSalesforce() {
		return codOfertaSalesforce;
	}

	public void setCodOfertaSalesforce(String codOfertaSalesforce) {
		this.codOfertaSalesforce = codOfertaSalesforce;
	}
	
	public String getIdOfertaSalesforce() {
		return idOfertaSalesforce;
	}

	public void setIdOfertaSalesforce(String idOfertaSalesforce) {
		this.idOfertaSalesforce = idOfertaSalesforce;
	}
	

	public Boolean getReplicateBC() {
		return Boolean.TRUE.equals(replicateBC);
	}

	public void setReplicateBC(Boolean replicateBC) {
		this.replicateBC = replicateBC;
	}
}
