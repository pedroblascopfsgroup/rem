package es.capgemini.pfs.asunto.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.expediente.model.ExpedienteContrato;

/**
 * clase modelo de prc_cex.
 *
 * @author pajimene
 *
 */
@Entity
@Table(name = "PRC_CEX", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProcedimientoContratoExpediente implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ProcedimientoContratoExpedientePk primaryKey = new ProcedimientoContratoExpedientePk();

    @Column(name = "PRC_ID", nullable = false, updatable = false, insertable = false)
    private Long procedimiento;

    @Column(name = "CEX_ID", nullable = false, updatable = false, insertable = false)
    private Long expedienteContrato;

    @Version
    private Integer version;

    /**
     * defualt contructor.
     */
    public ProcedimientoContratoExpediente() {
        primaryKey = new ProcedimientoContratoExpedientePk();
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.primaryKey.setProcedimiento(procedimiento);
    }

    /**
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return primaryKey.getProcedimiento();
    }

    /**
     * @param expedienteContrato the expedienteContrato to set
     */
    public void setExpedienteContrato(ExpedienteContrato expedienteContrato) {
        this.primaryKey.setExpedienteContrato(expedienteContrato);
    }

    /**
     * @return the contratoExpediente
     */
    public ExpedienteContrato getExpedienteContrato() {
        return primaryKey.getExpedienteContrato();
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * clase pk embebida.
     * @author pajimene
     *
     */
    @Embeddable
    public static class ProcedimientoContratoExpedientePk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ProcedimientoContratoExpediente other = (ProcedimientoContratoExpediente) obj;
            if (procedimiento == null) {
                if (other.procedimiento != null) { return false; }
            } else if (!procedimiento.equals(other.procedimiento)) { return false; }
            if (expedienteContrato == null) {
                if (other.expedienteContrato != null) { return false; }
            } else if (!expedienteContrato.equals(other.expedienteContrato)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((procedimiento == null) ? 0 : procedimiento.hashCode());
            result = prime * result + ((expedienteContrato == null) ? 0 : expedienteContrato.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @ManyToOne
        @JoinColumn(name = "PRC_ID")
        private Procedimiento procedimiento;

        @ManyToOne
        @JoinColumn(name = "CEX_ID")
        private ExpedienteContrato expedienteContrato;

        /**
         * default contructor.
         */
        public ProcedimientoContratoExpedientePk() {

        }

        /**
         * @param procedimiento the procedimiento to set
         */
        public void setProcedimiento(Procedimiento procedimiento) {
            this.procedimiento = procedimiento;
        }

        /**
         * @return the procedimiento
         */
        public Procedimiento getProcedimiento() {
            return procedimiento;
        }

        /**
         * @param expedienteContrato the expedienteContrato to set
         */
        public void setExpedienteContrato(ExpedienteContrato expedienteContrato) {
            this.expedienteContrato = expedienteContrato;
        }

        /**
         * @return the expedienteContrato
         */
        public ExpedienteContrato getExpedienteContrato() {
            return expedienteContrato;
        }
    }

}
