package es.pfsgroup.plugin.rem.model.dd;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de subtipos de documento para el Proveedor
 * 
 * @author Vicente Martinz Cifre
 *
 */
@Entity
@Table(name = "DD_SDP_SUBTIPO_DOC_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoDocumentoProveedor implements Auditable, Dictionary {

	public static final String CODIGO_NIF = "01";
	public static final String CODIGO_CUENTA_BANCARIA = "02";
	public static final String CODIGO_ESCRITURA_CONSTITUCION = "03";
	public static final String CODIGO_ESTATUTOS_VIGENTES = "04";
	public static final String CODIGO_ACTA_DE_ASAMBLEA = "05";
	public static final String CODIGO_CONVOCATORIA_ASAMBLEA = "06";
	public static final String CODIGO_CIRCULAR_COMUNIDAD = "07";
	public static final String CODIGO_ACTA_TITULAR_REAL = "08";
	public static final String CODIGO_CERTIFICADO_AEAT = "09";
	public static final String CODIGO_CERTIFICADO_SS = "10";
	public static final String CODIGO_CERTIFICADO_SUBCONTRATISTAS = "11";
	public static final String CODIGO_IMPUESTO_ACT_ECONOMICAS = "12";
	public static final String CODIGO_SEGUROS_SOCIALES_MES = "13";
	public static final String CODIGO_CARTA_PARA_LOC = "14";
	public static final String CODIGO_BUROFAX_PARA_LOC = "15";
	public static final String CODIGO_CERTIFICADO_NO_DEUDA = "16";
	public static final String CODIGO_ACTA_JUNTA = "17";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_SDP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoDocumentoProveedorGenerator")
	@SequenceGenerator(name = "DDSubtipoDocumentoProveedorGenerator", sequenceName = "S_DD_SDP_SUBTIPO_DOC_PROVEEDOR")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "DD_TDP_ID")
    private DDTipoDocumentoProveedor tipoDocumentoProveedor; 
	 
	@Column(name = "DD_SDP_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SDP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SDP_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_SDP_MATRICULA_GD")   
	private String matricula;	
	    
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

	public DDTipoDocumentoProveedor getTipoDocumentoProveedor() {
		return tipoDocumentoProveedor;
	}

	public void setTipoDocumentoProveedor(DDTipoDocumentoProveedor tipoDocumentoProveedor) {
		this.tipoDocumentoProveedor = tipoDocumentoProveedor;
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

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
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
