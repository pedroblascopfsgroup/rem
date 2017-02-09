package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.framework.paradise.gestorEntidad.model.GestorEntidadHistorico;

@Entity
@Table(name = "GCH_GESTOR_ECO_HISTORICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "GEH_ID")
public class GestorExpedienteComercialHistorico extends GestorEntidadHistorico implements Serializable {

	private static final long serialVersionUID = -8753595178478713541L;
	
	@ManyToOne
	@JoinColumn(name = "ECO_ID")
	private ExpedienteComercial expedienteComercial;

	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}
	
}
