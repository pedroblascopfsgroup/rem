package es.pfsgroup.plugin.recovery.coreextension.subasta.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarLotesSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dto.NMBDtoBuscarSubastas;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.impl.utils.StringUtils;

@Repository("SubastaDao")
public class SubastaDaoImpl extends AbstractEntityDao<Subasta, Long> implements
		SubastaDao {

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

	private void setSortSubastas(NMBDtoBuscarSubastas dto) {
		if (dto.getSort() != null) {
			if (dto.getSort().equals("numAutos")) {
				dto.setSort("s.procedimiento.codigoProcedimientoEnJuzgado");
			} else if (dto.getSort().equals("fechaSolicitud")) {
				dto.setSort("s.fechaSolicitud");
			} else if (dto.getSort().equals("fechaAnuncio")) {
				dto.setSort("s.fechaAnuncio");
			} else if (dto.getSort().equals("fechaSenyalamiento")) {
				dto.setSort("s.fechaSenyalamiento");
			} else if (dto.getSort().equals("estadoSubasta")) {
				dto.setSort("s.estadoSubasta.codigo");
			} else if (dto.getSort().equals("tasacion")) {
				dto.setSort("s.tasacion");
			} else if (dto.getSort().equals("embargo")) {
				dto.setSort("s.embargo");
			} else if (dto.getSort().equals("infLetrado")) {
				dto.setSort("s.infoLetrado");
			} else if (dto.getSort().equals("instrucciones")) {
				dto.setSort("s.instrucciones");
			} else if (dto.getSort().equals("subastaRevisada")) {
				dto.setSort("s.subastaRevisada");
			} else if (dto.getSort().equals("cargasAnteriores")) {
				dto.setSort("s.cargasAnteriores");
			} else if (dto.getSort().equals("totalImporteAdjudicado")) {
				dto.setSort("s.totalImporteAdjudicado");
			}
		} else {
			dto.setSort("s.id");
		}
	}

	
	@SuppressWarnings("unchecked")
	public List<Subasta> buscarSubastasExcel(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		// Establece el orden de la búsqueda
		setSortSubastas(dto);
		
		// return paginationManager.getHibernatePage(getHibernateTemplate(),
		// generarHQLBuscarSubastasPaginados(dto,usuLogado), dto);

		Query query = getSession().createQuery(
				generarHQLBuscarSubastasPaginados(dto, usuLogado));
		return (List<Subasta>) query.list();
	}

	public Page buscarSubastasPaginados(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		// Establece el orden de la búsqueda
		setSortSubastas(dto);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarSubastasPaginados(dto, usuLogado), dto);
	}

	private String anyadirApostrofesParaSql(String cadena) {
		String resultado = cadena.replace(",", "','");
		resultado = "'" + resultado + "'";
		return resultado;
	}

	private String sqlFechaMayorOIgual(String fecha, String nombreCampoYTabla) {
		String mes = fecha.substring(0, 2);
		String dia = fecha.substring(3, 5);
		String anyo = fecha.substring(6, 10);
		String fechaEnNumero = anyo.concat(mes).concat(dia);
		return (" and to_number(to_char(".concat(nombreCampoYTabla).concat(
				",'yyyyMMdd')) >= ").concat(fechaEnNumero));
	}

	private String sqlFechaMenorOIgual(String fecha, String nombreCampoYTabla) {
		String mes = fecha.substring(0, 2);
		String dia = fecha.substring(3, 5);
		String anyo = fecha.substring(6, 10);
		String fechaEnNumero = anyo.concat(mes).concat(dia);
		return (" and to_number(to_char(".concat(nombreCampoYTabla).concat(
				",'yyyyMMdd')) <= ").concat(fechaEnNumero));

	}

	private String generarHQLBuscarSubastasPaginados(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		StringBuffer hqlSelect = new StringBuffer();
		StringBuffer hqlFrom = new StringBuffer();
		StringBuffer hqlWhere = new StringBuffer();

		// Consulta inicial b�sica
		hqlSelect.append(" select distinct s ");

		hqlFrom.append("  from Subasta s ");
		hqlFrom.append(" , Asunto asu ");
		hqlFrom.append(" , Expediente e ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlFrom.append(" , Contrato c ");
			hqlFrom.append(" , ExpedienteContrato cex ");
		}
		hqlFrom.append(" , Procedimiento p ");
		hqlFrom.append(" , TipoJuzgado j  ");
		hqlFrom.append(" , TipoPlaza pla ");

		hqlWhere.append(" where s.auditoria.borrado = 0");

		hqlWhere.append(" and (asu=s.asunto or s.asunto is null) ");
		hqlWhere.append(" and asu.auditoria.borrado = 0 ");
		hqlWhere.append(" and (asu.expediente = e or asu.expediente is null)  ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlWhere.append(" and (cex.expediente = e or cex.expediente is null) ");
			hqlWhere.append(" and (cex.contrato = c or cex.contrato is null) ");
			hqlWhere.append(" and cex.auditoria.borrado = 0 ");
		}
		hqlWhere.append(" and (s.procedimiento = p or s.procedimiento is null) ");
		hqlWhere.append(" and (p.juzgado = j or p.juzgado is null) ");
		hqlWhere.append(" and (j.plaza = pla or j.plaza is null) ");

		if (usuLogado.getUsuarioExterno()) {
			hqlWhere.append(hqlFiltroEsGestorAsunto(usuLogado));
			if (necesitaContratos(dto, usuLogado)) {
				hqlWhere.append(" and cex.sinActuacion = 0 ");
			}
			hqlWhere.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}

		// Filtros de pesta�a de Subasta
		if (dto.getId() != null) {
			hqlWhere.append(" and s.id = ".concat(dto.getId().toString()));
		}

		if (!StringUtils.emtpyString(dto.getNumAutos())) {
			hqlWhere.append(" and s.procedimiento.codigoProcedimientoEnJuzgado like ('%"
					.concat(dto.getNumAutos()).concat("%')"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaSolicitudDesde(),
					"s.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSolicitudHasta(),
					"s.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaAnuncioDesde(),
					"s.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaAnuncioHasta(),
					"s.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(
					dto.getFechaSenyalamientoDesde(), "s.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(
					dto.getFechaSenyalamientoHasta(), "s.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInfLetradoCompleto())) {
			hqlWhere.append(" and s.infoLetrado = ".concat(dto
					.getIdComboInfLetradoCompleto()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInstruccionesCompletadas())) {
			hqlWhere.append(" and s.instrucciones = ".concat(dto
					.getIdComboInstruccionesCompletadas()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboSubastaRevisada())) {
			hqlWhere.append(" and s.subastaRevisada = ".concat(dto
					.getIdComboSubastaRevisada()));
		}

		if (!StringUtils.emtpyString(dto.getComboFiltroEstadoDeGestion())) {
			hqlWhere.append(" and s.estadoSubasta.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getComboFiltroEstadoDeGestion())).concat(")"));
		}

		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaBankia()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaBankia()))
							.concat(")) "));
		}
		
		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaSareb()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaSareb()))
							.concat(")) "));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEntidad())) {
			if (dto.getIdComboEntidad().equalsIgnoreCase("BANKIA")) {
				hqlWhere.append(" and s.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_BANKIA).concat("'"));
			} else {
				hqlWhere.append(" and s.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_SAREB).concat("'"));
			}
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresDesde())) {
			hqlWhere.append(" and to_number(s.cargasAnteriores)>= ".concat(dto
					.getTotalCargasAnterioresDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresHasta())) {
			hqlWhere.append(" and to_number(s.cargasAnteriores)<= ".concat(dto
					.getTotalCargasAnterioresHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoDesde())) {
			hqlWhere.append(" and to_number(s.totalImporteAdjudicado)>= "
					.concat(dto.getTotalImporteAdjudicadoDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoHasta())) {
			hqlWhere.append(" and to_number(s.totalImporteAdjudicado)<= "
					.concat(dto.getTotalImporteAdjudicadoHasta()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboTasacionCompletada())) {
			hqlWhere.append(" and s.tasacion = ".concat(dto
					.getIdComboTasacionCompletada()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEmbargo())) {
			// (SERGIO):
			// "Indica si la subasta es consecuencia de un embargo, esto es, que alguno de los bienes de la subasta este asociado a un embargo en alguno de los tr�mite del asunto donde esta la subasta"
			if (dto.getIdComboEmbargo().equalsIgnoreCase("1")) {
				hqlWhere.append(" and s.embargo=1 ");
			} else if (dto.getIdComboEmbargo().equalsIgnoreCase("0")) {
				hqlWhere.append(" and s.embargo=0 ");
			}
		}

		// Filtros de pesta�a de Cliente
		if (!StringUtils.emtpyString(dto.getCodigoCliente())
				|| !StringUtils.emtpyString(dto.getNombre())
				|| !StringUtils.emtpyString(dto.getApellidos())
				|| !StringUtils.emtpyString(dto.getNif())
				|| !StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , ProcedimientoPersona pp, Persona pers ");
			hqlWhere.append(" and p=pp.procedimiento ");
			hqlWhere.append(" and pp.persona=pers ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoCliente())) {
			hqlWhere.append(" and pers.codClienteEntidad like '%"
					+ dto.getCodigoCliente() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNombre())) {
			hqlWhere.append(" and upper(pers.nombre) like '%"
					+ dto.getNombre().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getApellidos())) {
			hqlWhere.append(" and upper(pers.apellido1)||' '||upper(pers.apellido2) like '%"
					+ dto.getApellidos().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNif())) {
			hqlWhere.append(" and upper(pers.docId) like '%"
					+ dto.getNif().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , DDTipoPersona tpe ");
			hqlWhere.append(" and tpe=pers.tipoPersona ");
			hqlWhere.append(" and tpe.codigo = '" + dto.getTipoPersona() + "' ");
		}

		// Filtros de pesta�a de Contrato
		if (existsFiltroContrato(dto)) {
			//TODO quitar todos estos comenarios

			/*
			 * hqlFrom.append(" , ExpedientePersona pe ");
			 * hqlFrom.append(" , Persona pers "); hqlFrom.append(
			 * ", LoteSubasta ls, LoteBien lb, NMBBien b, NMBContratoBien bc ");
			 * 
			 * hqlWhere.append(" and ls.id=lb.loteSubasta.id ");
			 * hqlWhere.append(" and b.id=lb.bien.id ");
			 * hqlWhere.append(" and lb.bien.id=bc.bien.id ");
			 * hqlWhere.append(" and bc.contrato.id=c.id ");
			 */
		}

		if (!StringUtils.emtpyString(dto.getNroContrato())) {
			hqlWhere.append(" and c.nroContrato like '%" + dto.getNroContrato()
					+ "%' ");
		}

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodRecibo())) {
			hqlFrom.append(", Recibo recibo");
			hqlWhere.append(" and  (recibo.codigoRecibo like '%"
					+ dto.getCodRecibo() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodEfecto())) {
			hqlFrom.append(", EfectoContrato efecto ");
			hqlWhere.append(" and  (efecto.codigoEfecto like '%"
					+ dto.getCodEfecto() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodDisposicion())) {
			hqlFrom.append(" , Disposicion disp ");
			hqlWhere.append(" and  (disp.codigoDisposicion like '%"
					+ dto.getCodDisposicion() + "%') ");
		}
		*/

		if (!StringUtils.emtpyString(dto.getStringEstadosContrato())) {
			hqlWhere.append(" and c.estadoContrato.codigo IN ( "
					+ dto.getStringEstadosContrato() + ")");
		}

		if (!StringUtils.emtpyString(dto.getTiposProductoEntidad())) {
			hqlWhere.append(" and c.tipoProductoEntidad.codigo in ("
					+ dto.getTiposProductoEntidad() + ")");
		}

		// Filtros de pesta�a de Jerarqu�a

		if (!StringUtils.emtpyString(dto.getCodigoZona())) {

			// Incluyo el cruce de tablas si a�n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinacontable") < 0) {
				hqlFrom.append(", Oficina oficinacontable ");
				hqlWhere.append(" and c.oficinaContable=oficinacontable ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinacontable") < 0) {
				hqlFrom.append(", DDZona zonaoficinacontable ");
				hqlWhere.append(" and zonaoficinacontable.oficina = oficinacontable ");
			}

			hqlWhere.append(" and zonaoficinacontable.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoZonaAdm())) {
			// Incluyo el cruce de tablas si a�n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinaadministrativa") < 0) {
				hqlFrom.append(", Oficina oficinaadministrativa ");
				hqlWhere.append(" and c.oficinaAdministrativa=oficinaadministrativa ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinaadministrativa") < 0) {
				hqlFrom.append(", DDZona zonaoficinaadministrativa ");
				hqlWhere.append(" and zonaoficinaadministrativa.oficina = oficinaadministrativa ");
			}

			hqlWhere.append(" and zonaoficinaadministrativa.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}


		// Filtros pesta�a asuntos
		if (!StringUtils.emtpyString(dto.getGestion())) {
			hqlWhere.append(" and asu.gestionAsunto.codigo = '"
					+ dto.getGestion() + "' ");
		}

		if (!StringUtils.emtpyString(dto.getPropiedad())) {
			hqlWhere.append(" and asu.propiedadAsunto.codigo = '"
					+ dto.getPropiedad() + "' ");
		}

		return hqlSelect.toString().concat(hqlFrom.toString())
				.concat(hqlWhere.toString());

	}

	private String hqlFiltroEsGestorAsunto(Usuario usuLogado) {
		String monogestor = " (asu.id in (select a.id from Asunto a where a.gestor.usuario.id = "
				+ usuLogado.getId() + "))";
		//String multigestor = " (asu.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "+ +usuLogado.getId() + "))";
		
		String multigestor = filtroGestorGrupo(extGrupoUsuariosDao.getIdsUsuariosGrupoUsuario(usuLogado));
		if(!Checks.esNulo(multigestor)){
			return " and (" + monogestor + " or " + multigestor + ")";
		}
		else
			return "and (" + monogestor + " or " + filtroGestorPropio(usuLogado.getId()) + ")";
		
	}
	
	private String filtroGestorPropio(Long idUsuario) {
		if (Checks.esNulo(idUsuario))
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id = ");
		hql.append(idUsuario);
		hql.append("))");
		return hql.toString();
	}
	
	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo==null || idsUsuariosGrupo.size()==0)
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id IN (");
		
		StringBuilder idsUsuarios = new StringBuilder();
		for (Long idUsario : idsUsuariosGrupo) {
			idsUsuarios.append("," + idUsario.toString());
		}
		if (idsUsuarios.length()>1)
			hql.append(idsUsuarios.deleteCharAt(0).toString());
		
		hql.append(")))");
		return hql.toString();
	}

	/**
	 * Este método nos dice si vamos a necesitar cruzar por Contratos en la
	 * búsqueda
	 * 
	 * @param dto
	 * @param usuLogado
	 * @return
	 */
	private boolean necesitaContratos(NMBDtoBuscarSubastas dto,
			Usuario usuLogado) {
		return (usuLogado!=null && usuLogado.getUsuarioExterno()) // need cex.sinActuacion = 0
				|| existsFiltroContrato(dto)
				|| existsFiltroZonificacion(dto)
		;
	}
	
	/**
	 * Nos dice si el usuario ha introducido algún filtro relativo a la Zonificación en el DTO
	 * @param dto
	 * @return
	 */
	private boolean existsFiltroZonificacion(NMBDtoBuscarSubastas dto) {
		return (!StringUtils.emtpyString(dto.getCodigoZona()))
				|| (!StringUtils.emtpyString(dto.getCodigoZonaAdm()));
	}

	/**
	 * Nos dice si el usuario ha introducido algún filtro relativo al Contrato en el DTO
	 * @param dto
	 * @return
	 */
	private boolean existsFiltroContrato(NMBDtoBuscarSubastas dto) {
		return (!StringUtils.emtpyString(dto.getNroContrato()))
				|| (!StringUtils.emtpyString(dto.getCodRecibo()))
				|| (!StringUtils.emtpyString(dto.getCodEfecto()))
				|| (!StringUtils.emtpyString(dto.getCodDisposicion()))
				|| (!StringUtils.emtpyString(dto.getStringEstadosContrato()))
				|| (!StringUtils.emtpyString(dto.getTiposProductoEntidad()));
	}
	
	public List<Subasta> getSubastasporIdBien (Long id){
		List<Subasta> listaSubastas = new ArrayList<Subasta>();
		HQLBuilder hql = new HQLBuilder("select lob.loteSubasta.subasta "
				+ "from Bien bi, "
				+ "LoteBien lob ");
		hql.appendWhere("bi.id="+id+" and lob.bien = bi and bi.auditoria.borrado = 0 "
				+ "and lob.loteSubasta.auditoria.borrado = 0 "
				+ "and lob.loteSubasta.subasta.auditoria.borrado = 0");
		listaSubastas = HibernateQueryUtils.list(this, hql);
		return listaSubastas;
		
	}

	private void setSortLotesSubastas(NMBDtoBuscarSubastas dto) {
		if (dto.getSort() != null) {
			if (dto.getSort().equals("valorSubasta")) {
				dto.setSort("coalesce(lot.valorBienes,0)");
			} else if (dto.getSort().equals("deudaJudicial")) {
				dto.setSort("coalesce(lot.deudaJudicial,0)");
			} else if (dto.getSort().equals("pujaSin")) {
				dto.setSort("coalesce(lot.insPujaSinPostores,0)");
			} else if (dto.getSort().equals("pujaConDesde")) {
				dto.setSort("coalesce(lot.insPujaPostoresDesde,0)");
			} else if (dto.getSort().equals("pujaConHasta")) {
				dto.setSort("coalesce(lot.insPujaPostoresHasta,0)");
			} else if (dto.getSort().equals("tasacion")) {
				dto.setSort("coalesce(lot.tasacionActiva,0)");
			} else if (dto.getSort().equals("fechaSubasta")) {
				dto.setSort("lot.subasta.fechaSenyalamiento");
			} else if (dto.getSort().equals("riesgoConsignacion")) {
				dto.setSort("coalesce(lot.riesgoConsignacion,0)");
			} else if (dto.getSort().equals("estado")) {
				dto.setSort("lot.estado.descripcion");
			} else if (dto.getSort().equals("cargas")) {
				dto.setSort("lot.tieneCargasAnteriores");
			}
		} else {
			dto.setSort("lot.id");
		}
	}

	@Override
	public Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto) {
		return buscarLotesSubastasPaginados(dto, null);
	}
	
	@Override
	public Page buscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		// Establece el orden de la búsqueda
		setSortLotesSubastas(dto);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarLotesSubastasPaginados(dto, usuLogado), dto);
	}

	
	private String generarHQLBuscarLotesSubastasPaginados(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		StringBuffer hqlSelect = new StringBuffer();
		StringBuffer hqlFrom = new StringBuffer();
		StringBuffer hqlWhere = new StringBuffer();

		// Consulta inicial b�sica
		hqlSelect.append("select lot ");

		hqlFrom.append("  from LoteSubasta lot ");
		hqlFrom.append(" , Asunto asu ");
		hqlFrom.append(" , Expediente e ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlFrom.append(" , Contrato c ");
			hqlFrom.append(" , ExpedienteContrato cex ");
		}
		hqlFrom.append(" , Procedimiento p ");
		hqlFrom.append(" , TipoJuzgado j  ");
		hqlFrom.append(" , TipoPlaza pla ");

		hqlWhere.append(" where lot.auditoria.borrado = 0");

		hqlWhere.append(" and (asu=lot.subasta.asunto or lot.subasta.asunto is null) ");
		hqlWhere.append(" and asu.auditoria.borrado = 0 ");
		hqlWhere.append(" and (asu.expediente = e or asu.expediente is null)  ");
		if (necesitaContratos(dto, usuLogado)) {
			hqlWhere.append(" and (cex.expediente = e or cex.expediente is null) ");
			hqlWhere.append(" and (cex.contrato = c or cex.contrato is null) ");
			hqlWhere.append(" and cex.auditoria.borrado = 0 ");
		}
		hqlWhere.append(" and (lot.subasta.procedimiento = p or lot.subasta.procedimiento is null) ");
		hqlWhere.append(" and (p.juzgado = j or p.juzgado is null) ");
		hqlWhere.append(" and (j.plaza = pla or j.plaza is null) ");

		if (usuLogado!=null && usuLogado.getUsuarioExterno()) {
			hqlWhere.append(hqlFiltroEsGestorAsunto(usuLogado));
			if (necesitaContratos(dto, usuLogado)) {
				hqlWhere.append(" and cex.sinActuacion = 0 ");
			}
			hqlWhere.append(" and asu.estadoAsunto.codigo NOT IN ("
					+ DDEstadoAsunto.ESTADO_ASUNTO_CANCELADO + ", "
					+ DDEstadoAsunto.ESTADO_ASUNTO_CERRADO + ")");
		}

		// Filtros de pesta�a de Subasta
		if (dto.getId() != null) {
			hqlWhere.append(" and lot.subasta.id = ".concat(dto.getId().toString()));
		}

		if (!StringUtils.emtpyString(dto.getNumAutos())) {
			hqlWhere.append(" and lot.subasta.procedimiento.codigoProcedimientoEnJuzgado like ('%"
					.concat(dto.getNumAutos()).concat("%')"));
		}

		// Busca por juzgado, sino por plaza
		if (!StringUtils.emtpyString(dto.getIdJuzgado())) {
			hqlWhere.append(String.format(" and j.codigo='%s'", dto.getIdJuzgado()));
		} else if (!StringUtils.emtpyString(dto.getIdPlazaJuzgado())) {
			hqlWhere.append(String.format(" and pla.codigo='%s'", dto.getIdPlazaJuzgado()));
		}


		if (!StringUtils.emtpyString(dto.getFechaSolicitudDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaSolicitudDesde(), "lot.subasta.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSolicitudHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaSolicitudHasta(), "lot.subasta.fechaSolicitud"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(dto.getFechaAnuncioDesde(), "lot.subasta.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaAnuncioHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(dto.getFechaAnuncioHasta(), "lot.subasta.fechaAnuncio"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoDesde())) {
			hqlWhere.append(sqlFechaMayorOIgual(
					dto.getFechaSenyalamientoDesde(), "lot.subasta.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getFechaSenyalamientoHasta())) {
			hqlWhere.append(sqlFechaMenorOIgual(
					dto.getFechaSenyalamientoHasta(), "lot.subasta.fechaSenyalamiento"));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInfLetradoCompleto())) {
			hqlWhere.append(" and lot.subasta.infoLetrado = ".concat(dto
					.getIdComboInfLetradoCompleto()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboInstruccionesCompletadas())) {
			hqlWhere.append(" and lot.subasta.instrucciones = ".concat(dto
					.getIdComboInstruccionesCompletadas()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboSubastaRevisada())) {
			hqlWhere.append(" and lot.subasta.subastaRevisada = ".concat(dto
					.getIdComboSubastaRevisada()));
		}

		if (!StringUtils.emtpyString(dto.getIdEstadoInstrucciones())) {
			hqlWhere.append(" and lot.estado.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getIdEstadoInstrucciones())).concat(")"));
		}
		
		if (!StringUtils.emtpyString(dto.getComboFiltroEstadoDeGestion())) {
			hqlWhere.append(" and lot.subasta.estadoSubasta.codigo in (".concat(
					anyadirApostrofesParaSql(dto
							.getComboFiltroEstadoDeGestion())).concat(")"));
		}

		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaBankia()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaBankia()))
							.concat(")) "));
		}
		
		if ((!StringUtils.emtpyString(dto.getComboFiltroTareasSubastaSareb()))
				|| (!StringUtils.emtpyString(dto
						.getComboFiltroTareasSubastaSareb()))) {
			hqlFrom.append("  , VTARTareaVsUsuario v ");
			hqlWhere.append(" and p=v.procedimiento ");
			hqlWhere.append(" and v.nombreTarea in ( "
					+ "                     select t.descripcion"
					+ "                     from TareaProcedimiento t "
					+ "                     where t.codigo in (".concat(
							anyadirApostrofesParaSql(dto
									.getComboFiltroTareasSubastaSareb()))
							.concat(")) "));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEntidad())) {
			if (dto.getIdComboEntidad().equalsIgnoreCase("BANKIA")) {
				hqlWhere.append(" and lot.subasta.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_BANKIA).concat("'"));
			} else {
				hqlWhere.append(" and lot.subasta.procedimiento.tipoProcedimiento.codigo='"
						.concat(CODIGO_TIPO_SUBASTA_SAREB).concat("'"));
			}
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresDesde())) {
			hqlWhere.append(" and to_number(lot.subasta.cargasAnteriores)>= ".concat(dto
					.getTotalCargasAnterioresDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalCargasAnterioresHasta())) {
			hqlWhere.append(" and to_number(lot.subasta.cargasAnteriores)<= ".concat(dto
					.getTotalCargasAnterioresHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoDesde())) {
			hqlWhere.append(" and to_number(lot.subasta.totalImporteAdjudicado)>= "
					.concat(dto.getTotalImporteAdjudicadoDesde()));
		}

		if (!StringUtils.emtpyString(dto.getTotalImporteAdjudicadoHasta())) {
			hqlWhere.append(" and to_number(lot.subasta.totalImporteAdjudicado)<= "
					.concat(dto.getTotalImporteAdjudicadoHasta()));
		}

		if (!StringUtils.emtpyString(dto.getTipoSubastaDesde())) {
			try {
				Float f = Float.parseFloat(dto.getTipoSubastaDesde());
				hqlWhere.append(String.format(" and to_number(lot.insValorSubasta)>=%f", f));
			} catch (Exception nfe) {
			}
		}

		if (!StringUtils.emtpyString(dto.getTipoSubastaHasta())) {
			try {
				Float f = Float.parseFloat(dto.getTipoSubastaHasta());
				hqlWhere.append(String.format(" and to_number(lot.insValorSubasta)<=%f", f));
			} catch (Exception nfe) {
			}
		}
		
		if (!StringUtils.emtpyString(dto.getIdComboTasacionCompletada())) {
			hqlWhere.append(" and lot.subasta.tasacion = ".concat(dto
					.getIdComboTasacionCompletada()));
		}

		if (!StringUtils.emtpyString(dto.getIdComboEmbargo())) {
			// (SERGIO):
			// "Indica si la subasta es consecuencia de un embargo, esto es, que alguno de los bienes de la subasta este asociado a un embargo en alguno de los tr�mite del asunto donde esta la subasta"
			if (dto.getIdComboEmbargo().equalsIgnoreCase("1")) {
				hqlWhere.append(" and lot.subasta.embargo=1 ");
			} else if (dto.getIdComboEmbargo().equalsIgnoreCase("0")) {
				hqlWhere.append(" and lot.subasta.embargo=0 ");
			}
		}

		// Filtros de pesta�a de Cliente
		if (!StringUtils.emtpyString(dto.getCodigoCliente())
				|| !StringUtils.emtpyString(dto.getNombre())
				|| !StringUtils.emtpyString(dto.getApellidos())
				|| !StringUtils.emtpyString(dto.getNif())
				|| !StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , ProcedimientoPersona pp, Persona pers ");
			hqlWhere.append(" and p=pp.procedimiento ");
			hqlWhere.append(" and pp.persona=pers ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoCliente())) {
			hqlWhere.append(" and pers.codClienteEntidad like '%"
					+ dto.getCodigoCliente() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNombre())) {
			hqlWhere.append(" and upper(pers.nombre) like '%"
					+ dto.getNombre().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getApellidos())) {
			hqlWhere.append(" and upper(pers.apellido1)||' '||upper(pers.apellido2) like '%"
					+ dto.getApellidos().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getNif())) {
			hqlWhere.append(" and upper(pers.docId) like '%"
					+ dto.getNif().toUpperCase() + "%' ");
		}

		if (!StringUtils.emtpyString(dto.getTipoPersona())) {
			hqlFrom.append(" , DDTipoPersona tpe ");
			hqlWhere.append(" and tpe=pers.tipoPersona ");
			hqlWhere.append(" and tpe.codigo = '" + dto.getTipoPersona() + "' ");
		}

		// Filtros de pesta�a de Contrato
		if (existsFiltroContrato(dto)) {
			//TODO quitar todos estos comenarios

			/*
			 * hqlFrom.append(" , ExpedientePersona pe ");
			 * hqlFrom.append(" , Persona pers "); hqlFrom.append(
			 * ", LoteSubasta ls, LoteBien lb, NMBBien b, NMBContratoBien bc ");
			 * 
			 * hqlWhere.append(" and ls.id=lb.loteSubasta.id ");
			 * hqlWhere.append(" and b.id=lb.bien.id ");
			 * hqlWhere.append(" and lb.bien.id=bc.bien.id ");
			 * hqlWhere.append(" and bc.contrato.id=c.id ");
			 */
		}

		if (!StringUtils.emtpyString(dto.getNroContrato())) {
			hqlWhere.append(String.format(" and c.nroContrato like '%%%s%%' ", dto.getNroContrato()));
		}
		
		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodRecibo())) {
			hqlFrom.append(", Recibo recibo");
			hqlWhere.append(" and  (recibo.codigoRecibo like '%"
					+ dto.getCodRecibo() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodEfecto())) {
			hqlFrom.append(", EfectoContrato efecto ");
			hqlWhere.append(" and  (efecto.codigoEfecto like '%"
					+ dto.getCodEfecto() + "%') ");
		}
		*/

		/* FIXME Volver a activar este filtro, para ello hay que relacionar esta entidad con 
		 * la subasta de algún modo
		 * 
		if (!StringUtils.emtpyString(dto.getCodDisposicion())) {
			hqlFrom.append(" , Disposicion disp ");
			hqlWhere.append(" and  (disp.codigoDisposicion like '%"
					+ dto.getCodDisposicion() + "%') ");
		}
		*/

		if (!StringUtils.emtpyString(dto.getStringEstadosContrato())) {
			hqlWhere.append(String.format("and c.estadoContrato.codigo in (%s)", dto.getStringEstadosContrato()));
		}

		if (!StringUtils.emtpyString(dto.getTiposProductoEntidad())) {
			hqlWhere.append(String.format("and c.tipoProductoEntidad.codigo in (%s)", dto.getTiposProductoEntidad()));
		}

		// Filtros de pesta�a de Jerarqu�a

		if (!StringUtils.emtpyString(dto.getCodigoZona())) {

			// Incluyo el cruce de tablas si a�n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinacontable") < 0) {
				hqlFrom.append(", Oficina oficinacontable ");
				hqlWhere.append(" and c.oficinaContable=oficinacontable ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinacontable") < 0) {
				hqlFrom.append(", DDZona zonaoficinacontable ");
				hqlWhere.append(" and zonaoficinacontable.oficina = oficinacontable ");
			}

			hqlWhere.append(" and zonaoficinacontable.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}

		if (!StringUtils.emtpyString(dto.getCodigoZonaAdm())) {
			// Incluyo el cruce de tablas si a�n no se ha incluido
			if (hqlFrom.indexOf("Oficina oficinaadministrativa") < 0) {
				hqlFrom.append(", Oficina oficinaadministrativa ");
				hqlWhere.append(" and c.oficinaAdministrativa=oficinaadministrativa ");
			}

			if (hqlFrom.indexOf("DDZona zonaoficinaadministrativa") < 0) {
				hqlFrom.append(", DDZona zonaoficinaadministrativa ");
				hqlWhere.append(" and zonaoficinaadministrativa.oficina = oficinaadministrativa ");
			}

			hqlWhere.append(" and zonaoficinaadministrativa.codigo in ("
					+ anyadirApostrofesParaSql(dto.getCodigoZona()) + ") ");
		}


		// Filtros pesta�a asuntos
		if (!StringUtils.emtpyString(dto.getGestion())) {
			hqlWhere.append(" and asu.gestionAsunto.codigo = '"
					+ dto.getGestion() + "' ");
		}

		if (!StringUtils.emtpyString(dto.getPropiedad())) {
			hqlWhere.append(" and asu.propiedadAsunto.codigo = '"
					+ dto.getPropiedad() + "' ");
		}
		
		setFiltroBienes(hqlWhere, dto);

		return hqlSelect.append(hqlFrom).append(hqlWhere).toString();

	}
	
	
	private void setFiltroBienes(StringBuffer where, NMBDtoBuscarLotesSubastas dto) {
		StringBuffer subWhere = new StringBuffer();
		if (StringUtils.emtpyString(dto.getNumeroActivo()) &&
				StringUtils.emtpyString(dto.getFincaRegistral())) {
			return;
		}
		String from = "select lb.loteSubasta.id from LoteBien lb";
		if (!StringUtils.emtpyString(dto.getNumeroActivo())) {
			subWhere.append(" and upper(nmbB.numeroActivo) like '%").append(dto.getNumeroActivo().toUpperCase()).append("%'");
			from = "LoteBien lb, NMBBien nmbB where nmbB.id=lb.bien.id";
		}
		if (!StringUtils.emtpyString(dto.getFincaRegistral())) {
			subWhere.append(" and infoReg.auditoria.borrado=0 and upper(infoReg.numFinca) like '%").append(dto.getFincaRegistral().toUpperCase()).append("%'");
			from = "LoteBien lb, NMBBien nmbB, NMBInformacionRegistralBien infoReg where nmbB.id=lb.bien.id and infoReg.bien.id=nmbB.id";
		}
		
		where.append(" and lot.id in (select lb.loteSubasta.id from ").append(from).append(subWhere).append(")");
	}
	
	@Override
	public List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto) {
		return buscarLoteSubastasExcel(dto, null);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<LoteSubasta> buscarLoteSubastasExcel(NMBDtoBuscarLotesSubastas dto,
			Usuario usuLogado) {
		setSortLotesSubastas(dto);
		Query query = getSession().createQuery(
				generarHQLBuscarLotesSubastasPaginados(dto, usuLogado));
		return (List<LoteSubasta>) query.list();
	}


	@Override
	public Integer buscarSubastasExcelCount(NMBDtoBuscarSubastas dto, Usuario usuLogado) {
		
		Query query = getSession().createQuery(
				generarHQLBuscarSubastasPaginados(dto, usuLogado));
		return query.list().size();
	}

	
}