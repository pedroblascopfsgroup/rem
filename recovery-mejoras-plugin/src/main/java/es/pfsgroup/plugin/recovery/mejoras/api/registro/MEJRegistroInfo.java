package es.pfsgroup.plugin.recovery.mejoras.api.registro;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.core.api.registro.ClaveValor;
import es.capgemini.pfs.users.domain.Usuario;

public interface MEJRegistroInfo {
	
	MEJDDTipoRegistroInfo getTipo();

	String getTipoEntidadInformacion();

	Long getIdEntidadInformacion();

	Usuario getUsuario();

	List<? extends ClaveValor> getInfoRegistro();

	Date getFecha();
	
	Long getId();


}
