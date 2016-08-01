package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.rem.model.dd.DDEstadoPropuestaActivo;



/**
 * Modelo que gestiona la relación entre activos y propuestas de precios 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_PRP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoPropuesta implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ActivoPropuestaPk primaryKey = new ActivoPropuestaPk();

    @Column(name = "ACT_ID", nullable = false, updatable = false, insertable = false)
    private Long activo;

    @Column(name = "PRP_ID", nullable = false, updatable = false, insertable = false)
    private Long propuestaPrecio;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPA_ID")
    private DDEstadoPropuestaActivo estado;
    
    @Column(name="ACT_PRP_PRECIO_PROPUESTO")
    private Double precioPropuesto;
    
    @Column(name="ACT_PRP_PRECIO_SANCIONADO")
    private Double precioSancionado;
    
    


	public ActivoPropuestaPk getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(ActivoPropuestaPk primaryKey) {
		this.primaryKey = primaryKey;
	}


	public Double getPrecioPropuesto() {
		return precioPropuesto;
	}

	public void setPrecioPropuesto(Double precioPropuesto) {
		this.precioPropuesto = precioPropuesto;
	}

	public Double getPrecioSancionado() {
		return precioSancionado;
	}

	public void setPrecioSancionado(Double precioSancionado) {
		this.precioSancionado = precioSancionado;
	}

	public DDEstadoPropuestaActivo getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoPropuestaActivo estado) {
		this.estado = estado;
	}


	@Version
    private Integer version;

    /**
     * defualt contructor.
     */
    public ActivoPropuesta() {
        primaryKey = new ActivoPropuestaPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class ActivoPropuestaPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ActivoPropuesta other = (ActivoPropuesta) obj;
            if (activo == null) {
                if (other.activo != null) { return false; }
            } else if (!activo.equals(other.activo)) { return false; }
            if (propuestaPrecio == null) {
                if (other.propuestaPrecio != null) { return false; }
            } else if (!propuestaPrecio.equals(other.propuestaPrecio)) { return false; }
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
            result = prime * result + ((propuestaPrecio == null) ? 0 : propuestaPrecio.hashCode());
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
        @JoinColumn(name = "PRP_ID")
        private PropuestaPrecio propuestaPrecio;

        /**
         * default contructor.
         */
        public ActivoPropuestaPk() {

        }

		public Activo getActivo() {
			return activo;
		}

		public void setActivo(Activo activo) {
			this.activo = activo;
		}

		public PropuestaPrecio getPropuestaPrecio() {
			return propuestaPrecio;
		}

		public void setPropuestaPrecio(PropuestaPrecio propuestaPrecio) {
			this.propuestaPrecio = propuestaPrecio;
		}
        
        

     
    }

}
