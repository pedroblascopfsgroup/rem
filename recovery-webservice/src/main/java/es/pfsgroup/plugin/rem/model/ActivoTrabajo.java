package es.pfsgroup.plugin.rem.model;

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



/**
 * clase modelo de ACT_TBJ.
 *
 */
@Entity
@Table(name = "ACT_TBJ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoTrabajo implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ActivoTrabajoPk primaryKey = new ActivoTrabajoPk();

    @Column(name = "ACT_ID", nullable = false, updatable = false, insertable = false)
    private Long activo;

    @Column(name = "TBJ_ID", nullable = false, updatable = false, insertable = false)
    private Long trabajo;
    
    @Column(name="ACT_TBJ_PARTICIPACION")
    private Float participacion;

    
    
    
    
    public Float getParticipacion() {
		return participacion;
	}
    
	public void setParticipacion(Float participacion) {
		this.participacion = participacion;
	}


	public ActivoTrabajoPk getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(ActivoTrabajoPk primaryKey) {
		this.primaryKey = primaryKey;
	}


	@Version
    private Integer version;

    /**
     * defualt contructor.
     */
    public ActivoTrabajo() {
        primaryKey = new ActivoTrabajoPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class ActivoTrabajoPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ActivoTrabajo other = (ActivoTrabajo) obj;
            if (activo == null) {
                if (other.activo != null) { return false; }
            } else if (!activo.equals(other.activo)) { return false; }
            if (trabajo == null) {
                if (other.trabajo != null) { return false; }
            } else if (!trabajo.equals(other.trabajo)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((activo == null) ? 0 : activo.hashCode());
            result = prime * result + ((trabajo == null) ? 0 : trabajo.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @ManyToOne
        @JoinColumn(name = "ACT_ID")
        private Activo activo;

        @ManyToOne
        @JoinColumn(name = "TBJ_ID")
        private Trabajo trabajo;

        /**
         * default contructor.
         */
        public ActivoTrabajoPk() {

        }

		public Activo getActivo() {
			return activo;
		}

		public void setActivo(Activo activo) {
			this.activo = activo;
		}

		public Trabajo getTrabajo() {
			return trabajo;
		}

		public void setTrabajo(Trabajo trabajo) {
			this.trabajo = trabajo;
		}
        
        

     
    }

}
