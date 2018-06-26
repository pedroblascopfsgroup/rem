Ext.define('HreRem.view.activos.gestores.ComboGestores', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'combogestores',
    isSearchForm: false,
    reference: 'combogestoresform',
    collapsible: true,
    
	initComponent: function() {
		var me = this;
		me.setTitle(HreRem.i18n('title.anyadir.gestor'));
    	me.buttonAlign = 'left';
    	
    	me.items = [
			{			
	        	xtype: 'toolfieldset',
	        	border: false,
	        	style: 'background: none; margin-left: -13px',
	        	bind:{
	        		hidden: '{!activo.isCarteraBankia}',
	        		title: 'Gestoría de Recovery: {activo.acbCoreaeTexto}'
	        	}
	        },			
			{
	        	xtype: 'combo',
	        	matchFieldWidth: false,
	        	fieldLabel: HreRem.i18n('gestores.comboGestores.fieldlabel.combo.gestor'),
	        	bind: {
            		store: '{comboTipoGestor}'
            	},
				reference: 'tipoGestor',
				name: 'tipoGestor',
				chainedStore: 'comboUsuarios',
				chainedReference: 'usuarioGestor',
            	displayField: 'descripcion',
				valueField: 'id',
				emptyText: HreRem.i18n('gestores.comboGestores.emptyText.combo.gestor'),
				listeners: {
					select: 'onChangeChainedCombo'
				}
			},							
			{
	        	xtype: 'combo',
	        	matchFieldWidth: false,
	        	fieldLabel: HreRem.i18n('gestores.comboGestores.fieldlabel.combo.usuario'),
	        	reference: 'usuarioGestor',
	        	name: 'usuarioGestor',
	        	bind: {
            		store: '{comboUsuarios}',
            		disabled: '{!tipoGestor.selection}'
            	},
            	displayField: 'apellidoNombre',
				valueField: 'id',
				mode: 'local',
				emptyText: HreRem.i18n('gestores.comboGestores.emptyText.combo.usuario'),
				enableKeyEvents:true,
			    listeners: {
			     'keyup': function() {
			    	   this.getStore().clearFilter();
			    	   this.getStore().filter({
			        	    property: 'apellidoNombre',
			        	    value: this.getRawValue(),
			        	    anyMatch: true,
			        	    caseSensitive: false
			        	})
			     },
			     'beforequery': function(queryEvent) {
			           queryEvent.combo.onLoad();
			     }
			    }
            }          
		];
    	
    	me.buttons = [
	    	{ 
	    		text: HreRem.i18n('gestores.comboGestores.button.botonAgregar'),
	    		handler: 'onAgregarGestoresClick',
	    		bind: { disabled: '{!usuarioGestor.selection}'}
	    	}
	    ];
    	
	    

	    me.callParent();
	}
});