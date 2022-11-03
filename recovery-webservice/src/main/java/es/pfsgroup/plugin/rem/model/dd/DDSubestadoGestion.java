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
 * Modelo que gestiona el diccionario de equipo de gestion
 * 
 * @author Alfonso Rodriguez
 *
 */
@Entity
@Table(name = "DD_SEG_SUBESTADO_GESTION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubestadoGestion implements Auditable, Dictionary {
	
	public static final String CODIGO_NO_COLAB = "NO_COLAB";
    public static final String CODIGO_CON_CONT = "CON_CONT";
    public static final String CODIGO_CONT_ERR = "CONT_ERR";
    public static final String CODIGO_CONT_FALL = "CONT_FALL";
    public static final String CODIGO_GEST_LOC = "GEST_LOC";
    public static final String CODIGO_INC = "INC";
    public static final String CODIGO_INC_PAG = "INC_PAG";
    public static final String CODIGO_EN_CONST = "EN_CONST";
    public static final String CODIGO_SIN_CONST = "SIN_CONST";
    public static final String CODIGO_NA = "NA";
    public static final String CODIGO_SUELO = "SUELO";
    public static final String CODIGO_PDTE_DOC = "PDTE_DOC";
    public static final String CODIGO_REG = "REG";
    public static final String CODIGO_SIN_DEU = "SIN_DEU";
    public static final String CODIGO_SIN_INI = "SIN_INI";
    public static final String CODIGO_SIN_TIT = "SIN_TIT";
    public static final String CODIGO_GEST_CP = "GEST_CP";
    public static final String CODIGO_SINT = "SINT";
    public static final String CODIGO_PUT = "PUT";
    public static final String CODIGO_SDF = "SDF";
    public static final String CODIGO_ED_CONST = "ED_CONST";
    public static final String CODIGO_NGCO = "NGCO";
    
    

    
    private static final long serialVersionUID = 1L;
    
    @Id
	@Column(name = "DD_SEG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubestadoGestionGenerator")
	@SequenceGenerator(name = "DDSubestadoGestionGenerator", sequenceName = "S_DD_SEG_SUBESTADO_GESTION")
    private Long id;
    
    
    @Column(name = "DD_SEG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SEG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SEG_DESCRIPCION_LARGA")   
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

