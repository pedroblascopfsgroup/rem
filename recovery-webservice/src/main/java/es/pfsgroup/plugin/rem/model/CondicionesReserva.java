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
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;


@Entity
@Table(name = "COR_CONDICIONES_RESERVA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CondicionesReserva implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "COR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FechaArrasExpedienteGenerator")
    @SequenceGenerator(name = "FechaArrasExpedienteGenerator", sequenceName = "S_COR_CONDICIONES_RESERVA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RES_ID")
    private Reserva reserva;
    
    @Column(name = "COR_INS_TITULO")
    private Boolean inscripcionTitulo;
    
    @Column(name = "COR_TANTEO_DL")
    private Boolean tanteoDL;
    
    @Column(name = "COR_CARGAS")
    private Boolean cargas;
    
    @Column(name = "COR_TEMAS_TECNICOS")
    private Boolean temasTecnicos;
    
    @Column(name = "COR_POSESION")
    private Boolean posesion;
    
    @Column(name = "COR_TEMAS_CATASTRALES")
    private Boolean temasCatastrales;
    
    @Column(name = "COR_AUTOR_VPO")
    private Boolean autorizacionVpo;
    
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

	public Reserva getReserva() {
		return reserva;
	}

	public void setReserva(Reserva reserva) {
		this.reserva = reserva;
	}

	public Boolean getInscripcionTitulo() {
		return inscripcionTitulo;
	}

	public void setInscripcionTitulo(Boolean inscripcionTitulo) {
		this.inscripcionTitulo = inscripcionTitulo;
	}

	public Boolean getTanteoDL() {
		return tanteoDL;
	}

	public void setTanteoDL(Boolean tanteoDL) {
		this.tanteoDL = tanteoDL;
	}

	public Boolean getCargas() {
		return cargas;
	}

	public void setCargas(Boolean cargas) {
		this.cargas = cargas;
	}

	public Boolean getTemasTecnicos() {
		return temasTecnicos;
	}

	public void setTemasTecnicos(Boolean temasTecnicos) {
		this.temasTecnicos = temasTecnicos;
	}

	public Boolean getPosesion() {
		return posesion;
	}

	public void setPosesion(Boolean posesion) {
		this.posesion = posesion;
	}

	public Boolean getTemasCatastrales() {
		return temasCatastrales;
	}

	public void setTemasCatastrales(Boolean temasCatastrales) {
		this.temasCatastrales = temasCatastrales;
	}

	public Boolean getAutorizacionVpo() {
		return autorizacionVpo;
	}

	public void setAutorizacionVpo(Boolean autorizacionVpo) {
		this.autorizacionVpo = autorizacionVpo;
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