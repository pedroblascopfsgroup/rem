package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de comités sancionadores
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_COS_COMITES_SANCION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDComiteSancion implements Auditable, Dictionary {
	
	public static final String CODIGO_HAYA_CAJAMAR = "1";
	public static final String CODIGO_HAYA_SAREB = "12";
	public static final String CODIGO_PLATAFORMA = "3";
	public static final String CODIGO_CAJAMAR = "10";
	public static final String CODIGO_SAREB = "11";
	public static final String CODIGO_BANKIA_DGVIER = "2";
	public static final String CODIGO_HAYA_TANGO = "16";
	public static final String CODIGO_TANGO_TANGO = "19";
	public static final String CODIGO_HAYA_GIANTS = "20";
	public static final String CODIGO_GIANTS_GIANTS = "21";
	public static final String CODIGO_HAYA_HYT = "14";
	public static final String CODIGO_HAYA_THIRD_PARTIES = "18";
	public static final String CODIGO_HAYA_CERBERUS = "26";
	public static final String CODIGO_EXTERNO_CERBERUS = "27";
	public static final String CODIGO_CERBERUS = "29";
	public static final String CODIGO_APPLE_CERBERUS = "31";
	
	public static final String CODIGO_HAYA_LIBERBANK = "22";
	public static final String CODIGO_LIBERBANK_RESIDENCIAL = "23";
	public static final String CODIGO_LIBERBANK_SINGULAR_TERCIARIO = "24";
	public static final String CODIGO_LIBERBANK_INVERSION_INMOBILIARIA = "25";
	public static final String CODIGO_HAYA_GALEON = "28";
	public static final String CODIGO_HAYA_EGEO = "30";
	public static final String CODIGO_THIRD_PARTIES_YUBAI = "32";
	
	public static final String CODIGO_GESTION_INMOBILIARIA = "34";
	public static final String CODIGO_DIRECTOR_GESTION_INMOBILIARIA = "35";
	public static final String CODIGO_COMITE_INVERSION_INMOBILIARIA = "36";
	public static final String CODIGO_COMITE_DIRECCION = "37";
	public static final String CODIGO_ARROW = "40";
	public static final String CODIGO_HAYA_REMAINING = "41";
	public static final String CODIGO_HAYA_APPLE = "42";
	public static final String CODIGO_CES_REMAINING = "43";
	public static final String CODIGO_CES_APPLE = "44";
	
	public static final String CODIGO_HAYA_BBVA = "47";
	public static final String CODIGO_BBVA = "48";
	
	public static final String CODIGO_JAGUAR = "51";
	public static final String CODIGO_HAYA_JAGUAR = "52";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_COS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDComiteSancionGenerator")
	@SequenceGenerator(name = "DDComiteSancionGenerator", sequenceName = "S_DD_COS_COMITES_SANCION")
	private Long id;
	    
	@Column(name = "DD_COS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_COS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_COS_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SCR_ID")
	private DDSubcartera Subcartera;
    
    @Transient
    private String carteraCodigo;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return Subcartera;
	}

	public void setSubcartera(DDSubcartera Subcartera) {
		this.Subcartera = Subcartera;
	}

	public String getCarteraCodigo() {
		return Checks.esNulo(cartera) ? carteraCodigo : cartera.getCodigo();
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = Checks.esNulo(cartera) ? carteraCodigo : cartera.getCodigo();
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
