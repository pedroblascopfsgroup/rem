package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dao;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.mail.Session;

import org.apache.commons.beanutils.BeanUtils;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;
import es.capgemini.pfs.users.domain.Usuario;

@Repository("VListadoPreProyectadoCntDao")
public class VListadoPreProyectadoCntDaoImpl extends AbstractEntityDao<VListadoPreProyectadoCnt, Long> implements VListadoPreProyectadoCntDao {


	private StringBuilder construirSql(ListadoPreProyectadoDTO dto) {
		StringBuilder sb = new StringBuilder();
		//sb.append("Select distinct c ");
		sb.append("Select distinct f.cntId, f.contrato, f.expId, f.riesgoTotal, f.deudaIrregular, f.tramo, f.diasVencidos, f.fechaPaseAMoraCnt, f.propuesta, f.estadoGestion, f.fechaPrevReguCnt ");
		//sb.append("select distinct f ");
		sb.append(" from VListadoPreProyectadoCnt f ");
		sb.append(" where 1=1 ");
		//sb.append(" where c.cntId IN (select distinct f.cntId from VListadoPreProyectadoCntFiltros f where 1=1 ");
		
		if (!Checks.esNulo(dto.getCodEstadoGestion())) {
			sb.append(" and f.estadoGestionCod = '" + dto.getCodEstadoGestion() + "' ");
		}
			
		if (!Checks.esNulo(dto.getCodTipoPersona())) {
			sb.append(" and f.tipoPersonaCod = '" + dto.getCodTipoPersona() + "' ");
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
					sb.append(" f.zonExp = '" + zonaExp + "' ");
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
		
		if (!Checks.esNulo(dto.getCodContrato())) {
			sb.append(" and f.contrato = '" + dto.getCodContrato() + "' ");
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacion())) {
			sb.append(" and f.fechaPrevReguCnt >= TO_DATE('" + dto.getFechaPrevRegularizacion().substring(0, 10) + "','yyyy-MM-dd') ");
			
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacionHasta())) {
			sb.append(" and f.fechaPrevReguCnt <= TO_DATE('" + dto.getFechaPrevRegularizacionHasta().substring(0,10) + "','yyyy-MM-dd') ");
		}
		
		if (!Checks.esNulo(dto.getZonasCto())) {
			String[] zonasCnt = dto.getZonasCto().split(",");
			if (zonasCnt.length>0) {
				sb.append(" and (");
				for (int i = 0; i < zonasCnt.length; i++) {
					String zonaCnt = zonasCnt[i];
					sb.append(" f.zonCodContrato='" + zonaCnt + "' ");
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
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto) {
		
		StringBuilder sb = construirSql(dto);
		
		List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		return castearListado(lista);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntExp(Long expId, Usuario usuarioLogado) {
		StringBuilder sb = new StringBuilder();
		//sb.append("Select distinct c ");
		sb.append("Select distinct f.cntId, f.contrato, f.expId, f.riesgoTotal, f.deudaIrregular, f.tramo, f.diasVencidos, f.fechaPaseAMoraCnt, f.propuesta, f.estadoGestion, f.fechaPrevReguCnt ");
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
		return castearListado(lista);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		//this.getSession().createSQLQuery("{call DBMS_MVIEW.REFRESH('V_LIS_PREPROYECT_CNT')}").executeUpdate();
		
		StringBuilder sb = construirSql(dto);
		
		//List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		HQLBuilder hb = new HQLBuilder(sb.toString());
		Page pagina = HibernateQueryUtils.page(this, hb, dto);
		return castearListado((List<Object[]>) pagina.getResults());
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public int getCountListadoPreProyectadoCntPaginated(ListadoPreProyectadoDTO dto) {
		StringBuilder sb = construirSql(dto);
		
		List<Object[]> lista = getHibernateTemplate().find(sb.toString());
		return lista.size();
	}
	
	private List<VListadoPreProyectadoCnt> castearListado(List<Object[]> lista) {
		List<VListadoPreProyectadoCnt> resultado = new ArrayList<VListadoPreProyectadoCnt>();
		
		for (Object[] item : lista) {
			VListadoPreProyectadoCnt cnt = new VListadoPreProyectadoCnt();
			cnt.setCntId((Long) item[0]);
			cnt.setContrato((String) item[1]);
			cnt.setExpId((Long) item[2]);
			cnt.setRiesgoTotal((BigDecimal) item[3]);
			cnt.setDeudaIrregular((BigDecimal) item[4]);
			cnt.setTramo((String) item[5]);
			cnt.setDiasVencidos((Long) item[6]);
			cnt.setFechaPaseAMoraCnt((Date) item[7]);
			cnt.setPropuesta((String) item[8]);
			cnt.setEstadoGestion((String)item[9]);
			cnt.setFechaPrevReguCnt((Date) item[10]);
			
			resultado.add(cnt);
		}
		
		return resultado;
	}
}
