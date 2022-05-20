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
@Table(name = "DD_ETP_ESTADO_POSESORIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoPosesorio implements Auditable, Dictionary {
	
	public static final String SIN_POSESION ="P01";
	public static final String ALQUILADO ="P02";
	public static final String REOCUPADO ="P03";
	public static final String CEDIDO_AAPP ="P04";
	public static final String VERTICAL ="P05";
	public static final String CON_POSESION ="P06";	

	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_ETP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoPosesorioGenerator")
	@SequenceGenerator(name = "DDEstadoPosesorioGenerator", sequenceName = "S_DD_ETP_ESTADO_POSESORIO")
	private Long id;
	
	@Column(name = "DD_ETP_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_ETP_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ETP_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "INDICA_POSESION")   
	private Integer indicaPosesion;   
	    
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

	public Integer getIndicaPosesion() {
		return indicaPosesion;
	}

	public void setIndicaPosesion(Integer indicaPosesion) {
		this.indicaPosesion = indicaPosesion;
	}	
}
