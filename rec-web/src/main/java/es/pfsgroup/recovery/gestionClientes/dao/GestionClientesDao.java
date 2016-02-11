package es.pfsgroup.recovery.gestionClientes.dao;

import java.util.List;
import java.util.Map;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;

public interface GestionClientesDao extends AbstractDao<Persona, Long> {
	
	public static final String COLUM_CODIGO= "COD";
	public static final String COLUMN_TOTAL_COUNT = "TOTAL_COUNT";
	public static final String COLUMN_STA_CODIGO = "STA_COD";
	public static final String COLUMN_STA_DESCRIPCION = "STA_DESC";
	
	public List<Map> obtenerCantidadDeVencidosUsuario(Usuario usuarioLogado);

}
