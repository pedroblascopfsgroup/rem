package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;



/**
 * clase modelo de ACT_LGE_LOCALIZACION_GEST.
 *
 */
@Entity
@Table(name = "ACT_LGE_LOCALIZACION_GEST", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class LocalizacionSubestadoGestion implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private LocalizacionSubestadoGestionPk primaryKey = new LocalizacionSubestadoGestionPk();

    @Column(name = "DD_ELO_ID", nullable = false, updatable = false, insertable = false)
    private Long estadoLocalizacion;

    @Column(name = "DD_SEG_ID", nullable = false, updatable = false, insertable = false)
    private Long subestadoGestion;
    
	@Version   
	private Integer version;
	
	@Embedded
	private Auditoria auditoria;
	
	public Long getEstadoLocalizacion() {
		return estadoLocalizacion;
	}

	public void setEstadoLocalizacion(Long estadoLocalizacion) {
		this.estadoLocalizacion = estadoLocalizacion;
	}

	public Long getSubestadoGestion() {
		return subestadoGestion;
	}

	public void setSubestadoGestion(Long subestadoGestion) {
		this.subestadoGestion = subestadoGestion;
	}

	public LocalizacionSubestadoGestionPk getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(LocalizacionSubestadoGestionPk primaryKey) {
		this.primaryKey = primaryKey;
	}

    public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
     * defualt contructor.
     */
    public LocalizacionSubestadoGestion() {
        primaryKey = new LocalizacionSubestadoGestionPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class LocalizacionSubestadoGestionPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            LocalizacionSubestadoGestion other = (LocalizacionSubestadoGestion) obj;
            if (estadoLocalizacion == null) {
                if (other.estadoLocalizacion != null) { return false; }
            } else if (!estadoLocalizacion.equals(other.estadoLocalizacion)) { return false; }
            if (subestadoGestion == null) {
                if (other.subestadoGestion != null) { return false; }
            } else if (!subestadoGestion.equals(other.subestadoGestion)) { return false; }
            return true;
        }

        /**
         * {@inheritDoc}
         */
        @Override
        public int hashCode() {
            final int prime = 31;
            int result = 1;
            result = prime * result + ((estadoLocalizacion == null) ? 0 : estadoLocalizacion.hashCode());
            result = prime * result + ((subestadoGestion == null) ? 0 : subestadoGestion.hashCode());
            return result;
        }

        /**
         * setial.
         */
        private static final long serialVersionUID = 1L;

        @ManyToOne
        @JoinColumn(name = "DD_ELO_ID")
        private DDEstadoLocalizacion estadoLocalizacion;

        @ManyToOne
        @JoinColumn(name = "DD_SEG_ID")
        @Where(clause = Auditoria.UNDELETED_RESTICTION)
        private DDSubestadoGestion subestadoGestion;

        /**
         * default contructor.
         */
        public LocalizacionSubestadoGestionPk() {

        }

		public DDEstadoLocalizacion getEstadoLocalizacion() {
			return estadoLocalizacion;
		}

		public void setEstadoLocalizacion(DDEstadoLocalizacion estadoLocalizacion) {
			this.estadoLocalizacion = estadoLocalizacion;
		}

		public DDSubestadoGestion getSubestadoGestion() {
			return subestadoGestion;
		}

		public void setSubestadoGestion(DDSubestadoGestion subestadoGestion) {
			this.subestadoGestion = subestadoGestion;
		}

        
     
    }

}
