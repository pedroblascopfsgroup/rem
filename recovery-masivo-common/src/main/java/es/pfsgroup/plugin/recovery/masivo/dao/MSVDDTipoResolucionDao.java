package es.pfsgroup.plugin.recovery.masivo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;

public interface MSVDDTipoResolucionDao  extends AbstractDao<MSVDDTipoResolucion, Long>{
	List<MSVDDTipoResolucion> dameTiposEspeciales(String prefijoResEspeciales);
	boolean esTipoEspecial(Long idTipo, String PrefijoResEspeciales);
}
