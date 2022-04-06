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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;



/**
 * clase modelo de PVE_ESP.
 *
 */
@Entity
@Table(name = "PVE_ESP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProveedorEspecialidad implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ProveedorEspecialidadPk primaryKey = new ProveedorEspecialidadPk();

    @Column(name = "PVE_ID", nullable = false, updatable = false, insertable = false)
    private Long proveedor;

    @Column(name = "ESP_ID", nullable = false, updatable = false, insertable = false)
    private Long especialidad;

	
	
	public ProveedorEspecialidadPk getPrimaryKey() {
		return primaryKey;
	}


	public void setPrimaryKey(ProveedorEspecialidadPk primaryKey) {
		this.primaryKey = primaryKey;
	}


	public Long getProveedor() {
		return proveedor;
	}


	public void setProveedor(Long proveedor) {
		this.proveedor = proveedor;
	}


	public Long getEspecialidad() {
		return especialidad;
	}


	public void setEspecialidad(Long especialidad) {
		this.especialidad = especialidad;
	}


	public Integer getVersion() {
		return version;
	}


	public void setVersion(Integer version) {
		this.version = version;
	}


	@Version
    private Integer version;

    /**
     * defualt contructor.
     */
    public ProveedorEspecialidad() {
        primaryKey = new ProveedorEspecialidadPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class ProveedorEspecialidadPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ProveedorEspecialidad other = (ProveedorEspecialidad) obj;
            if (proveedor == null) {
                if (other.proveedor != null) { return false; }
            } else if (!proveedor.equals(other.proveedor)) { return false; }
            if (especialidad == null) {
                if (other.especialidad != null) { return false; }
            } else if (!especialidad.equals(other.especialidad)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((proveedor == null) ? 0 : proveedor.hashCode());
            result = prime * result + ((especialidad == null) ? 0 : especialidad.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @ManyToOne
        @JoinColumn(name = "PVE_ID")
        private ActivoProveedor proveedor;

        @ManyToOne
        @JoinColumn(name = "ESP_ID")
        private DDEspecialidad especialidad;

        /**
         * default contructor.
         */
        
        public ProveedorEspecialidadPk() {

        }
        
		public ActivoProveedor getProveedor() {
			return proveedor;
		}

		public void setProveedor(ActivoProveedor proveedor) {
			this.proveedor = proveedor;
		}

		public DDEspecialidad getEspecialidad() {
			return especialidad;
		}

		public void setEspecialidad(DDEspecialidad especialidad) {
			this.especialidad = especialidad;
		}
     
    }

}
