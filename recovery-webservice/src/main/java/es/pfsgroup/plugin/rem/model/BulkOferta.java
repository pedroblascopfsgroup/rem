package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * clase modelo de BLK_OFR.
 *
 */
@Entity
@Table(name = "BLK_OFR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BulkOferta implements Serializable, Auditable {
    private static final long serialVersionUID = 1L;

    @EmbeddedId
    private BulkOfertaPk primaryKey = new BulkOfertaPk();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BLK_ID", nullable = false, updatable = false, insertable = false)
    private BulkAdvisoryNote bulkAdvisoryNote;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID", nullable = false, updatable = false, insertable = false)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Oferta oferta;
	
	@Version
    private Integer version;

	@Embedded
	private Auditoria auditoria;
	
    /**
     * defualt constructor.
     */
    public BulkOferta() {
        primaryKey = new BulkOfertaPk();
    }

	public BulkOfertaPk getPrimaryKey() {
		return primaryKey;
	}


	public void setPrimaryKey(BulkOfertaPk primaryKey) {
		this.primaryKey = primaryKey;
	}

	public BulkAdvisoryNote getBulkAdvisoryNote() {
		return bulkAdvisoryNote;
	}

	public void setBulkAdvisoryNote(BulkAdvisoryNote bulkAdvisoryNote) {
		this.bulkAdvisoryNote = bulkAdvisoryNote;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Integer getVersion() {
		return version;
	}


	public void setVersion(Integer version) {
		this.version = version;
	}


	public Auditoria getAuditoria() {
		return auditoria;
	}


	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

    /**
     * clase pk embebida
     */
    @Embeddable
    public static class BulkOfertaPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            BulkOfertaPk other = (BulkOfertaPk) obj;
            if (bulkAdvisoryNote == null) {
                if (other.bulkAdvisoryNote != null) { return false; }
            } else if (!bulkAdvisoryNote.equals(other.bulkAdvisoryNote)) { return false; }
            if (oferta == null) {
                if (other.oferta != null) { return false; }
            } else if (!oferta.equals(other.oferta)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((bulkAdvisoryNote == null) ? 0 : bulkAdvisoryNote.hashCode());
            result = prime * result + ((oferta == null) ? 0 : oferta.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @Column(name = "BLK_ID")
        private Long bulkAdvisoryNote;

        @Column(name = "OFR_ID")
        private Long oferta;

        /**
         * default contructor.
         */
        public BulkOfertaPk() {

        }
        
        public BulkOfertaPk(Long bulkAdvisoryNote, Long oferta) {
        	this.bulkAdvisoryNote = bulkAdvisoryNote;
        	this.oferta = oferta;
        }
        
		public Long getBulkAdvisoryNote() {
			return bulkAdvisoryNote;
		}

		public void setBulkAdvisoryNote(Long bulkAdvisoryNote) {
			this.bulkAdvisoryNote = bulkAdvisoryNote;
		}

		public Long getOferta() {
			return oferta;
		}

		public void setOferta(Long oferta) {
			this.oferta = oferta;
		}        
     
    }

}
