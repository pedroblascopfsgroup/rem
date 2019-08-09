package es.pfsgroup.plugin.rem.model;

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
import es.pfsgroup.plugin.rem.model.dd.DDDevolucionReserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;


/**
 * Modelo que gestiona la informacion de una reserva
 *  
 * @author David Benavente
 *
 */
@Entity
@Table(name = "OGR_OFERTAS_AGRUPADAS_LBK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class OfertasAgrupadasLbk implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "OGR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ReservaGenerator")
    @SequenceGenerator(name = "ReservaGenerator", sequenceName = "S_OGR_OFERTAS_AGRUPADAS_LBK")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_OFERTA_PRINCIPAL")
    private Oferta ofertaPrincipal;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ID_OFERTA_DEPENDIENTE")
    private Oferta ofertaDependiente;
   
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


	public Oferta getOfertaPrincipal() {
		return ofertaPrincipal;
	}

	public void setOfertaPrincipal(Oferta ofertaPrincipal) {
		this.ofertaPrincipal = ofertaPrincipal;
	}

	public Oferta getOfertaDependiente() {
		return ofertaDependiente;
	}

	public void setOfertaDependiente(Oferta ofertaDependiente) {
		this.ofertaDependiente = ofertaDependiente;
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
