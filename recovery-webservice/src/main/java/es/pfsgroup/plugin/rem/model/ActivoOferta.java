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



/**
 * clase modelo de ACT_OFR.
 *
 */
@Entity
@Table(name = "ACT_OFR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoOferta implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private ActivoOfertaPk primaryKey = new ActivoOfertaPk();

    @Column(name = "ACT_ID", nullable = false, updatable = false, insertable = false)
    private Long activo;

    @Column(name = "OFR_ID", nullable = false, updatable = false, insertable = false)
    private Long oferta;

	@Column(name="ACT_OFR_IMPORTE")
	private Double importeActivoOferta;
	
	@Column(name="OFR_ACT_PORCEN_PARTICIPACION")
	private Double porcentajeParticipacion;
	
	
	public Long getActivoId() {
		return activo;
	}
	public Long getOferta() {
		return oferta;
	}

	public void setOferta(Long oferta) {
		this.oferta = oferta;
	}
	
	public Double getImporteActivoOferta() {
		return importeActivoOferta;
	}

	public void setImporteActivoOferta(Double importeActivoOferta) {
		this.importeActivoOferta = importeActivoOferta;
	}

	public ActivoOfertaPk getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(ActivoOfertaPk primaryKey) {
		this.primaryKey = primaryKey;
	}

	public Double getPorcentajeParticipacion() {
		return porcentajeParticipacion;
	}

	public void setPorcentajeParticipacion(Double porcentajeParticipacion) {
		this.porcentajeParticipacion = porcentajeParticipacion;
	}


	@Version
    private Integer version;

    /**
     * defualt contructor.
     */
    public ActivoOferta() {
        primaryKey = new ActivoOfertaPk();
    }


    /**
     * clase pk embebida
     */
    @Embeddable
    public static class ActivoOfertaPk implements Serializable {

        /**
         * {@inheritDoc}
         */
        @Override
        public boolean equals(Object obj) {
            if (this == obj) { return true; }
            if (obj == null) { return false; }
            if (getClass() != obj.getClass()) { return false; }

            ActivoOferta other = (ActivoOferta) obj;
            if (activo == null) {
                if (other.activo != null) { return false; }
            } else if (!activo.equals(other.activo)) { return false; }
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
            result = prime * result + ((activo == null) ? 0 : activo.hashCode());
            result = prime * result + ((oferta == null) ? 0 : oferta.hashCode());
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
        @JoinColumn(name = "OFR_ID")
        @Where(clause = Auditoria.UNDELETED_RESTICTION)
        private Oferta oferta;

        /**
         * default contructor.
         */
        public ActivoOfertaPk() {

        }

		public Activo getActivo() {
			return activo;
		}

		public void setActivo(Activo activo) {
			this.activo = activo;
		}

		public Oferta getOferta() {
			return oferta;
		}

		public void setOferta(Oferta oferta) {
			this.oferta = oferta;
		}

	
     
    }

}
