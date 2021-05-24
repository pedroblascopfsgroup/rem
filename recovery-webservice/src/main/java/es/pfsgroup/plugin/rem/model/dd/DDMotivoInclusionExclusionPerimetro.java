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
@Table(name = "DD_MPT_MTV_IN_EX_PERIMETRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoInclusionExclusionPerimetro implements Auditable, Dictionary{

	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_PEND_CONF_PEP = "01";
	public static final String CODIGO_NO_COMERC_PEP = "02";
	public static final String CODIGO_PUBLICABLE = "03";
	public static final String CODIGO_SIN_PRECIO = "04";
	public static final String CODIGO_PRECOMERCIALIZACION = "05";
	public static final String CODIGO_SUELO_WIP_GES_VAL = "06";
	public static final String CODIGO_CNL_OKP_SIN_VUL = "07";
	public static final String CODIGO_PNDTE_INF_SUELO = "08";
	
	public static final String CODIGO_TERC_GEST_VAL = "09";
	public static final String CODIGO_PLAYA_MECENAS = "10";
	public static final String CODIGO_PRT_MR_NO_PUBLI = "11";
	public static final String CODIGO_RSC_OKU_ANA_VUL = "12";
	public static final String CODIGO_BLOQ_TOTAL_DPI_SUELOS = "13";
	public static final String CODIGO_BLQ_TOTAL_DPI_WIP_NNDD = "14";
	public static final String CODIGO_ESLA= "15";
	public static final String CODIGO_ROFO_4 = "16";
	
	public static final String CODIGO_RSC_CONV_AAPP_BLOQ = "17";
	public static final String CODIGO_RSC_AQL_SOCIAL = "18";
	public static final String CODIGO_RSC_OKU_VULNERABILIDAD = "19";
	public static final String CODIGO_ESTRATEGIA_COMERCIAL = "20";
	public static final String CODIGO_EXCEP_COMERC_PROMO = "21";
	public static final String CODIGO_PRECOMERCIALIZACION_MANT_HIST = "22";

	@Id
	@Column(name = "DD_MPT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoInclusionExclusionPerimetroGenerator")
	@SequenceGenerator(name = "DDMotivoInclusionExclusionPerimetroGenerator", sequenceName = "S_DD_MPT_MTV_IN_EX_PERIMETRO")
	private Long id;
	
	@Column(name = "DD_MPT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MPT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MPT_DESCRIPCION_LARGA")   
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}   
}
