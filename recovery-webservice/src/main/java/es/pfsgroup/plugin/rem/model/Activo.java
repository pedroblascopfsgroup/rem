package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.DDTipoBien;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBLocalizacionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDOrigenBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.model.dd.ActivoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDClasificacionApple;
import es.pfsgroup.plugin.rem.model.dd.DDDireccionTerritorial;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDEntradaActivoBankia;
import es.pfsgroup.plugin.rem.model.dd.DDEquipoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoCargaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoRegistralActivo;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDProcedenciaProducto;
import es.pfsgroup.plugin.rem.model.dd.DDRatingActivo;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSociedadPagoAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;
import es.pfsgroup.plugin.rem.model.dd.DDValidaEstadoActivo;

/**
 * Modelo que gestiona los activos.
 */
@Entity
@Table(name = "ACT_ACTIVO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Activo implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "ACT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoGenerator")
    @SequenceGenerator(name = "ActivoGenerator", sequenceName = "S_ACT_ACTIVO")
    private Long id;

    @Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo; 
    
    @Column(name = "ACT_NUM_ACTIVO_REM")
	private Long numActivoRem;  
     
    @Column(name = "ACT_NUM_ACTIVO_UVEM")
   	private Long numActivoUvem;
    
    @Column(name = "ACT_NUM_ACTIVO_SAREB")
   	private String idSareb;
    
    @Column(name = "ACT_NUM_ACTIVO_PRINEX")
   	private Long idProp;
    
    @Column(name = "ACT_RECOVERY_ID")
   	private Long idRecovery;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ID")
    private NMBBien bien;

    @Column(name = "ACT_DESCRIPCION")
	private String descripcion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_RTG_ID")
	private DDRatingActivo rating;
    
    @Column(name = "ACT_DIVISION_HORIZONTAL")
   	private Integer divHorizontal;
    
    @Deprecated
    @Column(name = "ACT_GESTION_HRE")
   	private Integer gestionHre;
    
    @Column(name = "ACT_FECHA_REV_CARGAS")
    private Date fechaRevisionCarga;
    
    @Column(name="ACT_CON_CARGAS")
    private Integer conCargas;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TTR_ID")
  	private DDTipoTransmision tipoTransmision;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPA_ID")
    private DDTipoActivo tipoActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo subtipoActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EAC_ID")
    private DDEstadoActivo estadoActivo;
   
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTA_ID")
    private DDTipoTituloActivo tipoTitulo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STA_ID")
    private DDSubtipoTituloActivo subtipoTitulo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;  
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
    private DDSubcartera subcartera;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ENO_ID")
    private DDEntidadOrigen entidadOrigen;  
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ENO_ORIGEN_ANT_ID")
    private DDEntidadOrigen entidadOrigenAnterior;  
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TUD_ID")
    private DDTipoUsoDestino tipoUsoDestino; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCM_ID")
    private DDSituacionComercial situacionComercial;     
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SPG_ID")
    private DDSociedadPagoAnterior sociedadDePagoAnterior;
    
    @Column(name = "ACT_VPO")
    private Integer vpo;
    
    @Column(name = "ACT_LLAVES_NECESARIAS")
    private Integer llavesNecesarias;
	
    @Column(name = "ACT_LLAVES_HRE")
    private Integer llavesHre;
			
	@Column(name = "ACT_LLAVES_FECHA_RECEP")
	private Date fechaRecepcionLlaves;
	
	@Column(name = "ACT_LLAVES_NUM_JUEGOS")
	private Integer numJuegosLlaves;
	
    @Column(name = "ACT_ADMISION")
    private Boolean admision;
    
    @Column(name = "ACT_GESTION")
    private Boolean gestion;
    
    @Column(name = "ACT_SELLO_CALIDAD")
    private Boolean selloCalidad;
    
    @Column(name = "ACT_BLOQUEO_PRECIO_FECHA_INI")
    private Date bloqueoPrecioFechaIni;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SDV_ID")
	private ActivoSubdivision subdivision;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CPR_ID")
	private ActivoComunidadPropietarios comunidadPropietarios;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoTitulo titulo;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoPlanDinVentas> pdvs;  
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoAdjudicacionNoJudicial adjNoJudicial;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoAdjudicacionJudicial adjJudicial;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoSituacionPosesoria situacionPosesoria;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoValoraciones> valoracion;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoInfAdministrativa infoAdministrativa;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoInfoRegistral infoRegistral;

    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoLocalizacion localizacion;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoInfoComercial infoComercial;

    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoLlave> llaves;

    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoCargas> cargas;
	
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoCatastro> catastro;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoPropietarioActivo> propietariosActivo;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoCopropietarioActivo> copropietariosActivo;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoAdmisionDocumento> admisionDocumento;
    
    @OneToMany(mappedBy = "activo", fetch = FetchType.LAZY)
    private List<ActivoTrabajo> activoTrabajos;
     
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoObservacion> observacion;
        
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoTasacion> tasacion;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoFoto> fotos;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoAgrupacionActivo> agrupaciones;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private ActivoPublicacion activoPublicacion;

    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<PresupuestoActivo> presupuesto;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<ActivoAdjuntoActivo> adjuntos;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_BLOQUEO_PRECIO_USU_ID")
	private Usuario gestorBloqueoPrecio;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPU_ID")
    private DDTipoPublicacion tipoPublicacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCO_ID")
    private DDTipoComercializacion tipoComercializacion;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    @OrderBy("fechaVisita")
    private List<Visita> visitas;  
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private List<ActivoOferta> ofertas;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private List<ActivoIntegrado> integraciones;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntosPromocion> adjuntosPromocion;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Cascade({org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private List<AdjuntosProyecto> adjuntosProyecto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DRT_ID")
    private DDDireccionTerritorial direccionTerritorial; 

    // Indicadores de precios del activo y de activo publicable
    @Column(name = "ACT_FECHA_IND_PRECIAR")
    private Date fechaPreciar;
    
    @Column(name = "ACT_FECHA_IND_REPRECIAR")
    private Date fechaRepreciar;
    
    @Column(name = "ACT_FECHA_IND_DESCUENTO")
    private Date fechaDescuento;
    
    @Column(name = "ACT_FECHA_IND_PUBLICABLE")
    private Date fechaPublicable;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TCR_ID")
    private DDTipoComercializar tipoComercializar;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAL_ID")
    private DDTipoAlquiler tipoAlquiler;

    @Column(name = "ACT_VENTA_EXTERNA_FECHA")
    private Date fechaVentaExterna;

    @Column(name = "ACT_VENTA_EXTERNA_OBSERVACION")
    private String observacionesVentaExterna;

    @Column(name = "ACT_VENTA_EXTERNA_IMPORTE")
    private Double importeVentaExterna;

    @Column(name = "ACT_BLOQUEO_TIPO_COMERCIALIZAR")
    private Boolean bloqueoTipoComercializacionAutomatico;

    @ManyToOne
	@JoinColumn(name = "DD_ENA_ID")
	private DDEntradaActivoBankia entradaActivoBankia;

    @Column(name = "ACT_NUM_INMOVILIZADO_BNK")
    private Integer numInmovilizadoBnk;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<TanteoActivoExpediente> tanteoActivoExpediente;
    
	@ManyToOne
	@JoinColumn(name = "ACT_GESTOR_SELLO_CALIDAD")
	private Usuario gestorSelloCalidad;
    
    @Column(name = "ACT_FECHA_SELLO_CALIDAD")
    private Date fechaRevisionSelloCalidad;
    
    @Column(name = "ACT_IBI_EXENTO")
    private Boolean ibiExento;
    
    @Column(name = "ACT_COD_PROMOCION_PRINEX")
    private String codigoPromocionPrinex;
    
    @Column(name = "ACT_VENTA_DIRECTA_BANKIA", columnDefinition = "tinyint default false")
    private boolean ventaDirectaBankia;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private ActivoBNK activoBNK;
    
    @Column(name = "OK_TECNICO")
    private Boolean tieneOkTecnico;

    @Column(name = "ACT_ACTIVO_DEMANDA_AFECT_COM")
    private Integer tieneDemandaAfecCom;

    @Column(name = "ACT_EN_TRAMITE")
    private Integer enTramite;

    @Column(name = "ACT_PUJA")
    private Boolean estaEnPuja;
    
    @Column(name = "ACT_EXCLUIR_DWH")
    private Boolean excluirDwh;    

    @Column(name = "ACT_MOTIVO")
    private String motivoActivo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CAP_ID")
    private DDClasificacionApple clasificacionApple;
    
    @Column(name = "ACT_FECHA_CAMBIO_TIPO_ACT")
    private Date fechaUltCambioTipoActivo;

    @Column(name = "ACT_NUM_ACTIVO_SAN")
    private String idSantander;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SRA_ID")
    private DDServicerActivo servicerActivo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CMS_ID")
    private DDCesionSaneamiento cesionSaneamiento;
    
    @Column(name = "ACT_PERIMETRO_MACC")
    private Integer perimetroMacc;
    
    @Column(name = "ACT_PERIMETRO_CARTERA")
    private Integer perimetroCartera;
    
    @Column(name = "ACT_NOM_CARTERA_PERIMETRO")
    private String nombreCarteraPerimetro;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EQG_ID")
    private DDEquipoGestion equipoGestion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECA_ID")
    private DDEstadoCargaActivo estadoCargaActivo;  
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_VENTA_PLANO")
    private DDSinSiNo ventaSobrePlano;
    
    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ActivoAutorizacionTramitacionOfertas activoAutorizacionTramitacionOfertas;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDC_ID")
    private DDTerritorio territorio; 
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TS_ID")
    private DDTipoSegmento tipoSegmento; 
	
    @Column(name = "ACT_VALOR_LIQUIDEZ")
    private String valorLiquidez;
    
    @Column(name = "ACT_NUM_ACTIVO_DIVARIAN")
	private String numActivoDivarian;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_OAN_ID")
    private DDOrigenAnterior origenAnterior;
    
    @Column(name = "ACT_FECHA_TITULO_ANTERIOR")
	private Date fechaTituloAnterior;
    
    @Column(name = "ACT_DND", columnDefinition = "tinyint default false")
   	private boolean isDnd;
    
    @ManyToOne
	@JoinColumn(name = "DD_EAA_ID")
	private DDEstadoAdmision estadoAdmision;
    
    @ManyToOne
	@JoinColumn(name = "DD_SAA_ID")
	private DDSubestadoAdmision subestadoAdmision;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ERA_ID")
    private DDEstadoRegistralActivo estadoRegistral;
    
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_VEA_ID")
    private DDValidaEstadoActivo estadoValidacionActivoDND; 
	
    @Column(name = "ACT_PORCENTAJE_CONSTRUCCION")
   	private Double porcentajeConstruccion;
	   
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_OVN_COMERC")
    private DDSinSiNo tieneObraNuevaAEfectosComercializacion;
    
    @Column(name = "ACT_OVN_COMERC_FECHA")
	private Date obraNuevaAEfectosComercializacionFecha;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTA_ID_BBVA")
    private DDTipoTituloActivo tipoTituloBbva;
    
    @OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<GastoAsociadoAdquisicion> gastosAsociados;
    
    @Column(name = "ACT_NECESIDAD_IF")
    private Boolean necesidadIfActivo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PRP_ID")
    private DDProcedenciaProducto procedenciaProducto; 

    @Column(name = "ACT_NUM_ACTIVO_CAIXA")
    private String numActivoCaixa;

    @OneToOne(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private ActivoAdmisionRevisionTitulo admisionRevisionTitulo;

    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_GESTION_DND")
    private DDSinSiNo tieneGestionDnd;
    
    // Getters del activo --------------------------------------------
    
    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}	

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getNumActivoRem() {
		return numActivoRem;
	}

	public void setNumActivoRem(Long numActivoRem) {
		this.numActivoRem = numActivoRem;
	}

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public String getIdSareb() {
		return idSareb;
	}

	public void setIdSareb(String idSareb) {
		this.idSareb = idSareb;
	}

	public Long getIdProp() {
		return idProp;
	}

	public void setIdProp(Long idProp) {
		this.idProp = idProp;
	}

	public Long getIdRecovery() {
		return idRecovery;
	}

	public void setIdRecovery(Long idRecovery) {
		this.idRecovery = idRecovery;
	}

	public NMBBien getBien() {
		return bien;
	}

	public void setBien(NMBBien bien) {
		this.bien = bien;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	
	public DDRatingActivo getRating() {
		return rating;
	}

	public void setRating(DDRatingActivo rating) {
		this.rating = rating;
	}

	public Integer getDivHorizontal() {
		return divHorizontal;
	}

	public void setDivHorizontal(Integer divHorizontal) {
		this.divHorizontal = divHorizontal;
	}

	public Date getFechaRevisionCarga() {
		return fechaRevisionCarga;
	}

	public void setFechaRevisionCarga(Date fechaRevisionCarga) {
		this.fechaRevisionCarga = fechaRevisionCarga;
	}

	public Integer getConCargas() {
		return conCargas;
	}

	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public DDEstadoActivo getEstadoActivo() {
		return estadoActivo;
	}

	public void setEstadoActivo(DDEstadoActivo estadoActivo) {
		this.estadoActivo = estadoActivo;
	}

	public DDTipoTituloActivo getTipoTitulo() {
		return tipoTitulo;
	}

	public void setTipoTitulo(DDTipoTituloActivo tipoTitulo) {
		this.tipoTitulo = tipoTitulo;
	}

	public DDSubtipoTituloActivo getSubtipoTitulo() {
		return subtipoTitulo;
	}

	public void setSubtipoTitulo(DDSubtipoTituloActivo subtipoTitulo) {
		this.subtipoTitulo = subtipoTitulo;
	}

	public Integer getVpo() {
		return vpo;
	}

	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public Boolean getSelloCalidad() {
		return selloCalidad;
	}

	public void setSelloCalidad(Boolean selloCalidad) {
		this.selloCalidad = selloCalidad;
	}

	public ActivoSubdivision getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(ActivoSubdivision subdivision) {
		this.subdivision = subdivision;
	}

	public ActivoComunidadPropietarios getComunidadPropietarios() {
		return comunidadPropietarios;
	}

	public void setComunidadPropietarios(
			ActivoComunidadPropietarios comunidadPropietarios) {
		this.comunidadPropietarios = comunidadPropietarios;
	}

	public ActivoTitulo getTitulo() {
		return titulo;
	}

	public void setTitulo(ActivoTitulo titulo) {
		this.titulo = titulo;
	}

	public List<ActivoPlanDinVentas> getPdvs() {
		return pdvs;
	}

	public void setPdvs(List<ActivoPlanDinVentas> pdvs) {
		this.pdvs = pdvs;
	}

	public ActivoAdjudicacionNoJudicial getAdjNoJudicial() {
		return adjNoJudicial;
	}

	public void setAdjNoJudicial(ActivoAdjudicacionNoJudicial adjNoJudicial) {
		this.adjNoJudicial = adjNoJudicial;
	}

	public ActivoSituacionPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(ActivoSituacionPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public List<ActivoLlave> getLlaves() {
		return llaves;
	}

	public void setLlaves(List<ActivoLlave> llaves) {
		this.llaves = llaves;
	}
	
	public List<ActivoValoraciones> getValoracion() {
		return valoracion;
	}

	public void setValoracion(List<ActivoValoraciones> valoracion) {
		this.valoracion = valoracion;
	}

	public ActivoInfoRegistral getInfoRegistral() {
		return infoRegistral;
	}

	public void setInfoRegistral(ActivoInfoRegistral infoRegistral) {
		this.infoRegistral = infoRegistral;
	}
    
   
    // Getters compuestos del bien --------------------------------------------

	public ActivoLocalizacion getLocalizacion() {
		return localizacion;
	}

	public void setLocalizacion(ActivoLocalizacion localizacion) {
		this.localizacion = localizacion;
	}

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public DDTipoBien getTipoBien() {
		return bien.getTipoBien();
	}

	public NMBDDOrigenBien getOrigen() {
		return bien.getOrigen();
	}

	public NMBLocalizacionesBienInfo getLocalizacionActual() {
		return bien.getLocalizacionActual();
	}
	
	public String getIdBienSareb() {
		return bien.getSarebId();
	}
	
	public void setIdBienSareb(String sarebId) {
		this.bien.setSarebId(sarebId);
	}
    
	public DDSociedadPagoAnterior getSociedadDePagoAnterior() {
		return sociedadDePagoAnterior;
	}

	public void setSociedadDePagoAnterior(DDSociedadPagoAnterior sociedadDePagoAnterior) {
		this.sociedadDePagoAnterior = sociedadDePagoAnterior;
	}

	public String getPoblacion() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getPoblacion();
		} else {
			return null;
		}
	}
  
	public String getDireccion() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getDireccion();
		} else {
			return null;
		}
	}
	
	public String getDireccionCompleta() {
		String direccion = "";
		
		ActivoLocalizacion activoLocalizacion = this.getLocalizacion();
		if(activoLocalizacion != null) {
			NMBLocalizacionesBien localizacionesBien = activoLocalizacion.getLocalizacionBien();
			if(localizacionesBien != null) {
				if(localizacionesBien.getTipoVia() != null) {
					direccion = localizacionesBien.getTipoVia().getDescripcion();
				}
			
				if(!Checks.esNulo(localizacionesBien.getNombreVia())) {
					direccion = direccion + " " + localizacionesBien.getNombreVia();
				}
				if(!Checks.esNulo(localizacionesBien.getNumeroDomicilio())) {
					direccion = direccion + " " + localizacionesBien.getNumeroDomicilio();
				}
			}
		}

		return direccion;
	}
  
	public String getCodPostal() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getCodPostal();
		} else {
			return null;
		}
	}
  
	public Localidad getLocalidad() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getLocalidad();
		} else {
			return null;
		}
	}
	
	public void setLocalidad(Localidad localidad) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setLocalidad(localidad);
		} 
	}
	
	public String getPais() {
		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getPais() != null) {
			return bien.getLocalizaciones().get(0).getPais().getCodigo();
		} else {
			return null;
		}
	}
	
	public void setPais(String codigoPais) {
		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getPais() != null) {
			bien.getLocalizaciones().get(0).getPais().setCodigo(codigoPais);
		} 
	}

	public String getPortal() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getPortal();
		} else {
			return null;
		}
	}
  
	public String getEscalera() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getEscalera();
		} else {
  			return null;
  		}
	}
  
	public String getPuerta() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getPuerta();
		} else {
  			return null;
  		}
	}
  
	public String getBarrio() {
		if (bien.getLocalizaciones() != null) {
			return bien.getLocalizaciones().get(0).getBarrio();
		} else {
  			return null;
  		}
	}
  
  	public String getPiso() {
  		if (bien.getLocalizaciones() != null) {
  			return bien.getLocalizaciones().get(0).getPiso();
  		} else {
  			return null;
  		}
  	}
  
  	public String getNumeroDomicilio() {
  		if (bien.getLocalizaciones() != null) {
  			return bien.getLocalizaciones().get(0).getNumeroDomicilio();
  		} else {
  			return null;
  		}
  	}
  
  	public String getNombreVia() {
  		if (bien.getLocalizaciones() != null) {
  			return bien.getLocalizaciones().get(0).getNombreVia();
  		} else {
  			return null;
  		}
  	}	

  	public void setTipoVia(String codigoTipoVia) {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getTipoVia() != null) {
  			bien.getLocalizaciones().get(0).getTipoVia().setCodigo(codigoTipoVia);
  		} 
  	}
  	

  	public void setPoblacion(String poblacion) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).setPoblacion(poblacion);
  		}
	}
  
	public void setDireccion(String direccion) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).setDireccion(direccion);
  		}
	}
  
	public void setCodPostal(String codigoPostal) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setCodPostal(codigoPostal);
		}
	}
  
	public void setPortal(String portal) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setPortal(portal);
		}
	}
  
	public void setEscalera(String escalera) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setEscalera(escalera);
		}
	}
  
	public void setPuerta(String puerta) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setPuerta(puerta);
		}
	}
  
	public void setBarrio(String barrio) {
		if (bien.getLocalizaciones() != null) {
			bien.getLocalizaciones().get(0).setBarrio(barrio);
		}
	}
  
  	public void setPiso(String piso) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).setPiso(piso);
  		}
  	}
  
  	public void setNumeroDomicilio(String numeroDomicilio) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).setNumeroDomicilio(numeroDomicilio);
  		}
  	}
  
  	public void setNombreVia(String nombreVia) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).setNombreVia(nombreVia);
  		}
  	}
  	
  	public String getMunicipio() {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getLocalidad() != null) {
  			return bien.getLocalizaciones().get(0).getLocalidad().getCodigo();
  		} else {
  			return null;
  		}
  	}
  	
  	public String getMunicipioDescripcion() {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getLocalidad() != null) {
  			return bien.getLocalizaciones().get(0).getLocalidad().getDescripcion();
  		} else {
  			return null;
  		}
  	}
  	
  	public void setMunicipio(String codigoMunicipio) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).getLocalidad().setCodigo(codigoMunicipio);
  		}
  	}
  	
  	public void setUnidadMunicipio(String codigoUnidadMunicipio) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).getUnidadPoblacional().setCodigo(codigoUnidadMunicipio);
  		}
  	}
  	
  	public String getUnidadMunicipio() {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getUnidadPoblacional() != null) {
  			return bien.getLocalizaciones().get(0).getUnidadPoblacional().getCodigo();
  		} else {
  			return null;
  		}
  	}
  	
  	public String getProvincia() {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getProvincia() != null) {
  			return bien.getLocalizaciones().get(0).getProvincia().getCodigo();
  		} else {
  			return null;
  		}
  		
  	}
  	
  	public String getProvinciaDescripcion() {
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getProvincia() != null) {
  			return bien.getLocalizaciones().get(0).getProvincia().getDescripcion();
  		} else {
  			return null;
  		}
  		
  	}
  	
  	public void setProvincia(String codProvincia) {
  		if (bien.getLocalizaciones() != null) {
  			bien.getLocalizaciones().get(0).getProvincia().setCodigo(codProvincia);
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

	public ActivoInfAdministrativa getInfoAdministrativa() {
		return infoAdministrativa;
	}

	public void setInfoAdministrativa(ActivoInfAdministrativa infoAdministrativa) {
		this.infoAdministrativa = infoAdministrativa;
	}


	public List<ActivoCargas> getCargas() {
		return cargas;
	}

	public void setCargas(List<ActivoCargas> cargas) {
		this.cargas = cargas;
	}
	

	public List<ActivoCatastro> getCatastro() {
		return catastro;
	}

	public void setCatastro(List<ActivoCatastro> catastro) {
		this.catastro = catastro;
	}

	public Float getTotalSuperficieConstruida() {
		try{
			
			Float total = Float.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getSuperficieConstruida() != null){
						total += catastro.getSuperficieConstruida();
					}
				}		
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Float.valueOf(0);
		}	
	}

	
	public Float getTotalSuperficieUtil() {
		try{
			
			Float total = Float.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getSuperficieUtil() != null){
						total += catastro.getSuperficieUtil();
					}
				}			
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Float.valueOf(0);
		}
	}

	
	public Float getTotalSuperficieReperComun() {
		try{
			
			Float total = Float.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getSuperficieReperComun() != null){
						total += catastro.getSuperficieReperComun();
					}
				}			
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Float.valueOf(0);
		}
	}


	public Float getTotalSuperficieParcela() {
		try{
			
			Float total = Float.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getSuperficieParcela() != null){
						total += catastro.getSuperficieParcela();
					}
				}		
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Float.valueOf(0);
		}
	}


	public Float getTotalSuperficieSuelo() {
		try{
			
			Float total = Float.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getSuperficieSuelo() != null){
						total += catastro.getSuperficieSuelo();
					}
				}		
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Float.valueOf(0);
		}
	}

	public Double getTotalValorCatastralConst() {
		try{
			
			Double total = Double.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getValorCatastralConst() != null){
						total += catastro.getValorCatastralConst();
					}
				}		
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}
	}

	public Double getTotalValorCatastralSuelo() {
		try{
			
			Double total = Double.valueOf(0);
			List<ActivoCatastro> listaCatastro = getCatastro();
			
			if(listaCatastro != null && listaCatastro.size()>0){
				Iterator<ActivoCatastro> it = listaCatastro.iterator();
				while (it.hasNext()) {
					ActivoCatastro catastro = (ActivoCatastro) it.next();
					if(catastro.getValorCatastralSuelo() != null){
						total += catastro.getValorCatastralSuelo();
					}
				}		
			}
			return total;
			
		} catch (Exception e) {
			e.printStackTrace();
			return  Double.valueOf(0);
		}
	}
	
	public List<ActivoPropietarioActivo> getPropietariosActivo() {
		return propietariosActivo;
	}

	public void setPropietariosActivo(List<ActivoPropietarioActivo> propietariosActivo) {
		this.propietariosActivo = propietariosActivo;
	}

	public List<ActivoAdmisionDocumento> getAdmisionDocumento() {
		return admisionDocumento;
	}

	public void setAdmisionDocumento(List<ActivoAdmisionDocumento> admisionDocumento) {
		this.admisionDocumento = admisionDocumento;
	}

	public List<ActivoObservacion> getObservacion() {
		return observacion;
	}

	public void setObservacion(List<ActivoObservacion> observacion) {
		this.observacion = observacion;
	}

	@Deprecated
	public List<ActivoTrabajo> getActivoTrabajos() {
		return activoTrabajos;
	}

	public void setActivoTrabajos(List<ActivoTrabajo> activoTrabajos) {
		this.activoTrabajos = activoTrabajos;
	}

	public List<ActivoTasacion> getTasacion() {
		return tasacion;
	}

	public void setTasacion(List<ActivoTasacion> tasacion) {
		this.tasacion = tasacion;
	}

	public ActivoAdjudicacionJudicial getAdjJudicial() {
		return adjJudicial;
	}

	public void setAdjJudicial(ActivoAdjudicacionJudicial adjJudicial) {
		this.adjJudicial = adjJudicial;
	}

	public List<ActivoFoto> getFotos() {
		return fotos;
	}

	public void setFotos(List<ActivoFoto> fotos) {
		this.fotos = fotos;
	}

	public List<ActivoAgrupacionActivo> getAgrupaciones() {
		return agrupaciones;
	}

	public void setAgrupaciones(List<ActivoAgrupacionActivo> agrupaciones) {
		this.agrupaciones = agrupaciones;
	}

	public List<PresupuestoActivo> getPresupuesto() {
		return presupuesto;
	}

	public void setPresupuesto(List<PresupuestoActivo> presupuesto) {
		this.presupuesto = presupuesto;
	}

	public List<ActivoAdjuntoActivo> getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List<ActivoAdjuntoActivo> adjuntos) {
		this.adjuntos = adjuntos;
	}


	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

    public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}
	
	public DDEntidadOrigen getEntidadOrigen() {
		return entidadOrigen;
	}

	public void setEntidadOrigen(DDEntidadOrigen entidadOrigen) {
		this.entidadOrigen = entidadOrigen;
	}

	public DDEntidadOrigen getEntidadOrigenAnterior() {
		return entidadOrigenAnterior;
	}

	public void setEntidadOrigenAnterior(DDEntidadOrigen entidadOrigenAnterior) {
		this.entidadOrigenAnterior = entidadOrigenAnterior;
	}

	public DDTipoUsoDestino getTipoUsoDestino() {
		return tipoUsoDestino;
	}

	public void setTipoUsoDestino(DDTipoUsoDestino tipoUsoDestino) {
		this.tipoUsoDestino = tipoUsoDestino;
	}

	public DDSituacionComercial getSituacionComercial() {
		return situacionComercial;
	}

	public void setSituacionComercial(DDSituacionComercial situacionComercial) {
		this.situacionComercial = situacionComercial;
	}

	public String getFullNamePropietario() {
		
		ActivoPropietario propietario = this.getPropietarioPrincipal();
		if(!Checks.esNulo(propietario)) {
			return propietario.getFullName();			
		}		
		return "Desconocido";

	}
	

	public Integer getLlavesNecesarias() {
		return llavesNecesarias;
	}

	public void setLlavesNecesarias(Integer llavesNecesarias) {
		this.llavesNecesarias = llavesNecesarias;
	}

	@Deprecated
	public Integer getGestionHre() {
		return gestionHre;
	}

	@Deprecated
	public void setGestionHre(Integer gestionHre) {
		this.gestionHre = gestionHre;
	}
	
	/**
     * Agrega un adjunto al activo
     */
    public void addAdjunto(FileItem fileItem) {
		ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo(fileItem);
		adjuntoActivo.setActivo(this);
        Auditoria.save(adjuntoActivo);
        getAdjuntos().add(adjuntoActivo);

    }
    
    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public ActivoAdjuntoActivo getAdjunto(Long id) {
        for (ActivoAdjuntoActivo adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }
    
	/**
     * devuelve el adjunto por Id.
     * @param idDocRestClient: id
     * @return adjunto
     */
    public ActivoAdjuntoActivo getAdjuntoGD(Long idDocRestClient) {
    	for (ActivoAdjuntoActivo adj : getAdjuntos()) {
    		if(!Checks.esNulo(adj.getIdDocRestClient()) && adj.getIdDocRestClient().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }


	/**
     * Agrega un adjuntos de promocion al activo
     */
    public void addAdjuntoPromocion(FileItem fileItem) {
		AdjuntosPromocion adjuntosPromocion = new AdjuntosPromocion(fileItem);
		adjuntosPromocion.setActivo(this);
        Auditoria.save(adjuntosPromocion);
        getAdjuntosPromocion().add(adjuntosPromocion);

    }

    /**
     * devuelve el adjunto de promocion por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntosPromocion getAdjuntoPromocion(Long id) {
        for (AdjuntosPromocion adj : getAdjuntosPromocion()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

	/**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntosPromocion getAdjuntoPromocionGD(Long idDocRestClient) {
    	for (AdjuntosPromocion adj : getAdjuntosPromocion()) {
    		if(!Checks.esNulo(adj.getIdDocRestClient()) && adj.getIdDocRestClient().equals(idDocRestClient)) { return adj; }
        }
        return null;
    }

    /**
	 * Comprueba que tiene un documento adjuntado del
	 * @param activo
	 * @param codigoDocumento
	 * @return
	 */
	public boolean hasAdjunto(String codigoDocumento)
	{
		for(ActivoAdjuntoActivo adjunto : getAdjuntos())
		{
			if(!Checks.esNulo(adjunto.getTipoDocumentoActivo()) && codigoDocumento.equals(adjunto.getTipoDocumentoActivo().getCodigo()))
			{
				return true;
			}
		}
		return false;
	}

	public Integer getLlavesHre() {
		return llavesHre;
	}

	public void setLlavesHre(Integer llavesHre) {
		this.llavesHre = llavesHre;
	}

	public Date getFechaRecepcionLlaves() {
		return fechaRecepcionLlaves;
	}

	public void setFechaRecepcionLlaves(Date fechaRecepcionLlaves) {
		this.fechaRecepcionLlaves = fechaRecepcionLlaves;
	}

	public Integer getNumJuegosLlaves() {
		return numJuegosLlaves;
	}

	public void setNumJuegosLlaves(Integer numJuegosLlaves) {
		this.numJuegosLlaves = numJuegosLlaves;
	}

	public Date getBloqueoPrecioFechaIni() {
		return bloqueoPrecioFechaIni;
	}

	public void setBloqueoPrecioFechaIni(Date bloqueoPrecioFechaIni) {
		this.bloqueoPrecioFechaIni = bloqueoPrecioFechaIni;
	}

	public Usuario getGestorBloqueoPrecio() {
		return gestorBloqueoPrecio;
	}

	public void setGestorBloqueoPrecio(Usuario gestorBloqueoPrecio) {
		this.gestorBloqueoPrecio = gestorBloqueoPrecio;
	}
    
    public DDTipoPublicacion getTipoPublicacion() {
		return tipoPublicacion;
	}

	public void setTipoPublicacion(DDTipoPublicacion tipoPublicacion) {
		this.tipoPublicacion = tipoPublicacion;
	}

	public DDTipoComercializacion getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(DDTipoComercializacion tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}
	
	public List<Visita> getVisitas() {
		return visitas;
	}

	public void setVisitas(List<Visita> visitas) {
		this.visitas = visitas;
	}

	public List<ActivoOferta> getOfertas() {
		return ofertas;
	}

	public void setOfertas(List<ActivoOferta> ofertas) {
		this.ofertas = ofertas;
	}

	public List<ActivoIntegrado> getIntegraciones() {
		return integraciones;
	}

	public void setIntegraciones(List<ActivoIntegrado> integraciones) {
		this.integraciones = integraciones;
	}

	public Date getFechaPreciar() {
		return fechaPreciar;
	}

	public void setFechaPreciar(Date fechaPreciar) {
		this.fechaPreciar = fechaPreciar;
	}

	public Date getFechaRepreciar() {
		return fechaRepreciar;
	}

	public void setFechaRepreciar(Date fechaRepreciar) {
		this.fechaRepreciar = fechaRepreciar;
	}

	public Date getFechaDescuento() {
		return fechaDescuento;
	}

	public void setFechaDescuento(Date fechaDescuento) {
		this.fechaDescuento = fechaDescuento;
	}

	public Date getFechaPublicable() {
		return fechaPublicable;
	}

	public void setFechaPublicable(Date fechaPublicable) {
		this.fechaPublicable = fechaPublicable;
	}

	public DDTipoComercializar getTipoComercializar() {
		return tipoComercializar;
	}

	public void setTipoComercializar(DDTipoComercializar tipoComercializar) {
		this.tipoComercializar = tipoComercializar;
	}

	public DDTipoAlquiler getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(DDTipoAlquiler tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}
	
	/**
	 * Devuelve el propietario principal del activo.
	 * @return
	 */
	public ActivoPropietario getPropietarioPrincipal() {
		ActivoPropietario propietario = null;
		
		if(!Checks.estaVacio(this.propietariosActivo)) {
			// TODO Si existe la opción de seleccionar un propietario principal, deberemos devolver el que lo sea
			// y no el primero
			propietario = this.propietariosActivo.get(0).getPropietario();
		}
		
		return propietario;
		
	}

	public Date getFechaVentaExterna() {
		return fechaVentaExterna;
	}

	public void setFechaVentaExterna(Date fechaVentaExterna) {
		this.fechaVentaExterna = fechaVentaExterna;
	}

	public String getObservacionesVentaExterna() {
		return observacionesVentaExterna;
	}

	public void setObservacionesVentaExterna(String observacionesVentaExterna) {
		this.observacionesVentaExterna = observacionesVentaExterna;
	}

	public Double getImporteVentaExterna() {
		return importeVentaExterna;
	}

	public void setImporteVentaExterna(Double importeVentaExterna) {
		this.importeVentaExterna = importeVentaExterna;
	}
	
	public Boolean getBloqueoTipoComercializacionAutomatico() {
		return bloqueoTipoComercializacionAutomatico;
	}

	public void setBloqueoTipoComercializacionAutomatico(
			Boolean bloqueoTipoComercializacionAutomatico) {
		this.bloqueoTipoComercializacionAutomatico = bloqueoTipoComercializacionAutomatico;

	}

	public Integer getNumInmovilizadoBnk() {
		return numInmovilizadoBnk;
	}

	public void setNumInmovilizadoBnk(Integer numInmovilizadoBnk) {
		this.numInmovilizadoBnk = numInmovilizadoBnk;
	}

	public List<TanteoActivoExpediente> getTanteoActivoExpediente() {
		return tanteoActivoExpediente;
	}

	public void setTanteoActivoExpediente(
			List<TanteoActivoExpediente> tanteoActivoExpediente) {
		this.tanteoActivoExpediente = tanteoActivoExpediente;
	}

	public Usuario getGestorSelloCalidad() {
		return gestorSelloCalidad;
	}

	public void setGestorSelloCalidad(Usuario gestorSelloCalidad) {
		this.gestorSelloCalidad = gestorSelloCalidad;
	}

	public Date getFechaRevisionSelloCalidad() {
		return fechaRevisionSelloCalidad;
	}

	public void setFechaRevisionSelloCalidad(Date fechaRevisionSelloCalidad) {
		this.fechaRevisionSelloCalidad = fechaRevisionSelloCalidad;
	}

	public Boolean getIbiExento() {
		return ibiExento;
	}

	public void setIbiExento(Boolean ibiExento) {
		this.ibiExento = ibiExento;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public DDEntradaActivoBankia getEntradaActivoBankia() {
		return entradaActivoBankia;
	}

	public void setEntradaActivoBankia(DDEntradaActivoBankia entradaActivoBankia) {
		this.entradaActivoBankia = entradaActivoBankia;
	}

	public List<ActivoCopropietarioActivo> getCopropietariosActivo() {
		return copropietariosActivo;
	}

	public void setCopropietariosActivo(List<ActivoCopropietarioActivo> copropietariosActivo) {
		this.copropietariosActivo = copropietariosActivo;
	}

	public Boolean getVentaDirectaBankia() {
		return ventaDirectaBankia;
	}

	public void setVentaDirectaBankia(Boolean ventaDirectaBankia) {
		this.ventaDirectaBankia = ventaDirectaBankia;
	}

	public ActivoBNK getActivoBNK() {
		return activoBNK;
	}

	public void setActivoBNK(ActivoBNK activoBNK) {
		this.activoBNK = activoBNK;
	}

	public ActivoPublicacion getActivoPublicacion() {
		return activoPublicacion;
	}

	public void setActivoPublicacion(ActivoPublicacion activoPublicacion) {
		this.activoPublicacion = activoPublicacion;
	}

	public Boolean getTieneOkTecnico() {
		return tieneOkTecnico;
	}

	public void setTieneOkTecnico(Boolean tieneOkTecnico) {
		this.tieneOkTecnico = tieneOkTecnico;
	}

	public Integer getEnTramite() {
		return enTramite;
	}

	public void setEnTramite(Integer enTramite) {
		this.enTramite = enTramite;
	}


	public List<AdjuntosPromocion> getAdjuntosPromocion() {
		return adjuntosPromocion;
	}

	public void setAdjuntosPromocion(List<AdjuntosPromocion> adjuntosPromocion) {
		this.adjuntosPromocion = adjuntosPromocion;
	}

	public Integer getTieneDemandaAfecCom() {
		return tieneDemandaAfecCom;
	}

	public void setTieneDemandaAfecCom(Integer tieneDemandaAfecCom) {
		this.tieneDemandaAfecCom = tieneDemandaAfecCom;
	}

	public Boolean getEstaEnPuja() {
		return estaEnPuja;
	}

	public void setEstaEnPuja(Boolean estaEnPuja) {
		this.estaEnPuja = estaEnPuja;
	}

	public Boolean getExcluirDwh() {
		return excluirDwh;
	}

	public void setExcluirDwh(Boolean excluirDwh) {
		this.excluirDwh = excluirDwh;
	}
	
	public String getMotivoActivo() {
		return motivoActivo;
	}

	public void setMotivoActivo(String motivoActivo) {
		this.motivoActivo = motivoActivo;
	}

	public DDClasificacionApple getClasificacionApple() {
		return clasificacionApple;
	}

	public void setClasificacionApple(DDClasificacionApple clasificacionApple) {
		this.clasificacionApple = clasificacionApple;
	}

	public Date getFechaUltCambioTipoActivo() {
		return fechaUltCambioTipoActivo;
	}

	public void setFechaUltCambioTipoActivo(Date fechaUltCambioTipoActivo) {
		this.fechaUltCambioTipoActivo = fechaUltCambioTipoActivo;
	}

	public String getIdSantander() {
		return idSantander;
	}

	public void setIdSantander(String idSantander) {
		this.idSantander = idSantander;
	}
	
	public DDServicerActivo getServicerActivo() {
		return servicerActivo;
	}

	public void setServicerActivo(DDServicerActivo servicerActivo) {
		this.servicerActivo = servicerActivo;
	}

	public DDCesionSaneamiento getCesionSaneamiento() {
		return cesionSaneamiento;
	}

	public void setCesionSaneamiento(DDCesionSaneamiento cesionSaneamiento) {
		this.cesionSaneamiento = cesionSaneamiento;
	}

	public Integer getPerimetroMacc() {
		return perimetroMacc;
	}

	public void setPerimetroMacc(Integer perimetroMacc) {
		this.perimetroMacc = perimetroMacc;
	}

	public Integer getPerimetroCartera() {
		return perimetroCartera;
	}

	public void setPerimetroCartera(Integer perimetroCartera) {
		this.perimetroCartera = perimetroCartera;
	}

	public String getNombreCarteraPerimetro() {
		return nombreCarteraPerimetro;
	}

	public void setNombreCarteraPerimetro(String nombreCarteraPerimetro) {
		this.nombreCarteraPerimetro = nombreCarteraPerimetro;
	}

	public DDEquipoGestion getEquipoGestion() {
		return equipoGestion;
	}

	public void setEquipoGestion(DDEquipoGestion equipoGestion) {
		this.equipoGestion = equipoGestion;
	}

	public List<AdjuntosProyecto> getAdjuntosProyecto() {
		return this.adjuntosProyecto;
	}
	
	public void setAdjuntosProyecto(List<AdjuntosProyecto> adjuntosProyecto) {
		this.adjuntosProyecto = adjuntosProyecto;
	}
	
  public AdjuntosProyecto getAdjuntoProyecto(Long id) {
       for (AdjuntosProyecto adj : getAdjuntosProyecto()) {
           if (adj.getId().equals(id)) { return adj; }
       }
       return null;
  }
  
  public AdjuntosProyecto getAdjuntoProyectoGD(Long id) {
	  for (AdjuntosProyecto adj : getAdjuntosProyecto()) {
          if (!Checks.esNulo(adj.getIdDocRest()) && adj.getIdDocRest().equals(id)) { return adj; }
      }
      return null;
  }
  
  public boolean tieneCedulaHabitabilidad() {
	  for (ActivoAdmisionDocumento ado : admisionDocumento) {
          if (DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD.equals(ado.getConfigDocumento().getTipoDocumentoActivo().getCodigo())
        		  || DDTipoDocumentoActivo.CODIGO_CEDULA_HABITABILIDAD2.equals(ado.getConfigDocumento().getTipoDocumentoActivo().getCodigo())) { return true; }
      }
      return false;
  }
   
  public void addAdjuntoProyecto(FileItem fileItem) {
	   AdjuntosProyecto adjuntosProyecto = new AdjuntosProyecto(fileItem);
	   adjuntosProyecto.setActivo(this);
       Auditoria.save(adjuntosProyecto);
       getAdjuntosProyecto().add(adjuntosProyecto);

  }

	public DDEstadoCargaActivo getEstadoCargaActivo() {
		return estadoCargaActivo;
	}

	public void setEstadoCargaActivo(DDEstadoCargaActivo estadoCargaActivo) {
		this.estadoCargaActivo = estadoCargaActivo;
	}
	
	public ActivoAutorizacionTramitacionOfertas getActivoAutorizacionTramitacionOfertas() {
		return activoAutorizacionTramitacionOfertas;
	}

	public void setActivoAutorizacionTramitacionOfertas(
			ActivoAutorizacionTramitacionOfertas activoAutorizacionTramitacionOfertas) {
		this.activoAutorizacionTramitacionOfertas = activoAutorizacionTramitacionOfertas;
	}

	public DDSinSiNo getVentaSobrePlano() {
		return ventaSobrePlano;
	}

	public void setVentaSobrePlano(DDSinSiNo ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}
	
	public DDDireccionTerritorial getDireccionTerritorial() {
		return direccionTerritorial;
	}

	public void setDireccionTerritorial(DDDireccionTerritorial direccionTerritorial) {
		this.direccionTerritorial = direccionTerritorial;
	}

	public DDTerritorio getTerritorio() {
		return territorio;
	}

	public void setTerritorio(DDTerritorio territorio) {
		this.territorio = territorio;
	}
	
	public String getValorLiquidez() {
		return valorLiquidez;
	}

	public void setValorLiquidez(String valorLiquidez) {
		this.valorLiquidez = valorLiquidez;
	}

	public DDTipoSegmento getTipoSegmento() {
		return tipoSegmento;
	}

	public void setTipoSegmento(DDTipoSegmento tipoSegmento) {
		this.tipoSegmento = tipoSegmento;
	}

	public List<GastoAsociadoAdquisicion> getGastosAsociados() {
		return gastosAsociados;
	}

	public void setGastosAsociados(List<GastoAsociadoAdquisicion> gastosAsociados) {
		this.gastosAsociados = gastosAsociados;
	}

	public boolean getIsDnd() {
		return isDnd;
	}

	public void setIsDnd(boolean isDnd) {
		this.isDnd = isDnd;
	}

	public String getNumActivoDivarian() {
		return numActivoDivarian;
	}

	public void setNumActivoDivarian(String numActivoDivarian) {
		this.numActivoDivarian = numActivoDivarian;
	}

	public DDOrigenAnterior getOrigenAnterior() {
		return origenAnterior;
	}

	public void setOrigenAnterior(DDOrigenAnterior origenAnterior) {
		this.origenAnterior = origenAnterior;
	}

	public Date getFechaTituloAnterior() {
		return fechaTituloAnterior;
	}

	public void setFechaTituloAnterior(Date fechaTituloAnterior) {
		this.fechaTituloAnterior = fechaTituloAnterior;
	}
	
	public DDEstadoAdmision getEstadoAdmision() {
		return estadoAdmision;
	}

	public void setEstadoAdmision(DDEstadoAdmision estadoAdmision) {
		this.estadoAdmision = estadoAdmision;
	}

	public DDSubestadoAdmision getSubestadoAdmision() {
		return subestadoAdmision;
	}

	public void setSubestadoAdmision(DDSubestadoAdmision subestadoAdmision) {
		this.subestadoAdmision = subestadoAdmision;
	}

	public DDEstadoRegistralActivo getEstadoRegistral() {
		return estadoRegistral;
	}

	public void setEstadoRegistral(DDEstadoRegistralActivo estadoRegistral) {
		this.estadoRegistral = estadoRegistral;
	}
	
	public DDTipoTituloActivo getTipoTituloBbva() {
		return tipoTituloBbva;
	}

	public DDSinSiNo getTieneObraNuevaAEfectosComercializacion() {
		return tieneObraNuevaAEfectosComercializacion;
	}

	public void setTieneObraNuevaAEfectosComercializacion(DDSinSiNo tieneObraNuevaAEfectosComercializacion) {
		this.tieneObraNuevaAEfectosComercializacion = tieneObraNuevaAEfectosComercializacion;
	}

	public Date getObraNuevaAEfectosComercializacionFecha() {
		return obraNuevaAEfectosComercializacionFecha;
	}

	public void setObraNuevaAEfectosComercializacionFecha(Date obraNuevaAEfectosComercializacionFecha) {
		this.obraNuevaAEfectosComercializacionFecha = obraNuevaAEfectosComercializacionFecha;
	}

	public DDValidaEstadoActivo getEstadoValidacionActivoDND() {
		return estadoValidacionActivoDND;
	}

	public void setEstadoValidacionActivoDND(DDValidaEstadoActivo estadoValidacionActivoDND) {
		this.estadoValidacionActivoDND = estadoValidacionActivoDND;
	}
	public Double getPorcentajeConstruccion() {
		return porcentajeConstruccion;
	}

	public void setPorcentajeConstruccion(Double porcentajeConstruccion) {
		this.porcentajeConstruccion = porcentajeConstruccion;
	}

	public void setTipoTituloBbva(DDTipoTituloActivo tipoTituloBbva) {
		this.tipoTituloBbva = tipoTituloBbva;
	}

	public DDTipoTransmision getTipoTransmision() {
		return tipoTransmision;
	}

	public void setTipoTransmision(DDTipoTransmision tipoTransmision) {
		this.tipoTransmision = tipoTransmision;
	}

	public Boolean getNecesidadIfActivo() {
		return necesidadIfActivo;
	}

	public void setNecesidadIfActivo(Boolean necesidadIfActivo) {
		this.necesidadIfActivo = necesidadIfActivo;
	}
	
	public DDProcedenciaProducto getProcedenciaProducto() {
		return procedenciaProducto;
	}

	public void setProcedenciaProducto(DDProcedenciaProducto procedenciaProducto) {
		this.procedenciaProducto = procedenciaProducto;
	}
	public String getNumActivoCaixa() {
		return numActivoCaixa;
	}

	public void setNumActivoCaixa(String numActivoCaixa) {
		this.numActivoCaixa = numActivoCaixa;
	}
	public ActivoAdmisionRevisionTitulo getAdmisionRevisionTitulo() {
		return admisionRevisionTitulo;
	}

	public void setAdmisionRevisionTitulo(ActivoAdmisionRevisionTitulo admisionRevisionTitulo) {
		this.admisionRevisionTitulo = admisionRevisionTitulo;
	}
	
	public DDSinSiNo getTieneGestionDnd() {
		return tieneGestionDnd;
	}

	public void setTieneGestionDnd(DDSinSiNo tieneGestionDnd) {
		this.tieneGestionDnd = tieneGestionDnd;
	}
	public DDTipoVia getTipoVia() {
		DDTipoVia tipoVia = null;
  		if (bien.getLocalizaciones() != null && bien.getLocalizaciones().get(0).getTipoVia() != null) {
  			tipoVia =  bien.getLocalizaciones().get(0).getTipoVia();
  		} 
  		
  		return tipoVia;
  	}
}
