package es.capgemini.pfs.asunto.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la entidad procedimientos.
 * Es una copia de Procedimientos, se crea porque al finalizar un procedimiento desde la pantalla de decisión
 * genera un error desconocido (el problema está en la variable procedimientoPadre.
 * 
 * Si se dejara de usar esta clase hay que probar la finalización y paralización de procedimiento.
 *
 * @author gestelles
 *
 */
@Entity
@Table(name = "PRC_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
//@Inheritance(strategy = InheritanceType.JOINED)
public class ProcedimientoFAKE implements Serializable, Auditable, Comparable<ProcedimientoFAKE> {

    private static final long serialVersionUID = -3745056486147306300L;

    @Id
    @Column(name = "PRC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoGenerator")
    @SequenceGenerator(name = "ProcedimientoGenerator", sequenceName = "S_PRC_PROCEDIMIENTOS")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPR_ID")
    private DDEstadoProcedimiento estadoProcedimiento;
    
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the estadoProcedimiento
     */
    public DDEstadoProcedimiento getEstadoProcedimiento() {
        return estadoProcedimiento;
    }

    /**
     * @param estadoProcedimiento the estadoProcedimiento to set
     */
    public void setEstadoProcedimiento(DDEstadoProcedimiento estadoProcedimiento) {
        this.estadoProcedimiento = estadoProcedimiento;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int compareTo(ProcedimientoFAKE o) {
        return this.id.compareTo(o.getId());
    }


}