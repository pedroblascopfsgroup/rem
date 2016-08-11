package es.pfsgroup.plugin.rem.api;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.api.GestorEntidadApi;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.rem.model.Activo;

public interface GestorActivoApi extends GestorEntidadApi {

	public static final String CODIGO_GESTOR_ACTIVO = "GACT";
	public static final String CODIGO_GESTOR_ADMISION = "GADM";
	public static final String CODIGO_GESTORIA_ADMISION = "GGADM";
	public static final String CODIGO_PROVEEDOR = "UPROV";
	public static final String CODIGO_SUPERVISOR_ADMISION = "SUPADM";
	public static final String CODIGO_SUPERVISOR_ACTIVOS = "SUPACT";
	public static final String CODIGO_GESTOR_PRECIOS = "GPREC";
	public static final String CODIGO_GESTOR_MARKETING = "GMARK";
	
	void insertarGestorAdicionalActivo(GestorEntidadDto dto);

	Usuario getGestorByActivoYTipo(Activo activo, Long tipo);
	
	Boolean isGestorActivo(Activo activo, Usuario usuario);
	
	Boolean isSupervisorActivo(Activo activo, Usuario usuario);
	
	Boolean isGestorAdmision(Activo activo, Usuario usuario);
	
	Boolean isGestorActivoOAdmision(Activo activo, Usuario usuario);
	
	Boolean isGestorActivoYTipo(Usuario usuario, Activo activo, String codigoGestor);
	
	Boolean isGestorPrecios(Activo activo, Usuario usuario);
	
	Boolean isGestorMarketing(Activo activo, Usuario usuario);
	
	Boolean isGestorPreciosOMarketing(Activo activo, Usuario usuario);

}
