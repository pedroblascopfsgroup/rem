package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_NOTIFICACIONES_WEBCOM", schema = "${entity.schema}")
public class VNotificacionesWebcom implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "IDWEBCOM")  
	private String idWebcom;


	public String getIdWebcom() {
		return idWebcom;
	}


	public void setIdWebcom(String idWebcom) {
		this.idWebcom = idWebcom;
	}	
		

}