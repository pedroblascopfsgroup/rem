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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

/**
 * Modelo que gestiona las derivaciones de estado del trabajo.
 */
@Entity
@Table(name = "TBJ_TPE_TRANS_PEF_ESTADO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class DerivacionEstadoTrabajo implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;
	
	//Estados iniciales
	public static final String RECHAZADO = "REJ";
	public static final String EN_CURSO = "CUR";
	public static final String FINALIZADO = "FIN";
	public static final String SUBSANADO = "SUB";
	public static final String VALIDADO = "13";

	@Id
    @Column(name = "TPE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DerivacionEstadoTrabajoGenerator")
    @SequenceGenerator(name = "DerivacionEstadoTrabajoGenerator", sequenceName = "S_TBJ_TPE_TRANS_PEF_ESTADO")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TPE_EST_INI")
	private DDEstadoTrabajo estadoInicial; 
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TPE_EST_FIN")
	private DDEstadoTrabajo estadoFinal;  
     
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PEF_ID")
   	private Perfil perfil;
    
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

	public DDEstadoTrabajo getEstadoInicial() {
		return estadoInicial;
	}

	public void setEstadoInicial(DDEstadoTrabajo estadoInicial) {
		this.estadoInicial = estadoInicial;
	}

	public DDEstadoTrabajo getEstadoFinal() {
		return estadoFinal;
	}

	public void setEstadoFinal(DDEstadoTrabajo estadoFinal) {
		this.estadoFinal = estadoFinal;
	}

	public Perfil getIdPerfil() {
		return perfil;
	}

	public void setIdPerfil(Perfil perfil) {
		this.perfil = perfil;
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
