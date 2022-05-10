package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoEntidad;


/**
 * Modelo que gestiona la informacion de la white list de matriculas
 *  
 * @author IRF
 *
 */
@Entity
@Table(name = "WLM_WHITE_LIST_MATRICULAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class WhiteListMatriculas implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "WLM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "WhiteListMatriculasGenerator")
    @SequenceGenerator(name = "WhiteListMatriculasGenerator", sequenceName = "S_WLM_WHITE_LIST_MATRICULAS")
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FUN_ID")
    private Funcion funcion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TDO_ID")
    private DDTipoDocumentoEntidad tipoDocumentoEntidad;
	
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

	public Funcion getFuncion() {
		return funcion;
	}

	public void setFuncion(Funcion funcion) {
		this.funcion = funcion;
	}

	public DDTipoDocumentoEntidad getTipoDocumentoEntidad() {
		return tipoDocumentoEntidad;
	}

	public void setTipoDocumentoEntidad(DDTipoDocumentoEntidad tipoDocumentoEntidad) {
		this.tipoDocumentoEntidad = tipoDocumentoEntidad;
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
