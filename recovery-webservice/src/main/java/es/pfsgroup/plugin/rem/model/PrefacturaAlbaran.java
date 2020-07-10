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
 * Clase modelo de PFA_ALB.
 *
 */
@Entity
@Table(name = "PFA_ALB", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PrefacturaAlbaran implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	private PrefacturaAlbaranPk primaryKey = new PrefacturaAlbaranPk();
	
	@Column(name="PFA_ID",nullable = false, updatable = false, insertable = false)
	private Long prefactura;
	
	@Column(name="ALB_ID",nullable = false, updatable = false, insertable = false)
	private Long albaran;
	
	
	
	public Long getPrefactura() {
		return prefactura;
	}
	
	public void setPrefactura(Long prefactura) {
		this.prefactura = prefactura;
	}
	
	public Long getAlbaran() {
		return albaran;
	}
	
	public void setAlbaran(Long albaran) {
		this.albaran = albaran;
	}
	
	public PrefacturaAlbaranPk getPrimaryKey() {
		return primaryKey;
	}
	
	public void setPrimaryKey(PrefacturaAlbaranPk primaryKey) {
		this.primaryKey = primaryKey;
	}
	
	@Version
	private Integer version;

	/**
	 * defualt contructor.
	 */
	public PrefacturaAlbaran() {
		primaryKey = new PrefacturaAlbaranPk();
	}


	/**
	 * clase pk embebida
	 */
	@Embeddable
	public static class PrefacturaAlbaranPk implements Serializable {

		/**
		 * {@inheritDoc}
		 */
		@Override
		public boolean equals(Object obj) {
			if (this == obj) { return true; }
			if (obj == null) { return false; }
			if (getClass() != obj.getClass()) { return false; }
			
			PrefacturaAlbaran other = (PrefacturaAlbaran) obj;
			if (prefactura == null) {
				if (other.prefactura != null) { return false; }
			} else if (!prefactura.equals(other.prefactura)) { return false; }
			if (albaran == null) {
				if (other.albaran != null) { return false; }
			} else if (!albaran.equals(other.albaran)) { return false; }
			return true;
		}
		
		/**
		 * {@inheritDoc}
		 */
		@Override
		public int hashCode() {
			final int prime = 31;
			int result = 1;
			result = prime * result + ((prefactura == null) ? 0 : prefactura.hashCode());
			result = prime * result + ((albaran == null) ? 0 : albaran.hashCode());
			return result;
		}
		
		/**
		 * setial.
		 */
		private static final long serialVersionUID = 1L;
		
		@Column(name = "ACT_ID")
		private Prefactura prefactura;
		
		@Column(name = "TBJ_ID")
		private Albaran albaran;
		
		/**
		 * default contructor.
		 */
		public PrefacturaAlbaranPk() {
			
		}
		
		public PrefacturaAlbaranPk(Prefactura prefactura, Albaran albaran) {
			this.prefactura = prefactura;
			this.albaran = albaran;
		}
		
		public Prefactura getPrefactura() {
			return prefactura;
		}
		
		public void setPrefactura(Prefactura prefactura) {
			this.prefactura = prefactura;
		}
		
		public Albaran getAlbaran() {
			return albaran;
		}
		
		public void setAlbaran(Albaran albaran) {
			this.albaran = albaran;
		}
		
	}

}
