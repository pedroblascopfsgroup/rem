package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.model.dd.DDDistritoCaixa;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicacion;


@Entity
@Table(name = "CPD_COD_POSTAL_DISTRITO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CodigoPostalDistrito implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CPD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CodigoPostalDistritoGenerator")
    @SequenceGenerator(name = "CodigoPostalDistritoGenerator", sequenceName = "S_CPD_COD_POSTAL_DISTRITO")
    private Long id;
	
	
    @Column(name = "CPD_COD_POSTAL")
    private String codigoPostal;
	

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_DIC_ID")
	private DDDistritoCaixa distritoCaixa;
	
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

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public DDDistritoCaixa getDistritoCaixa() {
		return distritoCaixa;
	}

	public void setDistritoCaixa(DDDistritoCaixa distritoCaixa) {
		this.distritoCaixa = distritoCaixa;
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
