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
 * Modelo que gestiona el diccionario de Tipos de riesgo de operacion.
 * 
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "DD_EEB_ESTADO_EXPEDIENTE_BC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoExpedienteBc implements Auditable, Dictionary {
		
	public static final String CODIGO_PDTE_APROBACION_BC = "001";
	public static final String CODIGO_OFERTA_CANCELADA = "002";
	public static final String CODIGO_OFERTA_APROBADA = "003";
	public static final String CODIGO_CONTRAOFERTA_ACEPTADA = "004";
	public static final String CODIGO_SCORING_A_REVISAR_POR_BC = "005";
	public static final String CODIGO_VALORAR_ACUERDO_SIN_GARANTIAS_ADICIONALES = "006";
	public static final String CODIGO_OFERTA_PDTE_SCORING = "007";
	public static final String CODIGO_BLOQUEADA_POR_SCREENING_BC = "008";
	public static final String CODIGO_ARRAS_PENDIENTES_DE_APROBACION_BC = "009";
	public static final String CODIGO_ARRAS_DOCUMENTACION_APORTADA_A_BC = "010";
	public static final String CODIGO_INGRESO_FINAL_PDTE_BC = "011";
	public static final String CODIGO_INGRESO_FINAL_DOCUMENTACION_APORTADA_A_BC = "012";
	public static final String CODIGO_ARRAS_PRORROGADAS = "013";
	public static final String CODIGO_INGRESO_DE_ARRAS = "014";
	public static final String CODIGO_VALIDACION_DE_FIRMA_DE_ARRAS_POR_BC = "015";
	public static final String CODIGO_FIRMA_DE_ARRAS_AGENDADAS = "016";
	public static final String CODIGO_ARRAS_FIRMADAS = "017";
	public static final String CODIGO_VALIDACION_DE_FIRMA_DE_CONTRATO_POR_BC = "018";
	public static final String CODIGO_FIRMA_DE_CONTRATO_AGENDADO = "019";
	public static final String CODIGO_CONTRATO_FIRMADO = "020";
	public static final String CODIGO_VENTA_FORMALIZADA = "021";
	public static final String CODIGO_COMPROMISO_CANCELADO = "022";
	public static final String CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC = "023";
	public static final String CODIGO_ARRAS_PTE_DOCUMENTACION = "024";
	public static final String CODIGO_ARRAS_APROBADAS = "025";
	public static final String CODIGO_IMPORTE_FINAL_PTE_DOC = "026";
	public static final String CODIGO_IMPORTE_FINAL_APROBADO = "027";
	public static final String CODIGO_PTE_GARANTIAS_ADICIONALES = "028";
	public static final String CODIGO_SCORING_APROBADO = "029";
	public static final String CODIGO_CONTRAOFERTADO = "030";
	public static final String CODIGO_PTE_SANCION_PATRIMONIO = "031";
	public static final String CODIGO_PTE_CALCULO_RIESGO = "032";
	public static final String CODIGO_SOLICITUD_MODIFICACION_VALORACION = "033";
	public static final String CODIGO_PTE_ENVIO = "034";
	public static final String CODIGO_PTE_AGENDAR_ARRAS = "035";	
	public static final String CODIGO_FIRMA_APROBADA = "036";
	public static final String CODIGO_EN_TRAMITE = "037";
	public static final String CODIGO_PENDIENTE_GARANTIAS_ADICIONALES_BC = "038";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_EEB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoExpedienteBcGenerator")
	@SequenceGenerator(name = "DDEstadoExpedienteBcGenerator", sequenceName = "S_DD_EEB_ESTADO_EXPEDIENTE_BC")
	private Long id;
	    
	@Column(name = "DD_EEB_CODIGO")   
	private String codigo;
    
	@Column(name = "DD_EEB_CODIGO_C4C")   
	private String codigoC4C;
	 
	@Column(name = "DD_EEB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EEB_DESCRIPCION_LARGA")   
	private String descripcionLarga;

	@Column(name = "DD_EEB_VENTA")
	private Boolean esVenta;

	@Column(name = "DD_EEB_ALQUILER")
	private Boolean esAlquiler;

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

	public Boolean getEsVenta() {
		return esVenta;
	}

	public void setEsVenta(Boolean esVenta) {
		this.esVenta = esVenta;
	}

	public Boolean getEsAlquiler() {
		return esAlquiler;
	}

	public void setEsAlquiler(Boolean esAlquiler) {
		this.esAlquiler = esAlquiler;
	}

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

}