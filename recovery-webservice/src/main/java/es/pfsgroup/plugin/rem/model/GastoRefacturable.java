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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "GRG_REFACTURACION_GASTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoRefacturable implements Serializable, Auditable {

	private static final long serialVersionUID = -8745320767092816790L;

	@Id
	@Column(name = "GRG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoRefacturableGenerator")
	@SequenceGenerator(name = "GastoRefacturableGenerator", sequenceName = "S_GRG_REFACTURACION_GASTOS")
	private Long id;
	
	/*
	 * 
	 * Se han mapeado ids en vez objetos ya que tanto
	 * GRG_GPV_ID como GRG_GPV_ID_REFACTURADO apuntan a
	 * GPV_ID de GPV_GASTOS_PROVEEDOR (GastoProveedor)
	 *
	 */
	
	@Column(name = "GRG_GPV_ID")
	private Long idGastoProveedor;
	
	@Column(name = "GRG_GPV_ID_REFACTURADO")
	private Long idGastoProveedorRefacturado;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGastoProveedor() {
		return idGastoProveedor;
	}

	public void setGastoProveedor(Long gastoProveedor) {
		this.idGastoProveedor = gastoProveedor;
	}

	public Long getGastoProveedorRefacturado() {
		return idGastoProveedorRefacturado;
	}

	public void setGastoProveedorRefacturado(Long gastoProveedorRefacturado) {
		this.idGastoProveedorRefacturado = gastoProveedorRefacturado;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}	

}

