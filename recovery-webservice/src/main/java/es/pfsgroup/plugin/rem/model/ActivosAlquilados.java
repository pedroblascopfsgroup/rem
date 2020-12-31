package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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

/**
 * Modelo que gestiona los activos alquilados.
 * 
 * @author Javier Esbri
 */
@Entity
@Table(name = "ACT_ALQ_ACTIVOS_ALQUILADOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivosAlquilados implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;


	@Id
    @Column(name = "ACT_ALQ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivosAlquiladosGenerator")
    @SequenceGenerator(name = "ActivosAlquiladosGenerator", sequenceName = "S_ACT_ALQ_ACTIVOS_ALQUILADOS")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activoAlq;
    
    @Column(name = "ACT_ALQ_RENTAS_MENSUAL")
    private Double alqRentaMensual;
    
    @Column(name = "ACT_ALQ_DEUDAS")
    private Integer alqDeudas; 
    
    @Column(name = "ACT_ALQ_INQUILINO")
    private Integer alqInquilino;  
	
	@Column(name = "ACT_AQL_OFERTANTE")
    private Integer alqOfertante;  
	
	@Column(name = "ACT_AQL_FECHA_FIN_CNT")
    private Date alqFechaFin;
	
	@Column(name = "ACT_ALQ_DEUDA_ACTUAL")
    private Double alqDeudaActual;
	
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

	public Activo getActivoAlq() {
		return activoAlq;
	}

	public void setActivoAlq(Activo activoAlq) {
		this.activoAlq = activoAlq;
	}

	public Double getAlqRentaMensual() {
		return alqRentaMensual;
	}

	public void setAlqRentaMensual(Double alqRentaMensual) {
		this.alqRentaMensual = alqRentaMensual;
	}

	public Integer getAlqDeudas() {
		return alqDeudas;
	}

	public void setAlqDeudas(Integer alqDeudas) {
		this.alqDeudas = alqDeudas;
	}

	public Integer getAlqInquilino() {
		return alqInquilino;
	}

	public void setAlqInquilino(Integer alqInquilino) {
		this.alqInquilino = alqInquilino;
	}

	public Integer getAlqOfertante() {
		return alqOfertante;
	}

	public void setAlqOfertante(Integer alqOfertante) {
		this.alqOfertante = alqOfertante;
	}

	public Date getAlqFechaFin() {
		return alqFechaFin;
	}

	public void setAlqFechaFin(Date alqFechaFin) {
		this.alqFechaFin = alqFechaFin;
	}

	public Double getAlqDeudaActual() {
		return alqDeudaActual;
	}

	public void setAlqDeudaActual(Double alqDeudaActual) {
		this.alqDeudaActual = alqDeudaActual;
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
