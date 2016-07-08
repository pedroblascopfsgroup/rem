package es.pfsgroup.framework.paradise.bulkUpload.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


/**
 * Clase que representa un campo de un formulario din�mico.
 * @author manuel
 *
 */
@Entity
@Table(name = "MSV_CAMPOS_DINAMICOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVCampoDinamico implements Auditable, Serializable{

	private static final long serialVersionUID = 6815354531687681957L;
	
	@Id
    @Column(name = "CD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVCampoDinamicoGenerator")
    @SequenceGenerator(name = "MSVCampoDinamicoGenerator", sequenceName = "S_MSV_CAMPOS_DINAMICOS")
	private Long id;
	
    @ManyToOne
    @JoinColumn(name = "CD_RES_ID")
    private MSVResolucion resolucion;
    
    @Column(name = "CD_NOMBRE_CAMPO")
    private String nombreCampo;
    
    @Column(name = "CD_VALOR_CAMPO")
    private String valorCampo;
	
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

	public MSVResolucion getResolucion() {
		return resolucion;
	}

	public void setResolucion(MSVResolucion resolucion) {
		this.resolucion = resolucion;
	}

	public String getNombreCampo() {
		return nombreCampo;
	}

	public void setNombreCampo(String nombreCampo) {
		this.nombreCampo = nombreCampo;
	}

	public String getValorCampo() {
		return valorCampo;
	}

	public void setValorCampo(String valorCampo) {
		this.valorCampo = valorCampo;
	}
	


}
