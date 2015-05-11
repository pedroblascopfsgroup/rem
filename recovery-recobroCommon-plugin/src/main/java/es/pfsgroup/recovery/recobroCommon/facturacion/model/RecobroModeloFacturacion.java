package es.pfsgroup.recovery.recobroCommon.facturacion.model;

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
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacionSubcartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

/**
 * Clase que mapea los modelos de facturacion
 * @author Sergio
 *
 */
@Entity
@Table(name = "RCF_MFA_MODELOS_FACTURACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroModeloFacturacion implements Auditable, Serializable  {
	
	private static final long serialVersionUID = -4807464097772185758L;

	@Id
    @Column(name = "RCF_MFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ModeloFacturacionGenerator")
	@SequenceGenerator(name = "ModeloFacturacionGenerator", sequenceName = "S_RCF_MFA_MODELOS_FACTURACION")
    private Long id;

	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MFA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroSubCartera> subCarteras;
	
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MFA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	@OrderBy("tramoDias ASC")
	private List<RecobroTramoFacturacion> tramosFacturacion;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MFA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroCobroFacturacion> cobrosAsociados;

	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="RCF_MFA_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<RecobroCorrectorFacturacion> tramosCorrectores;
	
	@Column(name="RCF_MFA_NOMBRE")
	private String nombre;
	
	@Column(name="RCF_MFA_DESCRIPCION")
	private String descripcion;
	
	@ManyToOne
	@JoinColumn(name = "RCF_DD_TCO_ID", nullable = true)
	private RecobroDDTipoCorrector tipoCorrector;
	
	@Column(name="RCF_MFA_OBJETIVO_RECOBRO")
	private Float objetivoRecobro;
	
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

	public List<RecobroSubCartera> getSubCarteras() {
		return subCarteras;
	}

	public void setSubCarteras(List<RecobroSubCartera> subCarteras) {
		this.subCarteras = subCarteras;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public List<RecobroTramoFacturacion> getTramosFacturacion() {
		return tramosFacturacion;
	}

	public void setTramosFacturacion(List<RecobroTramoFacturacion> tramosFacturacion) {
		this.tramosFacturacion = tramosFacturacion;
	}

	public List<RecobroCobroFacturacion> getCobrosAsociados() {
		return cobrosAsociados;
	}

	public void setCobrosAsociados(List<RecobroCobroFacturacion> cobrosAsociados) {
		this.cobrosAsociados = cobrosAsociados;
	}

	public Boolean isEnEsquemaVigente() {
		for (RecobroSubCartera subCartera: this.getSubCarteras()) {
			if (RecobroCommonEsquemasConstants.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO.
					equals(subCartera.getCarteraEsquema().getEsquema().getEstadoEsquema().getCodigo())) {
						return true;
			}
		}
		return false;
	}

	public Boolean getEnEsquemaVigente() {
		for (RecobroSubCartera subCartera: this.getSubCarteras()) {
			if (RecobroCommonEsquemasConstants.RCF_DD_EES_ESTADO_ESQUEMA_LIBERADO.
					equals(subCartera.getCarteraEsquema().getEsquema().getEstadoEsquema().getCodigo())) {
						return true;
			}
		}
		return false;
	}
	
	public Integer getNumeroTramos(){
		if (!Checks.esNulo(tramosFacturacion)){
			return this.getTramosFacturacion().size();
		}
		else {
			return 0;
		}
		
	}
	
	public RecobroDDTipoCorrector getTipoCorrector() {
		return tipoCorrector;
	}

	public void setTipoCorrector(RecobroDDTipoCorrector tipoCorrector) {
		this.tipoCorrector = tipoCorrector;
	}

	public Float getObjetivoRecobro() {
		return objetivoRecobro;
	}

	public void setObjetivoRecobro(Float objetivoRecobro) {
		this.objetivoRecobro = objetivoRecobro;
	}

	public List<RecobroCorrectorFacturacion> getTramosCorrectores() {
		return tramosCorrectores;
	}

	public void setTramosCorrectores(List<RecobroCorrectorFacturacion> tramosCorrectores) {
		this.tramosCorrectores = tramosCorrectores;
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
