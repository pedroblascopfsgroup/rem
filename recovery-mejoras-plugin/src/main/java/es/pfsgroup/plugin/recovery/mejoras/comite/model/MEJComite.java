package es.pfsgroup.plugin.recovery.mejoras.comite.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TreeSet;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;

import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

@Entity
public class MEJComite extends Comite {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6113989010476479335L;
	
	 @OneToMany(mappedBy = "comite", cascade = CascadeType.ALL, fetch= FetchType.LAZY)
	 @Where(clause = "borrado = 0 and DD_EAS_ID = '"+DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO+"'")
	private List<Asunto> preAsuntos;

	 @Formula(value = "( select count(asu.asu_id) from asu_asuntos asu where asu.borrado = 0 and asu.dd_eas_id = '"+DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO+"' " +
	 		" and asu.com_id = COM_ID)")
	 private Integer preAsuntosSize;

	 @Formula(value = " (SELECT   MIN (TAR.TAR_FECHA_VENC) " + " FROM   exp_expedientes EXP, "
	            + " ${master.schema}.DD_EST_ESTADOS_ITINERARIOS dd_est, " + " TAR_TAREAS_NOTIFICACIONES tar, "
	            + " ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE dd_sta, " + " ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex "
	            + " WHERE       EXP.COM_ID = COM_ID " + " and dd_eex.DD_EEX_ID = EXP.DD_EEX_ID " + " and dd_eex.DD_EEX_CODIGO = "
	            + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO_STRING + " AND EXP.DD_EST_ID = dd_est.dd_est_id " + " and DD_EST.DD_EST_CODIGO = '"
	            + DDEstadoItinerario.ESTADO_DECISION_COMIT + "'" + " AND tar.exp_id = EXP.exp_id " + " AND TAR.DD_EST_ID = dd_est.dd_est_id "
	            + " AND tar.borrado = 0 " + " AND TAR.DD_STA_ID = DD_STA.DD_STA_ID " + " AND DD_STA.DD_STA_CODIGO = '"
	            + SubtipoTarea.CODIGO_DECISION_COMITE + "' )")
	 private  Date fechaVencimientoMej;
	 
	 @Override
	 public Date getFechaVencimiento() {
		 TreeSet<Date> fechas = new TreeSet<Date>();
	        if (fechaVencimientoMej != null) {
	            fechas.add(fechaVencimientoMej);
	        }
	        for (Asunto asu : getPreAsuntos()) {
	            if (asu.getFechaVencimiento() != null) {
	                fechas.add(asu.getFechaVencimiento());
	            }
	        }

	        if (fechas.isEmpty()) { return null; }
	        return fechas.first();
	    } 
	 
	 @Override
	 public List<Asunto> getPreasuntos() {
		 return getPreAsuntos();
	 }

	public void setPreAsuntos(List<Asunto> preAsuntos) {
		this.preAsuntos = preAsuntos;
	}


	public List<Asunto> getPreAsuntos() {
		return preAsuntos;
	}


	public void setPreAsuntosSize(Integer preAsuntosSize) {
		this.preAsuntosSize = preAsuntosSize;
	}


	public Integer getPreAsuntosSize() {
		return preAsuntosSize;
	}

	public void setFechaVencimientoMej(Date fechaVencimientoMej) {
		this.fechaVencimientoMej = fechaVencimientoMej;
	}

	public Date getFechaVencimientoMej() {
		return fechaVencimientoMej;
	}

}
