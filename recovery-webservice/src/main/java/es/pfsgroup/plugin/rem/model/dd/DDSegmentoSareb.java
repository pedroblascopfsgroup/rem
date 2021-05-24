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
 * 
 * @author Héctor Crespo
 *
 */
@Entity
@Table(name = "DD_SGS_SEGMENTO_SAREB", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSegmentoSareb implements Auditable, Dictionary {
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_NEC_AN_ESP= "01";
	public static final String CODIGO_RUNOFF_EST_V_AGR = "02";
	public static final String CODIGO_RUNOFF_EST_V_MED = "03";
	public static final String CODIGO_RUNOFF_EST_V_CONS = "04";
	public static final String CODIGO_ALQ_EST_ALQ_AGR = "05";
	public static final String CODIGO_ALQ_EST_ALQ_MED = "06";
	public static final String CODIGO_AL_EST_ALQ_CONS = "07";
	public static final String CODIGO_PORTFOLIO_SOCIAL = "08";
	public static final String CODIGO_DES_URB_FINC_RUST = "09";
	public static final String CODIGO_PROM_SU_FIN_Y_FINWIP = "10";
	public static final String CODIGO_GEST_VALOR_ACT_TERC = "11";
	public static final String CODIGO_VENTA_CONJ = "12";
	

	@Id
	@Column(name = "DD_SGS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSegmentoSarebGenerator")
	@SequenceGenerator(name = "DDSegmentoSarebGenerator", sequenceName = "S_DD_SGS_SEGMENTO_SAREB")
	private Long id;
	
	@Column(name = "DD_SGS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SGS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SGS_DESCRIPCION_LARGA")   
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

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	
	
	
	

	 
	
	
	
}
