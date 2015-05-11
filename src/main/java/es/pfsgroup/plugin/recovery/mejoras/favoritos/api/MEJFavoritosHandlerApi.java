package es.pfsgroup.plugin.recovery.mejoras.favoritos.api;

import es.pfsgroup.plugin.recovery.mejoras.favoritos.dto.MEJDtoFavoritos;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.model.MEJFavoritos;

public interface MEJFavoritosHandlerApi {
	
	String getCodigo();
	
	MEJFavoritos crearFavoritoProductorConsumidor(MEJDtoFavoritos dto);
}
