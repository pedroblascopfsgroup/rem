package es.pfsgroup.plugin.rem.gestorDocumental.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoPromocion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;

public interface GestorDocumentalAdapterApi {
	
	List<DtoAdjunto> getAdjuntosActivo (Activo activo) throws GestorDocumentalException;
	
	List<DtoAdjunto> getAdjuntosActuacionesTecnicas (Trabajo trabajo) throws GestorDocumentalException;
	
	FileItem getFileItem(Long idDocumento, String nombreDocumento) throws Exception; 
	
	Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoActuacionesTecnicas(Trabajo trabajo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	boolean borrarAdjunto(Long idDocumento, String usuarioLogado);

	boolean modoRestClientActivado();

	Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException;
	
	Integer crearActuacionTecnica(Trabajo trabajo, String usuarioLogado) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosGasto(String numGasto) throws GestorDocumentalException;

	List<DtoAdjunto> getAdjuntosExpedienteComercial(ExpedienteComercial expedienteComercial) throws GestorDocumentalException;

	Long uploadDocumentoExpedienteComercial(ExpedienteComercial expedienteComercialEntrada, WebFileItem webFileItem,
			String username, String matricula) throws GestorDocumentalException;

	Integer crearExpedienteComercial(ExpedienteComercial expedienteComercial, String username) throws GestorDocumentalException;
	
	Integer crearExpedienteComercialTransactional(Long idEco, String username) throws GestorDocumentalException;
	
	void crearRelacionActivosExpediente(ExpedienteComercial expedienteComercial, Long idDocRestClient, String[] listaActivos, String login, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException ;
	
	Long uploadDocumentoPromociones(String codPromo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	List<DtoAdjuntoPromocion> getAdjuntosPromociones (String codPromo) throws GestorDocumentalException;

}
