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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTenedor;



/**
 * Modelo que gestiona la informacion de los movimientos de las llaves
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_MLV_MOVIMIENTO_LLAVE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoMovimientoLlave implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "MLV_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoMovimientoLlaveGenerator")
    @SequenceGenerator(name = "ActivoMovimientoLlaveGenerator", sequenceName = "S_ACT_MLV_MOVIMIENTO_LLAVE")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "LLV_ID")
	private ActivoLlave activoLlave;
	
	@Column(name = "DD_TTE_ID")
	private DDTipoTenedor tipoTenedor;
	
	@Column(name = "MLV_COD_TENEDOR")
	private String codTenedor;
	
	@Column(name = "MLV_NOM_TENEDOR")
	private String nomTenedor;
	 
	@Column(name = "MLV_FECHA_ENTREGA")
	private Date fechaEntrega;
	
	@Column(name = "MLV_FECHA_DEVOLUCION")
	private Date fechaDevolucion;
	
	
	
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

	public ActivoLlave getActivoLlave() {
		return activoLlave;
	}

	public void setActivoLlave(ActivoLlave activoLlave) {
		this.activoLlave = activoLlave;
	}

	public DDTipoTenedor getTipoTenedor() {
		return tipoTenedor;
	}

	public void setTipoTenedor(DDTipoTenedor tipoTenedor) {
		this.tipoTenedor = tipoTenedor;
	}

	public String getCodTenedor() {
		return codTenedor;
	}

	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}

	public String getNomTenedor() {
		return nomTenedor;
	}

	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}

	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
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
