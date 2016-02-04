package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.math.BigInteger;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Transient;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.annotations.Where;
import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;

@Entity
//@Table(name = "BIE_BIEN", schema = "${entity.schema}")
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class NMBBien extends Bien implements NMBBienInfo{
	
	private static final long serialVersionUID = -4497097910086775262L;

	@Transient
    private final Log logger = LogFactory.getLog(getClass());

	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<NMBInformacionRegistralBien> informacionRegistral;

	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<NMBValoracionesBien> valoraciones;

	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<NMBLocalizacionesBien> localizaciones;

	public List<ProcedimientoBien> getProcedimientos() {
		return procedimientos;
	}

	public void setProcedimientos(List<ProcedimientoBien> procedimientos) {
		this.procedimientos = procedimientos;
	}

	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<NMBContratoBien> contratos;

	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<NMBPersonasBien> NMBpersonas;
	
    @OneToOne(mappedBy = "bien")
    @JoinColumn(name = "BIE_ID")
    private EmbargoProcedimiento embargoProcedimiento;
    
    @OneToOne
    @JoinColumn(name = "BIE_ID")
    private NMBBienEntidad bienEntidad;
    
    @OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)    
    private List<NMBBienCargas> bienCargas;
    
    @OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    private List<NMBEmbargoProcedimiento> NMBEmbargosProcedimiento;
    
    @OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    private List<NMBSubastaInstrucciones> instruccionesSubasta;
    
	@ManyToOne
    @JoinColumn(name = "DD_ORIGEN_ID")
	private NMBDDOrigenBien origen;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPO_CARGA_ID")
	private NMBDDTipoCargaBien tipoCarga;   
	
	@Column(name = "BIE_MARCA_EXTERNOS")
    private Integer marcaExternos;
	
	@Column(name = "BIE_CODIGO_INTERNO")
    private String codigoInterno;

	@Column(name= "BIE_SOLVENCIA_NO_ENCONTRADA")
	private boolean solvenciaNoEncontrada;
	
	@Column(name= "BIE_OBSERVACIONES")
	private String observaciones;
	
	@OneToOne(mappedBy = "bien")
    @JoinColumn(name = "BIE_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
    private NMBAdicionalBien adicional;
	
	@OneToOne(mappedBy = "bien")
    @JoinColumn(name = "BIE_ID")
    private NMBAdjudicacionBien adjudicacion;
	
	@OneToOne
    @JoinColumn(name = "DD_SPO_ID")
	private DDSituacionPosesoria  situacionPosesoria;
	
	@Column(name= "BIE_VIVIENDA_HABITUAL") 
	private String viviendaHabitual;
	
	@Column(name= "BIE_NUMERO_ACTIVO")  
	private String numeroActivo;
	
	@Column(name= "BIE_LICENCIA_PRI_OCUPACION") 
	private String licenciaPrimeraOcupacion;
	
	@Column(name= "BIE_PRIMERA_TRANSMISION") 
	private String primeraTransmision;
	
	@Column(name= "BIE_CONTRATO_ALQUILER") 
	private String contratoAlquiler;
	
	@OneToMany(mappedBy = "bien", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ProcedimientoBien> procedimientos;
	
	@Column(name= "BIE_OBRA_EN_CURSO")
	private Boolean obraEnCurso;
	
	@Column(name= "BIE_TIPO_SUBASTA")
	private Float tipoSubasta;
	
	@Column(name = "BIE_DUE_DILLIGENCE")
	private Boolean dueDilligence;
	
	@Column(name = "BIE_TRANSMITENTE_PROMOTOR")
	private String transmitentePromotor;
	
	@Column(name = "BIE_ARRENDADO_SIN_OPC_COMPRA")
	private String arrendadoSinOpcCompra;
	
	@Column(name = "BIE_USO_PROMOTOR_MAYOR2")
	private String usoPromotorMayorDosAnyos;
	
	@Column(name = "BIE_FECHA_DUE_D")
	private Date fechaDueD;

	@Column(name = "BIE_FECHA_SOLICITUD_DUE_D")
	private Date fechaSolicitudDueD;
	
	@ManyToOne
    @JoinColumn(name = "DD_TRI_ID")
	private DDTipoTributacion tributacion; 
	
	@Column(name = "BIE_PORCT_IMP_COMPRA")
	private Float porcentajeImpuestoCompra;
	
	@ManyToOne
	@JoinColumn(name="DD_QCI_ID")
	private DDimpuestoCompra impuestoCompra;
	
	@Column(name = "BIE_SAREB_ID")
    private String sarebId;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPI_ID")
	private DDTipoImposicion tipoImposicionCompra;
	
	@ManyToOne
    @JoinColumn(name = "DD_TRIV_ID")
	private DDTipoTributacion tributacionVenta;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPIV_ID")
	private DDTipoImposicion tipoImposicionVenta;
	
	@ManyToOne
    @JoinColumn(name = "DD_IPR_ID")
	private DDSiNo inversionPorRenuncia;
	
	@Transient
	@Column(name = "NUM_DOMICILIO")
	private String numDomicilio;
	
	@Column(name = "BIE_IND_DIR_UNIVOCA")
	private String idDireccion;
	
	@Transient
	@Column(name = "CHAR_EXTRA3")
	private String destinoUso;
	
//	@Transient
//	private Boolean adjudicacionOK;
//	
//	@Transient
//	private Boolean saneamientoOK;
//	
//	@Transient
//    private Boolean posesionOK;
//	
//	@Transient
//    private Boolean llavesOK;
//	
//	@Transient
//    private String	tareaActivaAdjudicacion;
//	
//	@Transient
//    private TareaNotificacion tareaNotificacionActivaAdjudicacion;
//	
//	@Transient
//    private String	tareaActivaSaneamiento;
//	
//	@Transient
//    private String	tareaActivaPosesion;
//	
//	@Transient
//    private String	tareaActivaLlaves;
	
	
	public Float getTipoSubasta() {
		return tipoSubasta;
	}

	public void setTipoSubasta(Float tipoSubasta) {
		this.tipoSubasta = tipoSubasta;
	}

//	public String getTareaActivaAdjudicacion() {
//		TareaNotificacion tarea = this.getTareaNotificacionActivaAdjudicacion();		
//		return (Checks.esNulo(tarea) ? null : tarea.getDescripcionTarea());		
//	}
//	
//	public TareaNotificacion getTareaNotificacionActivaAdjudicacion() {
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			MEJProcedimiento mejp = this.getInstanceOf(p.getProcedimiento());
//			if (!Checks.esNulo(mejp) && !Checks.esNulo(mejp.getTipoProcedimiento())) {
//				if(("P413".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0) || 
//						("H005".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0) ){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							return tarea;
//						}
//					}
//				}
//			}
//		}
//		return null;
//	}
//	
//	private MEJProcedimiento getInstanceOf(Procedimiento procedimiento) {
//		if (procedimiento instanceof MEJProcedimiento) {
//			return (MEJProcedimiento) procedimiento;
//		}
//		if (Hibernate.getClass(procedimiento).equals(MEJProcedimiento.class)) {
//			HibernateProxy proxy = (HibernateProxy) procedimiento;				
//			return((MEJProcedimiento) proxy.writeReplace());
//		}
//		return null;
//	}
//	
//	public String getTareaActivaSaneamiento() {
//		
//		String estado = "";
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P415".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							return tarea.getDescripcionTarea();
//						}
//					}
//				}
//			}
//		}
//		return estado;
//	}
//
//	public String getTareaActivaPosesion() {
//	
//	String estado = "";
//	List<ProcedimientoBien> procs = this.getProcedimientos();
//	for(ProcedimientoBien p : procs){
//		if (p.getProcedimiento() instanceof MEJProcedimiento){
//			MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//			if("P416".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//				if (!mejp.isEstaParalizado()){
//					Set<TareaNotificacion> tareas = mejp.getTareas();
//					Iterator<TareaNotificacion> it = tareas.iterator();
//					while (it.hasNext()){
//						TareaNotificacion tarea = it.next();
//						return tarea.getDescripcionTarea();
//					}
//				}
//			}
//		}
//	}
//	return estado;
//	}
//	
//	public String getTareaActivaLlaves() {
//
//		String estado = "";
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P417".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							return tarea.getDescripcionTarea();
//						}
//					}
//				}
//			}
//		}
//		return estado;
//	}
//
//
//
//	public Boolean getAdjudicacionOK() {
//		
//		Boolean estado = false;
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P413".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
//								return false;
//							}
//						}
//						return true;
//					}
//				}
//			}
//		}
//		return estado;
//	}
//
//	public Boolean getSaneamientoOK() {
//		Boolean estado = false;
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P415".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
//								return false;
//							}
//						}
//						return true;
//					}
//				}
//			}
//		}
//		return estado;
//	}
//
//
//
//	public Boolean getPosesionOK() {
//		Boolean estado = false;
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P416".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
//								return false;
//							}
//						}
//						return true;
//					}
//				}
//			}
//		}
//		return estado;
//	}
//
//
//
//	public Boolean getLlavesOK() {
//		Boolean estado = false;
//		List<ProcedimientoBien> procs = this.getProcedimientos();
//		for(ProcedimientoBien p : procs){
//			if (p.getProcedimiento() instanceof MEJProcedimiento){
//				MEJProcedimiento mejp = (MEJProcedimiento) p.getProcedimiento();	
//				if("P417".compareTo(mejp.getTipoProcedimiento().getCodigo()) == 0){
//					if (!mejp.isEstaParalizado()){
//						Set<TareaNotificacion> tareas = mejp.getTareas();
//						Iterator<TareaNotificacion> it = tareas.iterator();
//						while (it.hasNext()){
//							TareaNotificacion tarea = it.next();
//							if(tarea.getTareaFinalizada() == null || !tarea.getTareaFinalizada()){
//								return false;
//							}
//						}
//						return true;
//					}
//				}
//			}
//		}
//		return estado;
//	}



	public DDSituacionPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(DDSituacionPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public String getViviendaHabitual() {
		return viviendaHabitual;
	}

	public void setViviendaHabitual(String viviendaHabitual) {
		this.viviendaHabitual = viviendaHabitual;
	}

	public String getNumeroActivo() {
		return numeroActivo;
	}

	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getLicenciaPrimeraOcupacion() {
		return licenciaPrimeraOcupacion;
	}

	public void setLicenciaPrimeraOcupacion(String licenciaPrimeraOcupacion) {
		this.licenciaPrimeraOcupacion = licenciaPrimeraOcupacion;
	}

	public String getPrimeraTransmision() {
		return primeraTransmision;
	}

	public void setPrimeraTransmision(String primeraTransmision) {
		this.primeraTransmision = primeraTransmision;
	}

	public String getContratoAlquiler() {
		return contratoAlquiler;
	}

	public void setContratoAlquiler(String contratoAlquiler) {
		this.contratoAlquiler = contratoAlquiler;
	}

	public NMBAdjudicacionBien getAdjudicacion() {
		return adjudicacion;
	}

	public void setAdjudicacion(NMBAdjudicacionBien adjudicacion) {
		this.adjudicacion = adjudicacion;
	}

	public List<NMBBienCargas> getBienCargas() {
		return bienCargas;
	}

	public void setBienCargas(List<NMBBienCargas> bienCargas) {
		this.bienCargas = bienCargas;
	}

	/**
	 * Buscar los datos registrales de fecha en registro mayor.
	 * Return: Datos registrales del Bien mas recientes
	 */
	@Override
	public NMBInformacionRegistralBienInfo getDatosRegistralesActivo() {
		NMBInformacionRegistralBienInfo drActivo = new NMBInformacionRegistralBien(); 
		drActivo=null;
		if (informacionRegistral!=null){
			for (NMBInformacionRegistralBienInfo dr : informacionRegistral) {
				if ((drActivo == null) || ( dr.getFechaInscripcion() != null && (dr.getFechaInscripcion().after(drActivo.getFechaInscripcion()))))
					drActivo = dr;
	        }
		}
        return drActivo;
	}

    public NMBBienEntidad getBienEntidad() {
		return bienEntidad;
	}

	public void setBienEntidad(NMBBienEntidad bienEntidad) {
		this.bienEntidad = bienEntidad;
	}

	public void setInformacionRegistral(List<NMBInformacionRegistralBien> informacionRegistral) {
		this.informacionRegistral = informacionRegistral;
	}

	public void setNMBEmbargosProcedimiento(List<NMBEmbargoProcedimiento> nMBEmbargosProcedimiento) {
		NMBEmbargosProcedimiento = nMBEmbargosProcedimiento;
	}

	/**
	 * Buscar la �ltima valoraci�n registrada.
	 * Return: valoraci�n del bien
	 */
	@Override
	public NMBValoracionesBienInfo getValoracionActiva() {
		NMBValoracionesBienInfo valActivo = new NMBValoracionesBien(); 
		valActivo=null;
		if (valoraciones!=null){
			for (NMBValoracionesBienInfo val : valoraciones) {
				if ((valActivo == null) || (val.getFechaValorTasacion() != null && (val.getFechaValorTasacion().after(valActivo.getFechaValorTasacion())))) 
					valActivo = val;
	        }
		}
        return valActivo;
	}
	
    /**
	 * Buscar la �ltima localizaci�n registrada.
	 * Return: valoraci�n del bien
	 */
	@Override
	public NMBLocalizacionesBienInfo getLocalizacionActual() {
		NMBLocalizacionesBienInfo locActiva = new NMBLocalizacionesBien(); 
		locActiva=null;
		if (localizaciones != null){
			for (NMBLocalizacionesBienInfo loc : localizaciones) {
				if ((locActiva == null) || (loc.getAuditoria().getFechaCrear() != null && (loc.getAuditoria().getFechaCrear().after(locActiva.getAuditoria().getFechaCrear())))) 
					locActiva = loc;
	        }
		}
        return locActiva;
	}

	public List<NMBInformacionRegistralBien> getInformacionRegistral() {
		return informacionRegistral;
	}

	public void setDatosRegistrales(List<NMBInformacionRegistralBien> datosRegistrales) {
		this.informacionRegistral = datosRegistrales;
	}

	public List<NMBValoracionesBien> getValoraciones() {
		return valoraciones;
	}

	public void setValoraciones(List<NMBValoracionesBien> valoraciones) {
		this.valoraciones = valoraciones;
	}

	public List<NMBLocalizacionesBien> getLocalizaciones() {
		return localizaciones;
	}

	public void setLocalizaciones(List<NMBLocalizacionesBien> localizaciones) {
		this.localizaciones = localizaciones;
	}

	public NMBDDOrigenBien getOrigen() {
		return origen;
	}

	public void setOrigen(NMBDDOrigenBien origen) {
		this.origen = origen;
	}

	public String getDescripcion() {
		return getDescripcionBien();
	}

	public void setDescripcion(String descripcion) {
		this.setDescripcionBien(descripcion);
	}

	public NMBDDTipoCargaBien getTipoCarga() {
		return tipoCarga;
	}

	public void setTipoCarga(NMBDDTipoCargaBien tipoCarga) {
		this.tipoCarga = tipoCarga;
	}

	public String getCodigoInterno() {
		return codigoInterno;
	}

	public void setCodigoInterno(String codigoInterno) {
		this.codigoInterno = codigoInterno;
	}

	/**
	 * @param embargoProcedimiento the embargoProcedimiento to set
	 */
	public void setEmbargoProcedimiento(EmbargoProcedimiento embargoProcedimiento) {
		this.embargoProcedimiento = embargoProcedimiento;
	}

	/**
	 * @return the embargoProcedimiento
	 */
	public EmbargoProcedimiento getEmbargoProcedimiento() {
		return embargoProcedimiento;
	}

	/**
	 * @param contratos the contratos to set
	 */
	public void setContratos(List<NMBContratoBien> contratos) {
		this.contratos = contratos;
	}

	/**
	 * @return the contratos
	 */
	public List<NMBContratoBien> getContratos() {
		return contratos;
	}

	/**
	 * @param nMBpersonas the nMBpersonas to set
	 */
	public void setNMBpersonas(List<NMBPersonasBien> nMBpersonas) {
		NMBpersonas = nMBpersonas;
	}

	/**
	 * @return the nMBpersonas
	 */
	public List<NMBPersonasBien> getNMBpersonas() {
		return NMBpersonas;
	}

	/**
	 * @param marcaExternos the marcaExternos to set
	 */
	public void setMarcaExternos(Integer marcaExternos) {
		this.marcaExternos = marcaExternos;
	}

	/**
	 * @return the marcaExternos
	 */
	public Integer getMarcaExternos() {
		return marcaExternos;
	}

	/**
	 * @param instruccionesSubasta the instruccionesSubasta to set
	 */
	public void setInstruccionesSubasta(List<NMBSubastaInstrucciones> instruccionesSubasta) {
		this.instruccionesSubasta = instruccionesSubasta;
	}

	/**
	 * @return the instruccionesSubasta
	 */
	public List<NMBSubastaInstrucciones> getInstruccionesSubasta() {
		return instruccionesSubasta;
	}

	@Override
	public List<NMBEmbargoProcedimiento> getNMBEmbargosProcedimiento() {
		return NMBEmbargosProcedimiento;
	}

	public void setNmbEmbargosProcedimiento(List<NMBEmbargoProcedimiento> NMBEmbargosProcedimiento) {
		this.NMBEmbargosProcedimiento = NMBEmbargosProcedimiento;
	}

	public void setSolvenciaNoEncontrada(boolean solvenciaNoEncontrada) {
		this.solvenciaNoEncontrada = solvenciaNoEncontrada;
	}

	public boolean isSolvenciaNoEncontrada() {
		return solvenciaNoEncontrada;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public NMBAdicionalBien getAdicional() {
		return adicional;
	}

	public void setAdicional(NMBAdicionalBien adicional) {
		this.adicional = adicional;
	}

	public Boolean getObraEnCurso() {
		return obraEnCurso;
	}

	public void setObraEnCurso(Boolean obraEnCurso) {
		this.obraEnCurso = obraEnCurso;
	}

	/**
	 * Total de cargas registrales y económicas.
	 * 
	 * @return
	 */
	public Float getImporteTotalCargas() {
		Float total = 0F;
		if (this.bienCargas==null) {
			return total;
		}
		for (NMBBienCargas carga : this.bienCargas) {
			if (carga.getImporteRegistral()!=null && 
					carga.getSituacionCarga()!=null && 
					DDSituacionCarga.ACEPTADA.equals(carga.getSituacionCarga().getCodigo())) {
				total += carga.getImporteRegistral();
			}
			if (carga.getImporteEconomico()!=null && 
					carga.getSituacionCargaEconomica()!=null && 
					DDSituacionCarga.ACEPTADA.equals(carga.getSituacionCargaEconomica().getCodigo())) {
				total += carga.getImporteEconomico();
			}
		}
		return total;
	}
	
	/**
	 * Indica si tiene cargas registrales en estado ACEPTADA.
	 * 
	 * @return
	 */
	public Boolean tieneCargas() {
		Boolean resultado = false;
		if (this.bienCargas==null) {
			return false;
		}
		for (NMBBienCargas carga : this.bienCargas) {
			if (carga.getSituacionCarga()!=null && 
					DDSituacionCarga.ACEPTADA.equals(carga.getSituacionCarga().getCodigo())) {
				resultado = true;
				break;
			}
			if (carga.getSituacionCargaEconomica()!=null && 
					DDSituacionCarga.ACEPTADA.equals(carga.getSituacionCargaEconomica().getCodigo())) {
				resultado = true;
				break;
			}
		}
		return resultado;
	}

	public Boolean getDueDilligence() {
		return dueDilligence;
	}

	public void setDueDilligence(Boolean dueDilligence) {
		this.dueDilligence = dueDilligence;
	}

	public String getTransmitentePromotor() {
		return transmitentePromotor;
	}

	public void setTransmitentePromotor(String transmitentePromotor) {
		this.transmitentePromotor = transmitentePromotor;
	}

	public String getArrendadoSinOpcCompra() {
		return arrendadoSinOpcCompra;
	}

	public void setArrendadoSinOpcCompra(String arrendadoSinOpcCompra) {
		this.arrendadoSinOpcCompra = arrendadoSinOpcCompra;
	}

	public String getUsoPromotorMayorDosAnyos() {
		return usoPromotorMayorDosAnyos;
	}

	public void setUsoPromotorMayorDosAnyos(String usoPromotorMayorDosAnyos) {
		this.usoPromotorMayorDosAnyos = usoPromotorMayorDosAnyos;
	}

	public Date getFechaDueD() {
		return fechaDueD;
	}

	public void setFechaDueD(Date fechaDueD) {
		this.fechaDueD = fechaDueD;
	}

	public Date getFechaSolicitudDueD() {
		return fechaSolicitudDueD;
	}

	public void setFechaSolicitudDueD(Date fechaSolicitudDueD) {
		this.fechaSolicitudDueD = fechaSolicitudDueD;
	}

	public DDTipoTributacion getTributacion() {
		return tributacion;
	}

	public void setTributacion(DDTipoTributacion tributacion) {
		this.tributacion = tributacion;
	}

//	public void setAdjudicacionOK(Boolean adjudicacionOK) {
//		this.adjudicacionOK = adjudicacionOK;
//	}
//
//	public void setSaneamientoOK(Boolean saneamientoOK) {
//		this.saneamientoOK = saneamientoOK;
//	}
//
//	public void setPosesionOK(Boolean posesionOK) {
//		this.posesionOK = posesionOK;
//	}
//
//	public void setLlavesOK(Boolean llavesOK) {
//		this.llavesOK = llavesOK;
//	}
//
//	public void setTareaActivaAdjudicacion(String tareaActivaAdjudicacion) {
//		this.tareaActivaAdjudicacion = tareaActivaAdjudicacion;
//	}
//
//	public void setTareaNotificacionActivaAdjudicacion(TareaNotificacion tareaNotificacionActivaAdjudicacion) {
//		this.tareaNotificacionActivaAdjudicacion = tareaNotificacionActivaAdjudicacion;
//	}
//	
//	public void setTareaActivaSaneamiento(String tareaActivaSaneamiento) {
//		this.tareaActivaSaneamiento = tareaActivaSaneamiento;
//	}
//
//	public void setTareaActivaPosesion(String tareaActivaPosesion) {
//		this.tareaActivaPosesion = tareaActivaPosesion;
//	}
//
//	public void setTareaActivaLlaves(String tareaActivaLlaves) {
//		this.tareaActivaLlaves = tareaActivaLlaves;
//	}
	/**
	 * Indica si este bien tiene o no número de activo.
	 * 
	 * @param nmbBien
	 * @return
	 */
	public boolean tieneNumeroActivo() {
		boolean encontrado = false;
		try {
			if (!Checks.esNulo(this.getNumeroActivo())) {
				BigInteger numActivo = new BigInteger(this.getNumeroActivo());
				encontrado = (BigInteger.ZERO.compareTo(numActivo)<0); // Si el número es 0 o 1 indica que es un valor >=0 por lo tanto no vale.
			}
		} catch (NumberFormatException nfe) {
			logger.debug("Numero de activo vacío para idBien: " + this.getId(), nfe);
		}
		return encontrado;
	}

	public Float getPorcentajeImpuestoCompra() {
		return porcentajeImpuestoCompra;
	}

	public void setPorcentajeImpuestoCompra(Float porcentajeImpuestoCompra) {
		this.porcentajeImpuestoCompra = porcentajeImpuestoCompra;
	}

	public DDimpuestoCompra getImpuestoCompra() {
		return impuestoCompra;
	}

	public void setImpuestoCompra(DDimpuestoCompra impuestoCompra) {
		this.impuestoCompra = impuestoCompra;
	}

	public String getSarebId() {
		return sarebId;
	}

	public void setSarebId(String sarebId) {
		this.sarebId = sarebId;
	}

	public static NMBBien instanceOf(Bien bien) {
		NMBBien nmbBien = null;
		if (bien==null) return null;
		//Hibernate.initialize(bien);
	    if (bien instanceof HibernateProxy) {
	        nmbBien = (NMBBien) ((HibernateProxy) bien).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (bien instanceof NMBBien){
			nmbBien = (NMBBien)bien;
		}
		return nmbBien;
	}
	
	public DDTipoImposicion getTipoImposicionCompra() {
		return tipoImposicionCompra;
	}

	public void setTipoImposicionCompra(DDTipoImposicion tipoImposicionCompra) {
		this.tipoImposicionCompra = tipoImposicionCompra;
	}

	public DDTipoTributacion getTributacionVenta() {
		return tributacionVenta;
	}

	public void setTributacionVenta(DDTipoTributacion tributacionVenta) {
		this.tributacionVenta = tributacionVenta;
	}

	public DDTipoImposicion getTipoImposicionVenta() {
		return tipoImposicionVenta;
	}

	public void setTipoImposicionVenta(DDTipoImposicion tipoImposicionVenta) {
		this.tipoImposicionVenta = tipoImposicionVenta;
	}

	public DDSiNo getInversionPorRenuncia() {
		return inversionPorRenuncia;
	}

	public void setInversionPorRenuncia(DDSiNo inversionPorRenuncia) {
		this.inversionPorRenuncia = inversionPorRenuncia;
	}

	/**
	 * @return the destinoUso
	 */
	public String getDestinoUso() {
		return destinoUso;
	}

	/**
	 * @param destinoUso the destinoUso to set
	 */
	public void setDestinoUso(String destinoUso) {
		this.destinoUso = destinoUso;
	}

	/**
	 * @return the numDomicilio
	 */
	public String getNumDomicilio() {
		return numDomicilio;
	}

	/**
	 * @param numDomicilio the numDomicilio to set
	 */
	public void setNumDomicilio(String numDomicilio) {
		this.numDomicilio = numDomicilio;
	}

	/**
	 * @return the idDireccion
	 */
	public String getIdDireccion() {
		return idDireccion;
	}

	/**
	 * @param idDireccion the idDireccion to set
	 */
	public void setIdDireccion(String idDireccion) {
		this.idDireccion = idDireccion;
	}	
}
