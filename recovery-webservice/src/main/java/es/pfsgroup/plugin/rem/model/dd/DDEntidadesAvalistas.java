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
 *
 */
@Entity
@Table(name = "DD_EAV_ENTIDADES_AVALISTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEntidadesAvalistas implements Auditable, Dictionary {

	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public final static String Bankia = "01";
	public final static String Bankinter = "02";
	public final static String BBVA = "03";
	public final static String CaixaBank = "04";
	public final static String Caja_ingenieros = "05";
	public final static String Caja_Rural = "06";
	public final static String Caja_Rural_Navarra = "07";
	public final static String Cajamar = "08";
	public final static String Cajasur = "09";
	public final static String Deutche_Bank = "10";
	public final static String Ibercaja = "11";
	public final static String ING_Direct = "12";
	public final static String Kutxabank = "13";
	public final static String Liberbank = "14";
	public final static String Openbank = "15";
	public final static String Pastor_Sabadell = "16";
	public final static String Santander = "17";
	public final static String Unicaja = "18";
	public final static String Otros = "19";



	@Id
	@Column(name = "DD_EAV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEntidadesAvalistasGenerator")
	@SequenceGenerator(name = "DDEntidadesAvalistasGenerator", sequenceName = "S_DD_EAV_ENTIDADES_AVALISTAS")
	private Long id;
	
	    
	@Column(name = "DD_EAV_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EAV_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EAV_DESCRIPCION_LARGA")   
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