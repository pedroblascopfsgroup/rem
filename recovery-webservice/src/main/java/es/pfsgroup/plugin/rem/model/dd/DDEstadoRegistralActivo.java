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
@Table(name = "DD_ERA_ESTADO_REG_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoRegistralActivo implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_EDIFICACION_TERMINADA = "EDF_TER";
	public static final String CODIGO_EN_CONTRUCCION = "CON_JUR";
	public static final String CODIGO_OBRA_EN_CURSO = "EDF_WIP";
	public static final String CODIGO_DISCREPANCIA_MAYOR_20 = "EXC_S20";
	public static final String CODIGO_DISCREPANCIA_MENOR_20 = "EXC_I20";
	public static final String CODIGO_DISCREPANCIA_SIN_INMATRICULAR = "EXC_SIM";
	public static final String CODIGO_DISCREPANCIA_CAMBIO_USO = "EXC_CDU";
	public static final String CODIGO_DISCREPANCIA_CAMBIO_DESC_REGISTRAL = "EXC_CDR";
	public static final String CODIGO_DISCREPANCIA_DIVISION_HORIZONTAL = "EXC_DHO";
	public static final String CODIGO_ILEGAL_IRREGU_URBANISTICAS = "CIL_IUR";
	public static final String CODIGO_ILEGAL_FUERA_ORDENACION = "CIL_FOR";
	public static final String CODIGO_ACTIVO_IRREGULAR = "ACT_IRR";

	@Id
	@Column(name = "DD_ERA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoRegistralActivoGenerator")
	@SequenceGenerator(name = "DDEstadoRegistralActivoGenerator", sequenceName = "S_DD_ERA_ESTADO_REG_ACTIVO")
	private Long id;
	 
	@Column(name = "DD_ERA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_ERA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_ERA_DESCRIPCION_LARGA")   
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
