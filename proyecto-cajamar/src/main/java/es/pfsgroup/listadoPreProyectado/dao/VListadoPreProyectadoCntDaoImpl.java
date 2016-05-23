package es.pfsgroup.listadoPreProyectado.dao;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.ProjectionList;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.listadoPreProyectado.model.VListadoPreProyectadoCnt;

@Repository("VListadoPreProyectadoCntDao")
public class VListadoPreProyectadoCntDaoImpl extends AbstractEntityDao<VListadoPreProyectadoCnt, Long> implements VListadoPreProyectadoCntDao {

	
	/**
	 * Construye la sql de búsqueda.
	 * 
	 * @param dto
	 * 
	 * @param isBuscadorProyectado
	 * 			true: en caso de que los resultados se vayan a visualizar en 
	 * 			el grid de resultados del buscador.
	 * @param isCount
	 * 			true: la sql se utiliza para realizar un count.
	 * @return
	 */
	private StringBuilder construirSql(final ListadoPreProyectadoDTO dto, final boolean isBuscadorProyectado, final boolean isCount) {
		StringBuilder sb = new StringBuilder();
		//sb.append("Select distinct c ");
		if(isCount){
			sb.append("Select count (distinct f.cntId) ");
		}else if (isBuscadorProyectado) {
			sb.append("Select distinct f.cntId, f.contrato, f.expId, f.riesgoTotal, f.deudaIrregular, f.tramo, f.diasVencidos, f.fechaPaseAMoraCnt, f.propuesta, f.estadoGestion, f.importePteDifer ");
		} else {
			sb.append("Select distinct f.cntId, f.contrato, f.expId, f.riesgoTotal, f.deudaIrregular, f.tramo, f.diasVencidos, f.fechaPaseAMoraCnt, f.propuesta, f.estadoGestion, f.importePteDifer, f.fechaPrevReguCnt, f.nomTitular, f.nifTitular, f.ofiCodigo ");
		}
		//sb.append("select distinct f ");
		sb.append(" from VListadoPreProyectadoCnt f ");
		sb.append(" where f.diasVencidos BETWEEN 1 AND 120 ");
		//sb.append(" where c.cntId IN (select distinct f.cntId from VListadoPreProyectadoCntFiltros f where 1=1 ");
		
		if (!Checks.esNulo(dto.getCodEstadoGestion())) {
			sb.append(" and f.estadoGestionCod = '" + dto.getCodEstadoGestion() + "' ");
		}
			
		if (!Checks.esNulo(dto.getCodTipoPersona())) {
			sb.append(" and f.tipoPersonaCod = '" + dto.getCodTipoPersona() + "' ");
		}
		
		if (!Checks.esNulo(dto.getNif())) {
			sb.append(" and (f.nifTitular like '" + dto.getNif().toUpperCase() + "%' or f.nifCliente like '" + dto.getNif().toUpperCase() + "%') ");
		}
		
		if (!Checks.esNulo(dto.getNombreCompleto())) {
			sb.append(" and (f.nomTitular like '" + dto.getNombreCompleto().toUpperCase() + "%' or f.nomCliente like '" + dto.getNombreCompleto().toUpperCase() + "%') ");
		}
		
		if (!Checks.esNulo(dto.getMinRiesgoTotal())) {
			sb.append(" and f.riesgoTotal >= " + dto.getMinRiesgoTotal() + " ");
		}
		
		if (!Checks.esNulo(dto.getMaxRiesgoTotal())) {
			sb.append(" and f.riesgoTotal <= " + dto.getMaxRiesgoTotal() + " ");
		}
		
		//Deuda irregular > 0
		sb.append(" and f.deudaIrregular > 0 ");
		
		if (!Checks.esNulo(dto.getMinDeudaIrregular())) {
			sb.append(" and f.deudaIrregular >= " + dto.getMinDeudaIrregular() + " ");
		}
		
		if (!Checks.esNulo(dto.getMaxDeudaIrregular())) {
			sb.append(" and f.deudaIrregular <= " + dto.getMaxDeudaIrregular() + " ");
		}
		
		if (!Checks.esNulo(dto.getMinDiasVencidos())) {
			sb.append(" and f.diasVencidos >= " + dto.getMinDiasVencidos() + " ");
		}
		
		if (!Checks.esNulo(dto.getMaxDiasVencidos())) {
			sb.append(" and f.diasVencidos <= " + dto.getMaxDiasVencidos() + " ");
		}		
		

		if (!Checks.esNulo(dto.getTramos())) {
			String[] tramos = dto.getTramos().split(",");
			if (tramos.length>0) {
				sb.append(" and ( ");
				for (int i = 0; i < tramos.length; i++) {
					String tramo = tramos[i];
					sb.append(" f.tramoCod = '" + tramo + "' ");
					if (i<tramos.length-1) {
						sb.append(" or ");
					}
				}
				sb.append(" ) ");
			}
		}
		
		if (!Checks.esNulo(dto.getPropuestas())) {
			String[] propuestas = dto.getPropuestas().split(",");
			if (propuestas.length>0) {
				sb.append(" and (");
				for (int i = 0; i < propuestas.length; i++) {
					String tipoPropuesta = propuestas[i];
					if (tipoPropuesta.equals(DDTipoAcuerdo.SIN_PROPUESTA)) {
						sb.append(" f.nPropuestas = 0 ");
					} else {
						sb.append(" f.tipoPropuestaCod = '" + tipoPropuesta + "' ");
					}
				
					if (i<propuestas.length-1) {
						sb.append(" or ");
					}
				}
				sb.append(" ) ");
			}
		}
		
		if (!Checks.esNulo(dto.getCodExpediente())) {
			sb.append(" and f.expId = " + dto.getCodExpediente() + " ");
		}
		
		if (!Checks.esNulo(dto.getZonasExp())) {
			String[] zonasExp = dto.getZonasExp().split(",");
			if (zonasExp.length>0) {
				sb.append(" and (");
				for (int i = 0; i < zonasExp.length; i++) {
					String zonaExp = zonasExp[i];
					sb.append(" f.zonExp LIKE '" + zonaExp + "%' ");
					if (i<zonasExp.length-1) {
						sb.append(" or ");
					}
				}
				sb.append(" ) ");
			}
		}
		
		if (!Checks.esNulo(dto.getItinerarios())) {
			String[] fases = dto.getItinerarios().split(",");
			if (fases.length>0) {
				sb.append(" and (");
				for (int i = 0; i < fases.length; i++) {
					String fase = fases[i];
					sb.append(" f.faseCod = '" + fase + "' ");
					if (i<fases.length-1) {
						sb.append(" or ");
					}
				}
				sb.append(" ) ");
			}
		}
		
		if (!Checks.esNulo(dto.getCodContrato()) && dto.getCodContrato().trim().length()>0) {
			//sb.append(" and f.contrato = '" + dto.getCodContrato() + "' ");
			sb.append(" and f.contrato like '%"	+ dto.getCodContrato().trim() + "%' ");
		}
				
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacion())) {
			sb.append(" and f.fechaPrevReguCnt >= TO_DATE('" + parseDate(dto.getFechaPrevRegularizacion()) + "','yyyy-MM-dd') ");
			
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacionHasta())) {
			sb.append(" and f.fechaPrevReguCnt <= TO_DATE('" + parseDate(dto.getFechaPrevRegularizacionHasta()) + "','yyyy-MM-dd') ");
		}
		
		if (!Checks.esNulo(dto.getPaseMoraDesde())) {
			sb.append(" and f.fechaPaseAMoraCnt >= TO_DATE('" + parseDate(dto.getPaseMoraDesde()) + "','yyyy-MM-dd') ");
		}
		
		if (!Checks.esNulo(dto.getPaseMoraHasta())) {
			sb.append(" and f.fechaPaseAMoraCnt <= TO_DATE('" + parseDate(dto.getPaseMoraHasta()) + "','yyyy-MM-dd') ");
		}
		
		if (!Checks.esNulo(dto.getZonasCto())) {
			String[] zonasCnt = dto.getZonasCto().split(",");
			if (zonasCnt.length>0) {
				sb.append(" and (");
				for (int i = 0; i < zonasCnt.length; i++) {
					String zonaCnt = zonasCnt[i];
					sb.append(" f.zonCodContrato LIKE '" + zonaCnt + "%' ");
					if (i<zonasCnt.length-1) {
						sb.append(" or ");
					}
				}
				sb.append(" ) ");
			}
		}
		
        //Filtrado visibilidad por zonas
		if (!Checks.esNulo(dto.getUsuarioLogado())) {
	        if (dto.getUsuarioLogado().getZonas().size() > 0) {
	            sb.append(" and ( ");
	            for (int i = 0; i < dto.getUsuarioLogado().getZonas().size(); i++) {
	            	DDZona zona = dto.getUsuarioLogado().getZonas().get(i);
	            	sb.append("f.zonCodContrato like '" + zona.getCodigo() + "%' ");
	            	if (i<dto.getUsuarioLogado().getZonas().size()-1) {
	            		sb.append(" or ");
	            	}
	            }
	            sb.append(" ) ");
	        }
		}		
		
		//sb.append(" ) ");
		
		return sb;
	}
		
	private String parseDate(String fechaSinFormato) {
		
		SimpleDateFormat formatoFechaFiltroWeb = new SimpleDateFormat("yyyy-MM-dd");
		try {
			formatoFechaFiltroWeb.parse(StringUtils.substring(fechaSinFormato, 0, 10));
			return StringUtils.substring(fechaSinFormato, 0, 10);
		}
		catch(Exception e) {
			SimpleDateFormat formatoFechaFiltroWeb2 = new SimpleDateFormat("EEE MMM dd yyyy");
			try {
				Date fecha = formatoFechaFiltroWeb2.parse(fechaSinFormato);
				return formatoFechaFiltroWeb.format(fecha);
			} 
			catch (ParseException e1) {
				formatoFechaFiltroWeb2 = new SimpleDateFormat("dd/MM/yyyy");
				try {
					Date fecha = formatoFechaFiltroWeb2.parse(fechaSinFormato);
					return formatoFechaFiltroWeb.format(fecha);
				} 
				catch (ParseException e2) {
					logger.error("Error en el método parseDate: " + e2.getLocalizedMessage());
				}		
			}					
		}
		
		return null;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto) {
		
		StringBuilder sb = construirSql(dto,false, false);
		
		List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		return castearListado(lista, false);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntExp(Long expId, Usuario usuarioLogado) {
		StringBuilder sb = new StringBuilder();
		//sb.append("Select distinct c ");
		sb.append("Select distinct f.cntId, f.contrato, f.expId, f.riesgoTotal, f.deudaIrregular, f.tramo, f.diasVencidos, f.fechaPaseAMoraCnt, f.propuesta, f.estadoGestion, f.importePteDifer, f.fechaPrevReguCnt ");
		sb.append(" from VListadoPreProyectadoCnt f ");
		sb.append(" where f.expId = " + expId);
		
		/*
        //Filtrado visibilidad por zonas
		if (!Checks.esNulo(usuarioLogado)) {
	        if (usuarioLogado.getZonas().size() > 0) {
	            sb.append(" and ( ");
	            for (int i = 0; i < usuarioLogado.getZonas().size(); i++) {
	            	DDZona zona = usuarioLogado.getZonas().get(i);
	            	sb.append("f.zonCodContrato like '" + zona.getCodigo() + "%' ");
	            	if (i<usuarioLogado.getZonas().size()-1) {
	            		sb.append(" or ");
	            	}
	            }
	            sb.append(" ) ");
	        }
		}*/	
		
		List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		return castearListado(lista, false);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntExp(List<Long> expsId) {
		ProjectionList select = Projections.projectionList();
		select.add(Projections.property("f.cntId").as("cntId"));
		select.add(Projections.property("f.contrato").as("contrato"));
		select.add(Projections.property("f.expId").as("expId"));
		select.add(Projections.property("f.riesgoTotal").as("riesgoTotal"));
		select.add(Projections.property("f.deudaIrregular").as("deudaIrregular"));
		select.add(Projections.property("f.tramo").as("tramo"));
		select.add(Projections.property("f.diasVencidos").as("diasVencidos"));
		select.add(Projections.property("f.fechaPaseAMoraCnt").as("fechaPaseAMoraCnt"));
		select.add(Projections.property("f.propuesta").as("propuesta"));
		select.add(Projections.property("f.estadoGestion").as("estadoGestion"));
		select.add(Projections.property("f.importePteDifer").as("importePteDifer"));
		select.add(Projections.property("f.fechaPrevReguCnt").as("fechaPrevReguCnt"));
		
		Criteria query = getSession().createCriteria(VListadoPreProyectadoCnt.class, "f");
		query.setProjection(Projections.distinct(select));
		query.add(Restrictions.in("f.expId", expsId));

		query.setResultTransformer(Transformers.aliasToBean(VListadoPreProyectadoCnt.class));
		
		return query.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		//this.getSession().createSQLQuery("{call DBMS_MVIEW.REFRESH('V_LIS_PREPROYECT_CNT')}").executeUpdate();
		
		StringBuilder sb = construirSql(dto,true, false);
		
		//List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		HQLBuilder hb = new HQLBuilder(sb.toString());
		Page pagina = HibernateQueryUtils.page(this, hb, dto);
		return castearListado((List<Object[]>) pagina.getResults(), true);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public int getCountListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		StringBuilder sb = construirSql(dto,true, true);
		
		List<Object> lista = getHibernateTemplate().find(sb.toString());
		if(lista.size() > 0){
			final Long size = (Long)lista.get(0);
			return size.intValue();
		}
		return 0;
	}
	
	/**
	 * Castea los resultados del buscador.
	 * 
	 * @param lista
	 *            lista de objectos
	 * @param isBuscadorProyectado
	 *            true: en caso de que los resultados se vayan a visualizar en
	 *            el grid de resultados del buscador.
	 * @return
	 */
	private List<VListadoPreProyectadoCnt> castearListado(final List<Object[]> lista, final boolean isBuscadorProyectado) {
		List<VListadoPreProyectadoCnt> resultado = new ArrayList<VListadoPreProyectadoCnt>();
		
		final List<Long> listCntId = new ArrayList<Long>();
		
		for (Object[] item : lista) {
			final Long cntId = (Long) item[0];
			if (!listCntId.contains(cntId)) {
				VListadoPreProyectadoCnt cnt = new VListadoPreProyectadoCnt();
				cnt.setCntId(cntId);
				cnt.setContrato((String) item[1]);
				cnt.setExpId((Long) item[2]);
				cnt.setRiesgoTotal((BigDecimal) item[3]);
				cnt.setDeudaIrregular((BigDecimal) item[4]);
				cnt.setTramo((String) item[5]);
				cnt.setDiasVencidos((Long) item[6]);
				cnt.setFechaPaseAMoraCnt((Date) item[7]);
				cnt.setPropuesta((String) item[8]);
				cnt.setEstadoGestion((String) item[9]);
				cnt.setImportePteDifer((BigDecimal) item[10]);
				if (!isBuscadorProyectado) {
					cnt.setFechaPrevReguCnt((Date) item[11]);
					cnt.setNomTitular((String) item[12]);
					cnt.setNifTitular((String) item[13]);
					cnt.setOfiCodigo((String) item[14]);
				}
				listCntId.add(cntId);
				resultado.add(cnt);
			}
		}
		
		return resultado;
	}
}