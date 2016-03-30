package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.StringTokenizer;

import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dao.BPRProcedimientoDao;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto.BPRDtoBusquedaProcedimientos;

@SuppressWarnings("rawtypes")
@Repository("BPRProcedimientoDao")
public class BPRProcedimientoDaoImpl extends
		AbstractEntityDao implements BPRProcedimientoDao {

	@Override
	public Page findProcedimientos(Usuario usuarioLogado, BPRDtoBusquedaProcedimientos dto) {		
		//final String QUERY1 = "select p from Procedimiento p ";
		final String QUERY1 = "select p from Procedimiento p join p.asunto asunto ";
		final String QUERY2 = QUERY1 + " left join p.asunto.expediente.personas per ";
		
		HQLBuilder hb;
		
		if (!Checks.esNulo(dto.getCodigoCliente()) || !Checks.esNulo(dto.getNifCliente()) || !Checks.esNulo(dto.getDemandado()))
		{
			hb= new HQLBuilder( QUERY2 );			
		}
		else
		{
			hb= new HQLBuilder( QUERY1 );	
		}
			//"select distinct p from Procedimiento p left join p.asunto.expediente.personas per join p.asunto asu ");
		     // "select distinct p from Asunto asu join asu.procedimientos p left join p.asunto.expediente.personas per");
		hb.appendWhere("p.auditoria.borrado = false");

		if (!Checks.esNulo(dto.getAsunto())) {
			
			hb.appendWhere("upper(asunto.nombre) LIKE '%'|| :asuNom ||'%'");
			hb.getParameters().put("asuNom", dto.getAsunto().toUpperCase());
			
//			hb.appendWhere(String.format("upper(asunto.nombre) LIKE '%%%s%%'", dto.getAsunto().toUpperCase()));
		}
		
		/*
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,
				"p.asunto.gestor.despachoExterno.id", dto.getDespacho());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.gestor.id", dto
				.getGestor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.supervisor.id", dto
				.getSupervisor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.procurador.id", dto
				.getProcurador());
		*/
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.comite.id", dto
				.getComite());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.estadoAsunto.id",
				dto.getEstadoAsunto());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.asunto.id", dto.getCodigoAsunto());

		// NO TENGO MUY CLARO SI ESO ES LA FECHA DE CONFORMACI�N O NO
		if (!Checks.esNulo(dto.getFechaConformacionAsuntoDesde())) {
			String fechaConformacionAsuntoDesde = ":fechaConformacionAsuntoDesde <= p.asunto.auditoria.fechaCrear and p.asunto.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaConformacionAsuntoDesde);
			try {
				hb.getParameters().put("fechaConformacionAsuntoDesde", DateFormat.toDate(dto.getFechaConformacionAsuntoDesde()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFehcaConformacionAsuntoHasta())) {
			String fechaConformacionAsuntoHasta = ":fechaConformacionAsuntoHasta >= p.asunto.auditoria.fechaCrear and p.asunto.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaConformacionAsuntoHasta);
			try {
				hb.getParameters().put("fechaConformacionAsuntoHasta", DateFormat.toDate(dto.getFehcaConformacionAsuntoHasta()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
/*		
		if (!Checks.esNulo(dto.getFechaConformacionAsuntoDesde())
				&& !Checks.esNulo(dto.getFehcaConformacionAsuntoHasta())) {
			try {
				HQLBuilder.addFiltroBetweenSiNotNull(hb,
						"p.asunto.auditoria.fechaCrear", DateFormat.toDate(dto
								.getFechaConformacionAsuntoDesde()), DateFormat
								.toDate(dto.getFehcaConformacionAsuntoHasta()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}*/
		
		// FECHA DE ACEPTACI�N PROCEDIMIENTOS INICIALES NO LO TENGO MUY CLARO
		if (!Checks.esNulo(dto.getFechaAceptacionInicialDesde())) {
			String fechaAceptacionInicialDesde = ":fechaAceptacionInicialDesde <= p.asunto.fichaAceptacion.auditoria.fechaCrear and p.asunto.fichaAceptacion.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaAceptacionInicialDesde);
			try {
				hb.getParameters().put("fechaAceptacionInicialDesde", DateFormat.toDate(dto.getFechaAceptacionInicialDesde()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFechaAceptacionInicialHasta())) {
			String fechaConformacionAsuntoHasta = ":fechaAceptacionInicialHasta >= p.asunto.fichaAceptacion.auditoria.fechaCrear and p.asunto.fichaAceptacion.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaConformacionAsuntoHasta);
			try {
				hb.getParameters().put("fechaAceptacionInicialHasta", DateFormat.toDate(dto.getFechaAceptacionInicialHasta()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		/*
		if (!Checks.esNulo(dto.getFechaAceptacionInicialDesde())
				&& !Checks.esNulo(dto.getFechaAceptacionInicialHasta())) {
			try {
				HQLBuilder
						.addFiltroBetweenSiNotNull(
								hb,
								"p.asunto.fichaAceptacion.auditoria.fechaCrear",
								DateFormat.toDate(dto
										.getFechaAceptacionInicialDesde()),
								DateFormat.toDate(dto
										.getFechaAceptacionInicialHasta()));

			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}*/

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "p.estadoProcedimiento.id",
				Conversiones.createLongCollection(dto.getEstadoProcedimiento(), ","));
		HQLBuilder.addFiltroLikeSiNotNull(hb,
				"p.codigoProcedimientoEnJuzgado", "undefined".compareTo(dto.getCodigoProcedimientoEnJuzgado()) == 0 ? null : dto.getCodigoProcedimientoEnJuzgado());
		
		if (!Checks.esNulo(dto.getNumeroProcedimientoEnJuzgado()) && !Checks.esNulo(dto.getAnyoProcedimientoEnJuzgado())){
			
			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%'|| :numProJuz ||'%-%'|| :anyoProJuz ||'%' or p.codigoProcedimientoEnJuzgado like '%'|| :numProJuz ||'%/%'|| :anyoProJuz ||'%'");
			hb.getParameters().put("numProJuz", dto.getNumeroProcedimientoEnJuzgado());
			hb.getParameters().put("anyoProJuz", dto.getAnyoProcedimientoEnJuzgado());
			
			
//			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%"+dto.getNumeroProcedimientoEnJuzgado()+"%-%"+dto.getAnyoProcedimientoEnJuzgado()+"%'" +
//							" or p.codigoProcedimientoEnJuzgado like '%"+dto.getNumeroProcedimientoEnJuzgado()+"%/%"+dto.getAnyoProcedimientoEnJuzgado()+"%'");
		}else if(!Checks.esNulo(dto.getNumeroProcedimientoEnJuzgado())){
			
			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%'|| :numProJuz ||'%-%' or p.codigoProcedimientoEnJuzgado like '%'|| :numProJuz ||'%/%'");
			hb.getParameters().put("numProJuz", dto.getNumeroProcedimientoEnJuzgado());
			
//			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%"+dto.getNumeroProcedimientoEnJuzgado()+"%-%'" +
//							" or p.codigoProcedimientoEnJuzgado like '%"+dto.getNumeroProcedimientoEnJuzgado()+"%/%'");
		}else if(!Checks.esNulo(dto.getAnyoProcedimientoEnJuzgado())){
			
			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%'|| :anyoProJuz ||'%-%' or p.codigoProcedimientoEnJuzgado like '%'|| :anyoProJuz ||'%/%'");
			hb.getParameters().put("anyoProJuz", dto.getAnyoProcedimientoEnJuzgado());

			
//			hb.appendWhere("p.codigoProcedimientoEnJuzgado like '%-%"+dto.getAnyoProcedimientoEnJuzgado()+"%'" +
//							" or p.codigoProcedimientoEnJuzgado like '%/%"+dto.getAnyoProcedimientoEnJuzgado()+"%'");
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.tipoProcedimiento.tipoActuacion.id", dto
				.getTipoActuacion());
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "p.tipoProcedimiento.id",
				Conversiones.createLongCollection(dto.getTipoProcedimiento(),
						","));
		HQLBuilder.addFiltroIgualQueSiNotNull(hb,
				"p.procedimientoPadre.tipoProcedimiento.tipoActuacion.id", dto
						.getTipoActuacionPadre());
		HQLBuilder.addFiltroWhereInSiNotNull(hb,
				"p.procedimientoPadre.tipoProcedimiento.id", Conversiones
						.createLongCollection(dto.getTipoProcedimientoPadre(),
								","));
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.juzgado.plaza.codigo", dto
				.getPlaza());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.juzgado.codigo", dto
				.getJuzgado());
		
		// SALDO TOTAL
		if (!Checks.esNulo(dto.getSaldoTotalContratosMin())) {
			String saldoTotalMin = ":saldoTotalMin <= p.saldoRecuperacion and p.saldoRecuperacion is not null";
			hb.appendWhere(saldoTotalMin);
			hb.getParameters().put("saldoTotalMin", dto.getSaldoTotalContratosMin());
		}
		if (!Checks.esNulo(dto.getSaldoTotalContratoMax())) {
			String saldoTotalMax = ":saldoTotalMax >= p.saldoRecuperacion and p.saldoRecuperacion is not null";
			hb.appendWhere(saldoTotalMax);
			hb.getParameters().put("saldoTotalMax", dto.getSaldoTotalContratoMax());
		}
		/*HQLBuilder.addFiltroBetweenSiNotNull(hb, "p.saldoRecuperacion", dto
				.getSaldoTotalContratosMin(), dto.getSaldoTotalContratoMax());*/

		// PORCENTAJE RECUPERACION
		if (!Checks.esNulo(dto.getPorcentajeRecupMin())) {
			String porcentajeRecMin = ":porcentajeRecuperacionMin <= p.porcentajeRecuperacion and p.porcentajeRecuperacion is not null";
			hb.appendWhere(porcentajeRecMin);
			hb.getParameters().put("porcentajeRecuperacionMin", dto.getPorcentajeRecupMin());
		}
		if (!Checks.esNulo(dto.getPorcentajeRecupMax())) {
			String porcentajeRecMax = ":porcentajeRecuperacionMax >= p.porcentajeRecuperacion and p.porcentajeRecuperacion is not null";
			hb.appendWhere(porcentajeRecMax);
			hb.getParameters().put("porcentajeRecuperacionMax", dto.getPorcentajeRecupMax());
		}
		/*HQLBuilder.addFiltroBetweenSiNotNull(hb, "p.porcentajeRecuperacion",
				dto.getPorcentajeRecupMin(), dto.getPorcentajeRecupMax());*/
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.tipoReclamacion.id", dto
				.getTipoReclamacion());
		
		if (!Checks.esNulo(dto.getFechaCrearDesde())) {
			String fechaCrearDesde = ":fechaCrearDesde <= p.auditoria.fechaCrear and p.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaCrearDesde);
			try {
				hb.getParameters().put("fechaCrearDesde", DateFormat.toDate(dto.getFechaCrearDesde()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFechaCrearHasta())) {
			String fechaCrearDesde = ":fechaCrearHasta >= p.auditoria.fechaCrear and p.auditoria.fechaCrear is not null";
			hb.appendWhere(fechaCrearDesde);
			try {
				hb.getParameters().put("fechaCrearHasta", DateFormat.toDate(dto.getFechaCrearHasta()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		/*
		if (!Checks.esNulo(dto.getFechaCrearDesde())
				&& !Checks.esNulo(dto.getFechaCrearHasta())) {
			try {
				HQLBuilder.addFiltroBetweenSiNotNull(hb,
						"p.auditoria.fechaCrear", DateFormat.toDate(dto
								.getFechaCrearDesde()), DateFormat
								.toDate(dto.getFechaCrearHasta()));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}*/

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "p.id",
				dto.getCodigoInterno());
		
		if (!Checks.esNulo(dto.getCodigoContrato())){	
			//hb.appendWhere("p in (select pce.procedimiento from ProcedimientoContratoExpediente pce where pce.expedienteContrato.contrato.nroContrato =" + dto.getCodigoContrato() + ")");
			hb.appendWhere("p.id in" +
					"					(select procedimiento from ProcedimientoContratoExpediente where expedienteContrato in" +
					"							(select id from ExpedienteContrato where contrato.nroContrato = :codCon)) ");
			hb.getParameters().put("codCon", dto.getCodigoContrato());
		}
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "per.persona.codClienteEntidad",
				dto.getCodigoCliente(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "per.persona.docId", dto
				.getNifCliente());
//		try {
//			HQLBuilder.addFiltroBetweenSiNotNull(hb, "t.fechaFin", DateFormat.toDate(dto.getFechaFinPrimeraTarea()), DateFormat.toDate(dto.getFechaFinUltimaTarea()));
//		} catch (ParseException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

//		if (!Checks.esNulo(dto.getFechaFinPrimeraTarea()) && !Checks.esNulo(dto.getFechaFinUltimaTarea())) {
//			//if(DateFormat.toDate(dto.getFechaFinPrimeraTarea()).after(arg0))
//			String fechaFinTodo = "(:fechaI >= (select min(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)) and (:fechaf <= (select max(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)) ";
//			hb.appendWhere(fechaFinTodo);
//				try {
//				hb.getParameters().put("fechaI", DateFormat.toDate(dto.getFechaFinPrimeraTarea()));
//			} catch (ParseException e1) {
//				// TODO Auto-generated catch block
//				e1.printStackTrace();
//			}
//			try {
//				hb.getParameters().put("fechaf",DateFormat.toDate(dto.getFechaFinUltimaTarea()) );
//			} catch (ParseException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
//		}
		
		if (!Checks.esNulo(dto.getFechaFinPrimeraTareaDesde())) {
			String fechaFinPrimeraTareaDesde = ":finiPrimTarDesde <= (select min(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)";
			hb.appendWhere(fechaFinPrimeraTareaDesde);
			try {
				hb.getParameters().put("finiPrimTarDesde", DateFormat.toDate(dto.getFechaFinPrimeraTareaDesde()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFechaFinPrimeraTareaHasta())) {
			String fechaFinPrimeraTareaHasta = ":finiPrimTarHasta >= (select min(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)";
			hb.appendWhere(fechaFinPrimeraTareaHasta);
			try {
				hb.getParameters().put("finiPrimTarHasta",DateFormat.toDate(dto.getFechaFinPrimeraTareaHasta()) );
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFechaFinUltimaTareaDesde())) {
			String fechaFinUltimaTareaDesde = ":finiUltimTarDesde <= (select max(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)";
			hb.appendWhere(fechaFinUltimaTareaDesde);
			try {
				hb.getParameters().put("finiUltimTarDesde", DateFormat.toDate(dto.getFechaFinUltimaTareaDesde()));
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		if (!Checks.esNulo(dto.getFechaFinUltimaTareaHasta())) {
			String fechaFinUltimaTareaHasta = ":finiUltimTarHasta >= (select max(tar.fechaFin) from TareaNotificacion tar where tar.procedimiento = p and tar.fechaFin is not null)";
			hb.appendWhere(fechaFinUltimaTareaHasta);
			try {
				hb.getParameters().put("finiUltimTarHasta",DateFormat.toDate(dto.getFechaFinUltimaTareaHasta()) );
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if (!Checks.esNulo(dto.getImporteTotalMin())) {
			String where1 = ":importeTotalMin <= (select sum(abs(proc.saldoOriginalVencido)) + sum(abs(proc.saldoOriginalNoVencido)) from Procedimiento proc where proc.asunto = p.asunto and proc.saldoOriginalVencido is not null)";
			hb.appendWhere(where1);
			hb.getParameters().put("importeTotalMin",
					new BigDecimal(dto.getImporteTotalMin()));
		}
		if (!Checks.esNulo(dto.getImporteTotalMax())) {
			String where2 = ":importeTotalMax >= (select sum(abs(proc.saldoOriginalVencido)) + sum(abs(proc.saldoOriginalNoVencido)) from Procedimiento proc where proc.asunto = p.asunto and proc.saldoOriginalVencido is not null)";
			hb.appendWhere(where2);
			hb.getParameters().put("importeTotalMax",
					new BigDecimal(dto.getImporteTotalMax()));
		}
		
		//DESPACHO
        if (dto.getDespacho() != null) {
        	hb.appendWhere("p.asunto.id in (" + getIdsAsuntosDelDespacho(dto.getDespacho(), hb.getParameters()) + ")"); 
        }
        //GESTOR
        if (!Checks.esNulo(dto.getGestor()) || !Checks.esNulo(dto.getTipoGestor())) {
            hb.appendWhere("p.asunto.id in (" + getIdsAsuntosParaGestor(dto.getGestor(), dto.getTipoGestor()) + ")");
        }
		
		
		// PERMISOS DEL USUARIO (en caso de que sea externo)
		if (usuarioLogado.getUsuarioExterno()) {
			hb.appendWhere("("
					+ filtroGestorSupervisorProcedimientoMonoGestor(usuarioLogado,
							hb.getParameters())
					+ " or "
					+ filtroGestorSupervisorProcedimientoMultiGestor(usuarioLogado,
							hb.getParameters()) + ")");

		}		
		
		//DEMANDADO
		if(!Checks.esNulo(dto.getDemandado())){
			
			hb.appendWhere("per.persona.id = '|| :proDem ||'");
			hb.getParameters().put("proDem",dto.getDemandado());
			
//			hb.appendWhere("per.persona.id = '"+dto.getDemandado()+"'");
		}
		
		Page pagina = HibernateQueryUtils.page(this, hb, dto);

		return pagina;
	}
	
	private String filtroGestorSupervisorProcedimientoMonoGestor(
			Usuario usuarioLogado, HashMap<String, Object> params) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (p.asunto.id in (");
		hql.append("select a.id from Asunto a ");
		hql
				.append("where (a.gestor.usuario.id = :usuarioLogado) or (a.supervisor.usuario.id = :usuarioLogado)");
		hql.append("))");
		params.put("usuarioLogado", usuarioLogado.getId());
		return hql.toString();
	}

	private String filtroGestorSupervisorProcedimientoMultiGestor(
			Usuario usuarioLogado, HashMap<String, Object> params) {
		StringBuilder hql = new StringBuilder();
		hql.append(" (p.asunto.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id = :usuarioLogado");
		hql.append("))");
		params.put("usuarioLogado", usuarioLogado.getId());
		return hql.toString();
	}
	
	private String getIdsAsuntosDelDespacho(Long idDespacho, HashMap<String, Object> params) {
		params.put("despExtId", idDespacho);
		return "select asu.id from EXTGestorAdicionalAsunto gaa join gaa.asunto asu " +
				"where gaa.gestor.despachoExterno.id = :despExtId";
	}
	
	private String getIdsAsuntosParaGestor(String comboGestor,
			String comboTiposGestor) {
		if (Checks.esNulo(comboTiposGestor) && Checks.esNulo(comboGestor)){
			throw new IllegalArgumentException("comboGestor y comboTiposGestor est�n vac�os.");
		}
		StringBuilder subhql = new StringBuilder("select asu.id from EXTGestorAdicionalAsunto gaa join gaa.asunto asu where ");
		String and = "";
		if (!Checks.esNulo(comboTiposGestor)){
			subhql.append("gaa.tipoGestor.codigo = '" + comboTiposGestor + "'");
			and = " and ";
		}
		if (!Checks.esNulo(comboGestor)){
			subhql.append(and +"gaa.gestor.usuario.id in (select usu.id from GestorDespacho gd join gd.usuario usu where gd.id in (");
			StringTokenizer tokensGestores = new StringTokenizer(comboGestor, ",");
	        while (tokensGestores.hasMoreElements()) {
	            subhql.append(tokensGestores.nextToken());
	            if (tokensGestores.hasMoreElements()) {
	                subhql.append(",");
	            }
	        }
	        subhql.append("))");
		}
		return subhql.toString();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Collection<? extends Persona> getDemandadosInstant(String query, Usuario usuLogado) {
		StringBuilder hql = new StringBuilder();
		final HashMap<String, Object> params = new HashMap<String, Object>();
		
        hql.append("from Persona p ");
        hql.append("where p.auditoria.borrado = 0 ");
        
        hql.append("and p.nom50 like '%|| :proDem ||%'");
        params.put("proDem",query.toUpperCase());
        
//        hql.append("and p.nom50 like '%" + query.toUpperCase() + "%' ");
        
        if(tieneFuncion(usuLogado, "SOLO_DEMANDADOS_CARTERIZADOS"))
        	esCarterizado(usuLogado, hql);
        
        hql.append("order by nombre, apellido1, apellido2");
        
        
        Query q = getSession().createQuery(hql.toString());
        q.setMaxResults(20);

        return q.list();

	}

	private StringBuilder esCarterizado(Usuario usuLogado, StringBuilder hql) {
		hql.append("and p.id in (");
        hql.append("select prcPer.id from EXTGestorAdicionalAsunto gaa join gaa.asunto asu join asu.procedimientos prc join prc.personasAfectadas prcPer ");
        hql.append("where gaa.gestor.usuario.id = "+usuLogado.getId()+" ");
        hql.append(") ");
        return hql;
	}
	
	private boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}
	
	
}
