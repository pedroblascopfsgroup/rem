package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dao;

import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.api.VListadoPreProyectadoCntDao;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model.VListadoPreProyectadoCnt;

@Repository("VListadoPreProyectadoCntDao")
public class VListadoPreProyectadoCntDaoImpl extends AbstractEntityDao<VListadoPreProyectadoCnt, Long> implements VListadoPreProyectadoCntDao {

	@SuppressWarnings("unchecked")
	@Override
	public List<VListadoPreProyectadoCnt> getListadoPreProyectadoCnt(
			ListadoPreProyectadoDTO dto) {
		
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
		
		// **** Tramos
		
		// **** Propuestas y sin propuestas
		
		if (!Checks.esNulo(dto.getCodExpediente())) {
			sb.append(" and c.expId = " + dto.getCodExpediente() + " ");
		}
		
		// **** Centros Expedientes
		
		// **** Fases expedientes
		
		if (!Checks.esNulo(dto.getCodContrato())) {
			sb.append(" and c.contrato = '" + dto.getCodContrato() + "' ");
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacion())) {
			sb.append(" and c.fechaPrevReguCnt >= TO_DATE('" + sdf.format(dto.getFechaPrevRegularizacion()) + "','dd/MM/yyyy') ");
		}
		
		if (!Checks.esNulo(dto.getFechaPrevRegularizacionHasta())) {
			sb.append(" and c.fechaPrevReguCnt <= TO_DATE('" + sdf.format(dto.getFechaPrevRegularizacionHasta()) + "','dd/MM/yyyy') ");
		}
		
		// **** Centros Contrato
		
		return getHibernateTemplate().find(sb.toString(), new Object[] {});
	}

}
