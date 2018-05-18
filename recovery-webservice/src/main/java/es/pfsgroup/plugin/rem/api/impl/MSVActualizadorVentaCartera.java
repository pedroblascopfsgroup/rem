package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.TrabajoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.UvemManagerApi;
import es.pfsgroup.plugin.rem.controller.ExpedienteComercialController;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoListadoTramites;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.VBusquedaDatosCompradorExpediente;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.recovery.api.UsuarioApi;

@Component
public class MSVActualizadorVentaCartera extends AbstractMSVActualizador implements MSVLiberator{

	public static final int EXCEL_FILA_INICIAL = 3;
	public static final int EXCEL_COL_NUMACTIVO = 0;
		
	
	@Autowired
	ActivoAdapter activoAdapter;
	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;
	
	@Autowired
	ParticularValidatorApi particularValidatorApi;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	AgendaAdapter agendaAdapter;
	
	@Autowired
	ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaApi;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	@Autowired
	private UvemManagerApi uvemManagerApi;
	
	
	
	
	private MSVHojaExcel excel;
	
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VENTA_DE_CARTERA;
	}
	
	@Override
	public int getFilaInicial() {
		return MSVActualizadorVentaCartera.EXCEL_FILA_INICIAL;
	}
	
	@Override
	public void preProcesado(MSVHojaExcel exc)
			throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		excel = exc;
	}


	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		ActivoAgrupacion agrupacion = null; 
		String codigoOferta = null;
		
		if(!Checks.esNulo(exc.dameCelda(fila, 7))){
			//                    CÓDIGO ÚNICO OFERTA
			codigoOferta = exc.dameCelda(fila, 7);
			String descripcionAgrupacion = codigoOferta+"-"+prmToken.toString();
			Integer activoPrincipal = null;
			// Comprobamos si existe la agrupacion por descripcion					
			if (!particularValidatorApi.existeAgrupacionByDescripcion(descripcionAgrupacion)) {
				// Creamos la agrupacion
				crearAgrupcacion(descripcionAgrupacion);
				// Añadimos datos a la agrupacion
				//                               USUARIO GESTOR COMERCIALIZACIÓN (USERNAME)
				agrupacion = modificarAgrupacion(exc.dameCelda(fila, 8),descripcionAgrupacion );
				activoPrincipal = 1;
			} else {	
				agrupacion = obtenerAgrupacion(descripcionAgrupacion);
			}
			
			// Añadimos el activo a la agrupación
			//					   NUMERO ACTIVO			  
			añadirActivoAgrupacion(exc.dameCelda(fila, 0),agrupacion.getId(),activoPrincipal);
		
			// Si es el último activo con ese 'CÓDIGO ÚNICO OFERTA' del excel
			if (esUltimoActivoAgrupacion(codigoOferta, fila)){
				// Creamos la oferta sobre a agrupacion
				//					PRECIO VENTA            NOMBRE                   RAZON SOCIAL            TIPO DOC                NUM DOC                 CÓDIGO PRESCRIPTOR     ID AGRUPACION  
				crearOfertaAgrupcion(exc.dameCelda(fila, 1),exc.dameCelda(fila, 10), exc.dameCelda(fila, 11),exc.dameCelda(fila, 12),exc.dameCelda(fila, 13),exc.dameCelda(fila, 9),agrupacion.getId());
				
				// Creamos un tramite para la oferta, y con ello el expedienteComercial
				crearTramiteOferta(agrupacion.getId());
				
				// Comprobamos el porcentaje de compra de todos los titulares para continuar
				if (	(((Checks.esNulo(exc.dameCelda(fila, 16)))? 0 : (Double.parseDouble(exc.dameCelda(fila, 16)))) +  
						((Checks.esNulo(exc.dameCelda(fila, 23)))? 0 : (Double.parseDouble(exc.dameCelda(fila, 23)))) + 
						((Checks.esNulo(exc.dameCelda(fila, 30)))? 0 : (Double.parseDouble(exc.dameCelda(fila, 30)))) + 
						((Checks.esNulo(exc.dameCelda(fila, 37)))? 0 : (Double.parseDouble(exc.dameCelda(fila, 37))))) == 100
						){												
					// Añadimos el porcentaje correcto al comprador principal, por defecto esta el 100%.
					modificarPorcentajePrincipal(agrupacion.getId(),Double.parseDouble(exc.dameCelda(fila, 16)));

					// Añadimos el resto de TITULARES (Comprador) 2, 3 y 4.
					añadirRestoCompradores(exc, fila, agrupacion.getId());
					
					// Avanzar el tramite de la oferta
					Long idTareaExterna = avanzaPrimeraTarea(agrupacion.getId());
				
					// Llamar al servicioweb Modi de Bankia
					llamadaSercivioWeb(idTareaExterna);
					// Esperamos 15 segundos por Bankia
					try {
						Thread.sleep(15000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				} else {
					// El porcentaje de los compradores no suma el 100%  
				}			
			} else {
				// El codigo unico de oferta no puede ser null
			}
		}
		
		HashMap<String, String> resultadoPorcesar = new HashMap<String, String>();
		//                                 NUMERO ACTIVO HAYA                    
		resultadoPorcesar.put(codigoOferta,exc.dameCelda(fila, 0) );
		ResultadoProcesarFila resultado = new ResultadoProcesarFila(); 
		resultado.sethMap(resultadoPorcesar);
		return resultado;
	}

	private void llamadaSercivioWeb(Long idTareaExterna) {
		TareaExterna tarea = activoTareaExternaApi.get(idTareaExterna);
	
	}

	private Long avanzaPrimeraTarea(Long idAgrupacion) throws Exception {
		
		TransactionStatus transaction = null;
		Long idTareaExterna = null;
		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			
			//Recuperamos el ExpedienteComercial
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			// Obtenemos el tramite del expediente, y de este sus tareas.
			List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(expedienteComercial.getTrabajo().getId());
			List<TareaExterna> tareasTramite = activoTareaExternaApi.getActivasByIdTramiteTodas(listaTramites.get(0).getId());
			idTareaExterna = tareasTramite.get(0).getId();
			
			Map<String, String[]> valoresTarea = new HashMap<String, String[]>();
			valoresTarea.put("comite", new String[] {"Sareb"});
			valoresTarea.put("comboConflicto", new String[] {"02"});
			valoresTarea.put("comboRiesgo", new String[] {"02"});
			valoresTarea.put("fechaEnvio", new String[] {new Date().toString()});
			valoresTarea.put("comiteSuperior", new String[] {"02"});
			valoresTarea.put("observaciones", new String[] {"Masivo Venta cartera"});
			valoresTarea.put("idTarea", new String[] {tareasTramite.get(0).getTareaPadre().getId().toString()});

			agendaAdapter.save(valoresTarea);
			transactionManager.commit(transaction);
			
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
		
		return idTareaExterna;
	}

	private void añadirRestoCompradores(MSVHojaExcel exc, int fila, Long idAgrupacion) throws Exception {
		VBusquedaDatosCompradorExpediente vDatosComprador = null;
		int contadorColumnas = 0;
		for (int i=0;i<3;i++){
			if (!Checks.esNulo(exc.dameCelda(fila, 17+contadorColumnas))||!Checks.esNulo(exc.dameCelda(fila,18+contadorColumnas))){
				
				TransactionStatus transaction = null;
				try{
					// Crea el comprador y la relacion con el expediente
					transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
					//Recuperamos el ExpedienteComercial
					List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
					Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(listaOfertas.get(0).getIdOferta())));
					ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
					vDatosComprador = new VBusquedaDatosCompradorExpediente();
					if (Checks.esNulo(exc.dameCelda(fila, 17+contadorColumnas))){
						vDatosComprador.setNombreRazonSocial(exc.dameCelda(fila, 18+contadorColumnas));
					}else{
						vDatosComprador.setNombreRazonSocial(exc.dameCelda(fila, 17+contadorColumnas));
					}
					vDatosComprador.setCodTipoDocumento(exc.dameCelda(fila, 19+contadorColumnas));
					vDatosComprador.setNumDocumento(exc.dameCelda(fila, 20+contadorColumnas));
					vDatosComprador.setNumeroClienteUrsus(Long.parseLong(exc.dameCelda(fila, 21+contadorColumnas)));
					vDatosComprador.setDocumentoConyuge(exc.dameCelda(fila, 22+contadorColumnas));
					vDatosComprador.setPorcentajeCompra(Double.parseDouble(exc.dameCelda(fila, 23+contadorColumnas)));
					
					expedienteComercialApi.createComprador(vDatosComprador, expedienteComercial.getId());
					transactionManager.commit(transaction);
				} catch (Exception e) {
					transactionManager.rollback(transaction);
					throw e;
				}							
				contadorColumnas = contadorColumnas+7;
			}			
		}	
	}

	private void modificarPorcentajePrincipal(Long idAgrupacion, double nuevoPorcentaje) throws Exception {
		TransactionStatus transaction = null;
		try{			
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			//Recuperamos el ExpedienteComercial
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			Oferta oferta = genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(listaOfertas.get(0).getIdOferta())));
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByOferta(oferta);
			
			VBusquedaDatosCompradorExpediente vDatosComprador = new VBusquedaDatosCompradorExpediente();
			vDatosComprador.setIdExpedienteComercial(expedienteComercial.getId().toString());
			vDatosComprador.setId(expedienteComercial.getCompradorPrincipal().getId().toString());
			vDatosComprador.setNombreRazonSocial(expedienteComercial.getCompradorPrincipal().getNombre());
			vDatosComprador.setPorcentajeCompra(nuevoPorcentaje);

			expedienteComercialApi.saveFichaComprador(vDatosComprador);
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	private void crearTramiteOferta(Long idAgrupacion) throws JsonViewerException, Exception {
		TransactionStatus transaction = null;
		try{			
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertaActivo dtoOferta = new DtoOfertaActivo();
			List<VOfertasActivosAgrupacion> listaOfertas = agrupacionAdapter.getListOfertasAgrupacion(idAgrupacion);
			dtoOferta.setIdOferta(Long.parseLong(listaOfertas.get(0).getIdOferta()));//La agrupacion solo tiene la oferta que acabamos de crear
			dtoOferta.setIdAgrupacion(idAgrupacion);
			dtoOferta.setCodigoEstadoOferta(DDEstadoOferta.CODIGO_ACEPTADA);

			agrupacionAdapter.saveOfertaAgrupacion(dtoOferta); //Aqui crea el expediente
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	private void crearOfertaAgrupcion(String precioVenta, String nombre, String razonSocial, String tipoDoc,
			String numdoc, String codigoPrescriptor, Long idAgrupacion) throws Exception {	
		TransactionStatus transactionE = null;
		try{
			transactionE = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoOfertasFilter dtoFilter = new DtoOfertasFilter();
			dtoFilter.setImporteOferta(precioVenta);
			dtoFilter.setTipoOferta(DDTipoOferta.CODIGO_VENTA);
			dtoFilter.setNombreCliente(nombre);
			dtoFilter.setRazonSocialCliente(razonSocial);
			dtoFilter.setTipoDocumento(tipoDoc);
			dtoFilter.setNumDocumentoCliente(numdoc);
			dtoFilter.setCodigoPrescriptor(codigoPrescriptor);
			dtoFilter.setIdAgrupacion(idAgrupacion);
			dtoFilter.setVentaDirecta(true);
			
			agrupacionAdapter.createOfertaAgrupacion(dtoFilter);
			transactionManager.commit(transactionE);
		} catch (Exception e) {
			transactionManager.rollback(transactionE);
			throw e;
		}
	}
	
	private void añadirActivoAgrupacion(String numActivo, Long idAgrupacion, Integer activoPrincipal) throws Exception {
		TransactionStatus transaction = null;
		try{	
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			
			agrupacionAdapter.createActivoAgrupacion(Long.parseLong(numActivo), idAgrupacion, activoPrincipal);	
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
	}

	private ActivoAgrupacion modificarAgrupacion(String gestorUsername, String descripcionAgrupacion) throws Exception {
		TransactionStatus transactionD = null;
		ActivoAgrupacion agrupacion = null;		
		try{
			transactionD = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoAgrupaciones dtoAgrupacionMod = new DtoAgrupaciones();
			dtoAgrupacionMod.setIsFormalizacion(1);
			Usuario usuario = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username",gestorUsername));
			dtoAgrupacionMod.setCodigoGestorComercial(usuario.getId());
			agrupacion = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "descripcion",descripcionAgrupacion));
			List<ActivoAgrupacionActivo> listaActivoAgrupacionActivo = new ArrayList<ActivoAgrupacionActivo>();
			agrupacion.setActivos(listaActivoAgrupacionActivo);
		
			agrupacionAdapter.saveAgrupacion(dtoAgrupacionMod, agrupacion.getId());
			transactionManager.commit(transactionD);
		} catch (Exception e) {
			transactionManager.rollback(transactionD);
			throw e;
		}
		return agrupacion;		
	}
	
	private ActivoAgrupacion obtenerAgrupacion(String descripcionAgrupacion) throws Exception {
		TransactionStatus transaction = null;
		ActivoAgrupacion agrupacion = null;
		try{
			transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
			// Recuperamos la agrupcaion
			agrupacion = genericDao.get(ActivoAgrupacion.class, genericDao.createFilter(FilterType.EQUALS, "descripcion",descripcionAgrupacion));
			transactionManager.commit(transaction);
		} catch (Exception e) {
			transactionManager.rollback(transaction);
			throw e;
		}
		return agrupacion;
	}

	private void crearAgrupcacion(String descripcionAgrupacion) throws Exception {
		TransactionStatus transactionC = null;
		try{
			transactionC = transactionManager.getTransaction(new DefaultTransactionDefinition());
			DtoAgrupacionesCreateDelete dtoAgrupacionCrear = new DtoAgrupacionesCreateDelete();
			dtoAgrupacionCrear.setNombre("No esta definido");
			dtoAgrupacionCrear.setDescripcion(descripcionAgrupacion);
			dtoAgrupacionCrear.setTipoAgrupacion(DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);
			dtoAgrupacionCrear.setFechaInicioVigencia(new Date());
			
			agrupacionAdapter.createAgrupacion(dtoAgrupacionCrear);				 
			transactionManager.commit(transactionC);		
		} catch (Exception e) {
			transactionManager.rollback(transactionC);
			throw e;
		}
	}

	private boolean esUltimoActivoAgrupacion(String codigoOferta, int fila) throws IllegalArgumentException, IOException, ParseException {
		
		Boolean esUltimo =  true;
		if (fila != excel.getNumeroFilas()-1){ // si no es la ultima del archivo
			for (int i=fila+1; i<=excel.getNumeroFilas()-1;i++){
				if (codigoOferta.equals(excel.dameCelda(i, 7))){
					esUltimo = false;
				};
			}			
		}

		return esUltimo;
	}

}
