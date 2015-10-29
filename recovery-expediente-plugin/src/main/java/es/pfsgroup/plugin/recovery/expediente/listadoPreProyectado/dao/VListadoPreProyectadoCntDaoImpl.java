package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;

@Repository("VListadoPreProyectadoCntDao")
public class VListadoPreProyectadoCntDaoImpl extends AbstractEntityDao<VListadoPreProyectadoCnt, Long> implements VListadoPreProyectadoCntDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto) {
		
		StringBuilder sb = new StringBuilder();
		//sb.append("Select distinct c ");
		sb.append("from VListadoPreProyectadoCnt c ");
		sb.append(" where c.cntId IN (select distinct f.cntId from VListadoPreProyectadoCntFiltros f where 1=1 ");
		
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
		
		sb.append(" ) ");
		
		return getHibernateTemplate().find(sb.toString());
	}

}
