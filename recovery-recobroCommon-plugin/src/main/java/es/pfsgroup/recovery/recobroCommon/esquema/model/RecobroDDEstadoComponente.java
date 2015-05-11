package es.pfsgroup.recovery.recobroCommon.esquema.model;

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
 * Clase donde se mapean los posibles estados de un esquema
 * @author Diana
 *
 */
@Entity
@Table(name = "RCF_DD_ECM_ESTADO_COMPONENT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroDDEstadoComponente implements Auditable, Dictionary{
	

	/**
	 * 
	 */
	private static final long serialVersionUID = -3363713317109491444L;
	
	
	public static final String RCF_DD_EES_ESTADO_COMPONENTE_DEFINICION  = "DEF";
	public static final String RCF_DD_EES_ESTADO_COMPONENTE_BLOQUEADO 	= "BLQ";
	public static final String RCF_DD_EES_ESTADO_COMPONENTE_DISPONIBLE  = "DSP";
	

	@Id
    @Column(name = "RCF_DD_ECM_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EstadoComponenteGenerator")
	@SequenceGenerator(name = "EstadoComponenteGenerator", sequenceName = "S_RCF_DD_ECM_ESTADO_COMPONENT")
    private Long id;

    @Column(name = "RCF_DD_ECM_CODIGO")
    private String codigo;

    @Column(name = "RCF_DD_ECM_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "RCF_DD_ECM_DESCRIPCION_LARGA")
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

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	
	public void setDescripcionLarga(String descripcionLarga){
		this.descripcionLarga=descripcionLarga;
	}
    

}
