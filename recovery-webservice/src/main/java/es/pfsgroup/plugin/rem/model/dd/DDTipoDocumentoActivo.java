package es.pfsgroup.plugin.rem.model.dd;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
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
 * Modelo que gestiona el diccionario de los tipos de documentos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TPD_TIPO_DOCUMENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoActivo implements Auditable, Dictionary {

    public static final String CODIGO_INFORME_COMERCIAL = "01";
    public static final String CODIGO_DECRETO_ADJUDICACION = "02";
    public static final String CODIGO_ESCRITURA_PUBLICA = "03";
    public static final String CODIGO_DILIGENCIA_TOMA_POSESION = "04";
    public static final String CODIGO_NOTA_SIMPLE_SIN_CARGAS = "05";
    public static final String CODIGO_NOTA_SIMPLE_ACTUALIZADA = "06";
    public static final String CODIGO_TASACION_ADJUDICACION = "07";
    public static final String CODIGO_VPO_SOLICITUD_AUTORIZACION = "08";
    public static final String CODIGO_VPO_NOTIFICACION_ADJUDICACION = "09";
    public static final String CODIGO_VPO_SOLICITUD_IMPORTE = "10";
    public static final String CODIGO_CEE = "11";
    public static final String CODIGO_LPO = "12";
    public static final String CODIGO_CEDULA_HABITABILIDAD = "13";
    public static final String CODIGO_CFO = "14";
    public static final String CODIGO_BOLETIN_AGUA = "15";
    public static final String CODIGO_BOLETIN_ELECTRICIDAD = "16";
    public static final String CODIGO_BOLETIN_GAS = "17";
    public static final String CODIGO_LISTADO_PROPUESTA_PRECIOS = "21";
    public static final String CODIGO_INFORME_OCUPACION_DESOCUPACION = "52";
    public static final String CODIGO_CONSENTIMIENTO_PROTECCION_DATOS = "77";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = -4760202568628965576L;

	@Id
	@Column(name = "DD_TPD_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoActivoGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoActivoGenerator", sequenceName = "S_DD_TPD_TIPO_DOCUMENTO")
	private Long id;
	 
	@Column(name = "DD_TPD_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPD_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPD_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Column(name = "DD_TPD_MATRICULA_GD")   
	private String matricula;
	
	@Column(name = "DD_TPD_VISIBLE")   
	private Boolean visible;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@OneToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "TPD_TTR", joinColumns = @JoinColumn(name = "DD_TPD_ID", referencedColumnName = "DD_TPD_ID"), 
		inverseJoinColumns = @JoinColumn(name = "DD_TTR_ID", referencedColumnName = "DD_TTR_ID"))
	private List<DDTipoTrabajo> tiposTrabajo;

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
	
	public String getMatricula() {
		return matricula;
	}
	
	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public List<DDTipoTrabajo> getTiposTrabajo() {
		List<DDTipoTrabajo> copy = new ArrayList<DDTipoTrabajo>();
		copy.addAll(tiposTrabajo);
		return copy;
	}

	public Boolean getVisible() {
		return visible;
	}

	public void setVisible(Boolean visible) {
		this.visible = visible;
	}
	
}
