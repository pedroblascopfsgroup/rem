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
 * Diccionario para Tipo de Documento
 * 
 * @author Carlos Augusto
 *
 */
@Entity
@Table(name = "DD_TDI_TIPO_DOCUMENTO_ID", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)

public class DDTipoDeDocumento implements Auditable, Dictionary{
private static final long serialVersionUID = 1L;
	
	
	public final static String DNI = "01";
	public final static String CIF = "02";
	public final static String TARJETA_DE_RESIDENTE = "03";
	public final static String PASAPORTE = "04";
	public final static String CIF_PAIS_EXTRANJERO = "05";
	public final static String DNI_PAIS_EXTRANJERO ="06";
	public final static String TJ_IDENTIFICACION_DIPLOMATICA ="07";
	public final static String MENOR ="08";
	public final static String OTROS_PERSONA_FISICA ="09";
	public final static String OTROS_PERSONA_JURIDICA ="10";
	public final static String IDENT_BANCO_DE_ESPAÑA ="11";
	public final static String NIE ="12";
	public final static String NIF_PAIS_ORIGEN ="13";
	public final static String OTRO ="14";
	public final static String NIF ="15";
	
	@Id
	@Column(name = "DD_TDI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoGenerator", sequenceName = "S_DD_TDI_TIPO_DOCUMENTO_ID")
	private Long id;
	    
	@Column(name = "DD_TDI_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDI_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDI_DESCRIPCION_LARGA")   
	private String descripcionLarga;	    
	
	@Column(name = "DD_TDI_CODIGO_C4C")   
	private String codigoC4C;	  

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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}
	
	
}