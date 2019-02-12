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

}