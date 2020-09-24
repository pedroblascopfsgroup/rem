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
 * Modelo que gestiona el diccionario de los motivos de anulación de las ofertas.
 * 
 * @author Juanjo Arbona
 *
 */
@Entity
@Table(name = "DD_MAO_MOTIVO_ANULACION_OFR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoAnulacionOferta implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public final static String COD_MOTIVO_ANULACION_TIEMPO_TRAMITACION = "01";
	public final static String COD_MOTIVO_ANULACION_PERDIDA_INTERES_INMUEBLE = "02";
	public final static String COD_MOTIVO_ANULACION_NO_ACEPTACION_CLIENTE = "03";
	public final static String COD_MOTIVO_ANULACION_INCUMPLIMIENTO_PLAZO = "04";
	public final static String COD_MOTIVO_ANULACION_ORDEN_PROPIEDAD = "05";
	public final static String COD_MOTIVO_ANULACION_DESESTIMIENTO_COMPRADOR = "06";
	public final static String COD_MOTIVO_ANULACION_3_MESES_SIN_FORMALIZAR = "07";
	public final static String COD_MOTIVO_ANULACION_SIN_NOTICIAS_COMPRADOR = "08";
	public final static String COD_MOTIVO_ANULACION_FINANCIACION_RECHAZADA = "09";
	public final static String COD_MOTIVO_ANULACION_SIN_DOC_PBC = "10";
	public final static String COD_MOTIVO_ANULACION_PBC_RECHAZADO = "11";
	public final static String COD_MOTIVO_ANULACION_EJERCE_GENCAT = "12";
	public final static String COD_MOTIVO_ANULACION_VPO_DENEGADA = "13";
	public final static String COD_MOTIVO_ANULACION_INCIDENCIA_JURIDICA_TECNICA = "14";
	public final static String COD_MOTIVO_ANULACION_ALTA_OFERTA_ESPEJO = "15";

	@Id
	@Column(name = "DD_MAO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivosAnulacionOferta")
	@SequenceGenerator(name = "DDMotivosAnulacionOferta", sequenceName = "S_DD_MAO_MOTIVO_ANULACION_OFR")
	private Long id;
	    
	@Column(name = "DD_MAO_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MAO_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MAO_DESCRIPCION_LARGA")   
	private String descripcionLarga;	    

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

}