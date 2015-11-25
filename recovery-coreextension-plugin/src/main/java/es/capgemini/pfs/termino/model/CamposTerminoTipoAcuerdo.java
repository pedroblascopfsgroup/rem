package es.capgemini.pfs.termino.model;

import java.io.Serializable;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * 
 * @author Carlos Gil 
 *
 */
@Entity
@Table(name = "ACU_CAMPOS_TIPO_ACUERDO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class CamposTerminoTipoAcuerdo implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1958131562516043847L;

	@Id
    @Column(name = "CMP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CamposTerminoTipoAcuerdoGenerator")
    @SequenceGenerator(name = "CamposTerminoTipoAcuerdoGenerator", sequenceName = "S_ACU_CAMPOS_TIPO_ACUERDO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoAcuerdo tipoAcuerdo;	

	@Column(name = "CMP_NOMBRE_CAMPO")
    private String nombreCampo;
	
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
	
    public DDTipoAcuerdo getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}

	public String getNombreCampo() {
		return nombreCampo;
	}

	public void setNombreCampo(String nombreCampo) {
		this.nombreCampo = nombreCampo;
	}

	public Auditoria getAuditoria() {
		return this.auditoria;
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
}
