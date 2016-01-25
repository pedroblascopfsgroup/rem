package es.pfsgroup.plugin.recovery.nuevoModeloBienes.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "BIE_ADJ_ADJUDICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class NMBAdjudicacionBien implements Serializable, Auditable{

	private static final long serialVersionUID = -3290771629640906608L;

	
	@Id
    @Column(name = "BIE_ADJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "NMBAdjudicacionBienGenerator")
    @SequenceGenerator(name = "NMBAdjudicacionBienGenerator", sequenceName = "S_BIE_ADJ_ADJUDICACION")
    private Long idAdjudicacion;
	 
	@OneToOne
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "BIE_ID")
	private NMBBien bien;

	@Column(name = "BIE_ADJ_F_DECRETO_N_FIRME")
	private Date fechaDecretoNoFirme;
	
	@Column(name = "BIE_ADJ_F_DECRETO_FIRME")
	private Date fechaDecretoFirme;
	
	@Column(name = "BIE_ADJ_F_ENTREGA_GESTOR")
	private Date fechaEntregaGestor;
	
	@Column(name = "BIE_ADJ_F_PRESEN_HACIENDA") 
	private Date fechaPresentacionHacienda;
	
	@Column(name = "BIE_ADJ_F_SEGUNDA_PRESEN")
	private Date fechaSegundaPresentacion;
	
	@Column(name = "BIE_ADJ_F_RECPCION_TITULO")
	private Date fechaRecepcionTitulo;
	
	@Column(name = "BIE_ADJ_F_INSCRIP_TITULO")
	private Date fechaInscripcionTitulo;
	
	@Column(name = "BIE_ADJ_F_ENVIO_ADICION")
	private Date fechaEnvioAdicion;
	
	@Column(name = "BIE_ADJ_F_PRESENT_REGISTRO") 
	private Date fechaPresentacionRegistro;
	
	@Column(name = "BIE_ADJ_F_SOL_POSESION") 
	private Date fechaSolicitudPosesion;
	
	@Column(name = "BIE_ADJ_F_SEN_POSESION") 
	private Date fechaSenalamientoPosesion;
	
	@Column(name = "BIE_ADJ_F_REA_POSESION")
	private Date fechaRealizacionPosesion;
	
	@Column(name = "BIE_ADJ_F_SOL_LANZAMIENTO") 
	private Date fechaSolicitudLanzamiento;
	
	@Column(name = "BIE_ADJ_F_SEN_LANZAMIENTO")
	private Date fechaSenalamientoLanzamiento;
	
	@Column(name = "BIE_ADJ_F_REA_LANZAMIENTO")
	private Date fechaRealizacionLanzamiento;
	
	@Column(name = "BIE_ADJ_F_SOL_MORATORIA")
	private Date fechaSolicitudMoratoria;
	
	@Column(name = "BIE_ADJ_F_RES_MORATORIA")
	private Date fechaResolucionMoratoria;
	
	@Column(name = "BIE_ADJ_F_CONTRATO_ARREN") 
	private Date fechaContratoArrendamiento;
	
	@Column(name = "BIE_ADJ_F_CAMBIO_CERRADURA")
	private Date fechaCambioCerradura;
	
	@Column(name = "BIE_ADJ_F_ENVIO_LLAVES")
	private Date fechaEnvioLLaves;
	
	@Column(name = "BIE_ADJ_F_RECEP_DEPOSITARIO") 
	private Date fechaRecepcionDepositario;
	
	@Column(name = "BIE_ADJ_F_RECEP_DEPOSITARIO_F") 
	private Date fechaRecepcionDepositarioFinal;
	
	@Column(name = "BIE_ADJ_F_ENVIO_DEPOSITARIO") 
	private Date fechaEnvioDepositario;
	
	@Column(name = "BIE_ADJ_OCUPADO") 
	private Boolean ocupado;
	
	@Column(name = "BIE_ADJ_POSIBLE_POSESION") 
	private Boolean posiblePosesion;
	
	@Column(name = "BIE_ADJ_OCUPANTES_DILIGENCIA") 
	private Boolean ocupantesDiligencia;
	
	@Column(name = "BIE_ADJ_LANZAMIENTO_NECES")  
	private Boolean lanzamientoNecesario ;
	
	@Column(name = "BIE_ADJ_ENTREGA_VOLUNTARIA")  
	private Boolean entregaVoluntaria;
	
	@Column(name = " BIE_ADJ_NECESARIA_FUERA_PUB")
	private Boolean necesariaFuerzaPublica;
	
	@Column(name = "BIE_ADJ_EXISTE_INQUILINO")  
	private Boolean existeInquilino;
	
	@Column(name = "BIE_ADJ_LLAVES_NECESARIAS") 
	private Boolean llavesNecesarias;
	
	@OneToOne
	@JoinColumn(name = "BIE_ADJ_GESTORIA_ADJUDIC") 
	private Usuario gestoriaAdjudicataria;
	
	@Column(name = "BIE_ADJ_NOMBRE_ARRENDATARIO")
	private String nombreArrendatario;
	
	@Column(name = "BIE_ADJ_NOMBRE_DEPOSITARIO") 
	private String nombreDepositario;
	
	@Column(name = "BIE_ADJ_NOMBRE_DEPOSITARIO_F") 
	private String nombreDepositarioFinal;

	@OneToOne
	@JoinColumn(name = "DD_TFO_ID")
	private DDTipoFondo fondo;
	
	@OneToOne
	@JoinColumn(name = "DD_EAD_ID") 
	private DDEntidadAdjudicataria entidadAdjudicataria;
	
	@OneToOne
	@JoinColumn(name = "DD_SIT_ID")
	private DDSituacionTitulo situacionTitulo;
	
	@OneToOne
	@JoinColumn(name = "DD_FAV_ID ")
	private DDFavorable resolucionMoratoria;
	
	@Column(name = "BIE_ADJ_REQ_SUBSANACION")  
	private Boolean requiereSubsanacion;
	
	@Column(name = "BIE_ADJ_NOTIF_DEMANDADOS")  
	private Boolean notificacionDemandados;
	
	@Column(name = "BIE_ADJ_F_REV_PROP_CAN") 
	private Date fechaRevisarPropuestaCancelacion;
	
	@Column(name = "BIE_ADJ_F_PROP_CAN") 
	private Date fechaPropuestaCancelacion;
	
	@Column(name = "BIE_ADJ_F_REV_CARGAS") 
	private Date fechaRevisarCargas;
	
	@Column(name = "BIE_ADJ_F_PRES_INS_ECO") 
	private Date fechaPresentacionInsEco;
	
	@Column(name = "BIE_ADJ_F_PRES_INS") 
	private Date fechaPresentacionIns;
	
	@Column(name = "BIE_ADJ_F_CAN_REG_ECO") 
	private Date fechaCancelacionRegEco;
	
	@Column(name = "BIE_ADJ_F_CAN_REG") 
	private Date fechaCancelacionReg;
	
	@Column(name = "BIE_ADJ_F_CAN_ECO") 
	private Date fechaCancelacionEco;
	
	@Column(name = "BIE_ADJ_F_LIQUIDACION") 
	private Date fechaLiquidacion;
	
	@Column(name = "BIE_ADJ_F_RECEPCION") 
	private Date fechaRecepcion;
	
	@Column(name = "BIE_ADJ_F_CANCELACION") 
	private Date fechaCancelacion;
	
    @Column(name = "BIE_ADJ_IMPORTE_ADJUDICACION")
    private BigDecimal importeAdjudicacion;
    
    @Column(name = "BIE_ADJ_CESION_REMATE")
    private Boolean cesionRemate;
    
    @Column(name = "BIE_ADJ_CESION_REMATE_IMP")
    private Float importeCesionRemate;
    
    @OneToOne
    @JoinColumn(name = "DD_DAD_ID")
	private DDDocAdjudicacion tipoDocAdjudicacion;
    
    @Column(name = "BIE_ADJ_F_CONTABILIDAD")
    private Date fechaContabilidad;

	@Embedded
	private Auditoria auditoria;


	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public Long getIdAdjudicacion() {
		return idAdjudicacion;
	}

	public void setIdAdjudicacion(Long idAdjudicacion) {
		this.idAdjudicacion = idAdjudicacion;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public Date getFechaDecretoNoFirme() {
		return fechaDecretoNoFirme;
	}

	public void setFechaDecretoNoFirme(Date fechaDecretoNoFirme) {
		this.fechaDecretoNoFirme = fechaDecretoNoFirme;
	}

	public Date getFechaDecretoFirme() {
		return fechaDecretoFirme;
	}

	public void setFechaDecretoFirme(Date fechaDecretoFirme) {
		this.fechaDecretoFirme = fechaDecretoFirme;
	}

	public Date getFechaEntregaGestor() {
		return fechaEntregaGestor;
	}

	public void setFechaEntregaGestor(Date fechaEntregaGestor) {
		this.fechaEntregaGestor = fechaEntregaGestor;
	}

	public Date getFechaPresentacionHacienda() {
		return fechaPresentacionHacienda;
	}

	public void setFechaPresentacionHacienda(Date fechaPresentacionHacienda) {
		this.fechaPresentacionHacienda = fechaPresentacionHacienda;
	}

	public Date getFechaSegundaPresentacion() {
		return fechaSegundaPresentacion;
	}

	public void setFechaSegundaPresentacion(Date fechaSegundaPresentacion) {
		this.fechaSegundaPresentacion = fechaSegundaPresentacion;
	}

	public Date getFechaRecepcionTitulo() {
		return fechaRecepcionTitulo;
	}

	public void setFechaRecepcionTitulo(Date fechaRecepcionTitulo) {
		this.fechaRecepcionTitulo = fechaRecepcionTitulo;
	}

	public Date getFechaInscripcionTitulo() {
		return fechaInscripcionTitulo;
	}

	public void setFechaInscripcionTitulo(Date fechaInscripcionTitulo) {
		this.fechaInscripcionTitulo = fechaInscripcionTitulo;
	}

	public Date getFechaEnvioAdicion() {
		return fechaEnvioAdicion;
	}

	public void setFechaEnvioAdicion(Date fechaEnvioAdicion) {
		this.fechaEnvioAdicion = fechaEnvioAdicion;
	}

	public Date getFechaPresentacionRegistro() {
		return fechaPresentacionRegistro;
	}

	public void setFechaPresentacionRegistro(Date fechaPresentacionRegistro) {
		this.fechaPresentacionRegistro = fechaPresentacionRegistro;
	}

	public Date getFechaSolicitudPosesion() {
		return fechaSolicitudPosesion;
	}

	public void setFechaSolicitudPosesion(Date fechaSolicitudPosesion) {
		this.fechaSolicitudPosesion = fechaSolicitudPosesion;
	}

	public Date getFechaSenalamientoPosesion() {
		return fechaSenalamientoPosesion;
	}

	public void setFechaSenalamientoPosesion(Date fechaSenalamientoPosesion) {
		this.fechaSenalamientoPosesion = fechaSenalamientoPosesion;
	}

	public Date getFechaRealizacionPosesion() {
		return fechaRealizacionPosesion;
	}

	public void setFechaRealizacionPosesion(Date fechaRealizacionPosesion) {
		this.fechaRealizacionPosesion = fechaRealizacionPosesion;
	}

	public Date getFechaSolicitudLanzamiento() {
		return fechaSolicitudLanzamiento;
	}

	public void setFechaSolicitudLanzamiento(Date fechaSolicitudLanzamiento) {
		this.fechaSolicitudLanzamiento = fechaSolicitudLanzamiento;
	}

	public Date getFechaSenalamientoLanzamiento() {
		return fechaSenalamientoLanzamiento;
	}

	public void setFechaSenalamientoLanzamiento(Date fechaSenalamientoLanzamiento) {
		this.fechaSenalamientoLanzamiento = fechaSenalamientoLanzamiento;
	}

	public Date getFechaRealizacionLanzamiento() {
		return fechaRealizacionLanzamiento;
	}

	public void setFechaRealizacionLanzamiento(Date fechaRealizacionLanzamiento) {
		this.fechaRealizacionLanzamiento = fechaRealizacionLanzamiento;
	}

	public Date getFechaRecepcionDepositarioFinal() {
		return fechaRecepcionDepositarioFinal;
	}

	public void setFechaRecepcionDepositarioFinal(Date fechaRecepcionDepositarioFinal) {
		this.fechaRecepcionDepositarioFinal = fechaRecepcionDepositarioFinal;
	}

	public Date getFechaSolicitudMoratoria() {
		return fechaSolicitudMoratoria;
	}

	public void setFechaSolicitudMoratoria(Date fechaSolicitudMoratoria) {
		this.fechaSolicitudMoratoria = fechaSolicitudMoratoria;
	}

	public Date getFechaResolucionMoratoria() {
		return fechaResolucionMoratoria;
	}

	public void setFechaResolucionMoratoria(Date fechaResolucionMoratoria) {
		this.fechaResolucionMoratoria = fechaResolucionMoratoria;
	}

	public Date getFechaContratoArrendamiento() {
		return fechaContratoArrendamiento;
	}

	public void setFechaContratoArrendamiento(Date fechaContratoArrendamiento) {
		this.fechaContratoArrendamiento = fechaContratoArrendamiento;
	}

	public Date getFechaCambioCerradura() {
		return fechaCambioCerradura;
	}

	public void setFechaCambioCerradura(Date fechaCambioCerradura) {
		this.fechaCambioCerradura = fechaCambioCerradura;
	}

	public Date getFechaEnvioLLaves() {
		return fechaEnvioLLaves;
	}

	public void setFechaEnvioLLaves(Date fechaEnvioLLaves) {
		this.fechaEnvioLLaves = fechaEnvioLLaves;
	}

	public Date getFechaRecepcionDepositario() {
		return fechaRecepcionDepositario;
	}

	public void setFechaRecepcionDepositario(Date fechaRecepcionDepositario) {
		this.fechaRecepcionDepositario = fechaRecepcionDepositario;
	}

	public Date getFechaEnvioDepositario() {
		return fechaEnvioDepositario;
	}

	public void setFechaEnvioDepositario(Date fechaEnvioDepositario) {
		this.fechaEnvioDepositario = fechaEnvioDepositario;
	}

	public Boolean getOcupado() {
		return ocupado;
	}

	public void setOcupado(Boolean ocupado) {
		this.ocupado = ocupado;
	}

	public Boolean getPosiblePosesion() {
		return posiblePosesion;
	}

	public void setPosiblePosesion(Boolean posiblePosesion) {
		this.posiblePosesion = posiblePosesion;
	}

	public Boolean getOcupantesDiligencia() {
		return ocupantesDiligencia;
	}

	public void setOcupantesDiligencia(Boolean ocupantesDiligencia) {
		this.ocupantesDiligencia = ocupantesDiligencia;
	}

	public Boolean getLanzamientoNecesario() {
		return lanzamientoNecesario;
	}

	public void setLanzamientoNecesario(Boolean lanzamientoNecesario) {
		this.lanzamientoNecesario = lanzamientoNecesario;
	}

	public Boolean getEntregaVoluntaria() {
		return entregaVoluntaria;
	}

	public void setEntregaVoluntaria(Boolean entregaVoluntaria) {
		this.entregaVoluntaria = entregaVoluntaria;
	}

	public Boolean getNecesariaFuerzaPublica() {
		return necesariaFuerzaPublica;
	}

	public void setNecesariaFuerzaPublica(Boolean necesariaFuerzaPublica) {
		this.necesariaFuerzaPublica = necesariaFuerzaPublica;
	}

	public Boolean getExisteInquilino() {
		return existeInquilino;
	}

	public void setExisteInquilino(Boolean existeInquilino) {
		this.existeInquilino = existeInquilino;
	}

	public Boolean getLlavesNecesarias() {
		return llavesNecesarias;
	}

	public void setLlavesNecesarias(Boolean llavesNecesarias) {
		this.llavesNecesarias = llavesNecesarias;
	}

	public Usuario getGestoriaAdjudicataria() {
		return gestoriaAdjudicataria;
	}

	public void setGestoriaAdjudicataria(Usuario gestoriaAdjudicataria) {
		this.gestoriaAdjudicataria = gestoriaAdjudicataria;
	}

	public String getNombreArrendatario() {
		return nombreArrendatario;
	}

	public void setNombreArrendatario(String nombreArrendatario) {
		this.nombreArrendatario = nombreArrendatario;
	}

	public String getNombreDepositario() {
		return nombreDepositario;
	}

	public void setNombreDepositario(String nombreDepositario) {
		this.nombreDepositario = nombreDepositario;
	}

	public String getNombreDepositarioFinal() {
		return nombreDepositarioFinal;
	}

	public void setNombreDepositarioFinal(String nombreDepositarioFinal) {
		this.nombreDepositarioFinal = nombreDepositarioFinal;
	}

	public DDTipoFondo getFondo() {
		return fondo;
	}

	public void setFondo(DDTipoFondo fondo) {
		this.fondo = fondo;
	}

	public DDEntidadAdjudicataria getEntidadAdjudicataria() {
		return entidadAdjudicataria;
	}

	public void setEntidadAdjudicataria(DDEntidadAdjudicataria entidadAdjudicataria) {
		this.entidadAdjudicataria = entidadAdjudicataria;
	}

	public DDSituacionTitulo getSituacionTitulo() {
		return situacionTitulo;
	}

	public void setSituacionTitulo(DDSituacionTitulo situacionTitulo) {
		this.situacionTitulo = situacionTitulo;
	}

	public DDFavorable getResolucionMoratoria() {
		return resolucionMoratoria;
	}

	public void setResolucionMoratoria(DDFavorable resolucionMoratoria) {
		this.resolucionMoratoria = resolucionMoratoria;
	}

	public Boolean getRequiereSubsanacion() {
		return requiereSubsanacion;
	}

	public void setRequiereSubsanacion(Boolean requiereSubsanacion) {
		this.requiereSubsanacion = requiereSubsanacion;
	}

	public Boolean getNotificacionDemandados() {
		return notificacionDemandados;
	}

	public void setNotificacionDemandados(Boolean notificacionDemandados) {
		this.notificacionDemandados = notificacionDemandados;
	}

	public Date getFechaRevisarPropuestaCancelacion() {
		return fechaRevisarPropuestaCancelacion;
	}

	public void setFechaRevisarPropuestaCancelacion(Date fechaRevisarPropuestaCancelacion) {
		this.fechaRevisarPropuestaCancelacion = fechaRevisarPropuestaCancelacion;
	}

	public Date getFechaPropuestaCancelacion() {
		return fechaPropuestaCancelacion;
	}

	public void setFechaPropuestaCancelacion(Date fechaPropuestaCancelacion) {
		this.fechaPropuestaCancelacion = fechaPropuestaCancelacion;
	}

	public Date getFechaRevisarCargas() {
		return fechaRevisarCargas;
	}

	public void setFechaRevisarCargas(Date fechaRevisarCargas) {
		this.fechaRevisarCargas = fechaRevisarCargas;
	}

	public Date getFechaPresentacionInsEco() {
		return fechaPresentacionInsEco;
	}

	public void setFechaPresentacionInsEco(Date fechaPresentacionInsEco) {
		this.fechaPresentacionInsEco = fechaPresentacionInsEco;
	}

	public Date getFechaPresentacionIns() {
		return fechaPresentacionIns;
	}

	public void setFechaPresentacionIns(Date fechaPresentacionIns) {
		this.fechaPresentacionIns = fechaPresentacionIns;
	}

	public Date getFechaCancelacionRegEco() {
		return fechaCancelacionRegEco;
	}

	public void setFechaCancelacionRegEco(Date fechaCancelacionRegEco) {
		this.fechaCancelacionRegEco = fechaCancelacionRegEco;
	}

	public Date getFechaCancelacionReg() {
		return fechaCancelacionReg;
	}

	public void setFechaCancelacionReg(Date fechaCancelacionReg) {
		this.fechaCancelacionReg = fechaCancelacionReg;
	}

	public Date getFechaCancelacionEco() {
		return fechaCancelacionEco;
	}

	public void setFechaCancelacionEco(Date fechaCancelacionEco) {
		this.fechaCancelacionEco = fechaCancelacionEco;
	}

	public Date getFechaLiquidacion() {
		return fechaLiquidacion;
	}

	public void setFechaLiquidacion(Date fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}

	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}

	public BigDecimal getImporteAdjudicacion() {
		return importeAdjudicacion;
	}

	public void setImporteAdjudicacion(BigDecimal importeAdjudicacion) {
		this.importeAdjudicacion = importeAdjudicacion;
	}

	public Boolean getCesionRemate() {
		return cesionRemate;
	}

	public void setCesionRemate(Boolean cesionRemate) {
		this.cesionRemate = cesionRemate;
	}

	public Float getImporteCesionRemate() {
		return importeCesionRemate;
	}

	public void setImporteCesionRemate(Float importeCesionRemate) {
		this.importeCesionRemate = importeCesionRemate;
	}

	public DDDocAdjudicacion getTipoDocAdjudicacion() {
		return tipoDocAdjudicacion;
	}

	public void setTipoDocAdjudicacion(DDDocAdjudicacion tipoDocAdjudicacion) {
		this.tipoDocAdjudicacion = tipoDocAdjudicacion;
	}

	public Date getFechaContabilidad() {
		return fechaContabilidad;
	}

	public void setFechaContabilidad(Date fechaContabilidad) {
		this.fechaContabilidad = fechaContabilidad;
	}
	
}
