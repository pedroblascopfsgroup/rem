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
 * Clase modelo de TBJ_PFA.
 *
 */

@Entity
@Table(name = "TBJ_PFA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class TrabajoPrefactura implements Serializable {
	
	private static final long serialVersionUID = 1L;

	@Id
	private TrabajoPrefacturaPk primaryKey = new TrabajoPrefacturaPk();

	@Column(name="TBJ_ID",nullable = false, updatable = false, insertable = false)
	private Long trabajo;
	
	@Column(name="PFA_ID",nullable = false, updatable = false, insertable = false)
	private Long prefactura;
	
	
	
	public TrabajoPrefacturaPk getPrimaryKey() {
		return primaryKey;
	}
	
	public void setPrimaryKey(TrabajoPrefacturaPk primaryKey) {
		this.primaryKey = primaryKey;
	}
	
	@Version
	private Integer version;
	
	
	/**
	 * defualt contructor.
	 */
	public TrabajoPrefactura() {
		primaryKey = new TrabajoPrefacturaPk();
	}
	
	/**
	 * clase pk embebida
	 */
	@Embeddable
	public static class TrabajoPrefacturaPk implements Serializable {
		
		/**
		 * {@inheritDoc}
		 */
		
		@Override
		public boolean equals(Object obj) {
			if (this == obj) { return true; }
			if (obj == null) { return false; }
			if (getClass() != obj.getClass()) { return false; }
			
			TrabajoPrefactura other = (TrabajoPrefactura) obj;
			if (trabajo == null) {
				if (other.trabajo != null) {
					return false; 
				}
			} else if (!trabajo.equals(other.trabajo)) {
				return false; 
			}
			if (prefactura == null) {
				if (other.prefactura != null) {
					return false; 
				}
			} else if (!prefactura.equals(other.prefactura)) {
				return false; 
			}
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + ((trabajo == null) ? 0 : trabajo.hashCode());
			result = prime * result + ((prefactura == null) ? 0 : prefactura.hashCode());
			return result;
		}
		
		/**
		 * setial.
		 */
		private static final long serialVersionUID = 1L;
		
		@ManyToOne
		@JoinColumn(name = "TBJ_ID")
		private Trabajo trabajo;
		
		@ManyToOne
		@JoinColumn(name = "PFA_ID")
		private Prefactura prefactura;
		
		/**
		 * default contructor.
		 */
		public TrabajoPrefacturaPk() {
			
		}
		
		public Trabajo getTrabajo() {
			return trabajo;
		}
		
		public void setTrabajo(Trabajo trabajo) {
			this.trabajo = trabajo;
		}

		public Prefactura getPrefactura() {
			return prefactura;
		}

		public void setPrefactura(Prefactura prefactura) {
			this.prefactura = prefactura;
		}
	}

}
