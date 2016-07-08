/***
 * Bot�n de favorito que se puede incluir en cualquier toolbar, y cuya funcionalidad
 * se describe e implementa en el ViewController BotonFavoritoController 
 */
Ext.define('HreRem.ux.button.BotonFavorito', {
	extend	: 'Ext.button.Button',
	xtype	: 'botonfavorito',
    handler	: 'onClickBotonFavoritos',
    iconCls: 'ico-favoritos',
    cls: 'ux-favorito',
	/*
	 * Favorito marcado o no.
	 */    
    marcado: false,    
    /*
     * Css para añadir al elemento de menu que abrirá el favorito y que servirá para pintar un icono difenciador
     */
    cssFavorito: null,    
    /*
     * Tipo de favorito que servirá para diferenciarlo de otros tipos
     */
    tipoId: null,    
    /*
     * Id que servirá para abrir el favorito
     */
    openId: null,
    
    initComponent: function() {
    	
    	var me = this;
    	
    	me.tooltip= HreRem.i18n('btn.anyadir.favoritos');
    	
    	me.callParent();
    },
    
    /**
     * Función que modifica la css del botón.
     * @param {} esFavorito
     */
   	pintarFavorito: function() {		
		
   		var me = this;
   		
		if(me.marcado) {
			me.setIconCls("ico-favoritos-added");
			me.addCls("added");
		} else {
			me.setIconCls("ico-favoritos");
			me.removeCls("added");
		
		}
		
	},

	/**
	 * Función que actualiza el botón.
	 * Si se está marcando, se crea un elemento acción y se lanza el evento addFavorito junto al elemento para que sea añadido donde corresponda.
	 * Si se está desmarcando, se lanza el evento removeFavorito junto al id, para quitarlo de donde corresponda.
	 * 
	 * @param {} textFavorito
	 */
	updateFavorito: function(textoFavorito) {

		var me = this;
			
		if(me.marcado) {	
			me.fireEvent("removeFavorito", me.openId);
			me.marcado = false;
		} else {
			
			var favorito = me.crearFavorito(textoFavorito);     		

			me.marcado= true;
			me.fireEvent('addFavorito', favorito);				
		}
		
		me.pintarFavorito();

	},
	
	crearFavorito: function(textoFavorito) {
		var me = this;
		
		return Ext.create('Ext.Action',{
            text:  textoFavorito,
            cls: 'item-favorito',
           	iconCls: 'x-fa ' + me.cssFavorito,
            openId: me.openId,
            tipoId: me.tipoId,
            handler: 'onClickMenuFavoritos'
		});   
		
	},
	
	setOpenId: function (openId) {
		
		var me  = this;
		me.openId = openId;
		
		me.fireEvent("pintarFavorito", me);
		
	},
	
	getOpenId: function() {
		
		var me = this;		
		return me.openId;
		
	}
    
    
    
    
});