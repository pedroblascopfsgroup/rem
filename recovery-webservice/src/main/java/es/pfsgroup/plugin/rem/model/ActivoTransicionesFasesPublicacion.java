package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;

/**
 * Modelo que gestiona las fases de publicacion de los activos.
 */
@Entity
@Table(name = "ACT_TFP_TRANSICIONES_FASESP", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTransicionesFasesPublicacion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "TFP_ID")    
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TFP_ORIGEN")
	private DDSubfasePublicacion origen; 
    
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TFP_DESTINO")
	private DDSubfasePublicacion destino;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}
	
	public DDSubfasePublicacion getOrigen() {
		return origen;
	}

	public void setOrigen(DDSubfasePublicacion origen) {
		this.origen = origen;
	}

	public DDSubfasePublicacion getDestino() {
		return destino;
	}

	public void setDestino(DDSubfasePublicacion destino) {
		this.destino = destino;
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
