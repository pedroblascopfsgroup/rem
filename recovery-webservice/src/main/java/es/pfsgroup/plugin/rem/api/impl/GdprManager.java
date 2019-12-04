package es.pfsgroup.plugin.rem.api.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GdprApi;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;

@Service("gdprManager")
public class GdprManager implements GdprApi {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

	@Autowired
	private GenericAdapter genericAdapter;

	@Autowired
	private ClienteComercialDao clienteComercialDao;
	
	@Override
	public String obtenerIdPersonaHaya(String docCliente) throws UserException {

		String idPersonaHaya = null;
		TmpClienteGDPR tmpClienteGDPR = null;
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		Comprador comprador = genericDao.get(Comprador.class, filtro);
		if (!Checks.esNulo(comprador) && !Checks.esNulo(comprador.getIdPersonaHaya())) {
			idPersonaHaya = String.valueOf(comprador.getIdPersonaHaya());
		} else {
			List<ClienteComercial> clientes = genericDao.getList(ClienteComercial.class,
					genericDao.createFilter(FilterType.EQUALS, "documento", docCliente));
			if (clientes != null && !clientes.isEmpty()) {
				for (ClienteComercial clc : clientes) {
					if (clc.getIdPersonaHaya() != null) {
						idPersonaHaya = clc.getIdPersonaHaya();
						break;
					}
				}
			}
			if (Checks.esNulo(idPersonaHaya)) {
				tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class,
						genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));
				if (!Checks.esNulo(tmpClienteGDPR) && !Checks.esNulo(tmpClienteGDPR.getIdPersonaHaya())) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			}
		}
		if (Checks.esNulo(idPersonaHaya)) {
			throw new UserException("El comprador no está dado de alta en el maestro de personas");
		}
		return idPersonaHaya;

	}

	@Override
	public boolean deleteAdjuntoPersona(AdjuntoComprador adjuntoComprador, String docCliente) throws Exception {
		boolean borrado = false;
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			borrado = gestorDocumentalAdapterApi.borrarAdjunto(adjuntoComprador.getIdDocRestClient(),
					usuarioLogado.getUsername());

		}

		if (borrado) {
			// Borrado lógico del documento
			adjuntoComprador.getAuditoria().setBorrado(true);
			adjuntoComprador.getAuditoria().setUsuarioBorrar(usuarioLogado.getUsername());
			adjuntoComprador.getAuditoria().setFechaBorrar(new Date());
			genericDao.update(AdjuntoComprador.class, adjuntoComprador);
			List<ClienteGDPR> clientesGdpr = this.obtnenerClientesGdprNyNumDoc(docCliente);
			if (!Checks.estaVacio(clientesGdpr)) {
				for (ClienteGDPR clienteGDPR : clientesGdpr) {
					clienteGDPR.setAdjuntoComprador(null);
					Auditoria.save(clienteGDPR);
					genericDao.update(ClienteGDPR.class, clienteGDPR);
				}
			} else {
				Filter filtroDocumento = genericDao.createFilter(FilterType.EQUALS, "idAdjunto",
						adjuntoComprador.getId());
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, filtroDocumento);
				if (!Checks.esNulo(tmpClienteGDPR)) {
					tmpClienteGDPR.setIdAdjunto(null);
					genericDao.update(TmpClienteGDPR.class, tmpClienteGDPR);
				}
			}
		}
		return borrado;
	}

	@Override
	public List<ClienteGDPR> obtnenerClientesGdprNyNumDoc(String docCliente) throws Exception {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
		return genericDao.getList(ClienteGDPR.class, filtro);
	}

	@Override
	public void deleteTmpClienteByDocumento(String docCliente) throws Exception {
		clienteComercialDao.deleteTmpClienteByDocumento(docCliente);		
	}

	@Override
	public AdjuntoComprador obtenerAdjuntoComprador(String docCliente, Long idAdjunto) throws Exception {
		Filter filtroDoc;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			filtroDoc = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient",
					idAdjunto);
		} else {
			filtroDoc = genericDao.createFilter(FilterType.EQUALS, "id", idAdjunto);
		}

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.get(AdjuntoComprador.class, filtroDoc, filtroBorrado);		
	}
}
