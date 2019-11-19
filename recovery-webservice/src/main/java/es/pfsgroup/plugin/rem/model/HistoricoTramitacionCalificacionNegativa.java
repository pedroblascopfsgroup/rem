package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
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
import es.pfsgroup.plugin.rem.model.dd.DDCanalPrescripcion;
import es.pfsgroup.plugin.rem.model.dd.DDClaseOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenComprador;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoTanteo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;


/**
 * Modelo que gestiona el histórico de las tramitaciones de calificación negativa
 *
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "ACT_ATC_TRAM_CALIFICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class HistoricoTramitacionCalificacionNegativa implements Serializable, Auditable {

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "ATC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoTramitacionCalificacionNegativaGenerator")
    @SequenceGenerator(name = "HistoricoTramitacionCalificacionNegativaGenerator", sequenceName = "S_ACT_ATC_TRAM_CALIFICACION")
    private Long id;

   
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_CAN_ID")
    private ActivoCalificacionNegativa activoCalificacionNegativa;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "AHT_ID")
    private HistoricoTramitacionTitulo historicoTramitacionTitulo;
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ActivoCalificacionNegativa getActivoCalificacionNegativa() {
		return activoCalificacionNegativa;
	}

	public void setActivoCalificacionNegativa(ActivoCalificacionNegativa activoCalificacionNegativa) {
		this.activoCalificacionNegativa = activoCalificacionNegativa;
	}

	public HistoricoTramitacionTitulo getHistoricoTramitacionTitulo() {
		return historicoTramitacionTitulo;
	}

	public void setHistoricoTramitacionTitulo(HistoricoTramitacionTitulo historicoTramitacionTitulo) {
		this.historicoTramitacionTitulo = historicoTramitacionTitulo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
		
}