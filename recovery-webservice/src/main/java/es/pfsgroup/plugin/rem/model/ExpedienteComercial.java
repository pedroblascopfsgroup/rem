package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.apache.commons.lang.BooleanUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAntiguoDeud;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosDesbloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;


/**
 * Modelo que gestiona la informacion de un cliente comercial
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "ECO_EXPEDIENTE_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ExpedienteComercial implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "ECO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExpedienteComercialGenerator")
    @SequenceGenerator(name = "ExpedienteComercialGenerator", sequenceName = "S_ECO_EXPEDIENTE_COMERCIAL")
    private Long id;
	
    @Column(name = "ECO_NUM_EXPEDIENTE")
    private Long numExpediente;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEC_ID")
	private DDEstadosExpedienteComercial estado;      
    
    @Column(name = "ECO_FECHA_ALTA")
    private Date fechaAlta;
    
    @Column(name = "ECO_FECHA_SANCION")
    private Date fechaSancion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;    
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Reserva reserva;
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Formalizacion formalizacion;
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private CondicionanteExpediente condicionante; 
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<CompradorExpediente> compradores;
    
    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @OrderBy("fechaPosicionamiento DESC")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Posicionamiento> posicionamientos;
    
    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<GastosExpediente> honorarios;
    
    @Column(name="ECO_FECHA_ANULACION")
    private Date fechaAnulacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MAN_ID")
    private DDMotivoAnulacionExpediente motivoAnulacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MRE_ID")
    private DDMotivoRechazoExpediente motivoRechazo;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MAO_ID")
    private DDMotivoAnulacionOferta motivoAnulacionAlquiler;
    
    @Column(name="ECO_FECHA_CONT_PROPIETARIO")
    private Date fechaContabilizacionPropietario;
    
    @Column(name="ECO_PETICIONARIO_ANULACION")
    private String peticionarioAnulacion;
    
    @Column(name="ECO_IMP_DEV_ENTREGAS")
    private Double importeDevolucionEntregas;
    
    @Column(name="ECO_FECHA_DEV_ENTREGAS")
    private Date fechaDevolucionEntregas;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Trabajo trabajo;
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntoExpedienteComercial> adjuntos;
    
    @Column(name="ECO_FECHA_INICIO_ALQUILER")
    private Date fechaInicioAlquiler;
    
    @Column(name="ECO_FECHA_FIN_ALQUILER")
    private Date fechaFinAlquiler;
    
    @Column(name="ECO_IMPORTE_RENTA_ALQUILER")
    private Double importeRentaAlquiler;
    
    @Column(name="ECO_NUMERO_CONTRATO_ALQUILER")
    private String numContratoAlquiler;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
    private DDTipoAlquiler tipoAlquiler;
    
    @Column(name="ECO_PLAZO_OPCION_COMPRA")
    private Date fechaPlazoOpcionCompraAlquiler;
    
    @Column(name="ECO_PRIMA_OPCION_COMPRA")
    private Double primaOpcionCompraAlquiler;
    
    @Column(name="ECO_PRECIO_OPCION_COMPRA")
    private Double precioOpcionCompraAlquiler;
    
    @Column(name="ECO_CONDICIONES_OPCION_COMPRA")
    private String condicionesOpcionCompraAlquiler;
    
    @Column(name="ECO_CONFLICTO_INTERESES")
    private Integer conflictoIntereses;
    
    @Column(name="ECO_RIESGO_REPUTACIONAL")
    private Integer riesgoReputacional;
    
    @Column(name="ECO_FECHA_SANCION_COMITE")
    private Date fechaSancionComite;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID")
	private DDComiteSancion comiteSancion;   
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID_PROPUESTO")
	private DDComiteSancion comitePropuesto;
    
    @Column(name="ECO_ESTADO_PBC")
	private Integer estadoPbc; 
	
	@Column(name="ECO_ESTADO_PBC_R")
    private Integer estadoPbcR; 
    
    @Column(name="ECO_FECHA_VENTA")
    private Date fechaVenta;
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ResolucionComiteBankia> resolucionesComite;
    
    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TanteoActivoExpediente> tanteoActivoExpediente;
     
    @OneToMany(mappedBy = "expedienteComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<InformeJuridico> listaInformeJuridico;
    
    @Column(name="ECO_BLOQUEADO")
    private Integer bloqueado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MDE_ID")
    private DDMotivosDesbloqueo motivoDesbloqueo;
    
    @Column(name="ECO_MDE_OTROS")
    private String motivoDesbloqueoDescLibre;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COS_ID_SUPERIOR")
	private DDComiteSancion comiteSuperior;
    
    @Column(name="ECO_NECESITA_FINANCIACION")
    private Boolean necesitaFinanciacion;
    
    @OneToOne(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private SeguroRentasAlquiler seguroRentasAlquiler;
    
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_COA_ID")
	private DDComiteAlquiler comiteAlquiler;
    
    @Column(name="ECO_DOCUMENTACION_OK")
    private Boolean documentacionOk;
    
    @Column(name="ECO_FECHA_VALIDACION")
    private Date fechaValidacion;


    @Column(name="ECO_ASISTENCIA_PBC")
    private Boolean asistenciaPbc;
    
    @Column(name="ECO_ASISTENCIA_PBC_DESCRIPCION")
    private String obsAsisPbc;
    
    @Column(name="ECO_FECHA_POSICIONAMIENTO_PREVISTA")
    private Date fechaPosicionamientoPrevista;  
    
    @Column(name="ECO_FECHA_ENVIO_ADVISORY_NOTE")
    private Date fechaEnvioAdvisoryNote;
    
    @Column(name="ECO_FECHA_RECOMENDACION_CES")
    private Date fechaRecomendacionCes;

    @Column(name="ECO_CORRECW")
    private Long correcw;
    
    @Column(name="ECO_COMOA3")
    private Long comoa3;
    
    @Column (name="ECO_DEVOL_AUTO_NUMBER")
    private Boolean devolAutoNumber;

 	@Column(name="ECO_FECHA_CONT_VENTA")
   	private Date fechaContabilizacionVenta;
 	
 	@Column(name="ECO_FECHA_GRAB_VENTA")
 	private Date fechaGrabacionVenta;
 	
 	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SEC_ID")
	private DDSubestadosExpedienteComercial subestadoExpediente;  
 	
 	@Column(name="RESERVADO_ALQUILER")
	private Boolean reservadoAlquiler;
	 
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEB_ID")
	private DDEstadoExpedienteBc estadoBc;   
    
    @Column(name="ECO_ESTADO_ARRAS")
	private Integer estadoPbcArras;
    
    @Column(name="ECO_ESTADO_CN")
	private Integer estadoPbcCn;
    
    @Column(name="ECO_FECHA_RESER_DEPOS")
	private Date fechaReservaDeposito;
    
    @Column(name="ECO_FECHA_CONTAB")
	private Date fechaContabilizacion;
    
    @Column(name="ECO_FECHA_FIRMA_CONT")
   	private Date fechaFirmaContrato;
    
    @Column(name="ECO_NUM_PROTOCOLO")
    private String numeroProtocolo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MRA_ID")
	private DDMotivoRechazoAntiguoDeud motivoRechazoAntiguoDeud;
    
    @Column(name="ECO_MESES_DURACION_CNT_ALQ")
  	private Long mesesDuracionCntAlquiler;
      
    @Column(name="ECO_DETALLE_ANUL_ALQ")
  	private String detalleAnulacionCntAlquiler;
    
    @Column(name="ECO_REVISADO_CONTROLLERS")
	private Integer revisadoPorControllers;
    
    @Column(name="ECO_FECHA_REVISION")
	private Date fechaRevision;

	@OneToMany(mappedBy = "expedienteComercial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "ECO_ID")
	private List<InterlocutorExpediente> interlocutoresExpediente;
    
    @OneToOne
    @JoinColumn(name = "ECO_ID_ANTERIOR")
    private ExpedienteComercial expedienteAnterior;

	@Column(name="NUMERO_VAI_HAVAI_SAREB")
	private String numeroVaiHavaiSareb;
    
    @Column(name = "ECO_EDICION_COMPRADORES_CBX")
    private String motivoEdicionCompradores;

	@Column(name = "ECO_NUM_CONTRATO_ANT")
	private String numContratoAnterior;

	@Column(name = "ECO_FECHA_FIN_CONTRATO_ANT")
	private Date fechaFinContratoAnterior;

    
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

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public DDEstadosExpedienteComercial getEstado() {
		return estado;
	}

	public void setEstado(DDEstadosExpedienteComercial estado) {
		this.estado = estado;
		if (estado != null && estado.getCodigo().equals(DDEstadosExpedienteComercial.ANULADO)){
			this.fechaAnulacion = new Date();
		}
		
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public List<CompradorExpediente> getCompradores() {
		return compradores;
	}

	public void setCompradores(List<CompradorExpediente> compradores) {
		this.compradores = compradores;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Reserva getReserva() {
		return reserva;
	}

	public void setReserva(Reserva reserva) {
		this.reserva = reserva;
	}

	public Formalizacion getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(Formalizacion formalizacion) {
		this.formalizacion = formalizacion;
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

	public CondicionanteExpediente getCondicionante() {
		return condicionante;
	}

	public void setCondicionante(CondicionanteExpediente condicionante) {
		this.condicionante = condicionante;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public DDMotivoAnulacionExpediente getMotivoAnulacion() {
		return motivoAnulacion;
	}

	public void setMotivoAnulacion(DDMotivoAnulacionExpediente motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}
    
    public DDMotivoRechazoExpediente getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(DDMotivoRechazoExpediente motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	
    public DDMotivoAnulacionOferta getMotivoAnulacionAlquiler() {
		return motivoAnulacionAlquiler;
	}

	public void setMotivoAnulacionAlquiler(DDMotivoAnulacionOferta motivoAnulacionAlquiler) {
		this.motivoAnulacionAlquiler = motivoAnulacionAlquiler;
	}

	public List<Posicionamiento> getPosicionamientos() {
		return posicionamientos;
	}

	public void setPosicionamientos(List<Posicionamiento> posicionamientos) {
		this.posicionamientos = posicionamientos;
	}

	public Date getFechaContabilizacionPropietario() {
		return fechaContabilizacionPropietario;
	}

	public void setFechaContabilizacionPropietario(
			Date fechaContabilizacionPropietario) {
		this.fechaContabilizacionPropietario = fechaContabilizacionPropietario;
	}

	public String getPeticionarioAnulacion() {
		return peticionarioAnulacion;
	}

	public void setPeticionarioAnulacion(String peticionarioAnulacion) {
		this.peticionarioAnulacion = peticionarioAnulacion;
	}

	public Double getImporteDevolucionEntregas() {
		return importeDevolucionEntregas;
	}

	public void setImporteDevolucionEntregas(Double importeDevolucionEntregas) {
		this.importeDevolucionEntregas = importeDevolucionEntregas;
	}

	public Date getFechaDevolucionEntregas() {
		return fechaDevolucionEntregas;
	}

	public void setFechaDevolucionEntregas(Date fechaDevolucionEntregas) {
		this.fechaDevolucionEntregas = fechaDevolucionEntregas;
	}

	public Comprador getCompradorPrincipal() {
    	Comprador comprador = null;
    	
    	if(!Checks.esNulo(this.compradores)) {
    	
	    	for(CompradorExpediente compradorExp: this.compradores) {
	    		
	    		if(!Checks.esNulo(compradorExp.getTitularContratacion()) && BooleanUtils.toBoolean(compradorExp.getTitularContratacion())) {
	    			comprador = compradorExp.getPrimaryKey().getComprador();
	    		}	    		
	    	}
    	}
    	
    	return comprador;
    	
    }
    
    public Posicionamiento getUltimoPosicionamiento() {
    	
    	Posicionamiento posicionamiento = null;
    	
    	if(!Checks.esNulo(this.posicionamientos) && !this.posicionamientos.isEmpty()) {    	
    		Comparator<Posicionamiento> comparador = Collections.reverseOrder();
    		Collections.sort(this.posicionamientos, comparador);
    		
    		posicionamiento = this.posicionamientos.get(0);
    	}
    	
    	return posicionamiento;
    }

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}
    
	public List<AdjuntoExpedienteComercial> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<AdjuntoExpedienteComercial> adjuntos) {
		this.adjuntos = adjuntos;
	}
    
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoExpedienteComercial getAdjunto(Long id) {
        for (AdjuntoExpedienteComercial adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }
    
    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoExpedienteComercial getAdjuntoGD(Long idDocRestClient) {
    	for (AdjuntoExpedienteComercial adj : getAdjuntos()) {
    		if(!Checks.esNulo(adj.getIdDocRestClient()) && adj.getIdDocRestClient().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }

	public Date getFechaInicioAlquiler() {
		return fechaInicioAlquiler;
	}

	public void setFechaInicioAlquiler(Date fechaInicioAlquiler) {
		this.fechaInicioAlquiler = fechaInicioAlquiler;
	}

	public Date getFechaFinAlquiler() {
		return fechaFinAlquiler;
	}

	public void setFechaFinAlquiler(Date fechaFinAlquiler) {
		this.fechaFinAlquiler = fechaFinAlquiler;
	}

	public Double getImporteRentaAlquiler() {
		return importeRentaAlquiler;
	}

	public void setImporteRentaAlquiler(Double importeRentaAlquiler) {
		this.importeRentaAlquiler = importeRentaAlquiler;
	}

	public String getNumContratoAlquiler() {
		return numContratoAlquiler;
	}

	public void setNumContratoAlquiler(String numContratoAlquiler) {
		this.numContratoAlquiler = numContratoAlquiler;
	}

	public Date getFechaPlazoOpcionCompraAlquiler() {
		return fechaPlazoOpcionCompraAlquiler;
	}

	public void setFechaPlazoOpcionCompraAlquiler(
			Date fechaPlazoOpcionCompraAlquiler) {
		this.fechaPlazoOpcionCompraAlquiler = fechaPlazoOpcionCompraAlquiler;
	}

	public Double getPrimaOpcionCompraAlquiler() {
		return primaOpcionCompraAlquiler;
	}

	public void setPrimaOpcionCompraAlquiler(Double primaOpcionCompraAlquiler) {
		this.primaOpcionCompraAlquiler = primaOpcionCompraAlquiler;
	}

	public Double getPrecioOpcionCompraAlquiler() {
		return precioOpcionCompraAlquiler;
	}

	public void setPrecioOpcionCompraAlquiler(Double precioOpcionCompraAlquiler) {
		this.precioOpcionCompraAlquiler = precioOpcionCompraAlquiler;
	}

	public String getCondicionesOpcionCompraAlquiler() {
		return condicionesOpcionCompraAlquiler;
	}

	public void setCondicionesOpcionCompraAlquiler(
			String condicionesOpcionCompraAlquiler) {
		this.condicionesOpcionCompraAlquiler = condicionesOpcionCompraAlquiler;
	}

	public Integer getConflictoIntereses() {
		return conflictoIntereses;
	}

	public void setConflictoIntereses(Integer conflictoIntereses) {
		this.conflictoIntereses = conflictoIntereses;
	}

	public Integer getRiesgoReputacional() {
		return riesgoReputacional;
	}

	public void setRiesgoReputacional(Integer riesgoReputacional) {
		this.riesgoReputacional = riesgoReputacional;
	}

	public Date getFechaSancionComite() {
		return fechaSancionComite;
	}

	public void setFechaSancionComite(Date fechaSancionComite) {
		this.fechaSancionComite = fechaSancionComite;
	}

	public DDComiteSancion getComiteSancion() {
		return comiteSancion;
	}

	public void setComiteSancion(DDComiteSancion comiteSancion) {
		this.comiteSancion = comiteSancion;
	}

	public DDComiteSancion getComitePropuesto() {
		return comitePropuesto;
	}

	public void setComitePropuesto(DDComiteSancion comitePropuesto) {
		this.comitePropuesto = comitePropuesto;
	}

	public Integer getEstadoPbc() {
		return estadoPbc;
	}

	public void setEstadoPbc(Integer estadoPbc) {
		this.estadoPbc = estadoPbc;
	}
	public Integer getEstadoPbcR() {
		return estadoPbcR;
	}

	public void setEstadoPbcR(Integer estadoPbcR) {
		this.estadoPbcR = estadoPbcR;
	}

	public Date getFechaVenta() {
		return fechaVenta;
	}

	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}

	public List<ResolucionComiteBankia> getResolucionesComite() {
		return resolucionesComite;
	}

	public void setResolucionesComite(
			List<ResolucionComiteBankia> resolucionesComite) {
		this.resolucionesComite = resolucionesComite;
	}

	public List<GastosExpediente> getHonorarios() {
		return honorarios;
	}

	public void setHonorarios(List<GastosExpediente> honorarios) {
		this.honorarios = honorarios;
	}

	public List<TanteoActivoExpediente> getTanteoActivoExpediente() {
		return tanteoActivoExpediente;
	}

	public void setTanteoActivoExpediente(
			List<TanteoActivoExpediente> tanteoActivoExpediente) {
		this.tanteoActivoExpediente = tanteoActivoExpediente;
	}

	public List<InformeJuridico> getListaInformeJuridico() {
		return listaInformeJuridico;
	}

	public void setListaInformeJuridico(List<InformeJuridico> listaInformeJuridico) {
		this.listaInformeJuridico = listaInformeJuridico;
	}

	public Integer getBloqueado() {
		return bloqueado;
	}

	public void setBloqueado(Integer bloqueado) {
		this.bloqueado = bloqueado;
	}

	public DDMotivosDesbloqueo getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}

	public void setMotivoDesbloqueo(DDMotivosDesbloqueo motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}

	public String getMotivoDesbloqueoDescLibre() {
		return motivoDesbloqueoDescLibre;
	}

	public void setMotivoDesbloqueoDescLibre(String motivoDesbloqueoDescLibre) {
		this.motivoDesbloqueoDescLibre = motivoDesbloqueoDescLibre;
	}
	
	public List<CompradorExpediente> getCompradoresAlta(){
		List<CompradorExpediente> compradoresAlta= new ArrayList<CompradorExpediente>();
		
		if(!Checks.estaVacio(this.getCompradores())){
			for(CompradorExpediente com: this.getCompradores()){
				if(Checks.esNulo(com.getFechaBaja())){
					compradoresAlta.add(com);
				}
			}
		}
		
		return compradoresAlta;
	}

	public DDComiteSancion getComiteSuperior() {
		return comiteSuperior;
	}

	public void setComiteSuperior(DDComiteSancion comiteSuperior) {
		this.comiteSuperior = comiteSuperior;
	}

	public Boolean getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}

	public void setNecesitaFinanciacion(Boolean necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}

	public DDTipoAlquiler getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(DDTipoAlquiler tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}

	public SeguroRentasAlquiler getSeguroRentasAlquiler() {
		return seguroRentasAlquiler;
	}

	public void setSeguroRentasAlquiler(SeguroRentasAlquiler seguroRentasAlquiler) {
		this.seguroRentasAlquiler = seguroRentasAlquiler;
	}

	public DDComiteAlquiler getComiteAlquiler() {
		return comiteAlquiler;
	}

	public void setComiteAlquiler(DDComiteAlquiler comiteAlquiler) {
		this.comiteAlquiler = comiteAlquiler;
	}

	public Boolean getDocumentacionOk() {
		return documentacionOk;
	}

	public void setDocumentacionOk(Boolean documentacionOk) {
		this.documentacionOk = documentacionOk;
	}

	public Date getFechaValidacion() {
		return fechaValidacion;
	}

	public void setFechaValidacion(Date fechaValidacion) {
		this.fechaValidacion = fechaValidacion;
	}
	

	public Boolean getAsistenciaPbc() {
		return asistenciaPbc;
	}

	public void setAsistenciaPbc(Boolean asistenciaPbc) {
		this.asistenciaPbc = asistenciaPbc;
	}

	public String getObsAsisPbc() {
		return obsAsisPbc;
	}

	public void setObsAsisPbc(String obsAsisPbc) {
		this.obsAsisPbc = obsAsisPbc;
	}
	
	public Date getFechaPosicionamientoPrevista() {
		return fechaPosicionamientoPrevista;
	}

	public void setFechaPosicionamientoPrevista(Date fechaPosicionamientoPrevista) {
		this.fechaPosicionamientoPrevista = fechaPosicionamientoPrevista;
	}
	
	public Date getFechaEnvioAdvisoryNote() {
		return fechaEnvioAdvisoryNote;
	}

	public void setFechaEnvioAdvisoryNote(Date fechaEnvioAdvisoryNote) {
		this.fechaEnvioAdvisoryNote = fechaEnvioAdvisoryNote;
	}
	

	public Date getFechaRecomendacionCes() {
		return fechaRecomendacionCes;
	}

	public void setFechaRecomendacionCes(Date fechaRecomendacionCes) {
		this.fechaRecomendacionCes = fechaRecomendacionCes;
	}

	public Long getCorrecw() {
		return correcw;
	}

	public void setCorrecw(Long correcw) {
		this.correcw = correcw;
	}

	public Long getComoa3() {
		return comoa3;
	}

	public void setComoa3(Long comoa3) {
		this.comoa3 = comoa3;
	}
	public Boolean getDevolAutoNumber() {
		return devolAutoNumber;
	}

	public void setDevolAutoNumber(Boolean devolAutoNumber) {
		this.devolAutoNumber = devolAutoNumber;
	}

	public Date getFechaContabilizacionVenta() {
		return fechaContabilizacionVenta;
	}

	public void setFechaContabilizacionVenta(Date fechaContabilizacionVenta) {
		this.fechaContabilizacionVenta = fechaContabilizacionVenta;
	}

	public Date getFechaGrabacionVenta() {
		return fechaGrabacionVenta;
	}

	public void setFechaGrabacionVenta(Date fechaGrabacionVenta) {
		this.fechaGrabacionVenta = fechaGrabacionVenta;
	}

	public DDSubestadosExpedienteComercial getSubestadoExpediente() {
		return subestadoExpediente;
	}

	public void setSubestadoExpediente(DDSubestadosExpedienteComercial subestadoExpediente) {
		this.subestadoExpediente = subestadoExpediente;
	}
	
	public Boolean getReservadoAlquiler() {
		return reservadoAlquiler;
	}

	public void setReservadoAlquiler(Boolean reservadoAlquiler) {
		this.reservadoAlquiler = reservadoAlquiler;
	}

	public DDEstadoExpedienteBc getEstadoBc() {
		return estadoBc;
	}

	public void setEstadoBc(DDEstadoExpedienteBc estadoBc) {
		this.estadoBc = estadoBc;
	}

	public Integer getEstadoPbcArras() {
		return estadoPbcArras;
	}

	public void setEstadoPbcArras(Integer estadoPbcArras) {
		this.estadoPbcArras = estadoPbcArras;
	}

	public Integer getEstadoPbcCn() {
		return estadoPbcCn;
	}

	public void setEstadoPbcCn(Integer estadoPbcCn) {
		this.estadoPbcCn = estadoPbcCn;
	}

	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}

	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}

	public Date getFechaReservaDeposito() {
		return fechaReservaDeposito;
	}

	public void setFechaReservaDeposito(Date fechaReservaDeposito) {
		this.fechaReservaDeposito = fechaReservaDeposito;
	}

	public Date getFechaFirmaContrato() {
		return fechaFirmaContrato;
	}

	public void setFechaFirmaContrato(Date fechaFirmaContrato) {
		this.fechaFirmaContrato = fechaFirmaContrato;
	}

	public String getNumeroProtocolo() {
		return numeroProtocolo;
	}

	public void setNumeroProtocolo(String numeroProtocolo) {
		this.numeroProtocolo = numeroProtocolo;
	}

	public DDMotivoRechazoAntiguoDeud getMotivoRechazoAntiguoDeud() {
		return motivoRechazoAntiguoDeud;
	}

	public void setMotivoRechazoAntiguoDeud(DDMotivoRechazoAntiguoDeud motivoRechazoAntiguoDeud) {
		this.motivoRechazoAntiguoDeud = motivoRechazoAntiguoDeud;
	}

	public Long getMesesDuracionCntAlquiler() {
		return mesesDuracionCntAlquiler;
	}

	public void setMesesDuracionCntAlquiler(Long mesesDuracionCntAlquiler) {
		this.mesesDuracionCntAlquiler = mesesDuracionCntAlquiler;
	}

	public String getDetalleAnulacionCntAlquiler() {
		return detalleAnulacionCntAlquiler;
	}

	public void setDetalleAnulacionCntAlquiler(String detalleAnulacionCntAlquiler) {
		this.detalleAnulacionCntAlquiler = detalleAnulacionCntAlquiler;
	}

	public ExpedienteComercial getExpedienteAnterior() {
		return expedienteAnterior;
	}

	public void setExpedienteAnterior(ExpedienteComercial expedienteAnterior) {
		this.expedienteAnterior = expedienteAnterior;
	}

	public List<InterlocutorExpediente> getInterlocutoresExpediente() {
		return interlocutoresExpediente;
	}

	public void setInterlocutoresExpediente(List<InterlocutorExpediente> interlocutoresExpediente) {
		this.interlocutoresExpediente = interlocutoresExpediente;
	}
	
	public Integer getRevisadoPorControllers() {
		return revisadoPorControllers;
	}

	public void setRevisadoPorControllers(Integer revisadoPorControllers) {
		this.revisadoPorControllers = revisadoPorControllers;
	}

	public Date getFechaRevision() {
		return fechaRevision;
	}

	public void setFechaRevision(Date fechaRevision) {
		this.fechaRevision = fechaRevision;
	}

	public BigDecimal getImporteParticipacionTotal() {
		BigDecimal importe = new BigDecimal(0);
		
		List<CompradorExpediente> compradores = this.compradores;
		if(compradores != null && !compradores.isEmpty()) {
			for (CompradorExpediente compradorExpediente : compradores) {
				if(compradorExpediente.getPorcionCompra() != null && !compradorExpediente.getAuditoria().isBorrado()) {
					importe = importe.add(new BigDecimal(compradorExpediente.getPorcionCompra()));
				}
			}
		}
		
		return importe;
	}

	public String getMotivoEdicionCompradores() {
		return motivoEdicionCompradores;
	}

	public void setMotivoEdicionCompradores(String motivoEdicionCompradores) {
		this.motivoEdicionCompradores = motivoEdicionCompradores;
	}
	
	
	public String getNumeroVaiHavaiSareb() {
		return numeroVaiHavaiSareb;
	}

	public void setNumeroVaiHavaiSareb(String numeroVaiHavaiSareb) {
		this.numeroVaiHavaiSareb = numeroVaiHavaiSareb;
	}

	public String getNumContratoAnterior() {
		return numContratoAnterior;
	}

	public void setNumContratoAnterior(String numContratoAnterior) {
		this.numContratoAnterior = numContratoAnterior;
	}

	public Date getFechaFinContratoAnterior() {
		return fechaFinContratoAnterior;
	}

	public void setFechaFinContratoAnterior(Date fechaFinContratoAnterior) {
		this.fechaFinContratoAnterior = fechaFinContratoAnterior;
	}
}
