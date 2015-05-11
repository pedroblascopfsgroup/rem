package es.capgemini.pfs.cobropago.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase de diccionario para representar los subtipos de Cobros / Pagos.
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "DD_SCP_SUBTIPO_COBRO_PAGO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDSubtipoCobroPago implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DD_SCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoCobroPagoGenerator")
    @SequenceGenerator(name = "DDSubtipoCobroPagoGenerator", sequenceName = "S_DD_SCP_SUBTIPO_COBRO_PAGO")
    private Long id;

    @Column(name = "DD_SCP_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SCP_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_SCP_CODIGO")
    private String codigo;

    @ManyToOne
    @JoinColumn(name = "DD_TCP_ID")
    private DDTipoCobroPago tipoCobroPago;
    
    @Column(name = "DD_SCP_FACTURABLE")
    private Boolean facturable;

	@Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        if (this.descripcion == null) { return ""; }
        return this.descripcion;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the tipoCobroPago
     */
    public DDTipoCobroPago getTipoCobroPago() {
        return tipoCobroPago;
    }

    /**
     * @param tipoCobroPago the tipoCobroPago to set
     */
    public void setTipoCobroPago(DDTipoCobroPago tipoCobroPago) {
        this.tipoCobroPago = tipoCobroPago;
    }

    /**
     * @return the version
     */
    public Long getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Long version) {
        this.version = version;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }
    
    public Boolean getFacturable() {
		return facturable;
	}

	public void setFacturable(Boolean facturable) {
		this.facturable = facturable;
	}
}
