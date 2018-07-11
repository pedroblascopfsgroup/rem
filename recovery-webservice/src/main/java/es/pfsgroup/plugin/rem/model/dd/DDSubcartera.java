package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
 * Modelo que gestiona el diccionario de subcarteras.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "DD_SCR_SUBCARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubcartera implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	public static final String CODIGO_CAJ_ASISTIDA = "01";
	public static final String CODIGO_SAR_ASISTIDA = "03";
	public static final String CODIGO_BAN_ASISTIDA = "05";
	public static final String CODIGO_BAN_BH = "06";
	public static final String CODIGO_BAN_BFA = "07";
	public static final String CODIGO_BAN_BK = "08";
	public static final String CODIGO_BANKIA_SOLVIA = "14";
	public static final String CODIGO_BANKIA_SAREB = "15";
	public static final String CODIGO_BANKIA_SAREB_PRE_IBERO = "19";
	public static final String CODIGO_JAIPUR_FINANCIERO = "38";
	

	@Id
	@Column(name = "DD_SCR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubcarteraGenerator")
	@SequenceGenerator(name = "DDSubcarteraGenerator", sequenceName = "S_DD_SCR_SUBCARTERA")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_CRA_ID")
	DDCartera cartera;
	
	@Column(name = "DD_SCR_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SCR_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SCR_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
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
	
	public String getCarteraCodigo() {
		return !Checks.esNulo(this.carteraCodigo) ? this.carteraCodigo : cartera.getCodigo();
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = !Checks.esNulo(this.carteraCodigo) ? this.carteraCodigo : cartera.getCodigo();
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
