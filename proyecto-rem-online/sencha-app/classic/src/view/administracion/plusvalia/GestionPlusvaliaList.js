Ext.define('HreRem.view.administracion.plusvalia.GestionPlusvaliaList', {
    extend: 'HreRem.view.common.GridBase',
    xtype: 'gestionplusvalialist',
    requires: ['HreRem.view.common.CheckBoxModelBase', 'HreRem.ux.plugin.PagingSelectionPersistence'],
	bind: {
       	store: '{plusvaliaAdministracion}'
    },
    loadAfterBind: false,    
    plugins: 'pagingselectpersist',
    listeners:{
       rowdblclick: 'onClickAbrirPlusvalia'
    },

    initComponent: function() {

      var me = this;

    	me.columns = [
	 							{
						        	dataIndex: 'id',
						        	flex: 1,
						        	hidden: true,
						        	hideable: false
						       	},
						       	{
						       		text: HreRem.i18n('header.num.plusvalia'),
						        	dataIndex: 'plusvalia',
						        	flex: 0.4
						       	},
	    	                    {
									text: HreRem.i18n('header.num.activo'),
									dataIndex: 'activo',
									flex: 0.4
							   	},
	    	                    {
	    	                    	 text: HreRem.i18n('header.entidad.propietaria'),
	    	                    	 flex: 0.4,
	    	                    	 dataIndex: 'cartera'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.tipo.activo'),
	    	                    	 flex: 0.4,
	    	                    	 dataIndex: 'tipoActivo'
	    	                     },
	    	                     {
	    	                    	 text: HreRem.i18n('header.subtipo.activo'),
	    	                    	 flex: 0.4,
	    	                    	 dataIndex: 'subtipoActivo'
	    	                     },
	    	                     {
	    	                     	text: HreRem.i18n('header.estado.activo'),
	    	                     	flex: 0.4,
	    	                     	dataIndex: 'estadoActivo'
	    	                     }
		];

		me.dockedItems= [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            displayInfo: true,
		            bind: {
		                store: '{plusvaliaAdministracion}'
		            },
		            items:[
			            	{
			            		xtype: 'tbfill'
			            	},
			                {
			                	xtype: 'displayfieldbase',
			                	itemId: 'displaySelection',
			                	fieldStyle: 'color:#0c364b; padding-top: 4px'
			                }
	            	]
		        }
		];

    	me.callParent();

    }

});
