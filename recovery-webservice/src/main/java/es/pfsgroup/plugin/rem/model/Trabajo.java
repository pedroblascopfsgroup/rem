package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

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
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDAcoAprobacionComite;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoMargenTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificadorReam;
import es.pfsgroup.plugin.rem.model.dd.DDRefacturacionTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdelanto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;


/**
 * Modelo que gestiona la informacion de un trabajo.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_TBJ_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class Trabajo implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "TBJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoTrabajoGenerator")
    @SequenceGenerator(name = "ActivoTrabajoGenerator", sequenceName = "S_ACT_TBJ_TRABAJO")
    private Long id;
	
    @Column(name = "TBJ_NUM_TRABAJO")
    private Long numTrabajo;
    
    @Column(name = "TBJ_WEBCOM_ID")
    private Long idTrabajoWebcom;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVC_ID")
    private ActivoProveedorContacto proveedorContacto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PFA_ID")
    private Prefactura prefactura;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID")
    private Usuario solicitante;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTR_ID")
    private DDTipoTrabajo tipoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STR_ID")
    private DDSubtipoTrabajo subtipoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoTrabajo estado;
    
    @Column(name = "TBJ_DESCRIPCION")
	private String descripcion;
    
    @Column(name="TBJ_CUBRE_SEGURO")
    private Boolean cubreSeguro = false;
    
    @Column(name="TBJ_CIA_ASEGURADORA")
    private String ciaAseguradora;  
    
    @Column(name = "TBJ_FECHA_SOLICITUD")
   	private Date fechaSolicitud;
       
    @Column(name = "TBJ_FECHA_APROBACION")
   	private Date fechaAprobacion;
       
    @Column(name = "TBJ_FECHA_FIN")
   	private Date fechaFin;
    
    @Column(name = "TBJ_FECHA_FIN_COMPROMISO")
   	private Date fechaCompromisoEjecucion;
    
    @Column(name="TBJ_FECHA_EJECUTADO")
    private Date fechaEjecucionReal;
    
    @Column(name="TBJ_FECHA_INICIO")
    private Date fechaInicio;
    
    @Column(name="TBJ_CONTINUO_OBSERVACIONES")
    private String continuoObservaciones;
    
    @Column(name="TBJ_FECHA_HORA_CONCRETA")
    private Date fechaHoraConcreta;
    
    @Column(name="TBJ_FECHA_TOPE")
    private Date fechaTope;
    
    @Column(name="TBJ_URGENTE")
    private Boolean urgente;
    
    @Column(name="TBJ_CON_RIESGO_TERCEROS")
    private Boolean riesgoInminenteTerceros;       
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCA_ID")
    private DDTipoCalidad tipoCalidad;
    
    @Column(name="TBJ_TERCERO_NOMBRE")
    private String  terceroNombre;
    
    @Column(name="TBJ_TERCERO_EMAIL")
    private String terceroEmail;
    
    @Column(name="TBJ_TERCERO_DIRECCION")
    private String terceroDireccion;
    
    @Column(name="TBJ_TERCERO_CONTACTO")
    private String terceroContacto;
    
    @Column(name="TBJ_TERCERO_TEL1")
    private String terceroTel1;
    
    @Column(name="TBJ_TERCERO_TEL2")
    private String terceroTel2;    
    
    @Column(name = "TBJ_IMPORTE_PENAL_DIARIO")
   	private Double importePenalizacionDiario;
        
    @Column(name = "TBJ_OBSERVACIONES")
   	private String observaciones;
    
    @Column(name = "TBJ_IMPORTE_TOTAL")
   	private Double importeTotal;
    
    @Column(name = "TBJ_IMPORTE_PRESUPUESTO")
   	private Double importePresupuesto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="MEDIADOR_ID")
    private ActivoProveedor mediador;
    
   	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    private ActivoAgrupacion agrupacion;
    
    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private List<ActivoTrabajo> activosTrabajo;
    
    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TrabajoProvisionSuplido> provisionSuplido;
    
    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TrabajoRecargosProveedor> recargosProveedor;
    
    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntoTrabajo> adjuntos;

    @Column(name="TBJ_TARIFICADO")
    private Boolean esTarificado;    

    @OneToMany(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TrabajoFoto> fotos;    
    
    @Column(name="TBJ_FECHA_RECHAZO")
    private Date fechaRechazo;

    @Column(name="TBJ_MOTIVO_RECHAZO")
    private String motivoRechazo;
    
    @Column(name="TBJ_FECHA_ELECCION_PROVEEDOR")
    private Date fechaEleccionProveedor;
    
    @Column(name="TBJ_FECHA_ANULACION")
    private Date fechaAnulacion;
    
    @Column(name="TBJ_FECHA_VALIDACION")
    private Date fechaValidacion;
    
    @Column(name="TBJ_FECHA_CIERRE_ECONOMICO")
    private Date fechaCierreEconomico;
    
    @Column(name="TBJ_FECHA_PAGO")
    private Date fechaPago;

    @OneToOne(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private PropuestaPrecio propuestaPrecio;
    
    @Column(name="TBJ_FECHA_EMISION_FACTURA")
    private Date fechaEmisionFactura;
    
    @OneToOne(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private GastoLineaDetalleTrabajo gastoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="TBJ_GESTOR_ACTIVO_RESPONSABLE")
    private Usuario usuarioGestorActivoResponsable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="TBJ_SUPERVISOR_ACT_RESPONSABLE")
    private Usuario supervisorActivoResponsable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="TBJ_RESPONSABLE_TRABAJO")
    private Usuario usuarioResponsableTrabajo;
    
    @Column(name="TBJ_NOMBRE_UG")
    private String nombreUg;
	
	@Column(name="TBJ_NOMBRE_PROYECTO")
    private String nombreProyecto;
	
	@Column(name="TBJ_NOMBRE_EXPEDIENTE_TRABAJO")
    private String nombreExpedienteTrabajo;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_IRE_ID")
    private DDIdentificadorReam identificadorReam; 
	
    public Usuario getUsuarioResponsableTrabajo() {
		return usuarioResponsableTrabajo;
	}

	public void setUsuarioResponsableTrabajo(Usuario usuarioResponsableTrabajo) {
		this.usuarioResponsableTrabajo = usuarioResponsableTrabajo;
	}

    @Column(name="TBJ_REQUERIMIENTO")
    private Boolean requerimiento;

   	@Column(name="STR_TARIFA_PLANA")
    private Boolean esTarifaPlana = false;
    
    @Column(name = "ACT_COD_PROMOCION_PRINEX")
    private String codigoPromocionPrinex;
       	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@Column(name="TBJ_FECHA_AUTORIZACION_PROPIET")
    private Date fechaAutorizacionPropietario;	
	
	@Column(name="TBJ_CODIGO_PARTIDA")
    private String codigoPartida;	
	
	@Column(name="TBJ_CODIGO_SUBPARTIDA")
    private String codigoSubpartida;
	
	@Column(name="TBJ_NUM_DND")
    private Long numeroDnd;	
	
	@Column(name="TBJ_NOMBRE_DND")
    private String nombreDnd;
	

	@Column(name="TBJ_TRABAJO_DND")
    private Long trabajoDnd;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="TBJ_GESTOR_ALTA")
    private Usuario gestorAlta;
	
	@Column(name="TBJ_ID_TAREA")
    private String idTarea;
	
	@Column(name="TBJ_APLICA_COMITE")
    private Boolean aplicaComite;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ACO_ID")
    private DDAcoAprobacionComite aprobacionComite;
	
	@Column(name="TBJ_FECHA_RES_COMITE")
    private Date fechaResolucionComite;	
	
	@Column(name="TBJ_RES_COMITE_ID")
    private String resolucionComiteId;

	@Column(name="TBJ_REF_IMPORTE_PRESUPUESTO")
    private String resolucionImportePresupuesto;
	
	@Column(name="TBJ_SINIESTRO")
    private Boolean siniestro;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVC_ID_LLAVES")
    private ActivoProveedorContacto proveedorContactoLlaves;
   
    @Column(name="TBJ_FECHA_ENTREGA_LLAVES")
    private Date fechaEntregaLlaves;
   
    @Column(name="TBJ_NO_APLICA_LLAVES")
    private Boolean noAplicaLlaves;  
   
    @Column(name="TBJ_MOTIVO_LLAVES")
    private String motivoLlaves;  
	
	@Column(name="TBJ_PRIM_TOMA_POS")
    private Boolean tomaPosesion;
	
	@Column(name="TBJ_FECHA_CAMBIO_ESTADO")
	private Date fechaCambioEstado;

	@Column(name = "TBJ_IMPORTE_ASEGURADO")
   	private Double importeAsegurado;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_RFT_ID")
   	private DDRefacturacionTrabajo refacturacionTrabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CMT_ID")
   	private DDCalculoMargenTrabajo calculoMargenTrabajo;
	
	@Column(name = "TBJ_PORCENTAJE_MARGEN")
   	private Double porcentajeMargen;
	
	@Column(name = "TBJ_IMPORTE_MARGEN")
   	private Double importeMargen;
	
    @OneToOne(mappedBy = "trabajo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "TBJ_ID")
    private Prefacturas prefacturaTrabajo;
		
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Long getIdTrabajoWebcom() {
		return idTrabajoWebcom;
	}

	public void setIdTrabajoWebcom(Long idTrabajoWebcom) {
		this.idTrabajoWebcom = idTrabajoWebcom;
	}

	public DDTipoTrabajo getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(DDTipoTrabajo tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public DDEstadoTrabajo getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoTrabajo estado) {
		this.estado = estado;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public ActivoProveedorContacto getProveedorContacto() {
		return proveedorContacto;
	}

	public void setProveedorContacto(ActivoProveedorContacto proveedorContacto) {
		this.proveedorContacto = proveedorContacto;
	}

	public Usuario getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(Usuario solicitante) {
		this.solicitante = solicitante;
	}

	public Boolean getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Boolean cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public String getCiaAseguradora() {
		return ciaAseguradora;
	}

	public void setCiaAseguradora(String ciaAseguradora) {
		this.ciaAseguradora = ciaAseguradora;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public String getContinuoObservaciones() {
		return continuoObservaciones;
	}

	public void setContinuoObservaciones(String continuoObservaciones) {
		this.continuoObservaciones = continuoObservaciones;
	}

	public Date getFechaHoraConcreta() {
		return fechaHoraConcreta;
	}

	public void setFechaHoraConcreta(Date fechaHoraConcreta) {
		this.fechaHoraConcreta = fechaHoraConcreta;
	}

	public Date getFechaTope() {
		return fechaTope;
	}

	public void setFechaTope(Date fechaTope) {
		this.fechaTope = fechaTope;
	}

	public Boolean getUrgente() {
		return urgente;
	}

	public void setUrgente(Boolean urgente) {
		this.urgente = urgente;
	}

	public Boolean getRiesgoInminenteTerceros() {
		return riesgoInminenteTerceros;
	}

	public void setRiesgoInminenteTerceros(Boolean riesgoInminenteTerceros) {
		this.riesgoInminenteTerceros = riesgoInminenteTerceros;
	}

	public DDTipoCalidad getTipoCalidad() {
		return tipoCalidad;
	}

	public void setTipoCalidad(DDTipoCalidad tipoCalidad) {
		this.tipoCalidad = tipoCalidad;
	}

	public String getTerceroNombre() {
		return terceroNombre;
	}

	public void setTerceroNombre(String terceroNombre) {
		this.terceroNombre = terceroNombre;
	}

	public String getTerceroEmail() {
		return terceroEmail;
	}

	public void setTerceroEmail(String terceroEmail) {
		this.terceroEmail = terceroEmail;
	}

	public String getTerceroDireccion() {
		return terceroDireccion;
	}

	public void setTerceroDireccion(String terceroDireccion) {
		this.terceroDireccion = terceroDireccion;
	}

	public String getTerceroContacto() {
		return terceroContacto;
	}

	public void setTerceroContacto(String terceroContacto) {
		this.terceroContacto = terceroContacto;
	}

	public String getTerceroTel1() {
		return terceroTel1;
	}

	public void setTerceroTel1(String terceroTel1) {
		this.terceroTel1 = terceroTel1;
	}

	public String getTerceroTel2() {
		return terceroTel2;
	}

	public void setTerceroTel2(String terceroTel2) {
		this.terceroTel2 = terceroTel2;
	}

	public Date getFechaCompromisoEjecucion() {
		return fechaCompromisoEjecucion;
	}

	public void setFechaCompromisoEjecucion(Date fechaCompromisoEjecucion) {
		this.fechaCompromisoEjecucion = fechaCompromisoEjecucion;
	}

	public Double getImportePenalizacionDiario() {
		return importePenalizacionDiario;
	}

	public void setImportePenalizacionDiario(Double importePenalizacionDiario) {
		this.importePenalizacionDiario = importePenalizacionDiario;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Activo getActivo() {
		if(this.activo==null){
			if(!Checks.estaVacio(getActivosTrabajo()))
				return getActivosTrabajo().get(0).getActivo();
			else
				return null;
		}else{
			return this.activo;
		}
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

	public List<ActivoTrabajo> getActivosTrabajo() {
		
		if(activosTrabajo == null) activosTrabajo = new ArrayList<ActivoTrabajo>(); 
		
		return activosTrabajo;
	}

	public void setActivosTrabajo(List<ActivoTrabajo> activosTrabajo) {
		this.activosTrabajo = activosTrabajo;
	}


	public Date getFechaRechazo() {
		return fechaRechazo;
	}

	public void setFechaRechazo(Date fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public Date getFechaEleccionProveedor() {
		return fechaEleccionProveedor;
	}

	public void setFechaEleccionProveedor(Date fechaEleccionProveedor) {
		this.fechaEleccionProveedor = fechaEleccionProveedor;
	}

	public Date getFechaEjecucionReal() {
		return fechaEjecucionReal;
	}

	public void setFechaEjecucionReal(Date fechaEjecucionReal) {
		this.fechaEjecucionReal = fechaEjecucionReal;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public Date getFechaValidacion() {
		return fechaValidacion;
	}

	public void setFechaValidacion(Date fechaValidacion) {
		this.fechaValidacion = fechaValidacion;
	}

	public Date getFechaCierreEconomico() {
		return fechaCierreEconomico;
	}

	public void setFechaCierreEconomico(Date fechaCierreEconomico) {
		this.fechaCierreEconomico = fechaCierreEconomico;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public List<TrabajoProvisionSuplido> getProvisionSuplido() {
		return provisionSuplido;
	}

	public void setProvisionSuplido(List<TrabajoProvisionSuplido> provisionSuplido) {
		this.provisionSuplido = provisionSuplido;
	}
	
	public List<TrabajoRecargosProveedor> getRecargosProveedor() {
		return recargosProveedor;
	}

	public void setRecargosProveedor(
			List<TrabajoRecargosProveedor> recargosProveedor) {
		this.recargosProveedor = recargosProveedor;
	}

	public List<AdjuntoTrabajo> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<AdjuntoTrabajo> adjuntos) {
		this.adjuntos = adjuntos;
	}
	
	public Date getFechaAutorizacionPropietario() {
		return fechaAutorizacionPropietario;
	}

	public void setFechaAutorizacionPropietario(Date fechaAutorizacionPropietario) {
		this.fechaAutorizacionPropietario = fechaAutorizacionPropietario;
	}

	public Integer getDiasRetrasoOrigen() {
		
		try{
			Date fechaActual = new Date();
			Date fechaCompromiso = new Date();
			Integer diasRetraso = null;
			Date fechaFin = null;
			if (getFechaEjecucionReal()== null ) {
				fechaFin= fechaActual;
			}else {
				fechaFin = getFechaEjecucionReal();
			}
			
				
			if((getFechaCompromisoEjecucion() != null && getFechaFin() == null) || (getFechaCompromisoEjecucion() != null && fechaActual.before(getFechaFin()))){
				fechaCompromiso = getFechaCompromisoEjecucion();
				if(fechaActual != null){
					Long retrasoLong = TimeUnit.DAYS.convert(new Long(fechaFin.getTime() - fechaCompromiso.getTime()), TimeUnit.MILLISECONDS);
					diasRetraso = new Integer(retrasoLong.intValue());
				}
			}
			
			if(diasRetraso == null || (diasRetraso != null && diasRetraso <0)){
				diasRetraso = Integer.valueOf(0);
			}
			
			return diasRetraso;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Integer.valueOf(0);
		}	
	}
	
	public Integer getDiasRetrasoMesCurso() {
		try{
			Integer diasRetrasoMes = null;
			
			Integer diasRetraso = getDiasRetrasoOrigen();
			
			if (diasRetraso > 0)
			{
				Calendar calActual = Calendar.getInstance();
				Integer dayOfMonth = Integer.valueOf(calActual.get(Calendar.DAY_OF_MONTH));
				Integer monthActual = Integer.valueOf(calActual.get(Calendar.MONTH));

				Calendar calCompromiso = Calendar.getInstance();
				calCompromiso.setTime(getFechaCompromisoEjecucion());
				Integer monthCompromiso = Integer.valueOf(calCompromiso.get(Calendar.MONTH));
				
				if (monthCompromiso < monthActual)
				{
					diasRetrasoMes = dayOfMonth;
				}
				else
				{
					diasRetrasoMes = diasRetraso;
				}
			}
			else
			{
				diasRetrasoMes = Integer.valueOf(0);
			}
			
			return diasRetrasoMes;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Integer.valueOf(0);
		}	
	}
	
	public Double getImportePenalizacionTotal() {
		try{
			
			Integer diasRetraso = null;
			Double total = null;
			
			diasRetraso = getDiasRetrasoOrigen();		
			if(diasRetraso == null || (diasRetraso != null && diasRetraso <=0) || getImportePenalizacionDiario() == null){
				total = Double.valueOf(0);
			}else{
				total = diasRetraso * getImportePenalizacionDiario();
			}
			
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}	
	}

	public Double getImportePenalizacionMesCurso() {
		try{
			
			Integer diasRetraso = null;
			Double total = null;
			
			diasRetraso = getDiasRetrasoMesCurso();		
			if(diasRetraso == null || (diasRetraso != null && diasRetraso <=0)){
				total = Double.valueOf(0);
			}else{
				total =diasRetraso * getImportePenalizacionDiario();
			}
			
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}	
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
     * Agrega un adjunto al activo
     */
    public void addAdjunto(FileItem fileItem) {
		AdjuntoTrabajo adjuntoTrabajo = new AdjuntoTrabajo(fileItem);
		adjuntoTrabajo.setTrabajo(this);
        Auditoria.save(adjuntoTrabajo);
        getAdjuntos().add(adjuntoTrabajo);

    }
    
    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoTrabajo getAdjunto(Long id) {
        for (AdjuntoTrabajo adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

	public Boolean getEsTarificado() {
		return esTarificado;
	}

	public void setEsTarificado(Boolean esTarificado) {
		this.esTarificado = esTarificado;
	}

	public List<TrabajoFoto> getFotos() {
		return fotos;
	}

	public void setFotos(List<TrabajoFoto> fotos) {
		this.fotos = fotos;
	}

	public ActivoProveedor getMediador() {
		return mediador;
	}

	public void setMediador(ActivoProveedor mediador) {
		this.mediador = mediador;
	}

	public PropuestaPrecio getPropuestaPrecio() {
		return propuestaPrecio;
	}

	public void setPropuestaPrecio(PropuestaPrecio propuestaPrecio) {
		this.propuestaPrecio = propuestaPrecio;
	}

	public Date getFechaEmisionFactura() {
		return fechaEmisionFactura;
	}

	public void setFechaEmisionFactura(Date fechaEmisionFactura) {
		this.fechaEmisionFactura = fechaEmisionFactura;
	}

	public GastoLineaDetalleTrabajo getGastoTrabajo() {
		return gastoTrabajo;
	}

	public void setGastoTrabajo(GastoLineaDetalleTrabajo gastoTrabajo) {
		this.gastoTrabajo = gastoTrabajo;
	}

	public Double getImporteProvisionesSuplidos() {
		
		Double importe = new Double(0);
		
		for(TrabajoProvisionSuplido ps: provisionSuplido) {
			
			if(DDTipoAdelanto.CODIGO_PROVISION.equals(ps.getTipoAdelanto().getCodigo())) {
				importe-=ps.getImporte();
			} else if (DDTipoAdelanto.CODIGO_SUPLIDO.equals(ps.getTipoAdelanto().getCodigo())) {
				importe+=ps.getImporte();
			}
			
		}		
		return importe;
	}

	public Usuario getUsuarioGestorActivoResponsable() {
		return usuarioGestorActivoResponsable;
	}

	public void setUsuarioGestorActivoResponsable(Usuario usuarioGestorActivoResponsable) {
		this.usuarioGestorActivoResponsable = usuarioGestorActivoResponsable;
	}

	public Usuario getSupervisorActivoResponsable() {
		return supervisorActivoResponsable;
	}

	public void setSupervisorActivoResponsable(Usuario supervisorActivoResponsable) {
		this.supervisorActivoResponsable = supervisorActivoResponsable;
	}

	public Boolean getEsTarifaPlana() {
		return esTarifaPlana;
	}

	public void setEsTarifaPlana(Boolean esTarifaPlana) {
		this.esTarifaPlana = esTarifaPlana;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public Boolean getRequerimiento() {
		return requerimiento;
	}

	public void setRequerimiento(Boolean requerimiento) {
		this.requerimiento = requerimiento;
	}
	
	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoTrabajo getAdjuntoGD(Long idDocRestClient) {
    	for (AdjuntoTrabajo adj : getAdjuntos()) {
    		if(!Checks.esNulo(adj.getIdDocRestClient()) && adj.getIdDocRestClient().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }

	public String getCodigoPartida() {
		return codigoPartida;
	}

	public void setCodigoPartida(String codigoPartida) {
		this.codigoPartida = codigoPartida;
	}

	public String getCodigoSubpartida() {
		return codigoSubpartida;
	}

	public void setCodigoSubpartida(String codigoSubpartida) {
		this.codigoSubpartida = codigoSubpartida;
	}

	public Long getNumeroDnd() {
		return numeroDnd;
	}

	public void setNumeroDnd(Long numeroDnd) {
		this.numeroDnd = numeroDnd;
	}

	public String getNombreDnd() {
		return nombreDnd;
	}

	public void setNombreDnd(String nombreDnd) {
		this.nombreDnd = nombreDnd;
	}

	public String getNombreUg() {
		return nombreUg;
	}

	public void setNombreUg(String nombreUg) {
		this.nombreUg = nombreUg;
	}

	public String getNombreProyecto() {
		return nombreProyecto;
	}

	public void setNombreProyecto(String nombreProyecto) {
		this.nombreProyecto = nombreProyecto;
	}

	public String getNombreExpedienteTrabajo() {
		return nombreExpedienteTrabajo;
	}

	public void setNombreExpedienteTrabajo(String nombreExpedienteTrabajo) {
		this.nombreExpedienteTrabajo = nombreExpedienteTrabajo;
	}

	public Long getTrabajoDnd() {
		return trabajoDnd;
	}

	public void setTrabajoDnd(Long trabajoDnd) {
		this.trabajoDnd = trabajoDnd;
	}
	public Usuario getGestorAlta() {
		return gestorAlta;
	}

	public void setGestorAlta(Usuario gestorAlta) {
		this.gestorAlta = gestorAlta;
	}

	public String getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(String idTarea) {
		this.idTarea = idTarea;
	}

	public Date getFechaResolucionComite() {
		return fechaResolucionComite;
	}

	public void setFechaResolucionComite(Date fechaResolucionComite) {
		this.fechaResolucionComite = fechaResolucionComite;
	}

	public String getResolucionComiteId() {
		return resolucionComiteId;
	}

	public void setResolucionComiteId(String resolucionComiteId) {
		this.resolucionComiteId = resolucionComiteId;
	}

	public Double getImportePresupuesto() {
		return importePresupuesto;
	}

	public void setImportePresupuesto(Double importePresupuesto) {
		this.importePresupuesto = importePresupuesto;
	}

	public String getResolucionImportePresupuesto() {
		return resolucionImportePresupuesto;
	}

	public void setResolucionImportePresupuesto(String resolucionImportePresupuesto) {
		this.resolucionImportePresupuesto = resolucionImportePresupuesto;
	}

	public Boolean getSiniestro() {
		return siniestro;
	}

	public void setSiniestro(Boolean siniestro) {
		this.siniestro = siniestro;
	}

	public Prefactura getPrefactura() {
		return prefactura;
	}

	public void setPrefactura(Prefactura prefactura) {
		this.prefactura = prefactura;
	}

	public Boolean getAplicaComite() {
		return aplicaComite;
	}

	public void setAplicaComite(Boolean aplicaComite) {
		this.aplicaComite = aplicaComite;
	}

	public DDAcoAprobacionComite getAprobacionComite() {
		return aprobacionComite;
	}

	public void setAprobacionComite(DDAcoAprobacionComite aprobacionComite) {
		this.aprobacionComite = aprobacionComite;
	}

	public ActivoProveedorContacto getProveedorContactoLlaves() {
		return proveedorContactoLlaves;
	}

	public void setProveedorContactoLlaves(ActivoProveedorContacto proveedorContactoLlaves) {
		this.proveedorContactoLlaves = proveedorContactoLlaves;
	}

	public Date getFechaEntregaLlaves() {
		return fechaEntregaLlaves;
	}

	public void setFechaEntregaLlaves(Date fechaEntregaLlaves) {
		this.fechaEntregaLlaves = fechaEntregaLlaves;
	}

	public Boolean getNoAplicaLlaves() {
		return noAplicaLlaves;
	}

	public void setNoAplicaLlaves(Boolean noAplicaLlaves) {
		this.noAplicaLlaves = noAplicaLlaves;
	}

	public String getMotivoLlaves() {
		return motivoLlaves;
	}

	public void setMotivoLlaves(String motivoLlaves) {
		this.motivoLlaves = motivoLlaves;
	}

	public Boolean getTomaPosesion() {
		return tomaPosesion;
	}

	public void setTomaPosesion(Boolean tomaPosesion) {
		this.tomaPosesion = tomaPosesion;
	}

	public Date getFechaCambioEstado() {
		return fechaCambioEstado;
	}

	public void setFechaCambioEstado(Date fechaCambioEstado) {
		this.fechaCambioEstado = fechaCambioEstado;
	}

	public Double getImporteAsegurado() {
		return importeAsegurado;
	}

	public void setImporteAsegurado(Double importeAsegurado) {
		this.importeAsegurado = importeAsegurado;
	}

	public DDIdentificadorReam getIdentificadorReam() {
		return identificadorReam;
	}

	public void setIdentificadorReam(DDIdentificadorReam identificadorReam) {
		this.identificadorReam = identificadorReam;
	}
    
	public DDRefacturacionTrabajo getRefacturacionTrabajo() {
		return refacturacionTrabajo;
	}
	
	public void setRefacturacionTrabajo(DDRefacturacionTrabajo refacturacionTrabajo) {
		this.refacturacionTrabajo = refacturacionTrabajo;
	}
	
	public DDCalculoMargenTrabajo getCalculoMargenTrabajo() {
		return calculoMargenTrabajo;
	}
	
	public void setCalculoMargenTrabajo(DDCalculoMargenTrabajo calculoMargenTrabajo) {
		this.calculoMargenTrabajo= calculoMargenTrabajo;
	}
	
	public Double getPorcentajeMargen() {
		return porcentajeMargen;
	}
	
	public void setPorcentajeMargen(Double porcentajeMargen) {
		this.porcentajeMargen = porcentajeMargen;
	}
	
	public Double getImporteMargen() {
		return importeMargen;
	}
	
	public void setImporteMargen(Double importeMargen) {
		this.importeMargen = importeMargen;
	}

	public Prefacturas getPrefacturaTrabajo() {
		return prefacturaTrabajo;
	}

	public void setPrefacturaTrabajo(Prefacturas prefacturaTrabajo) {
		this.prefacturaTrabajo = prefacturaTrabajo;
	}
}
