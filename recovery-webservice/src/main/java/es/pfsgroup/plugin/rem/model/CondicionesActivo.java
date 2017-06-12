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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionesPosesoria;


/**
 * Modelo que gestiona la informacion de condiciones de un activo de un expediente comercial
 *  
 * @author Alberto Soler
 *
 */
@Entity
@Table(name = "ECO_COND_CONDICIONES_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class CondicionesActivo implements Serializable, Auditable {
	
		
	private static final long serialVersionUID = -8199960328477769633L;

	@Id
    @Column(name = "COND_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CondicionesActivoGenerator")
    @SequenceGenerator(name = "CondicionesActivoGenerator", sequenceName = "S_ECO_COND_CONDICIONES_ACTIVO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ETI_ID")
	private DDEstadoTitulo estadoTitulo;
	
	@Column(name="COND_POSESION_INICIAL")
    private Integer posesionInicial;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SIP_ID")
	private DDSituacionesPosesoria situacionPosesoria;
	
	@Column(name="COND_RENUNCIA_SNMTO_EVICCION")
    private Integer renunciaSaneamientoEviccion;
    
    @Column(name="COND_RENUNCIA_SNMTO_VICIOS")
    private Integer renunciaSaneamientoVicios;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public DDEstadoTitulo getEstadoTitulo() {
		return estadoTitulo;
	}

	public void setEstadoTitulo(DDEstadoTitulo estadoTitulo) {
		this.estadoTitulo = estadoTitulo;
	}

	public Integer getPosesionInicial() {
		return posesionInicial;
	}

	public void setPosesionInicial(Integer posesionInicial) {
		this.posesionInicial = posesionInicial;
	}

	public DDSituacionesPosesoria getSituacionPosesoria() {
		return situacionPosesoria;
	}

	public void setSituacionPosesoria(DDSituacionesPosesoria situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}

	public Integer getRenunciaSaneamientoEviccion() {
		return renunciaSaneamientoEviccion;
	}

	public void setRenunciaSaneamientoEviccion(Integer renunciaSaneamientoEviccion) {
		this.renunciaSaneamientoEviccion = renunciaSaneamientoEviccion;
	}

	public Integer getRenunciaSaneamientoVicios() {
		return renunciaSaneamientoVicios;
	}

	public void setRenunciaSaneamientoVicios(Integer renunciaSaneamientoVicios) {
		this.renunciaSaneamientoVicios = renunciaSaneamientoVicios;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

   
}
