package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "HIST_ENVIO_PEDIDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class HistoricoEnvioPedidos implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "HIST_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoEnvioPedidosGenerator")
    @SequenceGenerator(name = "HistoricoEnvioPedidosGenerator", sequenceName = "S_HIST_ENVIO_PEDIDOS")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor;
    
    @Column(name="FECHA_ENVIO_PRPTRIO")
    private Date fechaEnvioPropietario;
    
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

	public Date getFechaEnvioPropietario() {
		return fechaEnvioPropietario;
	}

	public void setFechaEnvioPropietario(Date fechaEnvioPropietario) {
		this.fechaEnvioPropietario = fechaEnvioPropietario;
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
