package es.pfsgroup.recovery.ext.impl.asunto.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Transient;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;
import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;

@Entity
public class EXTAsunto extends Asunto {

	private static final long serialVersionUID = 2075119525614504409L;
	
	@Transient
	private final Log logger = LogFactory.getLog(getClass());

	@OneToMany(mappedBy = "asunto", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "asu_id")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<EXTGestorAdicionalAsunto> gestoresAsunto;

	@Formula("("
			+ "				Select SUM(m.mov_pos_viva_no_vencida + m.mov_pos_viva_vencida)"
			+ "				from mov_movimientos m"
			+ "				where   (m.cnt_id, ASU_ID) in	"
			+ "						("
			+ "							Select distinct d.cnt_id, a.asu_id "
			+ "							from asu_asuntos a, prc_procedimientos p, prc_cex x, cex_contratos_expediente c, cnt_contratos d, ${master.schema}.dd_epr_estado_procedimiento esp"
			+ "							where a.asu_id = p.asu_id"
			+ "							and   p.prc_id = x.prc_id and x.cex_id = c.cex_id"
			+ "							and   c.cnt_id = d.cnt_id"
			+ "                           and   p.dd_epr_id = esp.dd_epr_id"
			+ "							and   p.borrado = 0 and (esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO
			+ "' or"
			+ "                                                    esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO
			+ "' or"
			+ "                                                    esp.dd_epr_codigo = '"
			+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO + "')"
			+ "						)" + "				and m.mov_fecha_extraccion ="
			+ "						(select MAX(m2.mov_fecha_extraccion)"
			+ "                         from mov_movimientos m2"
			+ "                         where m2.cnt_id = m.cnt_id )" + ")")
	private Double saldoTotalPorContratosSQL;

	/*@Formula("("
			+ " select sum(abs(prc.prc_saldo_recuperacion)) from prc_procedimientos prc "
			+ " where prc.asu_id = ASU_ID  and prc.borrado = 0 "
			+ " and prc.PRC_PRC_ID is null and prc.dd_epr_id not in ( '"
			+ PluginCoreextensionConstantes.ESTADO_PROCEDIMIENTO_REORGANIZADO
			+ "')" + " group by prc.asu_id" + ")")*/
	/*
	@Formula("(SELECT PRO.PRC_SALDO_RECUPERACION FROM " +
			"(SELECT PRC.PRC_ID, PRC.ASU_ID, PRC.PRC_SALDO_RECUPERACION,  ROW_NUMBER() OVER (PARTITION BY PRC.ASU_ID ORDER BY PRC.PRC_ID DESC) ROWNUMBER " +
			"FROM PRC_PROCEDIMIENTOS PRC " + 
			"INNER JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.PRC_ID = PRC.PRC_ID AND TAR.TAR_TAREA_FINALIZADA IS NULL AND TAR.BORRADO = 0 " + 
	        "INNER JOIN TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TEX.TAR_ID AND TEX.BORRADO = 0 " + 
	        "INNER JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAR.BORRADO = 0 " + 
	        "WHERE PRC.BORRADO = 0 AND PRC.ASU_ID = ASU_ID) PRO " +
	        "WHERE PRO.ROWNUMBER = 1)")
	*/
	//private Double importeEstimado;

	/*
	@Formula("(" + _GESTOR_DESPACHO_GEXT + ")")
	private String gestorNombreApellidosSQL;

	@Formula("(" + _GESTOR_DESPACHO_SUP + ")")
	private String supervisorNombreApellidosSQL;

	@Formula("(" + _DESPACHO_EXTERNO + ")")
	private String despachoSQL;
*/
	@Column(name = "ASU_ID_EXTERNO")
	private String codigoExterno;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PAS_ID")
	private DDPropiedadAsunto propiedadAsunto;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_GES_ID")
	private DDGestionAsunto gestionAsunto;

	@Column(name = "SYS_GUID")
	private String guid;

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public String getCodigoExterno() {
		return codigoExterno;
	}

	public void setCodigoExterno(String codigoExterno) {
		this.codigoExterno = codigoExterno;
	}

	public DDPropiedadAsunto getPropiedadAsunto() {
		return propiedadAsunto;
	}

