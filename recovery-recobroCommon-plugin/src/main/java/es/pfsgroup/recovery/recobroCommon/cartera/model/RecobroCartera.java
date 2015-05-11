package es.pfsgroup.recovery.recobroCommon.cartera.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;


/**
 * Clase donde se guardan las Carteras que pertenecen a los esquemas de Recobro
 *
 * @author Vanesa
 * 
 */
@Entity
@Table(name = "RCF_CAR_CARTERA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroCartera implements Auditable, Serializable{
	
	 /**
	 * 
	 */
	private static final long serialVersionUID = -1934773194960249533L;

	 @Id
	 @Column(name = "RCF_CAR_ID")
	 @GeneratedValue(strategy = GenerationType.AUTO, generator = "CarteraGenerator")
	 @SequenceGenerator(name = "CarteraGenerator", sequenceName = "S_RCF_CAR_CARTERA")
	 private Long id;
	 
	 @Column(name = "RCF_CAR_NOMBRE")
	 private String nombre;
	 
	 @Column(name = "RCF_CAR_DESCRIPCION")
	 private String descripcion;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "RD_ID")
	 private RuleDefinition regla;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
     @JoinColumn(name = "RCF_DD_ECM_ID")
	 private RecobroDDEstadoComponente estado;
	 
	 @OneToMany(cascade = CascadeType.ALL)
	 @JoinColumn(name="RCF_CAR_ID")
	 @Where(clause=Auditoria.UNDELETED_RESTICTION)
	 @OrderBy("prioridad ASC")
	 private List<RecobroCarteraEsquema> carteraEsquemas;
	 

	@Column(name = "RCF_CAR_FECHA_ALTA")
	 private Date fechaAlta;
	 
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public RuleDefinition getRegla() {
		return regla;
	}

	public void setRegla(RuleDefinition regla) {
		this.regla = regla;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public RecobroDDEstadoComponente getEstado() {
		return estado;
	}

	public void setEstado(RecobroDDEstadoComponente estado) {
		this.estado = estado;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public List<RecobroCarteraEsquema> getCarteraEsquemas() {
		return carteraEsquemas;
	}

	public void setCarteraEsquemas(List<RecobroCarteraEsquema> carteraEsquemas) {
		this.carteraEsquemas = carteraEsquemas;
	}
	
	public Boolean getEnEsquemaVigente(){
		Boolean enEsquemaVigente = false;
		for (RecobroCarteraEsquema esquema : carteraEsquemas){
			if (RecobroDDEstadoEsquema.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO.equals(esquema.getEsquema().getEstadoEsquema().getCodigo())){
				enEsquemaVigente=true;
			}
		}
		
		return enEsquemaVigente;
	}

	public Usuario getPropietario() {
		return propietario;
	}

	public void setPropietario(Usuario propietario) {
		this.propietario = propietario;
	}


}
