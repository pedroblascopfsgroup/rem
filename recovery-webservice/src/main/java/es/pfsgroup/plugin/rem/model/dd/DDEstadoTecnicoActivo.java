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
@Table(name = "DD_EAT_EST_TECNICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoTecnicoActivo implements Auditable, Dictionary {
	
	
	public static final String CODIGO_PEND_ACT_TECNICA = "E01";
	public static final String CODIGO_GEST_ENTRADA = "E02";
	public static final String CODIGO_ENTRADA_INCI = "E03";
	public static final String CODIGO_ENTRADA_FIN_ANUL = "E04";
	public static final String CODIGO_INCI_TEC_EN_CURSO = "E05";
	public static final String CODIGO_ACT_GRAN_ENVER_EN_CURSO = "E06";
	public static final String CODIGO_MANT_ACT_FIN_ANUL = "E07";
	public static final String CODIGO_DESA_EN_GESTION = "E08";
	public static final String CODIGO_DESA_EN_TRAMIT_FIN = "E09";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_EAT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoTecnicoActivoGenerator")
	@SequenceGenerator(name = "DDEstadoTecnicoActivoGenerator", sequenceName = "S_DD_EAT_EST_TECNICO")
	private Long id;
	 
	@Column(name = "DD_EAT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_EAT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_EAT_DESCRIPCION_LARGA")   
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
