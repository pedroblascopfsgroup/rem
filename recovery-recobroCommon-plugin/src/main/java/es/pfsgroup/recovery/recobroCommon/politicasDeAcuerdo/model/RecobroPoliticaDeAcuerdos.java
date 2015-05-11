package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.IndexColumn;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

/**
 * Clase que mapea las politicas de acuerdos
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_POA_POLITICA_ACUERDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroPoliticaDeAcuerdos implements Auditable, Serializable  {
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_POA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PoliticasDeAcuerdoGenerator")
	@SequenceGenerator(name = "PoliticasDeAcuerdoGenerator", sequenceName = "S_RCF_POA_POLITICA_ACUERDOS")
    private Long id;

	@Column(name = "RCF_POA_CODIGO")
	private String codigo;
	
	@Column(name = "RCF_POA_NOMBRE")
	private String nombre;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_POA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	@IndexColumn(base = 1,name="RCF_PAA_PRIORIDAD")
	private List<RecobroPoliticaAcuerdosPalanca> politicaAcuerdosPalancas;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_POA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroSubCartera> subCarteras;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_ECM_ID")
	private RecobroDDEstadoComponente estado;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario propietario;
	 
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
    
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public List<RecobroPoliticaAcuerdosPalanca> getPoliticaAcuerdosPalancas() {
		return politicaAcuerdosPalancas;
	}

	public void setPoliticaAcuerdosPalancas(List<RecobroPoliticaAcuerdosPalanca> politicaAcuerdosPalancas) {
		this.politicaAcuerdosPalancas = politicaAcuerdosPalancas;
	}
	
	public List<RecobroSubCartera> getSubCarteras() {
		return subCarteras;
	}

	public void setSubCarteras(List<RecobroSubCartera> subCarteras) {
		this.subCarteras = subCarteras;
	}

	public RecobroDDEstadoComponente getEstado() {
		return estado;
	}

	public void setEstado(RecobroDDEstadoComponente estado) {
		this.estado = estado;
	}

	public Usuario getPropietario() {
		return propietario;
	}

	public void setPropietario(Usuario propietario) {
		this.propietario = propietario;
	}
	

}
