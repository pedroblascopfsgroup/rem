/**
 * @class HreRem.controller.FavoritosController
 * @author Jose Villel
 * 
 * Controlador global de aplicación que gestiona la funcionalidad del menú de favoritos
 */
Ext.define('HreRem.controller.FavoritosController', {
    extend: 'Ext.app.Controller',
    
	refs: [
				{
					ref: 'menuFavoritos',
					selector: 'menufavoritos'
				}
	],

	control: {		
		
		'botonfavorito': {
			
			pintarFavorito: 'pintarFavorito',
			addFavorito: 'addFavorito',
			removeFavorito: 'removeFavorito'

		}
		

	},			      

	pintarFavorito: function(btn) {
		
		var me = this,
		menuFavoritos = me.getMenuFavoritos();
		Ext.Array.each(menuFavoritos.getFavoritos(), function(favorito, index){			
			if(favorito.openId == btn.openId) {
				btn.marcado = true;
			}			
		});
		btn.pintarFavorito();
	},
	
	addFavorito: function(favorito) {
		
		var me = this,
		menuFavoritos = me.getMenuFavoritos();
		menuFavoritos.addFavorito(favorito);

		
	},
	
	removeFavorito: function(id) {
		
		var me = this,
		menuFavoritos = me.getMenuFavoritos();			
		menuFavoritos.removeFavorito(id);		
	}

    
});
