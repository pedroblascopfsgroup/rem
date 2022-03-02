package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de subestados de un expediente comercial.
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "DD_SEC_SUBEST_EXP_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubestadosExpedienteComercial implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String PDTE_SANCION_HRE = "47";
	public static final String PDTE_PROPIEDAD_HRE = "48";
	public static final String PDTE_ACEPTACION_CONTRAOFERTA = "49";
	public static final String PDTE_CONFIRMACION_OFERTA = "50";
	public static final String CONGELADA = "54";
	public static final String RECHAZA_INQUILINO = "38";
	public static final String RECHAZA_ECONOMICAMENTE = "37";
	public static final String RECHAZA_CONTRASTE_LISTA = "36";
	public static final String NO_ENTREGA_DOCUMENTOS = "40";
	public static final String ACTIVO_NO_DISPONIBLE = "39";
	public static final String ACTIVO_OKUPADO = "41";
	public static final String DESCARTADA = "13";
	public static final String PDTE_PAGO_RESERVA = "19";
	public static final String PDTE_ENVIO_CONTRATO_FIRMA = "20";
	public static final String PDTE_INQUILINO_RESERVA = "21";
	public static final String PDTE_APODERADO_HRE_RESERVA = "22";
	public static final String PDTE_OBT_DOCUMENTACION = "23";
	public static final String PDTE_ENVIO_DOCUMENTACION_SCORING = "24";
	public static final String PDTE_SANCION_SCORING = "25";
	public static final String PDTE_APORTACION_GARANTIAS = "27";
	public static final String PDTE_SANCION_PROPIEDAD = "26";
	public static final String PDTE_TRAMITES_PREVIOS = "28";
	public static final String PDTE_FECHA_FIRMA = "29";
	public static final String PDTE_ELABORACION_CONTRATO = "30";
	public static final String PDTE_VALIDACION_API = "31";
	public static final String PDTE_INQUILINO_ALQUILER = "32";
	public static final String PDTE_APODERADO_HRE_ALQUILER = "33";
	public static final String PDTE_ENVIO_CONTRATO_SEGURO_RENTAS = "34";
	public static final String PDTE_REGISTRO_POLIZA_SEGURO_RENTAS = "35";
	public static final String ENVIADO = "42";
	public static final String NO_ENVIADO = "43";
	public static final String DESISTIMIENTO_INTERES = "52";
	public static final String BORRADOR = "55";
	
	
	
	
	@Id
	@Column(name = "DD_SEC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubestadosExpedienteGenerator")
	@SequenceGenerator(name = "DDSubestadosExpedienteGenerator", sequenceName = "S_DD_SEC_SUBEST_EXP_COMERCIAL")
	private Long id;
	    
	@Column(name = "DD_SEC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SEC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SEC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEC_ID")
	private DDEstadosExpedienteComercial estadoExpediente;  

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

	public DDEstadosExpedienteComercial getEstadoExpediente() {
		return estadoExpediente;
	}

	public void setEstadoExpediente(DDEstadosExpedienteComercial estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
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