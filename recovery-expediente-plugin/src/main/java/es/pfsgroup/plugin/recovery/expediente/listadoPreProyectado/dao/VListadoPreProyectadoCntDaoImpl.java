package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dao;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;

@Repository("VListadoPreProyectadoCntDao")
public class VListadoPreProyectadoCntDaoImpl extends AbstractEntityDao<VListadoPreProyectadoCnt, Long> implements VListadoPreProyectadoCntDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(ListadoPreProyectadoDTO dto) {
		
		StringBuilder sb = new StringBuilder();
		sb.append("Select distinct c.cntId, c.contrato, c.expId, c.riesgoTotal, c.deudaIrregular, c.tramo, c.diasVencidos, c.fechaPaseAMoraCnt, c.propuesta, c.estadoGestion, c.fechaPrevReguCnt ");
		sb.append("from VListadoPreProyectadoCnt c ");
		sb.append(" where 1=1 ");
		
		if (!Checks.esNulo(dto.getCodEstadoGestion())) {
			sb.append(" and c.estadoGestionCod = '" + dto.getCodEstadoGestion() + "' ");
		}
		
		if (!Checks.esNulo(dto.getCodTipoPersona())) {
			sb.append(" and c.tipoPersonaCod = '" + dto.getCodTipoPersona() + "' ");
		}
		
		if (!Checks.esNulo(dto.getMinRiesgoTotal())) {
			sb.append(" and c.riesgoTotal >= " + dto.getMinRiesgoTotal() + " ");
		}
		
		if (!Checks.esNulo(dto.getMaxRiesgoTotal())) {
			sb.append(" and c.riesgoTotal <= " + dto.getMaxRiesgoTotal() + " ");
		}
		
		if (!Checks.esNulo(dto.getMinDeudaIrregular())) {
			sb.append(" and c.deudaIrregular >= " + dto.getMinDeudaIrregular() + " ");
		}
		
		if (!Checks.esNulo(dto.getMaxDeudaIrregular())) {
			sb.append(" and c.deudaIrregular <= " + dto.getMaxDeudaIrregular() + " ");
		}
		
		if (!Checks.esNulo(dto.getTramos()) && !Checks.estaVacio(dto.getTramos())) {
			sb.append(" and ( ");
			Iterator<String> tramos = dto.getTramos().iterator();
			do {
				String tramo = tramos.next();
				sb.append(" tramoCod = '" + tramo + "' ");
				if (tramos.hasNext()) {
					sb.append(" or ");
				}
			} while (tramos.hasNext());
			sb.append(" ) ");
		}
		
		if (!Checks.esNulo(dto.getPropuestas()) && !Checks.estaVacio(dto.getPropuestas())) {
			sb.append(" and (");
			Iterator<String> tiposPropuesta = dto.getPropuestas().iterator();
			do {
				String tipoPropuesta = tiposPropuesta.next();
				if (tipoPropuesta.equals(DDTipoAcuerdo.SIN_PROPUESTA)) {
					sb.append(" nPropuestas = 0 ");
				} else {
					sb.append(" tipoPropuestaCod = '" + tipoPropuesta + "' ");
				}
				
				if (tiposPropuesta.hasNext()) {
					sb.append(" or ");
				}
			} while (tiposPropuesta.hasNext());
			sb.append(" ) ");
		}
		
		if (!Checks.esNulo(dto.getCodExpediente())) {
			sb.append(" and c.expId = " + dto.getCodExpediente() + " ");
		}
		
		if (!Checks.esNulo(dto.getZonasExp()) && !Checks.estaVacio(dto.getZonasExp())) {
			sb.append(" and (");
			Iterator<String> zonasExp = dto.getZonasExp().iterator();
			do {
				String zonaExp = zonasExp.next();
				sb.append(" zonExp = '" + zonaExp + "' ");
				if (zonasExp.hasNext()) {
					sb.append(" or ");
				}
			} while (zonasExp.hasNext());
			sb.append(" ) ");
		}
		
		if (!Checks.esNulo(dto.getItinerarios()) && !Checks.estaVacio(dto.getItinerarios())) {
			sb.append(" and (");
			Iterator<String> fases = dto.getItinerarios().iterator();
			do {
				String fase = fases.next();
				sb.append(" faseCod = '" + fase + "' ");
				if (fases.hasNext()) {
					sb.append(" or ");
				}
			} while (fases.hasNext());
			sb.append(" ) ");
		}
		
		if (!Checks.esNulo(dto.getCodContrato())) {
			sb.append(" and c.contrato = '" + dto.getCodContrato() + "' ");
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacion())) {
			sb.append(" and c.fechaPrevReguCnt >= TO_DATE('" + dto.getFechaPrevRegularizacion().substring(0, 10) + "','yyyy-MM-dd') ");
			
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacionHasta())) {
			sb.append(" and c.fechaPrevReguCnt <= TO_DATE('" + dto.getFechaPrevRegularizacionHasta().substring(0,10) + "','yyyy-MM-dd') ");
		}
		
		if (!Checks.esNulo(dto.getZonasCto()) && !Checks.estaVacio(dto.getZonasCto())) {
			sb.append(" and (");
			Iterator<String> zonasCnt = dto.getZonasCto().iterator();
			do {
				String zonaCnt = zonasCnt.next();
				sb.append(" zonCodContrato='" + zonaCnt + "' ");
				if (zonasCnt.hasNext()) {
					sb.append(" or ");
				}
			} while (zonasCnt.hasNext());
			sb.append(" ) ");
		}
		
		return (List<VListadoPreProyectadoCnt>)getHibernateTemplate().find(sb.toString(), new Object[] {});
	}

}
