package es.capgemini.pfs.tareaNotificacion.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

import org.hibernate.Hibernate;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;
import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.PluginCoreextensionConstantes;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.VencimientoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.integration.Guid;

@Entity
public class EXTTareaNotificacion extends TareaNotificacion {

	private static final long serialVersionUID = 1222231003584045081L;

	public static final String CODIGO_DESTINATARIO_GESTOR = "G";
	public static final String CODIGO_DESTINATARIO_SUPERVISOR = "S";
	public static final String CODIGO_DESTINATARIO_SUPERVISOR_EXP = "SEXP";
	public static final String CODIGO_DESTINATARIO_OFICINA = "O";
	public static final String CODIGO_DESTINATARIO_USUARIO = "U";
	public static final String CODIGO_DESTINATARIO_GESTOR_CONFECCION_EXP = "GCEXP";
	public static final String CODIGO_DESTINATARIO_SUPERVISOR_CONFECCION_EXP = "SCEXP";

	@Column(name = "TAR_FECHA_VENC_REAL")
	private Date fechaVencReal;

	@Column(name = "NFA_TAR_REVISADA")
	private Boolean revisada;

	@Column(name = "NFA_TAR_FECHA_REVIS_ALER")
	private Date fechaRevisionAlerta;

	@Column(name = "NFA_TAR_COMENTARIOS_ALERTA")
	private String comentariosAlertaSupervisor;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_TRA_ID")
	private NFADDTipoRevisionAlerta tipoRevision;

