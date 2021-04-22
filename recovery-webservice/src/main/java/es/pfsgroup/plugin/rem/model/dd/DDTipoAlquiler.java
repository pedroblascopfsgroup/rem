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
 * Modelo que gestiona el diccionario de tipos de alquiler
 * 
 * @author jros
 *
 */
@Entity
@Table(name = "DD_TAL_TIPO_ALQUILER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoAlquiler implements Auditable, Dictionary {
	
	public static final String CODIGO_ORDINARIO = "01";
    public static final String CODIGO_ALQUILER_OPCION_COMPRA = "02";
    public static final String CODIGO_FONDO_SOCIAL = "03";
    public static final String CODIGO_ESPECIAL = "04";
    public static final String CODIGO_NO_DEFINIDO = "05";
    public static final String CODIGO_CARITAS = "07";
    public static final String CODIGO_LEY_CATALANA = "08";
    public static final String CODIGO_ALQUILER_SOCIAL = "09";
    public static final String CODIGO_CESION_GENERALITAT_CX = "10";
    public static final String CODIGO_OTRAS_CORPORACIONES ="11";
    public static final String CODIGO_RD_LEY_17_2019 ="12";
    public static final String CODIGO_ACEPTADAS_CESION_GENERALITAT ="13";
    public static final String CODIGO_ALQUILER_SOCIAL_BBVA ="14";
    public static final String CODIGO_ALQUILER_SOCIAL_CX ="15";
    public static final String CODIGO_BUENAS_PRACTICAS ="16";
    public static final String CODIGO_EN_TRAMITE_CESION_GENERALITAT ="17";

	/**
	 * 
	 */
	private static final long serialVersionUID = -3085379805977887759L;

	@Id
	@Column(name = "DD_TAL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAlquilerGenerator")
	@SequenceGenerator(name = "DDTipoAlquilerGenerator", sequenceName = "S_DD_TAL_TIPO_ALQUILER")
	private Long id;
	 
	@Column(name = "DD_TAL_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TAL_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TAL_DESCRIPCION_LARGA")   
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
	
	public static boolean isAlquilerFondoSocial(DDTipoAlquiler tipoAlquiler) {
		boolean isTipo = false;
		
		if(tipoAlquiler != null && CODIGO_FONDO_SOCIAL.equals(tipoAlquiler.getCodigo())) {
			isTipo = true;
		}
		
		return isTipo;
	}
	
}
