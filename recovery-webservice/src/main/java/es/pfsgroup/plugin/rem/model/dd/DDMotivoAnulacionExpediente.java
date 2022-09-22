package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de motivos de anulacion de un expediente comercial
 * 
 * @author Bender
 *
 */
@Entity
@Table(name = "DD_MAN_MOTIVO_ANULACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoAnulacionExpediente implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	public static final String CODIGO_COMPRADOR_NO_INTERESADO_OPERACION = "100";
	public static final String CODIGO_INTERESADO_OTRO_INMUEBLE_AREA = "101";
	public static final String CODIGO_INTERESADO_OTRO_INMUEBLE_OTRO_AREA = "102";
	public static final String CODIGO_COMPRADOR_NO_INTERESADO_NADA = "103";
	public static final String CODIGO_EXCESIVO_TIEMPO_FIRMA_RESERVA = "200";
	public static final String CODIGO_NO_LOCALIZADO_CLIENTE = "201";
	public static final String CODIGO_LOCALIZADO_SIN_INTERES_FIRMAR = "202";
	public static final String CODIGO_FALTA_FINANCIACION = "300";
	public static final String CODIGO_MAS_1_MES_FIRMAR_RESERVA = "301";
	public static final String CODIGO_NO_TIENE_DINERO_SIN_FINANCIACION = "302";
	public static final String CODIGO_CIRCUNSTANCIAS_DISTINTAS_PACTADAS_DPT_COMERCIAL = "400";
	public static final String CODIGO_NO_FIRMA_RESERVA_SIN_VISITA = "401";
	public static final String CODIGO_CAUSAS_FISCALES = "402";
	public static final String CODIGO_CAUSAS_RELATIVAS_GASTOS = "403";
	public static final String CODIGO_CAUSAS_RELATIVAS_ESTADO_FISICO = "404";
	public static final String CODIGO_CARGAS_NO_PLANTEADAS = "405";
	public static final String CODIGO_NO_CUMPLE_CONDICION_BANKIA = "500";
	public static final String CODIGO_CLIENTE_NO_AMPLIACION_VALIDEZ = "501";
	public static final String CODIGO_NO_CUMPLE_CONDICION = "502";
	public static final String CODIGO_FUTURO_CUMPLIMIENTO_CONDICION = "503";
	public static final String CODIGO_SOLICITADA_AREA = "600";
	public static final String CODIGO_DETECTADO_IRREGULARIDADES_DPTO_COMERCIAL = "601";
	public static final String CODIGO_DETECTADO_IRREGULARIDADES_DPTO_ADM_TECNICO = "602";
	public static final String CODIGO_DETECTADO_IRREGULARIDADES_DIRECCION = "603";
	public static final String CODIGO_NO_RATIFICADA = "604";
	public static final String CODIGO_MEJOR_OFERTA_POSTERIOR = "605";
	public static final String CODIGO_SAREB_RETIRADA_OBRA_CURSO = "606";
	public static final String CODIGO_VENTA_SKY = "607";
	public static final String CODIGO_VENTA_EXTERNA = "608";
	public static final String CODIGO_ANULADAS_ESCRITURACION = "700";
	public static final String CODIGO_NO_PRESENTADOS_FIRMA_REQUERIDOS = "701";
	public static final String CODIGO_INCUMPLIMIENTO_PLAZOS_FORMA = "702";
	public static final String CODIGO_VENTA_ACTIVO = "705";
	public static final String CODIGO_TRASPASADO_SOLVIA = "706";
	public static final String CODIGO_ERROR_USUARIO_1 = "800";
	public static final String CODIGO_ERROR_USUARIO_2 = "801";
	public static final String CODIGO_VENCIDAS_POR_TIEMPO = "802";
	public static final String CODIGO_ANULADA_POR_VENCIMIENTO = "803";
	public static final String CODIGO_ANULADA_ALTA_NUEVA_FACULTAD_HAYA = "804";
	public static final String CODIGO_FINANCIACION_DENEGADA = "901";
	public static final String CODIGO_PBC_DENEGADO = "902";
	public static final String CODIGO_EXCESIVO_TIEMPO_FIRMA = "903";
	
	public final static String CODIGO_INCUMPLIMIENTO_PLAZO = "904";
	public final static String CODIGO_ORDEN_PROPIEDAD = "905";
	public final static String CODIGO_DESESTIMIENTO_COMPRADOR = "906";
	public final static String CODIGO_3_MESES_SIN_FORMALIZAR = "907";
	public final static String CODIGO_SIN_NOTICIAS_COMPRADOR = "908";
	public final static String CODIGO_FINANCIACION_RECHAZADA = "909";
	public final static String CODIGO_SIN_DOC_PBC = "910";
	public final static String CODIGO_PBC_RECHAZADO = "911";
	public final static String CODIGO_EJERCE_TANTEO = "912";
	public final static String CODIGO_VPO_DENEGADA = "913";
	public final static String CODIGO_INCIDENCIA_JURIDICA_TECNICA = "914";
	public final static String CODIGO_ALTA_OFERTA_ESPEJO = "915";

	public static final String COD_CAIXA_CAMBIO_TITULAR = "1000";
	public static final String COD_CAIXA_CLIENTE_ARREPENTIDO = "2000";
	public static final String COD_CAIXA_OTRA_OFR = "3000";
	public static final String COD_CAIXA_HIPOTECA_PROMOTOR = "4000";
	public static final String COD_CAIXA_INCI_REGISTRADA = "5000";
	public static final String COD_CAIXA_MOD_DATOS_NUEVA_OFR = "6000";
	public static final String COD_CAIXA_MOD_DATOS = "7000";
	public static final String COD_CAIXA_NO_FINANCIA = "8000";
	public static final String COD_CAIXA_NO_FINANCIA_CAIXA = "9000";
	public static final String COD_CAIXA_OCUPA_ILEGAL = "10000";
	public static final String COD_CAIXA_ERROR_DATOS = "11000";
	public static final String COD_CAIXA_RECHAZADO_PBC = "12000";
	public static final String COD_CAIXA_RECHAZADO_NO_DOC_PLAZO = "13000";
	public static final String COD_CAIXA_INCI_TECNICAS = "14000";
	public static final String COD_CAIXA_INC_FECHAS = "15000";
	public static final String COD_CAIXA_RECH_COMITE = "16000";
	public static final String COD_CAIXA_RECH_PROPIEDAD = "17000";
	public static final String COD_CAIXA_RECARGA_OFERTA = "18000";
	public static final String COD_CAIXA_RECH_SCORING = "19000";
	public static final String COD_CAIXA_RECH_GARANTIAS = "20000";
	public static final String COD_CAIXA_LISTA_ESPERA_ALQ = "21000";
	public static final String COD_CAIXA_CLIENTE_ARREPENTIDO_2 = "22000";
	public static final String COD_CAIXA_DATOS_ERR = "23000";
	public static final String COD_CAIXA_MOD_CLAUSULAS = "24000";
	public static final String COD_CAIXA_INM_NO_ADECUADO = "25000";
	public static final String COD_CAIXA_DOC_RESERVA_CAD = "26000";
	public static final String COD_CAIXA_FALTA_BOLETINES = "27000";
	public static final String COD_CAIXA_INCI_TECNICA = "28000";
	public static final String COD_CAIXA_FALTAN_LLAVES = "29000";
	public static final String COD_CAIXA_COND_GARANTIAS_ADIC = "30000";
	public static final String COD_CAIXA_COND_OBLIGADO_CUMP = "31000";
	public static final String COD_CAIXA_GEN_CONTRATO = "32000";
	public static final String COD_CAIXA_INM_BAJA = "33000";
	public static final String COD_CAIXA_FALTA_CEE = "34000";
	public static final String COD_CAIXA_INM_NO_ADEC = "35000";
	public static final String COD_CAIXA_CLI_ALQ_OTRO_INM = "36000";
	public static final String COD_CAIXA_CLI_DES_ZONA = "37000";
	public static final String COD_CAIXA_CLI_DES_PRECIO = "38000";

	@Id
	@Column(name = "DD_MAN_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoAnulacionExpedienteGenerator")
	@SequenceGenerator(name = "DDMotivoAnulacionExpedienteGenerator", sequenceName = "S_DD_MAN_MOTIVO_ANULACION")
	private Long id;
	    
	@Column(name = "DD_MAN_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MAN_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MAN_DESCRIPCION_LARGA")   
	private String descripcionLarga;	
	
	@Column(name = "DD_MAN_VENTA")   
	private Boolean venta;
	
	@Column(name = "DD_MAN_ALQUILER")   
	private Boolean alquiler;
	
	@Column(name = "DD_MAN_VISIBLE_WEB")   
	private Boolean visibleWeb;

	@Column(name = "DD_MAN_CODIGO_C4C")
	private String codC4c;

	@Column(name = "DD_MAN_VISIBLE_CAIXA")
	private Boolean visibleCaixa;

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
	
	public Boolean getVenta() {
		return venta;
	}
	
	public void setVenta(Boolean venta) {
		this.venta = venta;
	}
	
	public Boolean getAlquiler() {
		return alquiler;
	}
	
	public void setAlquiler(Boolean alquiler) {
		this.alquiler = alquiler;
	}

	public Boolean getVisibleWeb() {
		return visibleWeb;
	}

	public void setVisibleWeb(Boolean visibleWeb) {
		this.visibleWeb = visibleWeb;
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

	public String getCodC4c() {
		return codC4c;
	}

	public void setCodC4c(String codC4c) {
		this.codC4c = codC4c;
	}

	public Boolean getVisibleCaixa() {
		return visibleCaixa;
	}

	public void setVisibleCaixa(Boolean visibleCaixa) {
		this.visibleCaixa = visibleCaixa;
	}
}