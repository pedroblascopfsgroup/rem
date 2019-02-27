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

/*
 * Modelo que gestiona el diccionario de calculos de impuesto
 * 
 * @author Vicente Martinez
 * 
 */

@Entity
@Table(name = "DD_CAI_CALCULO_IMPUESTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCalculoImpuesto implements Auditable, Dictionary {
	
	public static final String CODIGO_VENCIDO = "01";
	public static final String CODIGO_EN_VOLUNTARIA = "02";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_CAI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCalculoImpuestoGenerator")
	@SequenceGenerator(name = "DDCalculoImpuestoGenerator", sequenceName = "S_DD_CAI_CALCULO_IMPUESTO")
	private Long id;
	
	@Column(name= "DD_CAI_CODIGO")
	private String codigo;
	
	@Column(name= "DD_CAI_DESCRIPCION")
	private String descripcion;
	
	@Column(name= "DD_CAI_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Version
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	@Override
	public Long getId() {
		return id;
	}
	
	public void setId(Long id){
		this.id = id;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}
	
	public void setCodigo(String codigo){
		this.codigo = codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}
	
	public void setDescripcion(String descrpicion){
		this.descripcion = descrpicion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescrpicionLarga(String descripcionLarga){
		this.descripcionLarga = descripcionLarga;
	}
	
	public Long getversion(){
		return version;
	}
	
	public void setVersion(Long version){
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
