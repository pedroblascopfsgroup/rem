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
import es.pfsgroup.plugin.rem.model.dd.DDIdioma;



/**
 * clase modelo de PVE_IDM.
 *
 */
@Entity
@Table(name = "PVE_IDM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProveedorIdioma implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ProveedorIdiomaPk primaryKey = new ProveedorIdiomaPk();

    @Column(name = "PVE_ID", nullable = false, updatable = false, insertable = false)
    private Long proveedor;

    @Column(name = "IDM_ID", nullable = false, updatable = false, insertable = false)
    private Long idioma;

	

	public ProveedorIdiomaPk getPrimaryKey() {
		return primaryKey;
	}


	public void setPrimaryKey(ProveedorIdiomaPk primaryKey) {
		this.primaryKey = primaryKey;
	}


	public Long getProveedor() {
		return proveedor;
	}


	public void setProveedor(Long proveedor) {
		this.proveedor = proveedor;
	}


	public Long getIdioma() {
		return idioma;
	}


	public void setIdioma(Long idioma) {
		this.idioma = idioma;
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
    public ProveedorIdioma() {
        primaryKey = new ProveedorIdiomaPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class ProveedorIdiomaPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ProveedorIdioma other = (ProveedorIdioma) obj;
            if (proveedor == null) {
                if (other.proveedor != null) { return false; }
            } else if (!proveedor.equals(other.proveedor)) { return false; }
            if (idioma == null) {
                if (other.idioma != null) { return false; }
            } else if (!idioma.equals(other.idioma)) { return false; }
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
            result = prime * result + ((idioma == null) ? 0 : idioma.hashCode());
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
        @JoinColumn(name = "IDM_ID")
        private DDIdioma idioma;

        /**
         * default contructor.
         */
        public ProveedorIdiomaPk() {

        }

		public ActivoProveedor getProveedor() {
			return proveedor;
		}

		public void setProveedor(ActivoProveedor proveedor) {
			this.proveedor = proveedor;
		}

		public DDIdioma getIdioma() {
			return idioma;
		}

		public void setIdioma(DDIdioma idioma) {
			this.idioma = idioma;
		}

		

	
     
    }

}
