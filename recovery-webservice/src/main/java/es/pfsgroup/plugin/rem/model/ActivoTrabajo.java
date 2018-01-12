package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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

    @EmbeddedId
    private ActivoTrabajoPk primaryKey = new ActivoTrabajoPk();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="ACT_ID",nullable = false, updatable = false, insertable = false)
    private Activo activo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="TBJ_ID",nullable = false, updatable = false, insertable = false)
    private Trabajo trabajo;
    
    @Column(name="ACT_TBJ_PARTICIPACION")
    private Float participacion;

    
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

        @Column(name = "ACT_ID")
        private Long activo;

        @Column(name = "TBJ_ID")
        private Long trabajo;

        /**
         * default contructor.
         */
        public ActivoTrabajoPk() {

        }
        
        public ActivoTrabajoPk(Long activo, Long trabajo) {
        	this.trabajo = trabajo;
        	this.activo = activo;
        }

		public Long getActivo() {
			return activo;
		}

		public void setActivo(Long activo) {
			this.activo = activo;
		}

		public Long getTrabajo() {
			return trabajo;
		}

		public void setTrabajo(Long trabajo) {
			this.trabajo = trabajo;
		}
        
        

     
    }

}
