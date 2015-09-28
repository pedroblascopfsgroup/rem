package es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dao.ITIReglasElevacionDao;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.dto.ITIDtoAltaReglaElevacion;
import es.pfsgroup.plugin.recovery.itinerarios.reglasElevacion.model.ITIReglasElevacion;

@Repository("ITIReglasElevacionDao")
public class ITIReglasElevacionDaoImpl extends AbstractEntityDao<ITIReglasElevacion, Long> implements ITIReglasElevacionDao{

	
	@SuppressWarnings("static-access")
	@Override
	public List<ITIReglasElevacion> buscaReglasEstado(Long idEstado) {
		HQLBuilder hb = new HQLBuilder("from ITIReglasElevacion re");
		hb.appendWhere("re.auditoria.borrado = 0");
		hb.addFiltroIgualQue(hb, "re.estado.id", idEstado);
		
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public ITIReglasElevacion createNewReglasElevacion() {
		return new ITIReglasElevacion();
	}

	@Override
	public boolean comprobarExisteRegla(ITIDtoAltaReglaElevacion dto) {
		boolean existe =false;
		HQLBuilder hb = new HQLBuilder("from ITIReglasElevacion re");
		hb.appendWhere("re.auditoria.borrado = 0");
		HQLBuilder.addFiltroIgualQue(hb, "re.estado.id", dto.getEstado());
		HQLBuilder.addFiltroIgualQue(hb, "re.ddTipoReglasElevacion.id", dto.getDdTipoReglasElevacion());
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "re.ambitoExpediente.id", dto.getAmbitoExpediente());
		
		List<ITIReglasElevacion> lista = HibernateQueryUtils.list(this, hb);
		if (!Checks.estaVacio(lista)){
			existe = true;
		}
		return existe;
	}

}
