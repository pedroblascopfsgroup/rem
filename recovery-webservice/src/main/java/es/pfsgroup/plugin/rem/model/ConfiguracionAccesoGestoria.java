package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDIdentificacionGestoria;

@Entity
@Table(name = "CAG_CONFIG_ACCESO_GESTORIAS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy=InheritanceType.JOINED)
public class ConfiguracionAccesoGestoria implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "CAG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfAccesoGestoriaGenerator")
    @SequenceGenerator(name = "ConfAccesoGestoriaGenerator", sequenceName = "S_CAG_CONFIG_ACCESO_GESTORIAS")
    private Long id;
	
    @OneToOne
    @JoinColumn(name="DD_IGE_ID", referencedColumnName="DD_IGE_ID")
    private DDIdentificacionGestoria gestoria;
    
    @OneToOne
    @JoinColumn(name="CAG_USU_GRUPO", referencedColumnName="USU_ID")
    private Usuario usuarioGrupo;
    
    @OneToOne
    @JoinColumn(name="DD_TGE_ID", referencedColumnName="DD_TGE_ID")
    private EXTDDTipoGestor tipoGestor;

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

	public DDIdentificacionGestoria getGestoria() {
		return gestoria;
	}

	public void setGestoria(DDIdentificacionGestoria gestoria) {
		this.gestoria = gestoria;
	}

	public Usuario getUsuarioGrupo() {
		return usuarioGrupo;
	}

	public void setUsuarioGrupo(Usuario usuarioGrupo) {
		this.usuarioGrupo = usuarioGrupo;
	}

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
