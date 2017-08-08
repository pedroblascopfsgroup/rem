package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.ArrayList;

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
import org.hibernate.annotations.Formula;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona la relación entre gastos y activo
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "AVG_AVISOS_GASTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class GastoProveedorAvisos implements Serializable {

	private static final String FORMULA_CUALQUIER_MOTIVO = "case when nvl(AVG_COMPRADOR,0)" + " + nvl(AVG_IBI_EXENTO,0)"
			+ " + nvl(AVG_IMPUESTO,0)" + " + nvl(AVG_PRIMER_PAGO,0)" + " + nvl(AVG_INCR_IMPORTE,0)"
			+ " + nvl(AVG_DIF_IMPORTE,0)" + " + nvl(AVG_PROVEEDOR_BAJA,0)" + " + nvl(AVG_PROVEEDOR_SINSALDO,0)"
			+ " + nvl(AVG_SIN_PER_ADMINISTRACION,0) > 0 then 1" + " else 0 end";
	// + " from AVG_AVISOS_GASTOS where avg_id = 1";

	/**
	 * 
	 */
	private static final long serialVersionUID = 8707341355818152059L;

	@Id
	@Column(name = "AVG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoProveedorAvisosGenerator")
	@SequenceGenerator(name = "GastoProveedorAvisosGenerator", sequenceName = "S_AVG_AVISOS_GASTOS")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "GPV_ID")
	private GastoProveedor gastoProveedor;

	@Column(name = "AVG_COMPRADOR")
	private Boolean correspondeComprador;

	@Column(name = "AVG_IBI_EXENTO")
	private Boolean ibiExento;

	@Column(name = "AVG_IMPUESTO")
	private Boolean noDevengaImpuesto;

	@Column(name = "AVG_PRIMER_PAGO")
	private Boolean primerPago;

	@Column(name = "AVG_INCR_IMPORTE")
	private Boolean incrementoImporte;

	@Column(name = "AVG_DIF_IMPORTE")
	private Boolean importeDiferente;

	@Column(name = "AVG_PROVEEDOR_BAJA")
	private Boolean bajaProveedor;

	@Column(name = "AVG_PROVEEDOR_SINSALDO")
	private Boolean proveedorSinSaldo;

	@Column(name = "AVG_SIN_PER_ADMINISTRACION")
	private Boolean fueraPerimetro;

	@Formula(FORMULA_CUALQUIER_MOTIVO)
	private Boolean algunMotivo;

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

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
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

	public Boolean getCorrespondeComprador() {
		return correspondeComprador;
	}

	public void setCorrespondeComprador(Boolean correspondeComprador) {
		this.correspondeComprador = correspondeComprador;
	}

	public Boolean getIbiExento() {
		return ibiExento;
	}

	public void setIbiExento(Boolean ibiExento) {
		this.ibiExento = ibiExento;
	}

	public Boolean getNoDevengaImpuesto() {
		return noDevengaImpuesto;
	}

	public void setNoDevengaImpuesto(Boolean noDevengaImpuesto) {
		this.noDevengaImpuesto = noDevengaImpuesto;
	}

	public Boolean getPrimerPago() {
		return primerPago;
	}

	public void setPrimerPago(Boolean primerPago) {
		this.primerPago = primerPago;
	}

	public Boolean getIncrementoImporte() {
		return incrementoImporte;
	}

	public void setIncrementoImporte(Boolean incrementoImporte) {
		this.incrementoImporte = incrementoImporte;
	}

	public Boolean getImporteDiferente() {
		return importeDiferente;
	}

	public void setImporteDiferente(Boolean importeDiferente) {
		this.importeDiferente = importeDiferente;
	}

	public Boolean getBajaProveedor() {
		return bajaProveedor;
	}

	public void setBajaProveedor(Boolean bajaProveedor) {
		this.bajaProveedor = bajaProveedor;
	}

	public Boolean getProveedorSinSaldo() {
		return proveedorSinSaldo;
	}

	public void setProveedorSinSaldo(Boolean proveedorSinSaldo) {
		this.proveedorSinSaldo = proveedorSinSaldo;
	}

	public Boolean getFueraPerimetro() {
		return fueraPerimetro;
	}

	public void setFueraPerimetro(Boolean fueraPerimetro) {
		this.fueraPerimetro = fueraPerimetro;
	}

	public Boolean getAlgunMotivo() {
		return algunMotivo;
	}

	public void setAlgunMotivo(Boolean algunMotivo) {
		this.algunMotivo = algunMotivo;
	}

	public String[] camposAlerta() {
		ArrayList<String> campos = new ArrayList<String>();
		Field[] fields = this.getClass().getDeclaredFields();
		for (Field f : fields) {
			if (f.isAnnotationPresent(Column.class) && (f.getType().equals(Boolean.class))) {
				f.setAccessible(true);
				try {
					if (Boolean.TRUE.equals((Boolean) f.get(this))) {
						campos.add(f.getName());
					}
				} catch (IllegalArgumentException e) {
					// Nothing to do
				} catch (IllegalAccessException e) {
					// Nothing to do
				}
			}
		}
		if (Checks.estaVacio(campos)) {
			return null;
		} else {
			return campos.toArray(new String[] {});
		}
	}

}
