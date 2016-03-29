package es.capgemini.pfs.contrato.dao.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.dao.EXTContratoDao;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.contrato.dto.DtoBuscarContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDSituacionGestion;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.api.contrato.dto.EXTBusquedaContratosDto;

@Repository
public class EXTContratoDaoImpl extends AbstractEntityDao<Contrato, Long>
		implements EXTContratoDao {

	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Resource
	private Properties appProperties;

	@Resource
	private PaginationManager paginationManager;
	/*
	 * Las siguientes variables tienen como propósito hacer este DAO flexible en
	 * el sentido de que, mediante una cierta configuración en devon.properties,
	 * podamos adaptar la búsqueda de contratos con distintas estrategias de
	 * optimización
	 * 
	 * Estas variables no se acceden directamente, sino que tienen asociado un
	 * determinado método. Estas variables sólo cachean el valor a devolver por
	 * dicho método de modo que no tengamos que consultar devon.properties cada
	 * vez.
	 */

	// Flag para propósito de testeo. True significa que usamos variables para
	// el paso de parámetros a Oracle, false que usamos constantes. Esta
	// variable no se accede directamente, sino a través del método
	// pasoDeVariables()
	private Boolean pasoVariables;

	// Variable para cachear el nombre del campo en el que se persiste el NIF
	// del contrato. El valor se obtiene usando el método getCampoDeBusqueda().
	//
	// Esta variable tiene propósitos de testeo
	private String campoNif;

	// Variable para cachear si queremos usar la optimización del like para
	// cuando buscamos por el código del contrato.
	//
	// Esta variable se accede mediante el método queremosOptimizarLike()
	//
	// Esta variable sólo tiene propósito de testeo
	private Boolean optimizacionLike;

	@Override
	public Page buscarContratosPaginados(BusquedaContratosDto dto,
			Usuario usuLogado) {

		final HashMap<String, Object> params = new HashMap<String, Object>();

		final String query = generarHQLBuscarContratosPaginados(dto, usuLogado,
				params);

		try {
			if (pasoDeVariables()) {
				return paginationManager.getHibernatePage(
						getHibernateTemplate(), query, dto, params);
			} else {
				return paginationManager.getHibernatePage(
						getHibernateTemplate(), query, dto);
			}

		} catch (RuntimeException rte) {
			// Sólo para debug
			throw rte;
		}
	}

	/**
	 * Genera la query HQL para la b�squeda de contratos.
	 * 
	 * @param dto
	 *            BusquedaContratosDto: con los par�metros de b�squeda
	 * 
	 * @param params
	 *            Parámetros que necesita esta query para ser ejecutada. El
	 *            método añade al mapa los parámetros que necesita según va
	 *            construyendo el select
	 * @return String
	 * 
	 */
	private String generarHQLBuscarContratosPaginados(BusquedaContratosDto dto,
			Usuario usuLogado, Map<String, Object> params) {
		StringBuffer hql = new StringBuffer();

		final boolean cruzaMovimientos = (dto.existenCamposMinMaxCargados()) ; //|| dto.isInclusion());
		final boolean cruzaPersonas = ((dto.getNombre() != null && dto
				.getNombre().trim().length() > 0)
				|| (dto.getApellido1() != null && dto.getApellido1().trim()
						.length() > 0)
				|| (dto.getApellido2() != null && dto.getApellido2().trim()
						.length() > 0) || (dto.getDocumento() != null && dto
				.getDocumento().trim().length() > 0) || dto.getSituacionGestion() != null);
		final boolean cruzaExpediente = (dto.getDescripcionExpediente() != null && dto
				.getDescripcionExpediente().trim().length() > 0);
		final boolean cruzaAsuntos = ((dto.getNombreAsunto() != null && dto
				.getNombreAsunto().trim().length() > 0) || usuLogado
				.getUsuarioExterno());

		// flag para el paso de variables a Oracle
		final boolean flagVariables = pasoDeVariables();

		hql.append("from Contrato c ");

		// LAS TABLAS QUE NECESITO
		if (flagVariables) {
			hql.append(" where 1 = :one ");
			params.put("one", 1);
		} else {
			hql.append(" where 1 = 1 ");
		}

		// *** LOS CRUCES CON LAS TABLAS ***

		if (cruzaMovimientos) {
			hql.append(" AND EXISTS (SELECT 1 FROM Movimiento mov WHERE mov.contrato = c");
			hql.append(" AND mov.fechaExtraccion = c.fechaExtraccion"); // selec.
																		// de
																		// �ltim.
																		// mov.
			if (dto.getMaxVolRiesgoVencido() != null
					&& dto.getMaxVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMaxVolRiesgoVencido();
				hql.append(" AND mov.posVivaVencida <= " + valor + " ");
			}

			if (dto.getMinVolRiesgoVencido() != null
					&& dto.getMinVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMinVolRiesgoVencido();
				hql.append(" AND mov.posVivaVencida >= " + valor + " ");
			}
			String maxVolTotalRiesgo = null;
			String minVolTotalRiesgo = null;
			if (dto.getMaxVolTotalRiesgo() != null
					&& dto.getMaxVolTotalRiesgo().trim().length() > 0) {
				maxVolTotalRiesgo = dto.getMaxVolTotalRiesgo();
			}
			if (dto.getMinVolTotalRiesgo() != null
					&& dto.getMinVolTotalRiesgo().trim().length() > 0) {
				minVolTotalRiesgo = dto.getMinVolTotalRiesgo();
			}
			if (dto.getTieneRiesgo() != null && !dto.getTieneRiesgo()) {
				maxVolTotalRiesgo = "0";
				minVolTotalRiesgo = "0";
			}
			if (minVolTotalRiesgo != null) {
				hql.append(" AND mov.riesgo >= " + minVolTotalRiesgo + " ");
			}
			if (maxVolTotalRiesgo != null) {
				hql.append(" AND mov.riesgo <= " + maxVolTotalRiesgo + " ");
			}
			if (dto.getMinDiasVencidos() != null
					&& dto.getMinDiasVencidos().trim().length() > 0) {
				hql.append(" AND FLOOR(SYSDATE-mov.fechaPosVencida) >= "
						+ dto.getMinDiasVencidos() + " ");
			}
			if (dto.getMaxDiasVencidos() != null
					&& dto.getMaxDiasVencidos().trim().length() > 0) {
				hql.append(" AND FLOOR(SYSDATE-mov.fechaPosVencida) <= "
						+ dto.getMaxDiasVencidos() + " ");
			}
			
			hql.append(")");
		}
		
		if (cruzaPersonas) {
			hql.append(" AND EXISTS (SELECT 1 FROM Persona p, ContratoPersona cp WHERE cp.persona = p and cp.contrato = c ");
			
			// Nombre
			if (dto.getNombre() != null && dto.getNombre().trim().length() > 0) {
				hql.append(" and upper(p.nombre) like '%"
						+ dto.getNombre().trim().toUpperCase() + "%'");
			}
			
			// Apellido1
			if (dto.getApellido1() != null
					&& dto.getApellido1().trim().length() > 0) {
				hql.append(" and upper(p.apellido1) like '%"
						+ dto.getApellido1().trim().toUpperCase() + "%'");
			}
			// Apellido2
			if (dto.getApellido2() != null
					&& dto.getApellido2().trim().length() > 0) {
				hql.append(" and upper(p.apellido2) like '%"
						+ dto.getApellido2().trim().toUpperCase() + "%'");
			}
			// DNI
			if (dto.getDocumento() != null
					&& dto.getDocumento().trim().length() > 0) {
				hql.append(" and upper(p.docId) like '%"
						+ dto.getDocumento().toUpperCase() + "%'");
			}

			if(!Checks.esNulo(dto.getSituacionGestion())){
				//TODO pasar el codigo de tio de intervencion en el dto y obtenido por proyectContext dependiendo de la entidad
				DDSituacionGestion situacion = (DDSituacionGestion) diccionarioApi.dameValorDiccionarioByCod(DDSituacionGestion.class, dto.getSituacionGestion());
				DDTipoIntervencion intervencion = (DDTipoIntervencion) diccionarioApi.dameValorDiccionarioByCod(DDTipoIntervencion.class, "01");
				if(intervencion == null){
					intervencion = (DDTipoIntervencion) diccionarioApi.dameValorDiccionarioByCod(DDTipoIntervencion.class, "10");
				}
				if(situacion != null && intervencion != null){
					hql.append(" AND EXISTS (SELECT 1 FROM PersonaFormulas pf WHERE cp.persona.id = pf.id ");
					if(situacion.getCodigo() == "SING"){
						hql.append(" and pf.situacion not in ('En Asunto', 'Normal','En Expediente','En Asunto/En Expediente')");
					}else{
						hql.append(" and pf.situacion = '" + situacion.getDescripcion() + "'");
					}
					hql.append(" and cp.tipoIntervencion = '" + intervencion.getId() + "') ");
				}
			}

			hql.append(")");
		}
		if (cruzaExpediente || cruzaAsuntos) {
                        //hql.append(" and cex.auditoria.borrado = 0 ");
			hql.append(" and EXISTS (SELECT 1 FROM Expediente e, ExpedienteContrato cex WHERE cex.contrato = c and cex.expediente = e ");
			
			// Nombre del Expediente
			if (dto.getDescripcionExpediente() != null
					&& dto.getDescripcionExpediente().trim().length() > 0) {
				hql.append(" and UPPER(e.descripcionExpediente) like '%"
						+ dto.getDescripcionExpediente().toUpperCase() + "%' ");
			}
			
			if (cruzaAsuntos) {
                //hql.append(" and asu.auditoria.borrado = 0 ");
				hql.append(" AND EXISTS (SELECT 1 FROM Asunto asu WHERE asu.expediente = e ");
				
				// Nombre del Asunto
				if (dto.getNombreAsunto() != null
						&& dto.getNombreAsunto().trim().length() > 0) {
					hql.append(" and UPPER(asu.nombre) like '%"
							+ dto.getNombreAsunto().toUpperCase()
							+ "%' and cex.sinActuacion = 0 ");
					hql.append(" and asu.estadoAsunto.codigo NOT IN ("
							+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
							+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
				}
				// Usuario externo, muestra solo los contratos que est�n en sus asuntos
				if (usuLogado.getUsuarioExterno()) {
					hql.append(hqlFiltroEsGestorAsunto(usuLogado)
							+ " and cex.sinActuacion = 0 ");
					hql.append(" and asu.estadoAsunto.codigo NOT IN ("
							+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
							+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
				}
				
				hql.append(")");
			}

			hql.append(")");
		}
		
		// Numero de contrato
		if (dto.getNroContrato() != null
				&& dto.getNroContrato().trim().length() > 0) {
			hql.append(this.createHQLNroContrato(dto.getNroContrato(), params));
		}
		
		// codigo de efecto
		if (!Checks.esNulo(dto.getCodEfecto())) {
			hql.append(" AND EXISTS (SELECT 1 FROM EfectoContrato efecto WHERE c = efecto.contrato AND  efecto.codigoEfecto like '%" + dto.getCodEfecto()
					+ "%')");
		}
		// codigo de disposicion
		if (!Checks.esNulo(dto.getCodDisposicion())) {
			hql.append(" AND EXISTS (SELECT 1 FROM Disposicion disp WHERE c = disp.contrato AND disp.codigoDisposicion like '%"
					+ dto.getCodDisposicion() + "%'))");
		}
		// codigo de recibo
		if (!Checks.esNulo(dto.getCodRecibo())) {
			hql.append(" AND EXISTS (SELECT 1 FROM Recibo recibo WHERE c = recibo.contrato AND recibo.codigoRecibo like '%" + dto.getCodRecibo()
					+ "%'))");
		}

		// Estado del contrato
		if (dto.getEstadosContrato() != null
				&& dto.getEstadosContrato().size() > 0) {
			addFiltroEstadoContrato(dto, hql, params);
		}
		
		// Estado financiero
		if (dto.getEstadosFinancieros() != null
				&& dto.getEstadosFinancieros().size() > 0) {
			hql.append(" AND EXISTS (SELECT 1 FROM DDEstadoFinanciero ef WHERE c.estadoFinanciero = ef AND ef.codigo IN (");
			for (Iterator<String> it = dto.getEstadosFinancieros().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}
			hql.append("))");
		}
		// Tipo de producto
		if (dto.getTiposProducto() != null
				&& !dto.getTiposProducto().equals("")) {
			hql.append(" AND EXISTS (SELECT 1 FROM DDTipoProducto tp WHERE c.tipoProducto = tp AND tp.codigo in ("
					+ dto.getTiposProducto() + "))");
		}
		// Tipo de producto entidad
		if (dto.getTiposProductoEntidad() != null
				&& !dto.getTiposProductoEntidad().equals("")) {
			hql.append(" AND EXISTS (SELECT 1 FROM DDTipoProductoEntidad tpe WHERE c.tipoProductoEntidad = tpe AND tpe.codigo in ("
					+ dto.getTiposProductoEntidad() + "))");
		}

		if (dto.getMotivoGestionHRE() != null
				&& !dto.getMotivoGestionHRE().equals("")) {
			hql.append(" AND EXISTS ( SELECT 1 FROM DDCondicionesRemuneracion cre WHERE c.RemuneracionEspecial = cre AND cre.codigo in ('"
					+ dto.getMotivoGestionHRE() + "'))");
		}

		if (!Checks.esNulo(dto.getCodigoZonaAdm())) {
			 
			 String[] codigosZona = StringUtils.split(dto.getCodigoZonaAdm(), ",");
			 int cantZonas = codigosZona.length; 
			 if (cantZonas > 0) { 
				 hql.append(" and ( "); 
				 for (int i = 0; i < codigosZona.length; i++) { 
					 String codigoZ = codigosZona[i]; 
					 hql.append(" c.oficinaAdministrativa.zona.codigo like '" + codigoZ + "%'"); 
					 if (i < codigosZona.length - 1) { 
						 hql.append(" OR"); 
					 } 
				 } 
		 			
				 // SE PONE ESTE FILTRO AQU�, DEBIDO A QUE PARA VISUALIZAR EL 
				 // CONTRATO, PUEDE O BIEN PERTENECER A LA ZONA 
				 // DEL USUARIO LOGEADO, O QUE ESTE SEA GESTOR DEL CONTRATO 
				 hql.append(" or c.id in (");
				 hql.append(generaFiltroContratosPorGestor(usuLogado, params));
				 hql.append(")"); 
				 hql.append(" ) "); 
			 } 
		} 

		if (dto.getCodigosZona() != null && dto.getCodigosZona().size() > 0) {
			int cantZonas = dto.getCodigosZona().size(); 
			if (cantZonas > 0) {
				hql.append(" and ( "); 
				for (Iterator<String> it = dto.getCodigosZona().iterator(); it .hasNext();) { 
					String codigoZ = it.next();
					hql.append(" c.oficinaContable.zona.codigo like '" + codigoZ + "%'");
	  
					if (it.hasNext()) { 
						hql.append(" OR"); 
					} 
				} 
					
				// SE PONE ESTE FILTRO AQU�, DEBIDO A QUE PARA VISUALIZAR EL 
				// CONTRATO, PUEDE O BIEN PERTENECER A LA ZONA 
				// DEL USUARIO LOGEADO, O QUE ESTE SEA GESTOR DEL CONTRATO 
				hql.append(" or c.id in (");
				hql.append(generaFiltroContratosPorGestor(usuLogado, params));
				hql.append(")"); 
				hql.append(" ) "); 
			} 
		} 
		else {
			// EN CASO DE QUE NO TENGA ZONAS ASIGNADAS Y SEA GESTOR DEL // CONTRATO // DEBE PODER SEGUIR VISUALIZANDO EL CONTRATO 
			hql.append(" and c.id in ( ");
			hql.append(generaFiltroContratosPorGestor(usuLogado, params));
			hql.append(" ) "); 
		}

		return hql.toString();
	}

	/***
	 * Devuelve un hql utilizado como subconsulta para obtener los contratos del
	 * que el usuario es gestor
	 * 
	 * @param usuLogado
	 *            Usuario logueado que ha realizado la busqueda
	 * 
	 * @param params
	 *            Mapa en dónde poner los parámetros que se necesitan
	 * 
	 * @return hql con la busqueda del contrato por gestor
	 * 
	 * */
	private String generaFiltroContratosPorGestor(Usuario usuLogado,
			Map<String, Object> params) {
		StringBuffer hql = new StringBuffer();

		hql.append(" select cnt.id from Contrato cnt , EXTGestorEntidad ge ");

		if (pasoDeVariables()) {

			hql.append(" where cnt.id = ge.unidadGestionId and ge.tipoEntidad.codigo = :tipo_entidad_contrato ");
			hql.append(" and ge.gestor.id = :usuario_logado ");

			params.put("tipo_entidad_contrato",
					DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO);
			params.put("usuario_logado", usuLogado.getId());

		} else {
			hql.append(" where cnt.id = ge.unidadGestionId and ge.tipoEntidad.codigo = '"
					+ DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO + "' ");
			hql.append(" and ge.gestor.id = " + usuLogado.getId() + " ");
		}

		return hql.toString();
	}

	/**
	 * Devuelve un HQL con los contratos existentes en los procedimientos en
	 * curso.
	 * 
	 * @param columnaRelacion
	 *            Si se le pasa este parametro (!= null) comparar� solamente los
	 *            contrato.id que relacionen con el parametro
	 * @return
	 */
	private String getHqlContratosEnProcedimientos(String columnaRelacion) {
		StringBuilder hql = new StringBuilder();

		hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, ProcedimientoContratoExpediente pce, Procedimiento prc ");
		hql.append("WHERE cex.id = pce.expedienteContrato ");
		hql.append("and pce.procedimiento = prc.id ");
		hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION
				+ " and prc.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
		hql.append("and prc.estadoProcedimiento.codigo IN ('"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_PROPUESTO + "', '"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CONFIRMADO
				+ "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO
				+ "', '" + DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
				+ "', '"
				+ DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_EN_CONFORMACION
				+ "') ");

		if (columnaRelacion != null) {
			hql.append("and cex.contrato.id = ").append(columnaRelacion);
		}
		return hql.toString();
	}

	/**
	 * Devuelve un HQL con los contratos existentes en los expedientes en curso.
	 * 
	 * @param columnaRelacion
	 *            Si se le pasa este parametro (!= null) comparar� solamente los
	 *            contrato.id que relacionen con el parametro
	 * @return
	 */
	private String getHqlContratosEnExpedientes(String columnaRelacion) {
		StringBuilder hql = new StringBuilder();

		hql.append("SELECT DISTINCT cex.contrato.id FROM ExpedienteContrato cex, Expediente exp  ");
		hql.append("WHERE exp.id = cex.expediente.id ");
		hql.append("and cex.auditoria." + Auditoria.UNDELETED_RESTICTION + " ");
		hql.append("and exp.estadoExpediente.codigo IN ('"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO + "', '"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO + "', '"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO + "') ");

		if (columnaRelacion != null) {
			hql.append("and cex.contrato.id = ").append(columnaRelacion);
		}

		return hql.toString();
	}

	private String hqlFiltroEsGestorAsunto(Usuario usuLogado) {
//		String monogestor = "(asu.id in (select a.id from Asunto a where a.gestor.usuario.id = "
//				+ usuLogado.getId() + "))";
//		String multigestor = "(asu.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "
//				+ +usuLogado.getId() + "))";
//		return "and (" + monogestor + " or " + multigestor + ")";
		String monogestor = "(EXISTS (select 1 from Asunto a where a.id = asu.id and a.gestor.usuario.id = "
				+ usuLogado.getId() + "))";
		String multigestor = "(EXISTS (select 1 from EXTGestorAdicionalAsunto gaa where gaa.asunto.id = asu.id and gaa.gestor.usuario.id = "
				+ +usuLogado.getId() + "))";
		return "and (" + monogestor + " or " + multigestor + ")";

	}

	/**
	 * {@inheritDoc}
	 */
	public Page buscarContratosCliente(DtoBuscarContrato dto) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		StringBuffer hql = new StringBuffer();
		hql.append("select cp.contrato from ");
		hql.append(" ContratoPersona cp, Movimiento m");
		hql.append(" where cp.persona.id = " + dto.getIdPersona());
		/*
		 * hql.append(" where cp.persona.id = :persona"); param.put("persona",
		 * dto.getIdPersona());
		 */
		hql.append(" and cp.auditoria.borrado = false ");
		hql.append(" and cp.contrato.id = m.contrato.id");
		hql.append(" and cp.contrato.fechaExtraccion = m.fechaExtraccion");

		switch (dto.getTipoBusquedaPersona()) {
		case 0:
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and ((m.riesgo is NULL) or (m.riesgo > 0))");
			break;
		case 1:
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo = 0");

			break;
		case 2:
			hql.append(" and cp.tipoIntervencion.titular = false");
			hql.append(" and ((m.riesgo is NULL) or (m.riesgo > 0))");

			break;
		default:
			break;

		}
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				hql.toString(), dto, param);
	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings({ "rawtypes" })
	public HashMap<String, Object> buscarTotalContratosCliente(
			DtoBuscarContrato dto) {
		StringBuffer hql = new StringBuffer();
		hql.append("select sum(abs(m.posVivaNoVencida)), sum(abs(m.posVivaVencida)), sum(abs(m.saldoPasivo)) from ");
		hql.append(" ContratoPersona cp, Movimiento m");
		hql.append(" where cp.persona.id = ?");
		hql.append(" and cp.auditoria.borrado = false ");
		hql.append(" and cp.contrato.id = m.contrato.id");
		hql.append(" and cp.contrato.fechaExtraccion = m.fechaExtraccion");
		switch (dto.getTipoBusquedaPersona()) {
		case 0:
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and ((m.riesgo is NULL) or (m.riesgo > 0))");
			break;
		case 1:
			hql.append(" and cp.tipoIntervencion.titular= true ");
			hql.append(" and m.riesgo = 0");
			break;
		case 2:
			hql.append(" and cp.tipoIntervencion.titular= false ");
			hql.append(" and ((m.riesgo is NULL) or (m.riesgo > 0))");

			break;
		default:
			break;

		}

		List lista = getHibernateTemplate().find(hql.toString(),
				new Object[] { dto.getIdPersona() });

		Object[] r = (Object[]) lista.get(0);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("posVivaNoVencida", r[0]);
		map.put("posVivaVencida", r[1]);
		map.put("saldoPasivo", r[2]);
		return map;
	}

	/**
	 * PBO: 28/11/12 Se usaba acoplado desde el plugin de UNNIM. Se copia desde
	 * el plugin de UNNIM y se adapta para poder desenchufarlo
	 */
	@Override
	public Page buscarContratosPaginadosAvanzado(EXTBusquedaContratosDto dto,
			Usuario usuLogado) {

		final HashMap<String, Object> parameters = new HashMap<String, Object>();
		;
		final String query = generarHQLBuscarContratosPaginados(null, dto,
				usuLogado, parameters);

		return paginationManager.getHibernatePage(getHibernateTemplate(),
				query, dto);
		// return paginationManager.getHibernatePage(getHibernateTemplate(),
		// query, dto, parameters);
	}

	/**
	 * {@inheritDoc}
	 */
	public int buscarContratosPaginadosCount(EXTBusquedaContratosDto dto,
			Usuario usuLogado) {
		final HashMap<String, Object> parameters = new HashMap<String, Object>();
		

		String hql = createQueryForCount(generarHQLBuscarContratosPaginados(dto,
				usuLogado, parameters));

		return ((Long) getHibernateTemplate().find(hql).get(0)).intValue();
	}

	/**
	 * Genera la query HQL para la b�squeda de contratos.
	 * 
	 * @param dto
	 *            BusquedaContratosDto: con los par�metros de b�squeda
	 * 
	 * @param params
	 *            Parámetros que necesita esta query para ser ejecutada. El
	 *            método añade al mapa los parámetros que necesita según va
	 *            construyendo el select
	 * 
	 * @return String
	 */
	private String generarHQLBuscarContratosPaginados(Long idAsunto,
			EXTBusquedaContratosDto dto, Usuario usuLogado,
			Map<String, Object> params) {
		StringBuffer hql = new StringBuffer();

		boolean cruzaMovimientos = (dto.existenCamposMinMaxCargados() || dto
				.isInclusion());
		boolean cruzaPersonas = ((dto.getNombre() != null && dto.getNombre()
				.trim().length() > 0)
				|| (dto.getApellido1() != null && dto.getApellido1().trim()
						.length() > 0)
				|| (dto.getApellido2() != null && dto.getApellido2().trim()
						.length() > 0) || (dto.getDocumento() != null && dto
				.getDocumento().trim().length() > 0));
		boolean cruzaExpediente = (dto.getDescripcionExpediente() != null && dto
				.getDescripcionExpediente().trim().length() > 0);
		boolean cruzaAsuntos = ((dto.getNombreAsunto() != null && dto
				.getNombreAsunto().trim().length() > 0) || usuLogado
				.getUsuarioExterno());

		if (idAsunto != null) {
			cruzaPersonas = true;
		}

		hql.append("select distinct c ");
		hql.append("from ");

		// LAS TABLAS QUE NECESITO
		hql.append("Contrato c ");

		if (cruzaMovimientos) {
			hql.append(", Movimiento mov");
		}
		if (cruzaPersonas) {
			hql.append(", Persona p, ContratoPersona cp");
		}
		if (cruzaExpediente || cruzaAsuntos) {
			hql.append(", Expediente e, ExpedienteContrato cex");
		}
		if (cruzaAsuntos) {
			hql.append(", Asunto asu");
		}
		hql.append(" where 1=1 ");

		// *** LOS CRUCES CON LAS TABLAS ***

		if (cruzaMovimientos) {
			hql.append(" and mov.contrato = c");
			hql.append(" and mov.fechaExtraccion = c.fechaExtraccion"); // selec.
			// de
			// �ltim.
			// mov.
		}
		if (cruzaPersonas) {
			hql.append(" and cp.persona = p and cp.contrato = c and cp.auditoria.borrado = 0 ");
			hql.append(" and cp.tipoIntervencion.titular = true and cp.orden = 1 ");
		}
		if (cruzaExpediente || cruzaAsuntos) {
			hql.append(" and cex.auditoria.borrado = 0 and cex.contrato = c and cex.expediente = e ");
		}
		if (cruzaAsuntos) {
			hql.append(" and asu.auditoria.borrado = 0 and asu.expediente = e ");
		}

		if (idAsunto != null) {
			hql.append(" and "
					+ createHQLLimitarContratosVisiblesAsunto(idAsunto) + " ");
		}

		// *** LAS CONDICIONES ***
		// En caso de que sea una b�squeda para una inclusi�n de contratos a un
		// expediente (F3_WEB-10)
		if (dto.isInclusion()) {
			String columnaRelacion = "c.id";
			// Que no est� en procedimientos (mirando si son o no cancelados)
			hql.append(" and c.id not in (")
					.append(getHqlContratosEnProcedimientos(columnaRelacion))
					.append(")");
			// Que no est� en expedientes (mirando si son o no cancelados)
			hql.append(" and c.id not in (")
					.append(getHqlContratosEnExpedientes(columnaRelacion))
					.append(")");
			// Que sea activo o pasivo negativo
			hql.append(" and mov.riesgo > 0 ");
		}
		// Numero de contrato
		if (dto.getCodigoEntidadOrigen() != null
				&& dto.getCodigoEntidadOrigen().trim().length() > 0) {
			hql.append(" and 1 = (select 1 from EXTInfoAdicionalContrato iac "
					+ " where c.id = iac.contrato.id and iac.value = '"
					+ dto.getCodigoEntidadOrigen().trim() + "')");
		}
		// Numero de contrato
		if (dto.getNroContrato() != null
				&& dto.getNroContrato().trim().length() > 0) {

			hql.append(this.createHQLNroContrato(dto.getNroContrato(), params));

			// hql.append(" and (c.nroContrato like '%"
			// + dto.getNroContrato().trim().replaceFirst("^0*", "")
			// + "%' or c.nroContrato like '%"
			// + dto.getNroContrato().trim() + "%')");
		}
		// Nombre
		if (dto.getNombre() != null && dto.getNombre().trim().length() > 0) {
			hql.append(" and upper(p.nombre) like '%"
					+ dto.getNombre().trim().toUpperCase() + "%'");
		}
		// Apellido1
		if (dto.getApellido1() != null
				&& dto.getApellido1().trim().length() > 0) {
			hql.append(" and upper(p.apellido1) like '%"
					+ dto.getApellido1().trim().toUpperCase() + "%'");
		}
		// Apellido2
		if (dto.getApellido2() != null
				&& dto.getApellido2().trim().length() > 0) {
			hql.append(" and upper(p.apellido2) like '%"
					+ dto.getApellido2().trim().toUpperCase() + "%'");
		}
		// DNI
		if (dto.getDocumento() != null
				&& dto.getDocumento().trim().length() > 0) {
			hql.append(" and upper(p.docId) like '%"
					+ dto.getDocumento().toUpperCase() + "%'");
		}
		// Nombre del Expediente
		if (dto.getDescripcionExpediente() != null
				&& dto.getDescripcionExpediente().trim().length() > 0) {
			hql.append(" and UPPER(e.descripcionExpediente) like '%"
					+ dto.getDescripcionExpediente().toUpperCase() + "%' ");
			hql.append(" and e.estadoExpediente.codigo NOT IN ("
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO + ", "
					+ DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO + ") ");
		}
		// Nombre del Asunto
		if (dto.getNombreAsunto() != null
				&& dto.getNombreAsunto().trim().length() > 0) {
			hql.append(" and UPPER(asu.nombre) like '%"
					+ dto.getNombreAsunto().toUpperCase()
					+ "%' and cex.sinActuacion = 0 ");
			hql.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}
		// Usuario externo, muestra solo los contratos que est�n en sus asuntos
		if (usuLogado.getUsuarioExterno()) {
			hql.append(hqlFiltroEsGestorAsunto(usuLogado)
					+ " and cex.sinActuacion = 0 ");
			hql.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}
		// Estado del contrato
		if (dto.getEstadosContrato() != null
				&& dto.getEstadosContrato().size() > 0) {
			hql.append(" and c.estadoContrato.codigo IN (");
			for (Iterator<String> it = dto.getEstadosContrato().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}
			hql.append(")");
		}
		// Estado financiero
		if (dto.getEstadosFinancieros() != null
				&& dto.getEstadosFinancieros().size() > 0) {
			hql.append(" and c.estadoFinanciero.codigo IN (");
			for (Iterator<String> it = dto.getEstadosFinancieros().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}
			hql.append(")");
		}
		// Tipo de producto
		if (dto.getTiposProducto() != null
				&& !dto.getTiposProducto().equals("")) {
			hql.append(" and c.tipoProducto.codigo in ("
					+ dto.getTiposProducto() + ")");
		}
		if (cruzaMovimientos) {
			if (dto.getMaxVolRiesgoVencido() != null
					&& dto.getMaxVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMaxVolRiesgoVencido();
				hql.append(" and mov.posVivaVencida <= " + valor + " ");
			}

			if (dto.getMinVolRiesgoVencido() != null
					&& dto.getMinVolRiesgoVencido().trim().length() > 0) {
				String valor = dto.getMinVolRiesgoVencido();
				hql.append(" and mov.posVivaVencida >= " + valor + " ");
			}
			String maxVolTotalRiesgo = null;
			String minVolTotalRiesgo = null;
			if (dto.getMaxVolTotalRiesgo() != null
					&& dto.getMaxVolTotalRiesgo().trim().length() > 0) {
				maxVolTotalRiesgo = dto.getMaxVolTotalRiesgo();
			}
			if (dto.getMinVolTotalRiesgo() != null
					&& dto.getMinVolTotalRiesgo().trim().length() > 0) {
				minVolTotalRiesgo = dto.getMinVolTotalRiesgo();
			}
			if (dto.getTieneRiesgo() != null && !dto.getTieneRiesgo()) {
				maxVolTotalRiesgo = "0";
				minVolTotalRiesgo = "0";
			}
			if (minVolTotalRiesgo != null) {
				hql.append(" and mov.riesgo >= " + minVolTotalRiesgo + " ");
			}
			if (maxVolTotalRiesgo != null) {
				hql.append(" and mov.riesgo <= " + maxVolTotalRiesgo + " ");
			}
			if (dto.getMinDiasVencidos() != null
					&& dto.getMinDiasVencidos().trim().length() > 0) {
				hql.append(" and FLOOR(SYSDATE-mov.fechaPosVencida) >= "
						+ dto.getMinDiasVencidos() + " ");
			}
			if (dto.getMaxDiasVencidos() != null
					&& dto.getMaxDiasVencidos().trim().length() > 0) {
				hql.append(" and FLOOR(SYSDATE-mov.fechaPosVencida) <= "
						+ dto.getMaxDiasVencidos() + " ");
			}
		}
		if (dto.getCodigosZona() != null && dto.getCodigosZona().size() > 0) {
			int cantZonas = dto.getCodigosZona().size();
			if (cantZonas > 0) {
				hql.append(" and ( ");
				for (Iterator<String> it = dto.getCodigosZona().iterator(); it
						.hasNext();) {
					String codigoZ = it.next();
					hql.append(" c.oficina.zona.codigo like '" + codigoZ + "%'");
					if (it.hasNext()) {
						hql.append(" OR");
					}
				}
				// SE PONE ESTE FILTRO AQU�, DEBIDO A QUE PARA VISUALIZAR EL
				// CONTRATO, PUEDE O BIEN PERTENECER A LA ZONA
				// DEL USUARIO LOGEADO, O QUE ESTE SEA GESTOR DEL CONTRATO
				hql.append(" or c.id in (");
				hql.append(generaFiltroContratosPorGestor(usuLogado, params));
				hql.append(")");
				hql.append(" ) ");
			}
		} 
		else {
			// EN CASO DE QUE NO TENGA ZONAS ASIGNADAS Y SEA GESTOR DEL
			// CONTRATO
			// DEBE PODER SEGUIR VISUALIZANDO EL CONTRATO
			hql.append(" and c.id in ( ");
			hql.append(generaFiltroContratosPorGestor(usuLogado, params));
			hql.append(" ) ");
		}
		return hql.toString();
	}

	private String createHQLLimitarContratosVisiblesAsunto(Long idAsunto) {
		StringBuilder sb = new StringBuilder("p.id in (");
		sb.append("select per.id from Persona per join per.contratosPersona cp");
		sb.append(" join cp.contrato cnt join cnt.expedienteContratos ec");
		sb.append(" join ec.expediente exp join exp.asuntos asu ");
		sb.append("where asu.id = " + idAsunto + ")");
		return sb.toString();
	}

	private String createHQLNroContrato(String nroContrato,
			Map<String, Object> params) {
		String cadReturn = "";
		// Si las propiedades están seteadas por la clase
		// SpringContratoConfigurator las comprobamos
		String formatoSubstringStart = null;
		String formatoSubstringEnd = null;
		if (appProperties != null) {
			formatoSubstringStart = appProperties
					.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_INI);
			formatoSubstringEnd = appProperties
					.getProperty(APPConstants.CNT_PROP_FORMAT_SUBST_FIN);
		}

		String campoBusqueda = getCampoDeBusqueda("c.nroContrato");

		if (!Checks.esNulo(formatoSubstringStart)
				|| !Checks.esNulo(formatoSubstringEnd)) {
			formatoSubstringStart = (Checks.esNulo(formatoSubstringStart) || ""
					.equals(formatoSubstringStart)) ? "1" : String
					.valueOf(Integer.parseInt(formatoSubstringStart) + 1);

			formatoSubstringEnd = (Checks.esNulo(formatoSubstringEnd) || ""
					.equals(formatoSubstringEnd)) ? ""
					: ","
							+ String.valueOf((Integer
									.parseInt(formatoSubstringEnd) - Integer
									.parseInt(formatoSubstringStart)) + 1);

			/*
			 * Trasladamos la construcción de la cadena de búsqueda fuera del
			 * IF. Simplificamos la cadena de búsqueda para que sea menos
			 * costosa en Oracle.
			 * 
			 * cadReturn = " and (substr(c.nroContrato," + formatoSubstringStart
			 * + formatoSubstringEnd + ") like '%" +
			 * nroContrato.trim().replaceFirst("^0*", "") + "%'" +
			 * " or substr(c.nroContrato," + formatoSubstringStart +
			 * formatoSubstringEnd + ") like '%" + nroContrato.trim() + "%'" +
			 * " or substr(c.nroContrato," + formatoSubstringStart +
			 * formatoSubstringEnd + ") like '%" + nroContrato.replaceAll(" ",
			 * "").trim() .replaceFirst("^0*", "") + "%' )";
			 */

			campoBusqueda = "substr(" + campoBusqueda + ","
					+ formatoSubstringStart + formatoSubstringEnd + ")";

		} else {
			/*
			 * Trasladamos la construcción de la cadena de búsqueda fuera del
			 * IF. Simplificamos la cadena de búsqueda para que sea menos
			 * costosa en Oracle.
			 * 
			 * cadReturn = " and (c.nroContrato like " + "'%" +
			 * nroContrato.trim().replaceFirst("^0*", "") + "%'" +
			 * " or c.nroContrato like " + "'%" + nroContrato.trim() + "%'" +
			 * " or c.nroContrato like " + "'%" + nroContrato.replaceAll(" ",
			 * "").trim() .replaceFirst("^0*", "") + "%')";
			 */

			/*
			 * cadReturn = " and (c.nroContrato like :ncontrato1" +
			 * " or c.nroContrato like :ncontrato2" +
			 * " or c.nroContrato like :ncontrato3 )";
			 * 
			 * params.put("ncontrato1", "%" +
			 * nroContrato.trim().replaceFirst("^0*", "") + "%");
			 * 
			 * params.put("ncontrato2", "%" + nroContrato.trim() + "%");
			 * 
			 * params.put( "ncontrato3", "%" + nroContrato.replaceAll(" ",
			 * "").trim() .replaceFirst("^0*", "") + "%");
			 */

		}
		if (queremosOptimizarLike()) {
			// Estrategia de LIKE original, con y sin paso de variables
			final String valueToFind = nroContrato.replaceAll(" ", "").trim()
					.replaceFirst("^0*", "");

			if (pasoDeVariables()) {
				cadReturn = " and (" + campoBusqueda + " like :nroContrato1 "
						+ " or " + campoBusqueda + " like :nroContrato2" + ")";

				params.put("nroContrato1", "%" + valueToFind);
				params.put("nroContrato2", valueToFind + "%");

			} else {
				cadReturn = " and (" + campoBusqueda + " like " + "'%"
						+ valueToFind + "' or " + campoBusqueda + " like "
						+ "'" + valueToFind + "%'" + ")";
			}

		} else {
			// Estrategia de LIKE optimizada, con y sin paso de variables
			final String value2f1 = "%"
					+ nroContrato.trim().replaceFirst("^0*", "") + "%";
			final String value2f2 = "%" + nroContrato.trim() + "%";
			final String value2f3 = "%"
					+ nroContrato.replaceAll(" ", "").trim()
							.replaceFirst("^0*", "") + "%";

			if (pasoDeVariables()) {
				cadReturn = " and (" + campoBusqueda + " like :value2f1"
						+ " or " + campoBusqueda + " like :value2f2" + " or "
						+ campoBusqueda + " like :value2f3" + ")";

				params.put("value2f1", value2f1);
				params.put("value2f2", value2f2);
				params.put("value2f3", value2f3);
			} else {
				cadReturn = " and (" + campoBusqueda + " like '" + value2f1
						+ "' or " + campoBusqueda + " like '" + value2f2
						+ "' or " + campoBusqueda + " like '" + value2f3 + "')";
			}
		}
		return cadReturn;
	}

	/**
	 * Este método devuelve el campo de búsqueda especificado en
	 * devon.properties para buscar por NIF
	 * 
	 * @param porDefecto
	 *            Valor por defecto
	 * @return
	 */
	private String getCampoDeBusqueda(final String porDefecto) {
		if (campoNif == null) { // inicialización
			campoNif = appProperties
					.getProperty("test.campobusqueda.contratos.nif");
			if (campoNif == null) {
				campoNif = porDefecto;
			}
		} // fin inicialización
		return campoNif;
	}

	/**
	 * Este método obtiene la configuración de devon.properties sobre si
	 * queremos usar o no paso de variables para las consultas en Oracle. Cachea
	 * el valor en la propiedad pasoVariables
	 * 
	 * @return TRUE Si usamos paso de variables, FALSE si usamos paso de
	 *         constantes
	 */
	private boolean pasoDeVariables() {
		if (pasoVariables == null) { // inicialización
			final String testPasoVar = appProperties
					.getProperty("test.oraclevars.contratos");
			if (testPasoVar == null) {
				// Valor por default
				pasoVariables = Boolean.FALSE;
			} else {
				try {
					final int op = Integer.parseInt(testPasoVar.trim());
					switch (op) {
					case 1:
						pasoVariables = Boolean.FALSE;
						break;
					case 2:
						pasoVariables = Boolean.TRUE;
						break;
					default:
						pasoVariables = Boolean.FALSE;
						break;
					}

				} catch (NumberFormatException nfe) {
					// Usamos el valor por default
					pasoVariables = Boolean.FALSE;
				}
			}
		} // fin inicialización
		return pasoVariables;
	}

	private void addFiltroEstadoContrato(BusquedaContratosDto dto,
			StringBuffer hql, Map<String, Object> params) {
		hql.append(" and EXISTS (SELECT 1 FROM DDEstadoContrato ec WHERE ec = c.estadoContrato AND ec.codigo IN (");
		if (pasoDeVariables() && (params != null)) { // ¿paso de variables?
			hql.append(":listaEstados");
			params.put("listaEstados",
					dto.getEstadosContrato().toArray(new String[] {}));
		} else {
			for (Iterator<String> it = dto.getEstadosContrato().iterator(); it
					.hasNext();) {
				String codigo = it.next();
				hql.append("'" + codigo + "'");
				if (it.hasNext()) {
					hql.append(", ");
				}
			}

		} // fin ¿paso de variables?
		hql.append("))");
	}

	/**
	 * Este método está sólo como propósito de testeo. Nos dice si queremos usar
	 * la optimización del like para buscar por numero contrato o no.
	 * 
	 * @return
	 */
	private boolean queremosOptimizarLike() {
		if (this.optimizacionLike == null) { // inicialización
			final String op = appProperties
					.getProperty("test.like.numcontrato");
			if (op == null) {
				this.optimizacionLike = Boolean.FALSE;
			} else {
				try {
					final int n = Integer.parseInt(op);
					return n == 2;
				} catch (NumberFormatException nfe) {
					this.optimizacionLike = Boolean.FALSE;
				}
			}
		}// fin inicialización
		return this.optimizacionLike;
	}

	
	/**
     * createQueryForCount.
     * @param query query original
     * @return count query
     */
    private String createQueryForCount(String query) {
        StringBuffer queryR = new StringBuffer();
        if (query.toUpperCase().indexOf("SELECT") >= 0) {
            int fromOn = query.toUpperCase().indexOf("FROM");
            queryR.append("select count(*) ").append(query.substring(fromOn));
        } else {
            queryR.append("select count(*) ").append(query);
        }
        return queryR.toString();
    }
}
