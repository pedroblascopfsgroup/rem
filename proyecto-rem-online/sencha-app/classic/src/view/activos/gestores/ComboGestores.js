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
            		store: '{comboTipoGestorByActivo}'
            	},
				reference: 'tipoGestor',
				name: 'tipoGestor',
				chainedStore: 'comboUsuarios',
				chainedReference: 'usuarioGestor',
            	displayField: 'descripcion',
				valueField: 'id',
				filtradoEspecial: true,
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
				queryMode: 'local',
	        	bind: {
            		store: '{comboUsuarios}',
            		disabled: '{!tipoGestor.selection}'
            	},
            	displayField: 'apellidoNombre',
				valueField: 'id',
				filtradoEspecial: true,
				emptyText: HreRem.i18n('gestores.comboGestores.emptyText.combo.usuario'),
			    listeners: {
			    	select: 'disableAgregarGestores'
			    }
            }          
		];
    	
    	me.buttons = [
	    	{ 
	    		text: HreRem.i18n('gestores.comboGestores.button.botonAgregar'),
	    		reference: 'agregarGestor',
	    		handler: 'onAgregarGestoresClick',
	    		disabled: true
	    	}
	    ];
    	
	    

	    me.callParent();
	}
});