

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
 * Modelo que gestiona el diccionario de los tipos de habitáculo
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TPH_TIPO_HABITACULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoHabitaculo implements Auditable, Dictionary {

	public static String TIPO_HABITACULO_DORMITORIO = "01";
	public static String TIPO_HABITACULO_BANYO = "02";
	public static String TIPO_HABITACULO_SALON = "03";
	public static String TIPO_HABITACULO_ASEO = "04";
	public static String TIPO_HABITACULO_BALCON = "05";
	public static String TIPO_HABITACULO_COCINA = "06";
	public static String TIPO_HABITACULO_TENDEDERO = "07";
	public static String TIPO_HABITACULO_HALL = "08";
	public static String TIPO_HABITACULO_PATIO = "09";
	public static String TIPO_HABITACULO_PORCHE = "10";
	public static String TIPO_HABITACULO_TRASTERO = "11";
	public static String TIPO_HABITACULO_GARAJE = "12";
	public static String TIPO_HABITACULO_DESPENSA = "13";
	public static String TIPO_HABITACULO_LAVADERO = "14";
	public static String TIPO_HABITACULO_T_CUBIERTA = "15";
	public static String TIPO_HABITACULO_T_DESCUBIERTA = "16";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8509577668696768850L;

	@Id
	@Column(name = "DD_TPH_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoHabitaculoGenerator")
	@SequenceGenerator(name = "DDTipoHabitaculoGenerator", sequenceName = "S_DD_TPH_TIPO_HABITACULO")
	private Long id;
	    
	@Column(name = "DD_TPH_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPH_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPH_DESCRIPCION_LARGA")   
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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