	public void setPropiedadAsunto(DDPropiedadAsunto propiedadAsunto) {
		this.propiedadAsunto = propiedadAsunto;
	}

	public DDGestionAsunto getGestionAsunto() {
		return gestionAsunto;
	}

	public void setGestionAsunto(DDGestionAsunto gestionAsunto) {
		this.gestionAsunto = gestionAsunto;
	}

	public GestorDespacho getGestor(String codigoGestor) {
		if (Checks.estaVacio(gestoresAsunto) || Checks.esNulo(codigoGestor)) {
			return null;
		} else {
			for (EXTGestorAdicionalAsunto gaa : gestoresAsunto) {
				if (codigoGestor.equals(gaa.getTipoGestor().getCodigo())) {
					return gaa.getGestor();
				}
			}
			return null;
		}
	}

	public Map<String, GestorDespacho> getGestoresMap() {
		HashMap<String, GestorDespacho> map = new HashMap<String, GestorDespacho>();
		if (!Checks.estaVacio(gestoresAsunto)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAsunto) {
				map.put(gaa.getTipoGestor().getCodigo(), gaa.getGestor());
			}
		}
		return map;
	}

	public GestorDespacho getGestor() {
		GestorDespacho gd = getGestorPorTipo();
		return gd;
	}

	// JEM:
	// Con esta funci�n se intenta evitar que haya JSON's que haya que
	// modificar por el cambio
	// introducido para ordenar por gestor/Supervisor/Despacho.
	// S�lo se modifica ListadoAsuntosJSON.jsp para que sea compatible entre
	// las diferentes
	// entidades financieras.
	public List<EXTGestorAdicionalAsunto> getGestoresAsunto() {
		// return (!Checks.estaVacio(gestoresAsunto));
		return gestoresAsunto;
	}

	public GestorDespacho getSupervisor() {
		if (super.getSupervisor() != null) {
			return super.getSupervisor();
		} else {
			return this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
		}
	}

	private GestorDespacho getGestorPorTipo() {
		GestorDespacho gd = getSupervisorPorTipo();
//		if (gd == null) {
//			logger.warn("EL ASUNTO " + this.getId()
//					+ " NO TIENE SUPERVISOR ASOCIADO");
//		}

		return gd;
	}

	private GestorDespacho getSupervisorPorTipo() {
		if (super.getGestor() != null) {
			return super.getGestor();
		} else {
			return this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		}
	}

	/**
	 * Devuelve el saldo total del asunto. Se calcula como la sumatoria del
	 * saldo original vencido de cada uno de los contratos asociados a los
	 * distintos procedimientos asociados a este Asunto.
	 * 
	 * @return el saldo total del Asunto
	 */
	public Double getSaldoTotalPorContratos() {
		double saldo = 0;

		ArrayList<ExpedienteContrato> listaExpc = new ArrayList<ExpedienteContrato>();

		saldo = 0;
		for (Procedimiento p : getProcedimientosContables()) {
			for (ExpedienteContrato exc : p.getExpedienteContratos()) {
				if (!listaExpc.contains(exc)) {
					listaExpc.add(exc);
					final Contrato contrato = exc.getContrato();
					if (!Checks.esNulo(contrato)
							&& !Checks.esNulo(contrato.getLastMovimiento())) {
						saldo += contrato.getLastMovimiento()
								.getPosVivaVencida();
						saldo += contrato.getLastMovimiento()
								.getPosVivaNoVencida();
					}
				}
			}
		}
		return saldo;
	}

	public Double getSaldoTotalPorContratosSQL() {

		Double saldo = saldoTotalPorContratosSQL;

		return saldo;
	}

	public String getGestorNombreApellidosSQL() {

		String gest = "";
		
		GestorDespacho gd = this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		if(gd != null) {
			Usuario usuario = gd.getUsuario();
			
			if(usuario != null) {
				gest = StringUtils.trim(usuario.getApellido1()) + "-" + StringUtils.trim(usuario.getApellido2()) + "-" + StringUtils.trim(usuario.getNombre());
			}
		}

		return gest;
	}

	public String getSupervisorNombreApellidosSQL() {

		String sup = "";
		
		GestorDespacho gd = this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
		if(gd != null) {
			Usuario usuario = gd.getUsuario();
		
			if(usuario != null) {
				sup = StringUtils.trim(usuario.getApellido1()) + "-" + StringUtils.trim(usuario.getApellido2()) + "-" + StringUtils.trim(usuario.getNombre());
			}
		}

		return sup;
	}

	public String getDespachoSQL() {

		String desp = "";
		GestorDespacho gd = this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		
		if(gd != null && gd.getDespachoExterno() != null) {
			desp = gd.getDespachoExterno().getDespacho();
		}

		return desp;
	}
	
	public GestorDespacho getGestorCEXP() {
		return this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP);
	}

	public GestorDespacho getSupervisorCEXP() {
		return this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP);
	}

	public GestorDespacho getProcurador() {
		if (super.getProcurador() != null) {
			return super.getProcurador();
		} else {
			return this.getGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR);
		}
	}

	public void setImporteEstimado(Double importeEstimado) {
		//this.importeEstimado = importeEstimado;
	}

	public Double getImporteEstimado() {
		Procedimiento ultimoProc = this.getUltimoProcedimientoConTareas();
		return (ultimoProc!=null) ? ultimoProc.getSaldoRecuperacion().doubleValue() : null;
	}

	/**
	 * Volumen de Riesgo de los procedimientos contenidos en el asunto (suma del
	 * principal del procedimiento).
	 * 
	 * @return Float
	 */
	@Override
	public Float getVolumenRiesgo() {

		Float volumenRiesgo = new Float(0.0f);

		for (Procedimiento p : getProcedimientosContables()) {

			if (p.getSaldoRecuperacion() != null)
				volumenRiesgo += p.getSaldoRecuperacion().floatValue();
		}
		return volumenRiesgo;
	}

	/**
	 * Recupera el último procedimiento del asunto (basado en el ID), considera
	 * el ID más alto como el último.
	 * 
	 * @param asu
	 * @return
	 */
	public Procedimiento getUltimoProcedimiento() {
		Procedimiento ultimoProc = null;
		List<Procedimiento> lista = this.getProcedimientos();
		if (!Checks.estaVacio(lista)) {
			for (Procedimiento prc : lista) {
				if (ultimoProc == null) {
					ultimoProc = prc;
				} else {
					if (prc.getId() > ultimoProc.getId())
						ultimoProc = prc;
				}
			}
		}
		return ultimoProc;
	}
	
	
	/**
	 * Recupera el último procedimiento del asunto (basado en el ID), considera
	 * el ID más alto como el último.
	 * 
	 * @param asu
	 * @return
	 */
	public Procedimiento getUltimoProcedimientoConTareas() {

		// Se obtienen los procedimientos y se ordenan de forma descendente por id
		Comparator<Procedimiento> comparator = new Comparator<Procedimiento>() {
			@Override
			public int compare(Procedimiento o1, Procedimiento o2) {
				return o2.getId().compareTo(o1.getId());
			}
		};
		
		List<Procedimiento> lista = this.getProcedimientos();
		Collections.sort(lista, comparator);		
		
		for (Procedimiento procedimiento : lista) {
			
			//Si tiene alguna tarea notificación no finalizada
			for (TareaNotificacion tarea : procedimiento.getTareas()) {
				if ((Checks.esNulo(tarea.getTareaFinalizada()) || !tarea.getTareaFinalizada()) 
						&& !Checks.esNulo(tarea.getTareaExterna())) {
					//Si tiene tarea_procedimiento
					if (!Checks.esNulo(tarea.getTareaExterna().getTareaProcedimiento())) {
						// Nos quedamos con este procedimiento
						return procedimiento;
					}
				}
			}
		}

		return null;
	}	

	@Transient
	public static EXTAsunto instanceOf(Asunto asunto) {
		EXTAsunto extAsunto = null;
		if (asunto == null)
			return null;
		if (asunto instanceof HibernateProxy) {
			extAsunto = (EXTAsunto) ((HibernateProxy) asunto)
					.getHibernateLazyInitializer().getImplementation();
		} else if (asunto instanceof EXTAsunto) {
			extAsunto = (EXTAsunto) asunto;
		}
		return extAsunto;
	}
}
