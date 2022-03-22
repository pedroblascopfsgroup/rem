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
 * Modelo que gestiona el diccionario de carteras.
 * 
 * @author Benjamín Guerrero
 *
 */
@Entity
@Table(name = "DD_CRA_CARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCartera implements Auditable, Dictionary {

	public static final String CODIGO_CARTERA_CAJAMAR = "01";
	public static final String CODIGO_CARTERA_SAREB = "02";
	public static final String CODIGO_CARTERA_BANKIA = "03";
	public static final String CODIGO_CARTERA_HYT = "06";
	public static final String CODIGO_CARTERA_TANGO = "10";
	public static final String CODIGO_CARTERA_THIRD_PARTY = "11";
	public static final String CODIGO_CARTERA_GIANTS = "12";
	public static final String CODIGO_CARTERA_ZEUS = "14";
	public static final String CODIGO_CARTERA_LIBERBANK = "08";
	public static final String CODIGO_CARTERA_CERBERUS = "07";
	public static final String CODIGO_CARTERA_GALEON = "15";
	public static final String DESCRIPCION_CARTERA_BANKIA = "Bankia";
	public static final String DESCRIPCION_CARTERA_HYT = "Haya Titulizacion";
	public static final String CODIGO_CARTERA_JAIPUR = "09";
	public static final String CODIGO_CARTERA_EGEO = "13";
	public static final String CODIGO_CARTERA_BBVA = "16";
	public static final String CODIGO_CAIXA = "03";
	public static final String CODIGO_CARTERA_BFA = "17";
	public static final String CODIGO_CARTERA_SIN_DEFINIR = "05";
	public static final String CODIGO_CARTERA_OTRAS_CARTERAS = "04";
	public static final String CODIGO_CARTERA_TITULIZADA = "18";
		/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_CRA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCarteraGenerator")
	@SequenceGenerator(name = "DDCarteraGenerator", sequenceName = "S_DD_CRA_CARTERA")
	private Long id;
	 
	@Column(name = "DD_CRA_CODIGO")   
	private String codigo;
	
	@Column(name = "DD_CRA_CIF")   
	private String cif;
	 
	@Column(name = "DD_CRA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_CRA_DESCRIPCION_LARGA")   
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
	
	public String getCif() {
		return cif;
	}

	public void setCif(String cif) {
		this.cif = cif;
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
	
	public static boolean isCarteraBk(DDCartera cartera) {
		boolean isCarteraBk = false;
		if(cartera != null && (CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()))) {
			isCarteraBk = true;
		}
		
		return isCarteraBk;
	}
	
	public static boolean isCarteraSareb(DDCartera cartera) {
		boolean isCarteraSareb = false;
		if(cartera != null && ( CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()))) {
			isCarteraSareb = true;
		}
		return isCarteraSareb;
	}
	
	public static boolean isCarteraCajamar(DDCartera cartera) {
		boolean isCarteraCajamar = false;
		if(cartera != null && ( CODIGO_CARTERA_CAJAMAR.equals(cartera.getCodigo()))) {
			isCarteraCajamar = true;
		}
		return isCarteraCajamar;
	}
	
	public static boolean isCarteraBBVA(DDCartera cartera) {
		boolean isCarteraBBVA = false;
		if(cartera != null && (CODIGO_CARTERA_BBVA.equals(cartera.getCodigo()))) {
			isCarteraBBVA = true;
		}
		return isCarteraBBVA;
	}
	
	public static boolean isCarteraCerberus (DDCartera cartera) {
		boolean isCarteraCerberus = false;
		if(cartera != null && (CODIGO_CARTERA_CERBERUS.equals(cartera.getCodigo()))) {
			isCarteraCerberus = true;
		}
		return isCarteraCerberus;
	}
	
	public static boolean isBFA (DDCartera cartera) {
		boolean is = false;
		if(cartera != null && CODIGO_CARTERA_BFA.equals(cartera.getCodigo())) {
			is = true;
		}
		
		return is;
	}

	public static boolean isCarteraTitulizada(DDCartera cartera) {
		boolean isCarteraTitulizada = false;
		if(cartera != null && ( CODIGO_CARTERA_TITULIZADA.equals(cartera.getCodigo()))) {
			isCarteraTitulizada = true;
		}
		return isCarteraTitulizada;
	}
}