	@Column(name = "TAR_TIPO_DESTINATARIO")
	private String tipoDestinatario;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "TAR_ID_DEST")
	private Usuario destinatarioTarea;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "PER_ID")
	private Persona persona;
	
    private transient String categoriaTarea;
    
    public void setCategoriaTarea(String categoriaTarea) {
    	this.categoriaTarea = categoriaTarea;
    }
    
    public String getCategoriaTarea() {
    	/*if (projectContext.getTareasTipoDecision().contains(this.subtipoTareaCodigoSubtarea))
    		return projectContext.CONST_TAREA_TIPO_DECISION;
    	
    	return "";*/
    	return this.categoriaTarea;
    }	

	@Column(name="SYS_GUID")
	private String guid;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	/*@Embedded
	private Guid guid;
	
	public Guid getGuid() {
		return guid;
	}

	public void setGuid(Guid guid) {
		this.guid = guid;
	}*/

	private static final String _SELECT_ENTIDAD_ASUNTO = " "
			+ " select NVL(per.per_riesgo, 0)"
			+ " from   TAR_TAREAS_NOTIFICACIONES ttt, cli_clientes cli, per_personas per"
			+ " where  ttt.cli_id = cli.cli_id"
			+ " and    cli.per_id = per.per_id"
			+ " and    ttt.tar_id = ttn.tar_id";

	private static final String _SELECT_ENTIDAD_CLIENTE = " "
			+ " Select NVL(sum(m.mov_riesgo),0)"
			+ " from mov_movimientos m, cex_contratos_expediente cex,"
			+ "     cnt_contratos cnt, DD_TPE_TIPO_PROD_ENTIDAD tpe,"
			+ "     TAR_TAREAS_NOTIFICACIONES t"
			+ " where cex.borrado = 0 and m.cnt_id = cex.cnt_id"
			+ " and cex.exp_id = t.exp_id AND cnt.cnt_id = cex.cnt_id"
			+ " and m.mov_fecha_extraccion = cnt.CNT_FECHA_EXTRACCION"
			+ " and cnt.dd_tpe_id = tpe.dd_tpe_id"
			+ " and   t.tar_id = ttn.tar_id";

	private static final String _SELECT_ENTIDAD_EXPEDIENTE = " "
			+ " Select NVL(SUM(m.mov_pos_viva_no_vencida + m.mov_pos_viva_vencida), 0)"
			+ " from mov_movimientos m"
			+ " where   (m.cnt_id, ttn.tar_id) in"
			+ "	("
			+ "	Select distinct d.cnt_id, tar.tar_id"
			+ "	from TAR_TAREAS_NOTIFICACIONES tar, asu_asuntos a, prc_procedimientos p, prc_cex x,"
			+ "	     cex_contratos_expediente c, cnt_contratos d, ${master.schema}.dd_epr_estado_procedimiento esp"
			+ "	where tar.asu_id = a.asu_id" + "	and   a.asu_id = p.asu_id"
			+ "	and   p.prc_id = x.prc_id and x.cex_id = c.cex_id"
			+ "	and   c.cnt_id = d.cnt_id"
			+ "	and   p.dd_epr_id = esp.dd_epr_id"
			+ "   and   p.borrado = 0 and (esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO + "' or"
			+ "                            esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO + "' or"
			+ "                            esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "')" + "	)"
			+ " and m.mov_fecha_extraccion ="
			+ "		(select MAX(m2.mov_fecha_extraccion)"
			+ "		 from mov_movimientos m2" + "		 where m2.cnt_id = m.cnt_id )";

	private static final String _SELECT_ENTIDAD_PROCEDIMIENTO = " "
			+ " select NVL(p.PRC_SALDO_RECUPERACION,0)"
			+ " from prc_procedimientos p, TAR_TAREAS_NOTIFICACIONES t"
			+ " where p.prc_id = t.prc_id" + " and   t.tar_id = ttn.tar_id";

	@Formula("(" + " select " + " CASE" + "  WHEN dde.DD_EIN_CODIGO ='"
			+ DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
			+ "' then ("
			+ _SELECT_ENTIDAD_ASUNTO
			+ ")"
			+ "  WHEN dde.DD_EIN_CODIGO ='"
			+ DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE
			+ "' then ("
			+ _SELECT_ENTIDAD_CLIENTE
			+ ")"
			+ "  WHEN dde.DD_EIN_CODIGO ='"
			+ DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
			+ "' then ("
			+ _SELECT_ENTIDAD_EXPEDIENTE
			+ ")"
			+ "  WHEN dde.DD_EIN_CODIGO ='"
			+ DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
			+ "' then ("
			+ _SELECT_ENTIDAD_PROCEDIMIENTO
			+ ")"
			+ "  ELSE 0"
			+ " END "
			+ " from TAR_TAREAS_NOTIFICACIONES ttn,  ${master.schema}.dd_ein_entidad_informacion dde"
			+ " where ttn.DD_EIN_ID = dde.DD_EIN_ID"
			+ " and ttn.tar_id = TAR_ID" + ")")
	private Float volumenRiesgoSQL;

	@Formula("(" + " select" + "   CASE" + "     WHEN stb.dd_sta_codigo in ('"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE
			+ "', '"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE
			+ "', '"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC
			+ "', '"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_ENSAN
			+ "', '"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_SANC
			+ "', '"
			+ SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO
			+ "') then 'Pr�rroga'"
			+ "     WHEN stb.dd_sta_codigo in ('"
			+ SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR
			+ "') then 'Cancelaci�n Expediente'"
			+ "     WHEN stb.dd_sta_codigo in ('"
			+ SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL
			+ "') then 'Expediente Manual'"
			+ "     WHEN stb.dd_sta_codigo in ('"
			+ SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR
			+ "', '"
			+ SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR
			+ "', '"
			+ SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR
			+ "', '"
			+ SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR
			+ "', '"
			+ SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR
			+ "', '"
			+ EXTSubtipoTarea.CODIGO_NOTIFICACION_INTERCOMUNICACION
			+ "', '"
			+ EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_INTERCOMUNICACION
			+ "', '"
			+ SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR
			+

			"') then 'Comunicaci�n'"
			+ "   ELSE ''"
			+ "   END"
			+ " from TAR_TAREAS_NOTIFICACIONES tn, ${master.schema}.dd_sta_subtipo_tarea_base stb"
			+ " where tn.DD_STA_ID = stb.DD_STA_ID" + " and tn.tar_id = TAR_ID"
			+ ")")
	private String tipoSolicitudSQL;

	@Formula("("
			+ " select (EXTRACT(day from (SYSTIMESTAMP - (tn.tar_fecha_venc)) ))"
			+ " from TAR_TAREAS_NOTIFICACIONES tn" + " where tn.tar_alerta = 1"
			+ " and   tn.tar_id = TAR_ID" + ")")
	private Integer diasVencidoSQL;

	// @Formula("(select ge.usu_id from tar_tareas_notificaciones tn ,GE_GESTOR_ENTIDAD ge,${master.schema}.dd_sta_subtipo_tarea_base sta  "+
	// "where tn.cnt_id = ge.UG_ID and tn.tar_id  = TAR_ID AND tn.dd_sta_id = sta.dd_sta_id and sta.dd_sta_id = DD_STA_ID and ge.dd_tge_id = sta.dd_tge_id)"
	// )
	// private Long gestorContrato;

	// @Formula("(select usu.usu_apellido1 ||','||usu.usu_nombre from tar_tareas_notificaciones tn ,GE_GESTOR_ENTIDAD ge,${master.schema}.usu_usuarios usu, ${master.schema}.dd_sta_subtipo_tarea_base sta "
	// +
	// " where tn.cnt_id = ge.UG_ID and ge.usu_id = usu.usu_id and tn.tar_id  = TAR_ID AND tn.dd_sta_id = sta.dd_sta_id and sta.dd_sta_id = DD_STA_ID and ge.dd_tge_id = sta.dd_tge_id ) "
	// )
	// private String gestorContratoDescripcion;

	@Override
	public Date getFechaVenc() {
		return super.getFechaVenc();
	}

	@Override
	public void setFechaVenc(Date fechaVenc) {
		super.setFechaVenc(fechaVenc);
		setFechaVencReal(fechaVenc);
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
    public Float getVolumenRiesgo() {
        Float vr = null;

        if (getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO)) {
            vr = getAsunto().getVolumenRiesgo();
        }
        if (getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE)) {
            if (getCliente().getPersona() != null) {
                vr = getCliente().getPersona().getRiesgoDirecto();
            }
        }
        if (getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE) && getExpediente() != null && getExpediente().getVolumenRiesgo() != null) {
            vr = getExpediente().getVolumenRiesgo().floatValue();
        }
        if (getProcedimiento() != null && getProcedimiento().getSaldoRecuperacion() != null && getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO)) {
            vr = getProcedimiento().getSaldoRecuperacion().floatValue();
        }
        return vr;
    }	
	
	/**
     * Volumen de Riesgo Vencido de la entidad de informaci�n asociada a la tarea (cliente, expediente, asunto o procedimiento).
     * @return el volumen de riesgo vencido
     */
	@Override
	 public Float getVolumenRiesgoVencido() {
        Float vr = null;
        if (getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE) && getCliente() != null && getCliente().getPersona() != null) {
            vr = getCliente().getPersona().getRiesgoTotal();
        }
        if (getTipoEntidad().getCodigo().equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE) && getExpediente() != null && getExpediente().getVolumenRiesgoVencido() != null) {
            vr = getExpediente().getVolumenRiesgoVencido().floatValue();
        }
        return vr;
    }
	
	 /**
     * getDescripcionEntidad.
     * @return getDescripcionEntidad
     */
	@Override
    public String getDescripcionEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(getTipoEntidad().getCodigo())) { return getProcedimiento().getNombreProcedimiento(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getTipoEntidad().getCodigo())) { return getAsunto().getNombre(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(getTipoEntidad().getCodigo())) { return getExpediente().getDescripcionExpediente(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(getTipoEntidad().getCodigo())) { return getObjetivo().getPolitica().getCicloMarcadoPolitica()
                .getPersona().getApellidoNombre(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getTipoEntidad().getCodigo())) {
            if (getCliente() != null) { return getCliente().getPersona().getApellidoNombre(); }
        }
        if ("9".equals(getTipoEntidad().getCodigo())) {
        	return getPersona().getApellidoNombre();
        }
        return getDescripcionTarea();
    }

	public void setFechaVencReal(Date fechaVencReal) {
		this.fechaVencReal = fechaVencReal;
	}

	public Date getFechaVencReal() {
		return fechaVencReal;
	}

	public void setVencimiento(VencimientoTarea v) {
		if (v.getFechaReal() != null) {
			this.fechaVencReal = v.getFechaReal();
		}
		super.setFechaVenc(v.getFechaVencimiento());
	}

	@Override
	public String getTipoSolicitud() {
		String tipoSolicitud = super.getTipoSolicitud();
		if (Checks.esNulo(tipoSolicitud)) {
			if (PluginCoreextensionConstantes.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION
					.equals(getSubtipoTarea().getCodigoSubtarea())) {
				tipoSolicitud = "Prorroga";
			}
		}
		return tipoSolicitud;
	}

	public void setRevisada(Boolean revisada) {
		this.revisada = revisada;
	}

	public Boolean getRevisada() {
		return revisada;
	}

	public void setFechaRevisionAlerta(Date fechaRevisionAlerta) {
		this.fechaRevisionAlerta = fechaRevisionAlerta;
	}

	public Date getFechaRevisionAlerta() {
		return fechaRevisionAlerta;
	}

	public void setComentariosAlertaSupervisor(
			String comentariosAlertaSupervisor) {
		this.comentariosAlertaSupervisor = comentariosAlertaSupervisor;
	}

	public String getComentariosAlertaSupervisor() {
		return comentariosAlertaSupervisor;
	}

	public void setTipoRevision(NFADDTipoRevisionAlerta tipoRevision) {
		this.tipoRevision = tipoRevision;
	}

	public NFADDTipoRevisionAlerta getTipoRevision() {
		return tipoRevision;
	}

	/**
	 * devuelve el gestor.
	 * 
	 * @return gestor
	 */
	@Override
	public Long getGestor() {
		if (this.getContrato() != null) {
			return getGestorContrato();
		} else {
			if (this.getSubtipoTarea().getGestor() != null) {
				return getGestor_super();
			} else {
				Usuario gestor = getNuevoGestor();
				if (gestor != null) {
					return gestor.getId();
				}
			}
		}
		return null;
	}

	/**
	 * devuelve la descripcion gestor.
	 * 
	 * @return gestor
	 */
	@Override
	public String getDescGestor() {
		try {
			if (this.getContrato() != null) {
				return getGestorContratoDescripcion();
			} else {
				if (this.getSubtipoTarea().getGestor() != null) {
					return super.getDescGestor();
				} else {
					Usuario gestor = getNuevoGestor();
					if (gestor != null) {
						return gestor.getApellidoNombre();
					}
				}
			}
			return null;
		} catch (NullPointerException npe) {
			return null;
		}
	}

	/**
	 * devuelve el supervisor.
	 * 
	 * @return supervisor
	 */
	@Override
	public Long getSupervisor() {
		if (this.getContrato() != null) {
			return getSupervisorContrato();
		} else {
			if (this.getSubtipoTarea().getGestor() != null) {
				return getSupervisor_super();
			} else {
				Usuario supervisor = getNuevoSupervisor();
				if (supervisor != null) {
					return supervisor.getId();
				}
			}
		}
		return null;
	}

	/**
	 * devuelve el supervisor.
	 * 
	 * @return supervisor
	 */
	@Override
	public String getDescSupervisor() {
		if (this.getContrato() != null) {
			return getSupervisorContratoDescripcion();
		} else {
			if (this.getSubtipoTarea().getGestor() != null) {
				return getDescSupervisorAux();
			} else {
				Usuario supervisor = getNuevoSupervisor();
				if (supervisor != null) {
					return supervisor.getApellidoNombre();
				}
			}
		}
		return null;
	}

	/**
	 * Funci�n auxiliar utilizada para poder sobreescribir
	 * calcularSupervisorExpedienteAux
	 * 
	 * */

	private String getDescSupervisorAux() {
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
				.equals(getCodigoTipoEntidad())) {
			return getApellidoNombreSupervisor(getProcedimiento().getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getCodigoTipoEntidad())) {
			return getApellidoNombreSupervisor(getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
				.equals(getCodigoTipoEntidad())) {
			if (getExpediente() != null) {
				return calcularSupervisorExpedienteAUX();
			}
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getCodigoTipoEntidad())) {
			if (getCliente() != null) {
				Perfil perfil = getCliente()
						.getArquetipo()
						.getItinerario()
						.getEstado(
								getCliente().getEstadoItinerario().getCodigo())
						.getSupervisor();
				if (perfil == null) {
					return "";
				}
				return perfil.getDescripcion();
			}
		}
		return "";
	}

	/***
	 * Funci�n que sustituye a calcularSupervisorExpediente de la clase padre
	 * Debido a que la anterior ten�a un bug, y cuando buscaba de un array cog�a
	 * siempre el primer valor, aunque pod�a darse el caso de que estuviera
	 * vac�o el array.
	 * 
	 * */

	private String calcularSupervisorExpedienteAUX() {
		Perfil perfil = null;
		perfil = getExpediente().getArquetipo().getItinerario()
				.getEstado(getCodigoEstadoItinerarioExpediente())
				.getSupervisor();

		if (perfil == null) {
			return "";
		}
		return perfil.getDescripcion();
	}

	@Override
	public String getDescripcionTarea() {
		String s = super.getDescripcionTarea();
		if (Checks.esNulo(s)) {
			return s;
		} else {
			return s.replaceAll("'", "�");
		}
	}

	@Override
	public Prorroga getProrrogaAsociada() {
		if (Checks.estaVacio(this.getProrrogasAsociada())) {
			return null;
		} else {
			return super.getProrrogaAsociada();
		}
	}

	private Usuario getNuevoGestor() {

		if (this.destinatarioTarea != null) {
			return this.destinatarioTarea;
		} else {

			if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
				EXTSubtipoTarea st = (EXTSubtipoTarea) this.getSubtipoTarea();
				if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
						.equals(getCodigoTipoEntidad())) {
					GestorDespacho gd = getGestorAsunto(getProcedimiento()
							.getAsunto(), st.getTipoGestor().getCodigo());
					if (gd != null) {
						return gd.getUsuario();
					}
				}
				if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
						.equals(getCodigoTipoEntidad())) {
					GestorDespacho gd = getGestorAsunto(getAsunto(), st
							.getTipoGestor().getCodigo());
					if (gd != null) {
						return gd.getUsuario();
					}
				}

			}
		}
		return null;
	}

	private Usuario getNuevoSupervisor() {
		if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
			if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
					.equals(getCodigoTipoEntidad())) {
				GestorDespacho gd = getGestorAsunto(getProcedimiento()
						.getAsunto(),
						EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
				if (gd != null) {
					return gd.getUsuario();
				}
			}
			if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
					.equals(getCodigoTipoEntidad())) {
				GestorDespacho gd = getGestorAsunto(getAsunto(),
						EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
				if (gd != null) {
					return gd.getUsuario();
				}
			}
		}
		return null;
	}

	private String calcularSupervisorExpedienteEXT() {
		Perfil perfil = null;
		if (DDEstadoItinerario.ESTADO_DECISION_COMIT
				.equals(getCodigoEstadoItinerarioExpediente())) {
			if (getExpediente().getComite() != null) {
				perfil = getExpediente().getComite().getPerfiles().get(0);
			}
		} else {
			perfil = getExpediente().getArquetipo().getItinerario()
					.getEstado(getCodigoEstadoItinerarioExpediente())
					.getSupervisor();
		}

		if (perfil == null) {
			return "";
		}
		return perfil.getDescripcion();
	}

	private GestorDespacho getGestorAsunto(Asunto asunto, String codigoGestor) {
		if (asunto == null) {
			return null;
		}
		try {
			if (Hibernate.getClass(asunto).equals(EXTAsunto.class)) {
				HibernateProxy proxy = (HibernateProxy) asunto;
				GestorDespacho gd = ((EXTAsunto) proxy.writeReplace())
						.getGestor(codigoGestor);
				if (gd != null) {
					return gd;
				} else {
					return null;
				}
			} else {
				return null;
			}
		} catch (Exception e) {
			GestorDespacho gd = ((EXTAsunto) asunto).getGestor(codigoGestor);
			if (gd != null) {
				return gd;
			} else {
				return null;
			}
		}
	}

	/**
     * retorna la situacion de la entidad de la tarea.
     * @return situacion
     */
	@Override
    public String getSituacionEntidad() {
        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(getTipoEntidad().getCodigo())) { return getExpediente().getEstadoItinerario().getDescripcion(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getTipoEntidad().getCodigo())) { return getAsunto().getEstadoItinerario().getDescripcion(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getTipoEntidad().getCodigo())) {
            if (getCliente() != null) { return getCliente().getEstadoItinerario().getDescripcion(); }
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO.equals(getTipoEntidad().getCodigo())) { return getObjetivo().getEstadoCumplimiento().getDescripcion(); }
        if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(getTipoEntidad().getCodigo())){ 
        	if(getProcedimiento().getEstadoProcedimiento() != null)
        		return getProcedimiento().getEstadoProcedimiento().getDescripcion();
        	}
        return "";
    }
	
	@Override
	public String getCodigo() {
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getCodigoTipoEntidad())) {
			if (getCliente() != null) {
				return getCliente().getPersona().getCodClienteEntidad()
						.toString();
			}
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
				.equals(getCodigoTipoEntidad())) {
			return getExpediente().getId().toString();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
				.equals(getCodigoTipoEntidad())) {
			return getAsunto().getId().toString();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
				.equals(getCodigoTipoEntidad())) {
			return getProcedimiento().getId().toString();
		} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO
				.equals(getCodigoTipoEntidad())) {
			return getContrato().getId().toString();
		}
		return "";
	}

	@Override
	public Long getIdEntidad() {
		if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO
				.equals(getCodigoTipoEntidad())) {
			return getContrato().getId();
		}
		if ("9".equals(getCodigoTipoEntidad())) {
			if (getPersona() != null) {
				return getPersona().getId();
			}
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO
				.equals(getCodigoTipoEntidad())) {
			return getObjetivo().getId();
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getCodigoTipoEntidad())) {
			return getAsunto().getId();
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
				.equals(getCodigoTipoEntidad())) {
			return getProcedimiento().getId();
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_TAREA.equals(getCodigoTipoEntidad())) {
			return getTareaId().getId();
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getCodigoTipoEntidad())) {
			if (getCliente() != null) {
				return getCliente().getId();
			}
		} else {
			if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
					.equals(getCodigoTipoEntidad())) {
				if (getExpediente() != null) {
					return getExpediente().getId();
				}
			}
		}
		return null;
	}

	public Float getVolumenRiesgoSQL() {
		Float vr = volumenRiesgoSQL;

		return vr;
	}

	public String getTipoSolicitudSQL() {
		// TODO Cuando se habilite el telecobro a�adir las tareas pertinentes
		// TODO i18n

		return tipoSolicitudSQL;
	}

	public Integer getDiasVencidoSQL() {
		return diasVencidoSQL;
	}

	public void setTipoDestinatario(String tipoDestinatario) {
		this.tipoDestinatario = tipoDestinatario;
	}

	public String getTipoDestinatario() {
		return tipoDestinatario;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Contrato getContrato() {
		return contrato;
	}

	private Usuario getGestorContrato(Contrato contrato, String codigoGestor) {
		if (contrato == null) {
			return null;
		}
		try {
			if (Hibernate.getClass(contrato).equals(EXTContrato.class)) {
				HibernateProxy proxy = (HibernateProxy) contrato;
				Usuario u = ((EXTContrato) proxy.writeReplace())
						.getGestor(codigoGestor);
				if (u != null) {
					return u;
				} else {
					return null;
				}
			} else {
				return null;
			}
		} catch (Exception e) {
			return null;
		}
	}

	public Long getGestorContrato() {
		if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
			EXTSubtipoTarea st = (EXTSubtipoTarea) this.getSubtipoTarea();
			if (st.getTipoGestor() != null) {
				Usuario usu = getGestorContrato(getContrato(), st
						.getTipoGestor().getCodigo());

				if (usu != null)
					return usu.getId();
				else
					return null;
			}

		}
		return null;
	}

	public String getGestorContratoDescripcion() {
		if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
			EXTSubtipoTarea st = (EXTSubtipoTarea) this.getSubtipoTarea();
			if (st.getTipoGestor() != null) {
				Usuario usu = getGestorContrato(getContrato(), st
						.getTipoGestor().getCodigo());

				if (usu != null)
					return usu.getApellidoNombre();
				else
					return "";
			} else
				return "";

		}
		return null;
	}

	public Long getSupervisorContrato() {
		if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
			Usuario usu = getGestorContrato(getContrato(), "SUPC");

			if (usu != null)
				return usu.getId();
			else
				return null;

		}
		return null;
	}

	public String getSupervisorContratoDescripcion() {
		if (this.getSubtipoTarea() instanceof EXTSubtipoTarea) {
			Usuario usu = getGestorContrato(getContrato(), "SUPC");

			if (usu != null)
				return usu.getApellidoNombre();
			else
				return "";

		}
		return null;
	}

	public Usuario getDestinatarioTarea() {
		return destinatarioTarea;
	}

	public void setDestinatarioTarea(Usuario destinatarioTarea) {
		this.destinatarioTarea = destinatarioTarea;
	}

	/**
	 * Este m�todo nos devuelve el c�digo del tipo de entidad controlando que no
	 * se nos produzca un NullPointerException
	 * 
	 * @return
	 */
	private String getCodigoTipoEntidad() {
		if (getTipoEntidad() == null)
			return null;
		return getTipoEntidad().getCodigo();
	}

	/**
	 * Este m�todo nos devuelve el ApellidoNombre del supervisor de un asunto
	 * controlando que no se nos produzca un NullPointerException
	 * 
	 * @param asunto
	 * @return Devuelve una cadena vac�a "" si no puede encontrar el
	 *         apellidonombre del supervisor
	 */
	private String getApellidoNombreSupervisor(Asunto asunto) {
		if (asunto == null)
			return "";
		if (asunto.getSupervisor() == null)
			return "";
		if (asunto.getSupervisor().getUsuario() == null)
			return "";
		String an = asunto.getSupervisor().getUsuario().getApellidoNombre();
		return an != null ? an : "";
	}

	/**
	 * Este m�todo nos devuelve el id del supervisor de un asunto controlando
	 * que no se nos produzca un NullPointerException
	 * 
	 * @param asunto
	 * @return
	 */
	private Long getIdSupervisor(Asunto asunto) {
		if (asunto == null)
			return null;
		if (asunto.getSupervisor() == null)
			return null;
		if (asunto.getSupervisor().getUsuario() == null)
			return null;
		return asunto.getSupervisor().getUsuario().getId();
	}

	/**
	 * Este m�todo nos devuelve el id del gestor de un asunto controlando que no
	 * se nos produzca un NullPointerException
	 * 
	 * @param asunto
	 * @return
	 */
	private Long getIdGestor(Asunto asunto) {
		if (asunto == null)
			return null;
		if (asunto.getGestor() == null)
			return null;
		if (asunto.getGestor().getUsuario() == null)
			return null;
		return asunto.getGestor().getUsuario().getId();
	}

	/**
	 * devuelve el supervisor.
	 * 
	 * Este m�todo sustituye al m�todo de la clase padre que es susceptible de
	 * dar un NullPointerException
	 * 
	 * @return supervisor
	 */
	private Long getSupervisor_super() {
		Perfil perfil = null;
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
				.equals(getCodigoTipoEntidad())) {
			return getIdSupervisor(getProcedimiento().getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getCodigoTipoEntidad())) {
			return getIdSupervisor(getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
				.equals(getCodigoTipoEntidad())) {
			if (getExpediente() != null) {
				perfil = getExpediente().getArquetipo().getItinerario()
						.getEstado(getCodigoEstadoItinerario(getExpediente()))
						.getSupervisor();
			}
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getCodigoTipoEntidad())) {
			if (getCliente() != null) {
				perfil = getCliente().getArquetipo().getItinerario()
						.getEstado(getCodigoEstadoItinerario(getCliente()))
						.getSupervisor();
			}
		}
		if (perfil != null) {
			return perfil.getId();
		}
		return null;
	}

	/**
	 * devuelve el gestor.
	 * 
	 * Este m�todo sustituye al m�todo de la clase padre que es susceptible de
	 * dar un NullPointerException
	 * 
	 * @return gestor
	 */
	public Long getGestor_super() {
		Perfil perfil = null;
		if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
				.equals(getCodigoTipoEntidad())) {
			return getIdGestor(getProcedimiento().getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(getCodigoTipoEntidad())) {
			return getIdGestor(getAsunto());
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
				.equals(getCodigoTipoEntidad())) {
			if (getExpediente() != null) {
				perfil = getExpediente().getArquetipo().getItinerario()
						.getEstado(getCodigoEstadoItinerario(getExpediente()))
						.getGestorPerfil();
			}
		}
		if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(getCodigoTipoEntidad())) {
			if (getCliente() != null) {
				perfil = getCliente().getArquetipo().getItinerario()
						.getEstado(getCodigoEstadoItinerario(getCliente()))
						.getGestorPerfil();
			}
		}
		if (perfil != null) {
			return perfil.getId();
		}
		return null;
	}

	/**
	 * Nos devuelve el c�digo del estado del itinerario del expediente
	 * controlando que en ning�n momento se produzca un NullPointerException
	 * 
	 * @return
	 */
	private String getCodigoEstadoItinerarioExpediente() {
		return getCodigoEstadoItinerario(getExpediente());
	}

	/**
	 * Nos devuelve el c�digo del estado del itinerario de un cliente procurando
	 * no dar un NullPointerException
	 * 
	 * @param expediente
	 * @return
	 */
	private String getCodigoEstadoItinerario(Cliente cliente) {
		if (cliente == null)
			return null;
		if (cliente.getEstadoItinerario() == null)
			return null;
		return cliente.getEstadoItinerario().getCodigo();
	}

	/**
	 * Nos devuelve el c�digo del estado del itinerario de un expediente
	 * procurando no dar un NullPointerException
	 * 
	 * @param expediente
	 * @return
	 */
	private String getCodigoEstadoItinerario(Expediente expediente) {
		if (expediente == null)
			return null;
		if (expediente.getEstadoItinerario() == null)
			return null;
		return expediente.getEstadoItinerario().getCodigo();
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Persona getPersona() {
		return persona;
	}

	@Transient
	public static EXTTareaNotificacion instanceOf(TareaNotificacion tareaNotificacion) {
		EXTTareaNotificacion extTareaNotif = null;
		if (tareaNotificacion==null) return null;
	    if (tareaNotificacion instanceof HibernateProxy) {
	    	extTareaNotif = (EXTTareaNotificacion) ((HibernateProxy) tareaNotificacion).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (tareaNotificacion instanceof EXTTareaNotificacion){
	    	extTareaNotif = (EXTTareaNotificacion) tareaNotificacion;
		}
		return extTareaNotif;
	}
	
}
