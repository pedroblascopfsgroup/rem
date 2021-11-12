package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Funcion;


@Entity
@Table(name = "DD_OPM_OPERACION_MASIVA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDOperacionMasiva implements Serializable, Auditable, Dictionary {

	// (Tabla DD_OPM_OPERACION_MASIVA)
	// CODIGO POR TIPOS DE PROCESIMIENTOS MASIVO
	public static final String CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED="AGAR";
	public static final String CODE_FILE_BULKUPLOAD_NEW_BUILDING="AGAN";
	public static final String CODE_FILE_BULKUPLOAD_AGRUPACION_ASISTIDA="AGAA";
	public static final String CODE_FILE_BULKUPLOAD_AGRUPACION_LOTE_COMERCIAL="AGLC";
	public static final String CODE_FILE_BULKUPLOAD_AGRUPACION_LOTE_COMERCIAL_ALQUILER="AGAL";
	public static final String CODE_FILE_BULKUPLOAD_AGRUPACION_PROYECTO="AGAP";
	public static final String CODE_FILE_BULKUPLOAD_LISTAACTIVOS="LACT";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR_ORDINARIA="APBO"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PUBLICAR="APUB"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARACTIVO="AOAC"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARACTIVO="ADAC"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_OCULTARPRECIO="AOPR"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESOCULTARPRECIO="ADPR"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESPUBLICAR="ADPU"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_PUBLICAR_FORZADO="ADPF"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_DESPUBLICAR_FORZADO="ADDF"; //TODO: eliminar.
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_AUTORIZAREDICION="AEME";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_IMPORTE="ADPA";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_FSV_ACTIVO_IMPORTE="ACPF";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_BLOQUEO="BBPA";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PRECIOS_ACTIVO_DESBLOQUEO="DBPA";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO="ACPA";
	public static final String CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO="CPPA";
	public static final String CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD01="CPPA_01";
	public static final String CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD02="CPPA_02";
	public static final String CODE_FILE_BULKUPLOAD_PROPUESTA_PRECIOS_ACTIVO_ENTIDAD03="CPPA_03";
	public static final String CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_FINANCIEROS="AAAF";
	public static final String CODE_FILE_BULKUPLOAD_MARCAR_IBI_EXENTO_ACTIVO="AMIE";
	public static final String CODE_FILE_BULKUPLOAD_DESMARCAR_IBI_EXENTO_ACTIVO="ADIE";
	public static final String CODE_FILE_BULKUPLOAD_ASOCIAR_ACTIVOS_GASTO="ACGA";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_GESTORES="CMG";
	public static final String CODE_FILE_BULKUPLOAD_OCULTACION_VENTA = "CMOV";
	public static final String CODE_FILE_BULKUPLOAD_OCULTACION_ALQUILER = "CMOA";
	public static final String CODE_FILE_BULKUPLOAD_DESOCULTACION_VENTA = "CMDOV";
	public static final String CODE_FILE_BULKUPLOAD_DESOCULTACION_ALQUILER = "CMDOA";
	public static final String CODE_FILE_BULKUPLOAD_PUBLICAR_ACTIVOS_VENTA="APV";
	public static final String CODE_FILE_BULKUPLOAD_PUBLICAR_ACTIVOS_ALQUILER="APA";
	public static final String CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_THIRD_PARTY = "AATP";
	public static final String CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA = "VDC";
	public static final String CODE_FILE_BULKUPLOAD_CENTRAL_TECNICA_OK_TECNICO_SELLO_CALIDAD = "OKTECSELLOCAL";
	public static final String CODE_FILE_BULKUPLOAD_OCULTACION_ALQUILER_AGRUPACION_RESTRINGIDA = "OAAR";
	public static final String CODE_FILE_BULKUPLOAD_OCULTACION_VENTA_AGRUPACION_RESTRINGIDA = "OVAR";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_ACTIVOS_GASTOS_PORCENTAJE="AGP";
	public static final String CODE_FILE_BULKUPLOAD_INFO_DETALLE_PRINEX_LBK = "PRINEX";
	public static final String CODE_FILE_BULKUPLOAD_SITUACION_COMUNIDADEDES_PROPIETARIOS = "SCOM";
	public static final String CODE_FILE_BULKUPLOAD_SITUACION_PLUSVALIA = "SPL";
	public static final String CODE_FILE_BULKUPLOAD_SITUACION_IMPUESTOS = "SIMP";
	public static final String CODE_FILE_BULKUPLOAD_INDICADOR_ACTIVO_VENTA = "MIAV";
	public static final String CODE_FILE_BULKUPLOAD_INDICADOR_ACTIVO_ALQUILER = "MIAA";
	public static final String CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ADECUACION = "CMAD";
	public static final String CODE_FILE_BULKUPLOAD_EXCLUSION_DWH = "EXDWH";
	public static final String CODE_FILE_BULKUPLOAD_AGRUPACION_PROMOCION_ALQUILER = "AGAPA";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES = "CMSAN";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES = "CMRE";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMUNICACIONES = "CMCO";
	public static final String CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ENVIO_BUROFAX = "CMEB";
	public static final String CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_IMPUESTOS = "CMI";
	public static final String CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZACION_SUPERFICIE = "CMSUP";
	public static final String CODE_FILE_BULKUPLOAD_VALIDADOR_ACTUALIZADOR_FECHA_INGRESO_CHEQUE = "CMFIC";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_OFERTAS_GTAM = "CMOFG";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_ECONOMICA_TRABAJOS = "CMGET";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FORMALIZACION="FORM";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_PUBLICACION = "CMEP";
	public static final String CODE_FILE_BULKUPLOAD_DISCLAIMER_PUBLICACION = "SUFDP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_DISTRIBUCION_PRECIOS = "CDP";
	public static final String CODE_FILE_BULKUPLOAD_SUPER_GASTOS_REFACTURABLES = "SUPGR";
	public static final String CODE_FILE_BULKUPLOAD_VALORES_PERIMETRO_APPLE = "VALPA";	
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_LPO="CML";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DOCUMENTACION_ADMINISTRATIVA="MSDOCADM";
	public static final String CODE_FILE_BULKUPLOAD_CONTROL_TRIBUTOS="MASCT";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_RECLAMACIONES_PLUSVALIAS="MRP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_JUNTAS="CMJOE";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_INSCRIPCIONES="CMIN";
	public static final String CODE_FILE_BULKUPLOAD_TOMA_POSESION="MSTP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FASES_PUBLICACION ="CMFP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_API_VALIDATOR="CMCAV";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUPER_BORRADO_TRABAJOS = "SUBT";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DIRECCIONES_COMERCIALES ="CMDC";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_TRABAJOS ="ACMT";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_GESTION_PETICIONES_PRECIOS ="GDPD";
	public static final String CODE_FILE_BULKUPLOAD_TACTICO_ESPARTA_PUBLICACIONES ="TEP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SUMINISTROS ="CMS";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_ADMISION="CMESTADOADM";
	public static final String CODE_FILE_BULKUPLOAD_MASIVO_CALIDAD_DATOS ="MCD";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_MODIFICACION_LINEAS_DE_DETALLE ="CMMLD";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_UNICA_GASTOS ="CMUG";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZACION_CAMPOS_ESPARTAR_CONVIVENCIA_SAREB ="CMACCS";


	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_PERIODOS_VOLUNTARIOS="CMCONFPERVOL";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_COMPLEMENTO_TITULO ="CMCT";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_GASTOS_ASOCIADOS_ADQUISICION= "CMGASTOSASOCADQ";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_ACTIVOS_BBVA ="CMALTABBVA";

	public static final String CODE_FILE_BULKUPLOAD_MASIVO_TARIFAS_PRESUPUESTO ="CMTARIFASPRESUP";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SANCIONES_BBVA="CMSANCIONESBBVA";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CAMPOS_ACCESIBILIDAD="CMCAMACC";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_PORCENTAJE_CONSTRUCCION="PRCS";	
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SOBRE_GASTOS="CMDSG";
	public static final String CODE_FILE_BULKUPLOAD_ACTUALIZAR_ESTADO_TRABAJOS="ESTT";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ALTA_TRABAJOS="CMTR";
	
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_FECHA_TITULO_Y_POSESION = "AFTYFS";
	public static final String CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CONFIGURACION_RECOMENDACION = "CFGREC";

	private static final long serialVersionUID = 5938440720826995243L;


	@Id
    @Column(name = "DD_OPM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDOperacionMasivaGenerator")
    @SequenceGenerator(name = "MSVDDOperacionMasivaGenerator", sequenceName = "S_DD_OPM_OPERACION_MASIVA")
    private Long id;

    @Column(name = "DD_OPM_CODIGO")
    private String codigo;

    @Column(name = "DD_OPM_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_OPM_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToOne
    @JoinColumn(name = "FUN_ID")
    private Funcion funcion;

    @Column(name="DD_OPM_VALIDACION_FORMATO")
    private String validacionFormato;

    @Column(name="DD_OPM_RESULTADO")
    private Boolean resultado;

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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Funcion getFuncion() {
		return funcion;
	}

	public void setFuncion(Funcion funcion) {
		this.funcion = funcion;
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

	public void setValidacionFormato(String validacionFormato) {
		this.validacionFormato = validacionFormato;
	}

	public String getValidacionFormato() {
		return validacionFormato;
	}

	public Boolean getResultado() {
		return resultado;
	}

	public void setResultado(Boolean resultado) {
		this.resultado = resultado;
	}


}
