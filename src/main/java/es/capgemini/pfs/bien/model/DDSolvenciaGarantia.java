package es.capgemini.pfs.bien.model;

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
 * @author carlos
 *
 */
@Entity
@Table(name = "DD_SGB_SOLVENCIA_GARANTIA_BIEN", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class DDSolvenciaGarantia implements Auditable, Dictionary{
	
	public static final String COD_SIN_RELACION = "SIN";
	public static final String COD_SOLVENCIA = "SOL";
	public static final String COD_GARANTIA= "GAR";
	
	private static final long serialVersionUID = -8747955571127760043L;

	@Id
    @Column(name = "DD_SGB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSolvenciaGarantiaGenerator")
	@SequenceGenerator(name = "DDSolvenciaGarantiaGenerator", sequenceName = "S_DD_SGB_BIEN")
    private Long id;

    @Column(name = "DD_SGB_CODIGO")
    private String codigo;

    @Column(name = "DD_SGB_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "DD_SGB_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Version
    private Integer version;

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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


}
