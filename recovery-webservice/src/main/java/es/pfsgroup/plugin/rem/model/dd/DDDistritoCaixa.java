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


@Entity
@Table(name = "DD_DIC_DISTRITO_CAIXA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDDistritoCaixa implements Auditable, Dictionary {


	public static final String CODIGO_BCN_CIUTAT_VELLA = "1";
	public static final String CODIGO_BCN_EIXAMPLE = "2";
	public static final String CODIGO_BCN_GRACIA = "3";
	public static final String CODIGO_BCN_HORTA_GUINARDO = "4";
	public static final String CODIGO_BCN_LES_CORTS = "5";
	public static final String CODIGO_BCN_NOU_BARRIS = "6";
	public static final String CODIGO_BCN_SANT_ANDREU = "7";
	public static final String CODIGO_BCN_SANT_MARTI = "8";
	public static final String CODIGO_BCN_SANTS = "9";
	public static final String CODIGO_BCN_SARRIA = "10";
	public static final String CODIGO_MAD_ARGANZUELA = "11";
	public static final String CODIGO_MAD_BARAJAS = "12";
	public static final String CODIGO_MAD_CANILLEJAS = "13";
	public static final String CODIGO_MAD_CARABANCHEL = "14";
	public static final String CODIGO_MAD_CENTRO = "15";
	public static final String CODIGO_MAD_CHAMARTIN = "16";
	public static final String CODIGO_MAD_CHAMBERI = "17";
	public static final String CODIGO_MAD_CIUDAD_LINEAL = "18";
	public static final String CODIGO_MAD_FUENCARRAL = "19";
	public static final String CODIGO_MAD_HORTALEZA = "20";
	public static final String CODIGO_MAD_LATINA = "21";
	public static final String CODIGO_MAD_MONCLOA = "22";
	public static final String CODIGO_MAD_MORATALAZ = "23";
	public static final String CODIGO_MAD_PUENTE_VALLECAS = "24";
	public static final String CODIGO_MAD_RETIRO = "25";
	public static final String CODIGO_MAD_SALAMANCA = "26";
	public static final String CODIGO_MAD_TETUAN = "27";
	public static final String CODIGO_MAD_USERA = "28";
	public static final String CODIGO_MAD_VICALVARO = "29";
	public static final String CODIGO_MAD_VILLA_VALLECAS = "30";
	public static final String CODIGO_MAD_VILLAVERDE = "31";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_DIC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDDistritoCaixaGenerator")
	@SequenceGenerator(name = "DDDistritoCaixaGenerator", sequenceName = "S_DD_DIC_DISTRITO_CAIXA")
	private Long id;
	 
	@Column(name = "DD_DIC_CODIGO")   
	private String codigo;	
	 
	@Column(name = "DD_DIC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_DIC_DESCRIPCION_LARGA")   
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
